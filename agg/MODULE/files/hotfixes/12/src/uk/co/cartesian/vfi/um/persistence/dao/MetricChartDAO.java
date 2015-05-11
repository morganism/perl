package uk.co.cartesian.vfi.um.persistence.dao;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Date;

import org.apache.log4j.Logger;

import uk.co.cartesian.ascertain.um.forecasting.ForecastException;
import uk.co.cartesian.ascertain.um.forecasting.ForecastPackageWrapper;
import uk.co.cartesian.ascertain.um.forecasting.ForecastValuesBean;
import uk.co.cartesian.ascertain.um.persistence.dao.UmDatabaseDAOUtils;
import uk.co.cartesian.ascertain.utils.database.DBCleaner;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;
import uk.co.cartesian.ascertain.utils.persistence.dropdown.DropDown;
import uk.co.cartesian.ascertain.web.helpers.Utils;

/**
 * VFI Specific implementation 
 * 
 * VFI use time based metrics. This class has been modified so that the metric chart only returns 
 * values which are useful/meaningful to VFI.
 * 
 * The main differences are: 
 * 		- summing() the metric values
 * 		- removing meaningless values (e.g. min()/max())
 * 		- modifying the way forecasts are calculated
 * 
 * There is a custom forecast package which is called to calculate the aggregate forecast value for 
 * the given options. 
 * 
 * Currently, for both metrics and forecasts, correct values will only be returned if there is no 
 * duplicate data in the f_metric or forecast/forecast_model_values tables. I.e. if you have run 
 * a forecast job twice given exactly the same parameters, this class will aggregate BOTH of those
 * values and thus return an incorrect value. 
 * 
 * @author jeremy.sumner
 *
 */
public class MetricChartDAO
{
    private static final long serialVersionUID = 1L;

    private static Logger logger = LogInitialiser.getLogger(MetricChartDAO.class.getName());
    
