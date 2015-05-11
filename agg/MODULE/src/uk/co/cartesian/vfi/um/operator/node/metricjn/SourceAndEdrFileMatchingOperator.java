/**
 * 
 */
package uk.co.cartesian.vfi.um.operator.node.metricjn;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import uk.co.cartesian.ascertain.um.operator.GenericFileMatchingConstants;
import uk.co.cartesian.ascertain.um.operator.OperatorException;
import uk.co.cartesian.ascertain.um.operator.node.metricjn.EdrFileMatchingOperator;
import uk.co.cartesian.ascertain.um.operator.node.metricjn.GroupNodeFileMatchingOperator;
import uk.co.cartesian.ascertain.um.operator.node.metricjn.MetricJnConfigHelper;
import uk.co.cartesian.ascertain.um.persistence.bean.MetricOperatorRef;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;

/**
 * This class is used for matching (grouping) by each node, by hour, by EDR type and by source.
 * We've basically stolen the original methods and added source, source type, edr type and edr sub type to the grouping so we get more buckets
 * 
 * @author jeremy.sumner
 *
 */
public class SourceAndEdrFileMatchingOperator extends EdrFileMatchingOperator
{
	private static Logger logger = LogInitialiser.getLogger(EdrFileMatchingOperator.class.getName());
	
	// Operator parameters
	protected static final String EDR_TYPE_ID_PARAM = GenericFileMatchingConstants.EDR_TYPE_ID_PARAM;
	protected static final String EDR_SUB_TYPE_ID_PARAM = GenericFileMatchingConstants.EDR_SUB_TYPE_ID_PARAM;

	// Valid grouping options
	protected static final String EDR_TYPE_AND_SUB_TYPE_VALUE = GenericFileMatchingConstants.EDR_TYPE_AND_SUB_TYPE_VALUE;
	protected static final String EDR_SUBTYPE = GenericFileMatchingConstants.EDR_SUBTYPE_VALUE;
	protected static final String EDR_TYPE_ID = GenericFileMatchingConstants.EDR_TYPE_ID_VALUE;
	
	protected static final String SOURCE_AND_EDR_TYPE_ID = "sourceAndEdrType";

	/**
	 * @override
	 */
	public String getInstanceDescription()
	{
		return "Node Based Source, EDR Type and Hour Grouping Operator";
	}
	
	/**
	 * @override
	 */
	public String version()
	{
		StringBuffer version = new StringBuffer();
		version.append("Version: 1.0")
		.append("\nClass: " + GroupNodeFileMatchingOperator.class.getName())
		.append("\nDescription: Operator for matching on a node and grouping results based on source, EDR Type and hour using " + GROUP_PARAM + " parameter.");
		
		return version.toString();
	}
	
	/**
	 * The SQL for selecting records to put into the I side
	 */
	@Override
	public String getISideSql(Map<String, Object> settings)
	{
		StringBuffer sql = new StringBuffer();
		Integer nodeId = (Integer)settings.get(NODE_PARAM);
		
		sql.append(" SELECT DISTINCT DETM.EDR_TYPE_UID || ' - ' || LR.SOURCE_ID AS GROUPING, LR.D_PERIOD_ID, LR.LOG_RECORD_ID, DETM.EDR_TYPE_UID AS EDR_TYPE_ID, DETM.EDR_SUB_TYPE_ID AS EDR_SUB_TYPE_ID, LR.SOURCE_ID");
		
		sql.append(" FROM UM.LOG_RECORD LR, UM.F_FILE FF, UM.F_ATTRIBUTE FA, UM.D_EDR_TYPE_MV DETM ")
		.append(" WHERE 1 = 1")
		.append(" AND LR.LOG_RECORD_ID = FF.LOG_RECORD_ID")
		.append(" AND FF.F_ATTRIBUTE_ID = FA.F_ATTRIBUTE_ID")
		.append(" AND FA.D_EDR_TYPE_ID = DETM.D_EDR_TYPE_ID");
		
		sql.append(getTimeClause(settings))
		.append(" AND LR.NODE_ID = ").append(nodeId)
		.append(" AND LR.NODE_ID = FA.D_NODE_ID")
		.append(" AND LR.D_PERIOD_ID = FF.D_PERIOD_ID");
		
		return sql.toString();
	}

	/**
	 * @override
	 */
	@Override
	protected void validateGroupParameter()
	throws OperatorException
	{
		String groupBy = getOperatorParameter(GROUP_PARAM);
		if (!(SOURCE_AND_EDR_TYPE_ID.equalsIgnoreCase(groupBy)))
		{
			throw new OperatorException("The " + GROUP_PARAM + " parameter must be ["+ SOURCE_AND_EDR_TYPE_ID+"]");
		}
		opDebug(getInstanceDescription() + "\t: Processing type " + groupBy);
	}
	
