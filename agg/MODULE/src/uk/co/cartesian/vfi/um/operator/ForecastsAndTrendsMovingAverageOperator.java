/*
 * Created on 26-Sep-2006
 *
 */
package uk.co.cartesian.vfi.um.operator;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;

import uk.co.cartesian.ascertain.jobs.server.JobAbandonedException;
import uk.co.cartesian.ascertain.jobs.utils.ErrorCodes;
import uk.co.cartesian.ascertain.um.job.ForecastsAndTrendsJob;
import uk.co.cartesian.ascertain.um.operator.ForecastsOperator;
import uk.co.cartesian.ascertain.um.operator.OperatorException;
import uk.co.cartesian.ascertain.um.operator.db.UMStatementRunner;
import uk.co.cartesian.ascertain.um.operator.forecast.ForecastAndTrendMVDbBean;
import uk.co.cartesian.ascertain.um.operator.forecast.ForecastDbBean;
import uk.co.cartesian.ascertain.um.persistence.bean.ForecastModelValues;
import uk.co.cartesian.ascertain.um.persistence.dao.ForecastModelValuesDatabaseDAO;
import uk.co.cartesian.ascertain.um.persistence.dao.UmDatabaseDAOUtils;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;
import uk.co.cartesian.ascertain.web.helpers.Utils;

/**
 * @author Cartesian Limited
 * @author imortimer
 *  
 */