    private static final String _FILE_METRIC_SQL =
    		 " select d_period_id\n" +
    		 "     ,sum_metric\n" +
    		 "     ,forecast_metric_id\n" +
    		 "     ,nvl2(forecast_metric_id,compare_value,null) as forecast_value\n" +
    		 "     ,is_operator_relative\n" +
    		 "     ,threshold_version_id\n" +
    	     "       _THRESHOLDS_SELECT_ " +
    		 " from (\n" +
    		 " with c as -- define static constants/variables used below   \n" +
    		 " (select ? as node_id\n" +
    		 "  ,? as edge_id\n" +
    		 "  ,? as source_id\n" +
    		 "  ,? as source_type_id\n" +
    		 "  ,? as edr_type_id\n" +
    		 "  ,? as edr_sub_type_id\n" +
    		 "  ,? as start_date\n" +
    		 "  ,? as end_date\n" +
    		 "  ,mr.metric_operator_id\n" +
    		 "  ,mr.forecast_metric_id\n" +
    		 "  ,mr.operator_order\n" +
    		 "  ,metric_definition_id\n" +
    		 "  ,nvl2(odr.operator_definition_id\n" +
    		 "       ,decode(lower(etl.get_parameter(odr.parameters\n" +
    		 "                                      ,'-relative'))\n" +
    		 "              ,'no'\n" +
    		 "              ,'N'\n" +
    		 "              ,'Y')\n" +
    		 "       ,'N') is_operator_relative\n" +
    		 " from metric_definition_ref m\n" +
    		 " left outer join metric_operator_ref mr\n" +
    		 " on mr.metric_operator_id =\n" +
    		 "   um.metrics.getActiveOperatorId(m.metric_definition_id)\n" +
    		 " left outer join operator_definition_ref odr\n" +
    		 " on odr.operator_definition_id = mr.operator_definition_id\n" +
    		 " where m.metric_definition_id = ?)\n" +
    		 " , t1 as (select t.d_period_id\n" +
    		 "       ,null as sum_metric\n" +
    		 "       ,null as threshold_version_id\n" +
    		 "       ,c.metric_definition_id\n" +
    		 "  from um.d_period t\n" +
    		 "  join c on t.d_period_id > c.start_date\n" +
    		 "        and t.d_period_id < c.end_date\n" +
    		 " group by t.d_period_id,metric_definition_id)\n" +
    		 " , t2 as (select d_period_id\n" +
    		 "       ,sum_metric\n" +
    		 "       ,threshold_version_id\n" +
    		 "       ,metric_definition_id\n" +
    		 "   from (select t.d_period_id\n" +
    		 "               ,t.metric as sum_metric\n" +
    		 "               ,t.threshold_version_id as threshold_version_id\n" +
    		 "               ,row_number() over(partition by d_period_id, d_source_id, t.source_type_id, t.edr_type_id, t.edr_sub_type_id order by creation_date desc) rn\n" +
    		 "               ,c.metric_definition_id\n" +
    		 "           from um.f_metric t\n" +
    		 "           join c\n" +
    		 "            on  t.metric_definition_id = c.metric_definition_id\n" +
    		 "            and t.d_period_id > c.start_date\n" +
    		 "            and t.d_period_id < c.end_date             \n" +
    		 "            _WHERE_CLAUSES_   \n" +
    		 "            ) t\n" + 
    		 "  where t.rn = 1)\n" +
    		 " select d_period_id\n" +
    		 " ,sum_metric\n" +
    		 " ,c.metric_definition_id\n" +
    		 " ,c.forecast_metric_id\n" +
    		 " ,c.metric_operator_id\n" +
    		 " -- if forecast metric is defined, this overrides a last-value compare   \n" +
    		 " , nvl2(c.forecast_metric_id ,'Y' ,c.is_operator_relative) is_operator_relative\n" +
    		 " -- value to apply threshold to (if not forecast)   \n" +
    		 " -- if forecast metric id defined, then use forecast value (whether it exists or not)   \n" +
    		 " -- else if active operator is defined as relative, use last value   \n" +
    		 " -- otherwise active operator is absolute, use value defined in threshold   \n" +
    		 " ,case\n" +
    		 "   when c.forecast_metric_id is not null then\n" +
    		 "    customer.forecasting.getForecast(c.forecast_metric_id\n" +
    		 "                                    ,c.node_id\n" +
    		 "                                    ,null\n" +
    		 "                                    ,c.source_id\n" +
    		 "                                    ,c.edr_type_id\n" +
    		 "                                    ,c.edr_sub_type_id\n" +
    		 "                                    ,d_period_id\n" +
    		 "                                    ,c.source_type_id)\n" +
    		 "   else decode(c.is_operator_relative\n" +
    		 "          ,'Y'\n" +
    		 "          ,metrics.getLastValue(d_period_id\n" +
    		 "                               ,c.node_id\n" +
    		 "                               ,c.edge_id\n" +
    		 "                               ,c.source_id\n" +
    		 "                               ,c.source_type_id\n" +
    		 "                               ,c.metric_operator_id\n" +
    		 "                               ,c.metric_definition_id\n" +
    		 "                               ,c.operator_order)\n" +
    		 "          ,0)\n" +
    		 "         end compare_value\n" +
    		 "   ,nvl(t3.threshold_version_id\n" +
    		 "       ,forecasting.getThresholdVersionId(c.edge_id\n" +
    		 "                                         ,c.node_id\n" +
    		 "                                         ,c.metric_definition_id\n" +
    		 "                                         ,c.source_type_id\n" +
    		 "                                         ,c.source_id\n" +
    		 "                                         ,c.edr_type_id\n" +
    		 "                                         ,c.edr_sub_type_id\n" +
    		 "                                         ,d_period_id)) as threshold_version_id\n" +
    		 " from (select mt.d_period_id as d_period_id\n" +
    		 " ,metric_definition_id\n" +
    		 " ,round(sum(mt.sum_metric) ,2) as sum_metric\n" +
    		 " ,max(mt.threshold_version_id) as threshold_version_id\n" +
    		 " from (select * from t1\n" +
    		 "      union all\n" +
    		 "      select *\n" +
    		 "      from t2 ) mt\n" +
    		 " group by mt.d_period_id,metric_definition_id\n" +
    		 " ) t3\n" +
    		 " join c on  t3.metric_definition_id = c.metric_definition_id\n" +
    		 "     and t3.d_period_id > c.start_date\n" +
    		 "     and t3.d_period_id < c.end_date      \n" +
    		 " )\n" +
    		 " order by d_period_id\n";