	/**
	 * Creates a temporary table of distinct records. Used for grouping.
	 * 
	 * @param settings
	 * @param conn
	 * @return
	 * @throws OperatorException
	 */
	@Override
	protected int createDistinctTable(Map<String, Object> settings, Connection conn)
	throws OperatorException
	{
		int distinct = 0;
		
		// Work out which D_PERIOD_ID should be used
		// Ensure that periodSelect is set to at least NULL if no D_PERIOD 
		// grouping is specified for the sake of simplicity later on when 
		// inserting into metric queues.
		String periodSelect = "";
		String periodGroup = "";
		if (settings.containsKey(GenericFileMatchingConstants.PERIOD_PARAM))
		{
			String period = (String)settings.get(GenericFileMatchingConstants.PERIOD_PARAM);
			if (GenericFileMatchingConstants.HOUR_VALUE.equalsIgnoreCase(period))
			{
				periodGroup = ", TO_CHAR(D_PERIOD_ID, 'DD-MON-YYYY HH24')";
				periodSelect = ", 1 AS PERIOD_PARAM " + periodGroup + " || ':00:00' AS D_PERIOD_ID";
			}
			else if (GenericFileMatchingConstants.DAILY_VALUE.equalsIgnoreCase(period))
			{
				periodGroup = ", TO_CHAR(D_PERIOD_ID, 'DD-MON-YYYY')";
				periodSelect = ", 1 AS PERIOD_PARAM " + periodGroup + " AS D_PERIOD_ID";
			}
		}

		if ("".equals(periodSelect))
		{
			periodSelect = ", 0 AS PERIOD_PARAM, 0 AS D_PERIOD_ID";
		}
		
		// Group values together
		StringBuffer sql = new StringBuffer();
		sql.append("CREATE TABLE ")
		.append(getDistinctTableName(settings))
		.append(" NOLOGGING AS")
		.append(" SELECT 0 AS FILESET_ID, MIN(D_PERIOD_ID) AS I_MIN_D_PERIOD_ID, MAX(D_PERIOD_ID) AS I_MAX_D_PERIOD_ID, GROUPING")
		.append(periodSelect)
		.append(", EDR_TYPE_ID, EDR_SUB_TYPE_ID, SOURCE_ID")
		.append(" FROM ")
		.append(getMatchTableName(settings))
		.append(" GROUP BY GROUPING").append(periodGroup).append(", EDR_TYPE_ID, EDR_SUB_TYPE_ID, SOURCE_ID");
		
		Statement stmnt = null;
		try 
		{
			opDebug(getInstanceDescription() + "\t: Creating temporary distinct table using sql-" + sql);
			if (logger.isDebugEnabled())
			{
				logger.debug("GroupNodeFileMatchingOperator.createDistinctTable(...) - Creating distinct match table using sql-" + sql);
			}
			
			stmnt = conn.createStatement();
			distinct = stmnt.executeUpdate(sql.toString());

			opDebug(getInstanceDescription() + "\t: Distinct match table created.");
			if (logger.isDebugEnabled())
			{
				logger.debug("GroupNodeFileMatchingOperator.createDistinctTable(...) - Distinct match table created.");
			}
		} 
		catch (SQLException e) 
		{
			if (logger.isDebugEnabled())
			{
				logger.debug("GroupNodeFileMatchingOperator.createDistinctTable(...) -  Unable to create distinct table for matching records. SQLException is " + e.getMessage());
			}
			writeLog(getInstanceDescription() + "\t: Unable to create distinct table for matching records.");
			throw new OperatorException(e.getMessage());
		}
		finally
		{
			try { stmnt.close(); } catch (Exception e) {}
		}
		
		return distinct;
	}
	
