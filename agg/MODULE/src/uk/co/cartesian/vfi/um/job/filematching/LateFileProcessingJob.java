package uk.co.cartesian.vfi.um.job.filematching;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.util.AbstractMap;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import uk.co.cartesian.ascertain.jobs.extensions.server.Describable;
import uk.co.cartesian.ascertain.jobs.log.JobLogFile;
import uk.co.cartesian.ascertain.jobs.server.AscertainJobId;
import uk.co.cartesian.ascertain.jobs.server.JobAbandonedException;
import uk.co.cartesian.ascertain.jobs.utils.ErrorCodes;
import uk.co.cartesian.ascertain.um.job.UMOperatorJob;
import uk.co.cartesian.ascertain.um.job.filematching.metricjn.GenericFileMatchingJob;
import uk.co.cartesian.ascertain.um.operator.GenericFileMatchingConstants;
import uk.co.cartesian.ascertain.um.persistence.dao.UmDatabaseDAOUtils;
import uk.co.cartesian.ascertain.utils.log.AscertainLogIOException;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;
import uk.co.cartesian.ascertain.utils.persistence.DatabasePersister;

/**
 * Slightly customized version. Only change is that this class supplies 'no' as the rerun flag. 
 * 
 * The reasons for this is that the normal late file processing job does not create filesets if
 * a late file hasn't been seen before, and then deletes the entry from the LATE_FILE_MATCH_QUEUE
 * table, and completes with status 'complete'. So if for some reason an older match didn't create
 * any filesets, the new usage will get completely overlooked by automated processing. 
 * 
 * @author jeremy.sumner
 *
 */