    private static final String _FILE_METRIC_SELECT_THRESHOLDS = 
        "       ,forecasting.getThresholdLimit(3000, 'MAX', threshold_version_id, compare_value, is_operator_relative) max_critical_threshold \n" + 
        "       ,forecasting.getThresholdLimit(3000, 'MIN', threshold_version_id, compare_value, is_operator_relative) min_critical_threshold \n" + 
        "       ,forecasting.getThresholdLimit(3001, 'MAX', threshold_version_id, compare_value, is_operator_relative) max_severe_threshold \n" + 
        "       ,forecasting.getThresholdLimit(3001, 'MIN', threshold_version_id, compare_value, is_operator_relative) min_severe_threshold \n" + 
        "       ,forecasting.getThresholdLimit(3002, 'MAX', threshold_version_id, compare_value, is_operator_relative) max_major_threshold \n" + 
        "       ,forecasting.getThresholdLimit(3002, 'MIN', threshold_version_id, compare_value, is_operator_relative) min_major_threshold \n" + 
        "       ,forecasting.getThresholdLimit(3003, 'MAX', threshold_version_id, compare_value, is_operator_relative) max_minor_threshold \n" + 
        "       ,forecasting.getThresholdLimit(3003, 'MIN', threshold_version_id, compare_value, is_operator_relative) min_minor_threshold \n" + 
        "       ,forecasting.getThresholdLimit(3004, 'MAX', threshold_version_id, compare_value, is_operator_relative) max_info_threshold \n" + 
        "       ,forecasting.getThresholdLimit(3004, 'MIN', threshold_version_id, compare_value, is_operator_relative) min_info_threshold \n";

    private static final String _FILE_METRIC_SELECT_NO_THRESHOLDS = 
		 "     ,null max_critical_threshold \n" +
		 "     ,null min_critical_threshold \n" +
		 "     ,null max_severe_threshold \n" +
		 "     ,null min_severe_threshold \n" +
		 "     ,null max_major_threshold \n" +
		 "     ,null min_major_threshold \n" +
		 "     ,null max_minor_threshold \n" +
		 "     ,null min_minor_threshold \n" +
		 "     ,null max_info_threshold \n" +
		 "     ,null min_info_threshold \n";

		 public static ResultSet getMetricData(
        Date fromDate,
        Date toDate,
        Integer metricDefinitionId,
        Integer nodeId,
        Integer edgeId,
        Integer sourceTypeId,
        Integer sourceId,
        Integer edrTypeId,
        Integer edrSubTypeId,
        boolean thresholds,
        DBCleaner cleaner)
    throws IOException
    {
        String fromDateStr = Utils.dateToLongString(fromDate);
        String toDateStr = Utils.dateToLongString(toDate);
        return getMetricData(
            fromDateStr,
            toDateStr,
            metricDefinitionId,
            nodeId,
            edgeId,
            sourceTypeId,
            sourceId,
            edrTypeId,
            edrSubTypeId,
            thresholds,
            cleaner);
    }