	/**
	 * Creates the temporary working table of matching records
	 * 
	 * Ripped from the original. 
	 * 
	 * @param settings
	 * @param conn
	 * @param matchSql
	 * @return
	 * @throws OperatorException
	 */
	@Override
	protected int createMatchTable(Map<String, Object> settings, Connection conn, String matchSql)
	throws OperatorException
	{
		int matched = 0;

		StringBuffer sql = new StringBuffer(" CREATE TABLE ");
		sql.append(getMatchTableName(settings))
		.append(" (")
		.append(" GROUPING") 
		.append(" , D_PERIOD_ID")
		.append(" , LOG_RECORD_ID")
		.append(" , EDR_TYPE_ID")
		.append(" , EDR_SUB_TYPE_ID")
		.append(" , SOURCE_ID")
		.append(" , CONSTRAINT ").append(getMatchTableName(settings, false)).append("_PK PRIMARY KEY (GROUPING,D_PERIOD_ID,LOG_RECORD_ID)")
		.append(" )")
		.append(" ORGANIZATION INDEX") 
		.append(" COMPRESS 2")
		.append(" AS")
		.append(matchSql);
		
		Statement stmnt = null;
		Statement stmnt2 = null;
		try 
		{
			opDebug(getInstanceDescription() + "\t: Creating temporary match table using sql-" + sql);
			if (logger.isDebugEnabled())
			{
				logger.debug("GroupNodeFileMatchingOperator.createMatchTable(...) - Creating temporary match table using sql-" + sql);
			}
			
			stmnt = conn.createStatement();
			matched = stmnt.executeUpdate(sql.toString());

			opDebug(getInstanceDescription() + "\t: Temporary match table created.");
			if (logger.isDebugEnabled())
			{
				logger.debug("GroupNodeFileMatchingOperator.createMatchTable(...) - Temporary match table created.");
			}
			
			/**
			 * For some reason, creating a scratch table index organized 
			 * returns 0 from Statement.executeUpdate(). So need to do 
			 * another for the rows in table.
			 */
			sql = new StringBuffer();
			sql.append(" SELECT COUNT(*) FROM ").append(getMatchTableName(settings));
			
			stmnt2 = conn.createStatement();
			ResultSet rs = stmnt2.executeQuery(sql.toString());
			while (rs.next())
			{
				matched = rs.getInt(1);
			}
		} 
		catch (SQLException e) 
		{
			logger.error("GroupNodeFileMatchingOperator.createMatchTable(...) -  Unable to create temporary table for matching records. SQLException is " + e.getMessage());
			writeLog(getInstanceDescription() + "\t: Unable to create temporary table for matching records.");
			throw new OperatorException(e.getMessage());
		}
		finally
		{
			try { stmnt.close(); } catch (Exception e) {}
			try { stmnt2.close(); } catch (Exception e) {}
		}
		
		return matched;
	}
	