public class ForecastsAndTrendsMovingAverageOperator 
extends ForecastsOperator
{
	private static final Logger logger = LogInitialiser.getLogger(ForecastsAndTrendsMovingAverageOperator.class.getName());

	private static final String _MODEL = "um.forecasting.MovingAverageModel";
	private static final String _VALUE = "VALUE";
	private static final String _CONFIDENCE = "CONFIDENCE";
	private static final String _GROWTH_FACTOR = "GROWTH_FACTOR";

	private static final String _FORECAST_SQL = 
		"		SELECT t2.week_day,\n" +
		"	       t2.the_hour,\n" +
		"	       d_source_id,\n" +
		"	       source_type_id,\n" +
		"	       edr_type_id,\n" +
		"	       edr_sub_type_id,\n" +
		"	       AVG(t2.adjusted_avg) the_average\n" +
		"	  FROM (SELECT t1.the_avg * NVL(um_dfj.adjuster, 1) AS adjusted_avg,\n" +
		"	               t1.x,\n" +
		"	               t1.week_day,\n" +
		"	               t1.the_hour,\n" +
		"	               d_source_id,\n" +
		"	               source_type_id,\n" +
		"	               edr_type_id,\n" +
		"	               edr_sub_type_id\n" +
		"	          FROM um.date_forecast_jn um_dfj\n" +
		"	         INNER JOIN imm.exception_date_ref um_edr ON um_edr.exception_date_id =\n" +
		"	                                                     um_dfj.exception_date_id\n" +
		"	                                                 AND um_dfj.forecast_version_id = ?\n" +
		"	         RIGHT OUTER JOIN (SELECT AVG(um_fm.metric) AS the_avg,\n" +
		"	                                 86400 *\n" +
		"	                                 ((to_date(um_dp.hour, 'YYYYMMDDHH24')) -\n" +
		"	                                 (to_date('01011970', 'DDMMYYYY'))) AS x,\n" +
		"	                                 um_dp.week_day AS week_day,\n" +
		"	                                 substr(um_dp.hour, 9, 2) AS the_hour,\n" +
		"	                                 um_fm.d_source_id,\n" +
		"	                                 um_fm.source_type_id,\n" +
		"	                                 um_fm.edr_type_id,\n" +
		"	                                 um_fm.edr_sub_type_id\n" +
		"	                            FROM um.d_period um_dp\n" +
		"						       INNER JOIN (select um_fm.*, row_number() over(partition by d_period_id, d_source_id, um_fm.edr_type_id, um_fm.edr_sub_type_id order by creation_date desc) rn\n" + 
		"						               from um.f_metric um_fm\n" +
		"						              where um_fm.metric_definition_id = ?\n" +
		"						                AND um_fm.{COLUMN_NAME} = ?\n" +
		"						                AND um_fm.d_period_id >= ?\n" +
		"						                AND um_fm.d_period_id < ?\n" +
		"						                AND um_fm.is_comparator = 'Y' ) um_fm ON um_fm.d_period_id = um_dp.d_period_id\n" + 
		"						              WHERE um_fm.rn = 1\n" +
		"	                           GROUP BY um_dp.week_day,\n" +
		"	                                    um_dp.day,\n" +
		"	                                    um_dp.month,\n" +
		"	                                    um_dp.year,\n" +
		"	                                    um_dp.hour,\n" +
		"	                                    um_dp.d_period_id,\n" +
		"	                                    um_fm.d_source_id,\n" +
		"	                                    um_fm.source_type_id,\n" +
		"	                                    um_fm.edr_type_id,\n" +
		"	                                    um_fm.edr_sub_type_id) t1 ON TO_CHAR((TO_DATE('01011970',\n" +
		"	                                                                                  'DDMMYYYY') +\n" +
		"	                                                                         (t1.x /\n" +
		"	                                                                         86400)),\n" +
		"	                                                                         'DDMMYYYY') =\n" +
		"	                                                                 to_char(um_edr.exception_date,\n" +
		"	                                                                         'DDMMYYYY')) t2\n" +
		"	 GROUP BY t2.week_day,\n" +
		"	          t2.the_hour,\n" +
		"	          d_source_id,\n" +
		"	          source_type_id,\n" +
		"	          edr_type_id,\n" +
		"	          edr_sub_type_id\n";
			
	private static final String _HAVING_SOURCE = " having t2.d_source_id = ";
	
	/**
	 * 
	 * @return
	 */
	protected String getForecastSql()
	{
		return _FORECAST_SQL;
	}

	/**
	 * 
	 * @return
	 */
	protected String getForecastModel()
	{
		return _MODEL;
	}
	
	/**
	 * 
	 * @param query
	 * @param forecastId
	 * @param metricDefinitionId
	 * @param dataFrom
	 * @param dataTo
	 * @throws Exception
	 */
	protected void populateForecastModelValuesTable(List<ForecastDbBean> forecastData)
	throws Exception
	{
		// Get the solution to the forecast equation
		// In this case Oracle will do this for us - the linear regression stuff in built in
		if (forecastData.size() == 0 ) 
		{
			writeLog("Forecast generated no data.");
			return;
		}

		// Go through this list and populate the forecast_model_values tables
		ForecastModelValues forecastModelValues;
		for(int i = 0; i < forecastData.size(); i ++)
		{
			ForecastAndTrendMVDbBean dbBean = (ForecastAndTrendMVDbBean)forecastData.get(i);
			
			//Save the forecast model values
			forecastModelValues = new ForecastModelValues(dbBean.getForecastId(), dbBean.getWeekDay(), dbBean.getHour(), _VALUE, dbBean.getAverage());
			ForecastModelValuesDatabaseDAO.save(forecastModelValues, null);

			forecastModelValues = new ForecastModelValues(dbBean.getForecastId(), dbBean.getWeekDay(), dbBean.getHour(), _CONFIDENCE, new Double(1.0));
			ForecastModelValuesDatabaseDAO.save(forecastModelValues, null);

			String growthFactor = getOperatorParameter(ForecastsAndTrendsJob.GROWTH_FACTOR_OPTION_FLAG);
			forecastModelValues = new ForecastModelValues(dbBean.getForecastId(), dbBean.getWeekDay(), dbBean.getHour(), _GROWTH_FACTOR, Double.valueOf(growthFactor));
			ForecastModelValuesDatabaseDAO.save(forecastModelValues, null);
		}
	}

	/**
	 * 
	 * @param query
	 * @param metricOperatorId
	 * @param dataFrom
	 * @param dataTo
	 * @return
	 * @throws SQLException
	 * @throws OperatorException
	 */
	protected List<ForecastDbBean> getForecastData(String query, int metricDefinitionId, Date dataFrom, Date dataTo, Integer sourceId, Integer nodeId, Integer edgeId)
	throws SQLException, OperatorException
	{
		if(logger.isDebugEnabled())
		{
			logger.debug("ForecastsAndTrendsMovingAverageOperator:getForecastData(...) - metricDefinitionId = " + metricDefinitionId);
			logger.debug("ForecastsAndTrendsMovingAverageOperator:getForecastData(...) - dataFrom = " + Utils.dateToShortString(dataFrom));
			logger.debug("ForecastsAndTrendsMovingAverageOperator:getForecastData(...) - dataTo = " + Utils.dateToShortString(dataTo));
			logger.debug("ForecastsAndTrendsMovingAverageOperator:getForecastData(...) - sourceId = " + sourceId);
			logger.debug("ForecastsAndTrendsMovingAverageOperator:getForecastData(...) - nodeId / edgeId = " + nodeId + edgeId);

		}

		String fvId = getOperatorParameter(ForecastsAndTrendsJob.FORECAST_VERSION_JOB_OPTION_FLAG);
		int forecastVersionId = Integer.parseInt(fvId);
		List<ForecastDbBean> returnValue = new ArrayList<ForecastDbBean>();

		setRunner(new UMStatementRunner());    	

		PreparedStatement pstmnt = null;
		ResultSet results = null;
		Connection connection = UmDatabaseDAOUtils.getAutoConnection();
		int index = 1;
		StringBuffer newSql = new StringBuffer(query);
		try
		{
			if (sourceId != null)
			{
				newSql.append(_HAVING_SOURCE).append(sourceId.intValue()).append("\n"); 
			}
			newSql.append(" ORDER BY T2.D_SOURCE_ID, T2.SOURCE_TYPE_ID, T2.EDR_TYPE_ID, T2.EDR_SUB_TYPE_ID");
			logger.debug("ForecastsAndTrendsMovingAverageOperator:getForecastData(...) - query to execute is\n" + newSql);
			pstmnt = connection.prepareStatement(newSql.toString());
			pstmnt.setInt(index++, forecastVersionId);
			pstmnt.setInt(index++, metricDefinitionId);

			if (nodeId != null) {
				pstmnt.setInt(index++, nodeId.intValue());
			}
			else {
				pstmnt.setInt(index++, edgeId.intValue());
			}

			pstmnt.setDate(index++, new java.sql.Date(dataFrom.getTime()));
			pstmnt.setDate(index++, new java.sql.Date(dataTo.getTime()));
			
			logger.debug("ForecastsAndTrendsMovingAverageOperator:getForcastData(...) - Before execute query for " + metricDefinitionId);
			executeSqlRunner(pstmnt);         

			boolean done = false;
			while (!done)
			{
				done = isDone();
				if (!getMonitor().isExecuting())
				{
					abort();
					logger.debug("ForecastsAndTrendsMovingAverageOperator.lockingRecords("+getJobId()+":"+metricDefinitionId+"). Job being abandoned");
					throw new JobAbandonedException(ErrorCodes.KILLED);
				}
				else if (isSqlProblem()) 
				{
					throw getRunnerException();
				}

				if (!done) 
				{
					Thread.sleep(5);
				}
				logger.debug("ForecastsAndTrendsMovingAverageOperator.lockingRecords("+getJobId()+":"+metricDefinitionId+") - Waiting 5ms...");
			}

			logger.debug("ForecastsAndTrendsMovingAverageOperator:getForcastData(...) - After execute query for " + metricDefinitionId);            

			results = getResultSet();   

			while(results.next())
			{
				ForecastAndTrendMVDbBean bean = new ForecastAndTrendMVDbBean();
				bean.setSourceId(results.getInt("d_source_id"));
				bean.setSourceTypeId(results.getInt("source_type_id"));
				bean.setEdrTypeId(results.getInt("edr_type_id"));
				bean.setEdrSubTypeId(results.getInt("edr_sub_type_id"));
				bean.setAverage(new Double(results.getDouble("the_average")));
				bean.setWeekDay(new Integer(results.getInt("week_day")));
				bean.setHour(new Integer(results.getInt("the_hour")));
				returnValue.add(bean);
			}

			connection.commit();
		}
		catch (JobAbandonedException e)
		{
			writeLog("\t\tJob Abandoned.");
			writeLog("\t\tJobAbandonedException - " + e.getMessage());
			if (logger.isDebugEnabled())
			{
				logger.debug("ForecastsAndTrendsMovingAverageOperator.getForcastData - JobAbandonedException - " + e.getMessage());

			}
			try { connection.rollback(); } catch (Exception e1) {}            

			logger.debug("ForecastsAndTrendsMovingAverageOperator:getForcastData(...) - END for " + metricDefinitionId);
		}
		catch (Exception e)
		{
			logger.error("ForecastsAndTrendsMovingAverageOperator: execute("+getJobId()+":"+metricDefinitionId+") Unexpected Exception: ", e);
			try { connection.rollback(); } catch (Exception e1) {}

			throw new OperatorException(e);
		}        
		finally
		{
			try { results.close(); } catch (Throwable te) { }
			try { pstmnt.close(); } catch (Throwable te) { }
			try { connection.close(); } catch (Throwable te) { }
		}

		return returnValue;
	}
}