    public static ResultSet getMetricData(
        String fromDate,
        String toDate,
        Integer metricDefinitionId,
        Integer nodeId,
        Integer edgeId,
        Integer sourceTypeId,
        Integer sourceId,
        Integer edrTypeId,
        Integer edrSubTypeId,
        boolean thresholds,
        DBCleaner cleaner)
    throws IOException
    {
        Connection conn = null;
        Statement stmnt = null;
        ResultSet rs = null;

        try
        {
            String sql = _FILE_METRIC_SQL;
            String whereClause = getWhereClause(nodeId, edgeId, sourceTypeId, sourceId, edrTypeId, edrSubTypeId);
            sql = sql.replaceFirst("_WHERE_CLAUSES_", whereClause);       
            
            if (thresholds)
            {
                sql = sql.replaceFirst("_THRESHOLDS_SELECT_", _FILE_METRIC_SELECT_THRESHOLDS);       
            }
            else
            {
                sql = sql.replaceFirst("_THRESHOLDS_SELECT_", _FILE_METRIC_SELECT_NO_THRESHOLDS);
            }

            if (logger.isDebugEnabled())
            {
                logger.debug("MetricChartDAO.getMetricData(): Retrieving metric data points using sql - " + sql);
            }
            
            conn = UmDatabaseDAOUtils.getAutoConnection();
            cleaner.add(conn); 

            // NOTE Avoid using bind variables as this can result in Oracle using
            // inappropriate/inefficient/cached execution plans  
            //Integer ALL_ID = new Integer(DropDown.ALL_ID);
            
            // JS: Reinstated '0' as a valid selection so that aggregate values can be calculated
            sql = sql.replaceFirst("\\?", nodeId == null ? "null" : nodeId.toString())
                     .replaceFirst("\\?", edgeId == null ? "null" : edgeId.toString())
                     .replaceFirst("\\?", sourceId == null ? "null" : sourceId.toString())
                     .replaceFirst("\\?", sourceTypeId == null ? "null" : sourceTypeId.toString())
                     .replaceFirst("\\?", edrTypeId == null ? "null" : edrTypeId.toString())
                     .replaceFirst("\\?", edrSubTypeId == null ? "null" : edrSubTypeId.toString())
                     .replaceFirst("\\?", "to_date( '"+fromDate+"','DY, DD MONTH YYYY')")
                     .replaceFirst("\\?", "to_date( '"+toDate+"','DY, DD MONTH YYYY')")
                     .replaceFirst("\\?", metricDefinitionId.toString());

            logger.debug("MetricChartDAO.getMetricData(): sql=" + sql);
            stmnt = conn.createStatement();
            cleaner.add(stmnt);
            rs = stmnt.executeQuery(sql);
            cleaner.add(rs);
        }
        catch (SQLException e)
        {
            throw new IOException(e);
        }
        return rs;
    }
        
    /**
     * 
     */
    private static String getWhereClause(
        Integer nodeId,
        Integer edgeId,
        Integer sourceTypeId,
        Integer sourceId,
        Integer edrTypeId,
        Integer edrSubTypeId)
    {
        StringBuffer returnValue = new StringBuffer();

        //Set conditional where clauses
        if (nodeId != null && nodeId != 0)
        {
            returnValue.append(" AND t.d_node_id = " + nodeId + "\n");
        }
        else
        {
            returnValue.append(" AND t.d_edge_id = " + edgeId + "\n");
        }

        // Add the source if selected
        if (sourceTypeId == null)
        {
            returnValue.append(" AND t.source_type_id is null\n");
        }
        else if (Integer.parseInt(DropDown.ALL_ID) != sourceTypeId)
        {
            returnValue.append(" AND t.source_type_id = " + sourceTypeId + "\n");
        }

        // Add the source if selected
        if (sourceId == null)
        {
            returnValue.append(" AND t.d_source_id is null\n");
        }
        else if (Integer.parseInt(DropDown.ALL_ID) != sourceId)
        {
            returnValue.append(" AND t.d_source_id = " + sourceId + "\n");
        }

        // Add the EDR type if selected
        if (edrTypeId == null)
        {
            returnValue.append(" AND t.edr_type_id = -1\n");
        }
        else if (Integer.parseInt(DropDown.ALL_ID) != edrTypeId)
        {
            returnValue.append(" AND t.edr_type_id = " + edrTypeId + "\n");
        }

        // Add the EDR sub-type if selected
        if (edrSubTypeId == null)
        {
            returnValue.append(" AND t.edr_sub_type_id is null\n");
        }
        else if (Integer.parseInt(DropDown.ALL_ID) != edrSubTypeId)
        {
            returnValue.append(" AND t.edr_sub_type_id = " + edrSubTypeId +"\n");
        }

        return returnValue.toString();
    }
    
    /**
     * @deprecated   This method is no longer needed as it is now handled directly in sql
     */
    public static Double getForecastValue(Integer forecastMetricId, Timestamp dPeriodId,
                                     Integer metricDefinitionId, Integer nodeId, Integer edgeId,
                                      Integer sourceId, Integer edrTypeId, Integer edrSubTypeId)
    throws ForecastException
    {
        Double returnValue = null;
        
        ForecastValuesBean forecast = ForecastPackageWrapper.getForecast(
                forecastMetricId,
                metricDefinitionId,
                nodeId == null ? null : nodeId,
                edgeId == null ? null : edgeId,
                sourceId == null ? null : sourceId,
                edrTypeId == null ? null : edrTypeId,
                edrSubTypeId == null ? null : edrSubTypeId,
                dPeriodId);

        if(forecast!=null)
        {
            returnValue = forecast.getYValue().doubleValue();
        }
        return returnValue;
    }
}