	/**
	 * Insert into fmo_metric_queue
	 * This has basically been copied from the original except that we insert SOURCE_ID
	 */
	@Override
	public int insertFmoMetricQueue(Map<String, Object> settings, Connection connection)
	throws OperatorException
	{
		Integer nodeId = (Integer)settings.get(NODE_PARAM);
		StringBuffer sql = new StringBuffer();
		
		/**
		 * This bit builds SQL to insert into FMO_METRIC_QUEUE
		 */
		sql.append(" INSERT INTO UM.FMO_METRIC_QUEUE(")
		.append("		METRIC_QUEUE_ID, I_FILESET_ID, I_MIN_D_PERIOD_ID, I_MAX_D_PERIOD_ID, METRIC_OPERATOR_ID, NODE_ID, STATUS, ")
		.append("		FILE_TYPE, SOURCE_ID, SOURCE_TYPE_ID, OPERATOR_ID, THREAD_ID, D_PERIOD_ID, FMO_MATCH_HISTORY_ID, FMO_MATCH_CHECKSUM,")
		.append(" 		PROCESS_FLAG, EDR_TYPE_ID, EDR_SUB_TYPE_ID)")
		.append(" 	 SELECT UM.SEQ_FMO_METRIC_QUEUE_ID.NEXTVAL, A.FILESET_ID, I_MIN_D_PERIOD_ID, I_MAX_D_PERIOD_ID, ?, ?, 'P', '")
		.append(getOperatorParameter(FILE_TYPE_PARAM)).append("'");

		sql.append(", TO_NUMBER(A.SOURCE_ID), ").append(GenericFileMatchingConstants.DEFAULT_SOURCE_TYPE_ID);

		sql.append(", -1, -1, DECODE(PERIOD_PARAM, 1, TO_DATE(A.D_PERIOD_ID, 'dd-MON-yyyy HH24:MI:SS'), NULL), ?, ")
		.append(getFilesetMatchKey())
		.append(", ?, DECODE(EDR_TYPE_ID, 0, NULL, EDR_TYPE_ID), DECODE(EDR_SUB_TYPE_ID, 0, NULL, EDR_SUB_TYPE_ID)")
		.append(" FROM")
		.append(" ")
		.append(getDistinctTableName(settings))
		.append(" A");

		PreparedStatement insertBatch = null;
		int inserted = 0;
		try 
		{
			List<MetricOperatorRef> nodeMetricOperators = MetricJnConfigHelper.getNodeMetricOperatorRefs(settings);
			int metricOpCount = nodeMetricOperators.size();
			if (metricOpCount > 0)
			{
				opDebug(getInstanceDescription() + "\t: Node has " + metricOpCount + " metric operators.");
				logger.debug("GroupNodeFileMatchingOperator.insertFmoMetricQueue(...). System contains " + metricOpCount + " metric operators for nodeId-" + nodeId);
				
			    String insertFilesetQueueSql = sql.toString();
				opDebug(getInstanceDescription() + "\t: About to insert into fmo metric queue table using sql-" + insertFilesetQueueSql);
		    	logger.debug("GroupNodeFileMatchingOperator.insertFmoMetricQueue(...). About to insert into fmo metric queue table using sql-" + insertFilesetQueueSql);

				for (int metricOpIndex = 0; metricOpIndex < metricOpCount; metricOpIndex++)
			    {
			    	MetricOperatorRef metricOp = (MetricOperatorRef)nodeMetricOperators.get(metricOpIndex);
			        insertBatch = connection.prepareStatement(insertFilesetQueueSql);
			        
			        if ((metricOp.getDescription() != null) && (!StringUtils.isEmpty(metricOp.getDescription())))
			        {
			        	opDebug(getInstanceDescription() + "\t: Inserting matching files for metric operator \"" + metricOp.getDescription() + "\"");
			    	}
			        else
			        {
			        	opDebug(getInstanceDescription() + "\t: Inserting matching files for metric operator id \"" + metricOp.getMetricOperatorId() + "\"");			        
			        }
		        	logger.debug("GroupNodeFileMatchingOperator.insertFmoMetricQueue(...) - Inserting matching files for metric operator id \"" + metricOp.getMetricOperatorId() + "\"");
			        
			        // Set up parameters
			        int i = 1;
			        insertBatch.setInt(i++, metricOp.getMetricOperatorId().intValue());
					insertBatch.setInt(i++, nodeId.intValue());

					try
					{
						// Insert the FmoMatchHistory value
						Integer fmoMatchHistoryId = (Integer)settings.get(GenericFileMatchingConstants.FMO_MATCH_HISTORY_ID_PARAM);
						insertBatch.setInt(i++, fmoMatchHistoryId.intValue());
					}
					catch (Exception e)
					{
			        	opDebug(getInstanceDescription() + "\t: Could not get FMO_MATCH_HISTORY_ID for fileset queue. Defaulting to 0.");
				    	logger.debug("GroupNodeFileMatchingOperator.insertFmoMetricQueue(...) - Could not get FMO_MATCH_HISTORY_ID for fileset queue. Defaulting to 0");
						insertBatch.setInt(i++, 0);
					}
					
					// Add the METRIC_OPERATOR_ID again for maintaining unique match criteria
					insertBatch.setInt(i++, metricOp.getMetricOperatorId().intValue());

					if (rerun)
					{
						insertBatch.setString(i++, GenericFileMatchingConstants.RERUN_RUN_FLAG);
					}
					else
					{
						insertBatch.setString(i++, GenericFileMatchingConstants.NORMAL_RUN_FLAG);
					}
					
			        // Insert into FMO_METRIC_QUEUE
			        int metricInserted = insertBatch.executeUpdate();
			        inserted += metricInserted;
			        if ((metricOp.getDescription() != null) && (!StringUtils.isEmpty(metricOp.getDescription())))
			        {
			        	opDebug(getInstanceDescription() + "\t: " + metricInserted + " records inserted into fileset queue for metric operator: " + metricOp.getDescription());
			    	}
			        else
			        {
			        	opDebug(getInstanceDescription() + "\t: " + metricInserted + " records inserted into fileset queue for metric operator with ID: " + metricOp.getMetricOperatorId() + "\"");			        
			        }
			        
			    	logger.debug("GroupNodeFileMatchingOperator.insertFmoMetricQueue(...) - " + metricInserted + " records inserted into fileset queue for metric operator: " + metricOp.getDescription());
				    insertBatch.close();
			    }

			}
			else if (logger.isDebugEnabled())
			{
				// Basically, we can't insert into FMO_METRIC_QUEUE as metric_operator_id is non nullable
				logger.info("GroupNodeFileMatchingOperator.insertFmoMetricQueue(...). No metric operators where found for nodeId-"+ nodeId);
				writeLog(getInstanceDescription() + "\t: Node has no metric operators. Cannot insert into fileset queue. Processing stopped.");
			}
		} 
		catch (SQLException sqle) 
		{
        	opDebug(getInstanceDescription() + "\t: SQLException : " + sqle.getMessage());
		    if (logger.isDebugEnabled())
		    {
		    	logger.debug("GroupNodeFileMatchingOperator.insertFmoMetricQueue(...) - SQLException : " + sqle.getMessage());
		    }
			throw new OperatorException(sqle.getMessage());
		}
		finally
		{
			try { insertBatch.close(); } catch (Exception e) {}
		}

		return inserted;
	}

}