public class LateFileProcessingJob
extends UMOperatorJob
implements Describable
{
	private static final long serialVersionUID = 4682206620552328895L;
	
    protected static Logger logger = LogInitialiser.getLogger(LateFileProcessingJob.class.getName());

	private static final String LATE_FILE_PROCESSING_LOCK_SQL = 
		" UPDATE UM.LATE_FILE_MATCH_QUEUE LFMQ" +
		" SET LFMQ.STATUS = 'P'" +
		" WHERE LFMQ.STATUS = 'L'";

	private static final String LATE_FILE_PROCESSING_SQL = 
		" SELECT DISTINCT TRUNC(SAMPLE_DATE) AS SAMPLE_DATE, LFMQ.NODE_ID, NULL AS EDGE_ID, NMJ.FILE_MATCH_DEFINITION_ID, TRUNC(SYSDATE) - TRUNC(SAMPLE_DATE) - 1 AS OFFSET" + 
		" FROM UM.LATE_FILE_MATCH_QUEUE LFMQ, UM.NODE_MATCH_JN NMJ" +
		" WHERE 1 = 1" +
		" AND EDGE_ID IS NULL" +
		" AND LFMQ.NODE_ID = NMJ.NODE_ID" +
		" AND LFMQ.STATUS = 'P'" +
		" UNION" +
		" SELECT DISTINCT TRUNC(SAMPLE_DATE), NULL AS NODE_ID, LFMQ.EDGE_ID, EMJ.FILE_MATCH_DEFINITION_ID, TRUNC(SYSDATE) - TRUNC(SAMPLE_DATE) - 1 AS OFFSET" +
		" FROM UM.LATE_FILE_MATCH_QUEUE LFMQ, UM.EDGE_MATCH_JN EMJ" +
		" WHERE 1 = 1" +
		" AND NODE_ID IS NULL" +
		" AND LFMQ.EDGE_ID = EMJ.EDGE_ID" +
		" AND LFMQ.STATUS = 'P'";

	private static final String LATE_FILE_PROCESSING_CLEANUP_SQL = 
		" DELETE FROM UM.LATE_FILE_MATCH_QUEUE LFMQ" +
		" WHERE 1 = 1" +
		" AND LFMQ.STATUS = 'P'";

	private static Object _LOCK_TOKEN = new Object();
	
	public int execute(AscertainJobId jobid, JobLogFile joblog, Map sharedParameters)
    throws JobAbandonedException, AscertainLogIOException, ParseException
	{
		Connection conn = null;
		Statement lateFilesStmnt = null;
		ResultSet rs = null;
		int success = ErrorCodes.FAILED;
		
		synchronized (_LOCK_TOKEN) 
		{
			joblog.writeLine(getInstanceDescription() + "\t: START.");
			try 
			{
				// Lock the late files for processing
				lockLateFileQueue(joblog);
				
				// Process the late files
				conn = UmDatabaseDAOUtils.getManualConnection();
				lateFilesStmnt = conn.createStatement();
				rs = lateFilesStmnt.executeQuery(LATE_FILE_PROCESSING_SQL);
				
				AbstractMap oldParameters = new HashMap();
				oldParameters.putAll(sharedParameters);

				joblog.writeLine(getInstanceDescription() + "\t: Beginning Late File Processing Job.");
				
				int count = 0;
				while (rs.next())
				{
					GregorianCalendar sampleDate = new GregorianCalendar();
					sampleDate.setTime(DatabasePersister.getTimestamp(rs, "SAMPLE_DATE"));
					Integer nodeId = rs.getInt("NODE_ID");
					Integer edgeId = rs.getInt("EDGE_ID");
					Integer offset = rs.getInt("OFFSET");
					Integer fileMatchDefinitionId = rs.getInt("FILE_MATCH_DEFINITION_ID");
				
					AbstractMap newParameters = new HashMap();
					newParameters.putAll(oldParameters);
					newParameters.put(GenericFileMatchingConstants.MATCH_PARAM, fileMatchDefinitionId.toString());
					newParameters.put(GenericFileMatchingConstants.WEEKDAY_PARAM, Integer.toString(sampleDate.get(Calendar.DAY_OF_WEEK)));
					newParameters.put(GenericFileMatchingConstants.OFFSET_PARAM, offset.toString());
					newParameters.put(GenericFileMatchingConstants.RERUN_PARAM, "force");
					newParameters.put("-threads", "1");
					joblog.writeLine(getInstanceDescription() + "\t: Processing File Match Definition - " + fileMatchDefinitionId);
					if ((nodeId != null && nodeId > 0))
					{
						newParameters.put(GenericFileMatchingConstants.NODE_PARAM, nodeId.toString());
						joblog.writeLine(getInstanceDescription() + "\t: Processing Node - " + nodeId);
					}
					else if ((edgeId != null) && (edgeId > 0))
					{
						newParameters.put(GenericFileMatchingConstants.EDGE_PARAM, edgeId.toString());
						joblog.writeLine(getInstanceDescription() + "\t: Processing Edge - " + edgeId);
					}
					UMOperatorJob gfmj = new GenericFileMatchingJob();
					gfmj.setJoblog(joblog);
					gfmj.setParameters(newParameters);
					success = gfmj.execute(jobid, joblog, newParameters);
					count++;
				}
				joblog.writeLine(getInstanceDescription() + "\t: Processed - " + count + " late file entries.");
				clearLateFileQueue(joblog);
				success = ErrorCodes.SUCCESS;
			}
			catch (SQLException sqle) 
			{
				joblog.writeLine(getInstanceDescription() + "\t: Failed for the following reason: " + sqle.getMessage());
		        if (logger.isDebugEnabled())
		        {
		        	logger.debug("LateFileProcessingJob.execute(...). OperatorException: " + sqle.getMessage());
		        }
		        
		        throw new JobAbandonedException(ErrorCodes.FAILED);
			}
			catch (Exception e)
			{
				joblog.writeLine(getInstanceDescription() + "\t: Failed for the following reason: " + e.getMessage());
		        if (logger.isDebugEnabled())
		        {
		        	logger.debug("LateFileProcessingJob.execute(...). Exception: " + e.getMessage());
		        }
		        
				e.printStackTrace();
			}
			finally
			{
				try { conn.close(); } catch (Exception e) {}
				try { lateFilesStmnt.close(); } catch (Exception e) {}
				try { rs.close(); } catch (Exception e) {}
			}
		}

		joblog.writeLine(getInstanceDescription() + "\t: END.");

		return success;
	}
	
	public void lockLateFileQueue(JobLogFile joblog)
	{
		Connection conn = null;
		Statement lateFilesStmnt = null;
		try
		{
			conn = UmDatabaseDAOUtils.getManualConnection();
			lateFilesStmnt = conn.createStatement();
			lateFilesStmnt.execute(LATE_FILE_PROCESSING_LOCK_SQL);
			conn.commit();
			joblog.writeLine(getInstanceDescription() + "\t: All entries in late file queue locked for processing.");
		}
		catch (SQLException sqle)
		{
			joblog.writeLine(getInstanceDescription() + "\t: Failed for the following reason: " + sqle.getMessage());
	        if (logger.isDebugEnabled())
	        {
	        	logger.debug("LateFileProcessingJob.lockLateFileQueue(...). OperatorException: " + sqle.getMessage());
	        }
		}
		finally
		{
			try { conn.close(); } catch (Exception e) {}
			try { lateFilesStmnt.close(); } catch (Exception e) {}
		}
	}
	
	public void clearLateFileQueue(JobLogFile joblog)
	{
		Connection conn = null;
		Statement lateFilesStmnt = null;
		try
		{
			conn = UmDatabaseDAOUtils.getManualConnection();
			lateFilesStmnt = conn.createStatement();
			lateFilesStmnt.execute(LATE_FILE_PROCESSING_CLEANUP_SQL);
			conn.commit();
			joblog.writeLine(getInstanceDescription() + "\t: All entries removed from late file queue.");
		}
		catch (SQLException sqle)
		{
			joblog.writeLine(getInstanceDescription() + "\t: Failed for the following reason: " + sqle.getMessage());
	        if (logger.isDebugEnabled())
	        {
	        	logger.debug("LateFileProcessingJob.execute(...). OperatorException: " + sqle.getMessage());
	        }
		}
		finally
		{
			try { conn.close(); } catch (Exception e) {}
			try { lateFilesStmnt.close(); } catch (Exception e) {}
		}
	}
	
    public String getInstanceDescription()
    {
    	return "Late File Processing Job";
    }
}