package uk.co.cartesian.ascertain.um.persistence.dao;

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
import uk.co.cartesian.ascertain.utils.database.DBCleaner;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;
import uk.co.cartesian.ascertain.utils.persistence.dropdown.DropDown;
import uk.co.cartesian.ascertain.web.helpers.Utils;

public class MetricChartDAO
{
    private static final long serialVersionUID = 1L;

    private static Logger logger = LogInitialiser.getLogger(MetricChartDAO.class.getName());
    
    private static final String _FILE_METRIC_SQL =
        "    WITH c AS -- define static constants/variables used below \n" + 
        "    ( SELECT ? as node_id, \n" + 
        "             ? as edge_id, \n" + 
        "             ? as source_id, \n" + 
        "             ? as source_type_id, \n" + 
        "             ? as edr_type_id, \n" + 
        "             ? as edr_sub_type_id, \n" + 
        "             ? as start_date, \n" + 
        "             ? as end_date, \n" + 
        "             mr.metric_operator_id, \n" + 
        "             mr.forecast_metric_id, \n" + 
        "             mr.operator_order, \n" + 
        "             m.metric_definition_id, \n" + 
        "             nvl2(odr.operator_definition_id, decode(lower(etl.get_parameter(odr.parameters, '-relative')), 'no', 'N', 'Y'), 'N') is_operator_relative \n" + 
        "       FROM metric_definition_ref m \n" + 
        "       LEFT OUTER JOIN metric_operator_ref mr on mr.metric_operator_id = um.metrics.getActiveOperatorId(m.metric_definition_id) \n" + 
        "       LEFT OUTER JOIN operator_definition_ref odr on odr.operator_definition_id = mr.operator_definition_id \n" + 
        "      WHERE m.metric_definition_id = ? \n" + 
        "    ), \n" + 
        "    t1 AS \n" + 
        "    ( \n" + 
        "      SELECT t.d_period_id, \n" + 
        "             null as max_metric, \n" + 
        "             null as min_metric, \n" + 
        "             null as average_metric, \n" + 
        "             null as moving_average, \n" + 
	"             null as sum_metric, \n" +
        "             null as threshold_version_id \n" + 
        "        FROM um.d_period t, c \n" + 
        "       WHERE t.d_period_id > c.start_date \n" + 
        "         AND t.d_period_id < c.end_date \n" + 
        "       GROUP BY t.d_period_id \n" + 
        "    ), \n" + 
        "    t2 as \n" + 
        "    ( \n" + 
        "      SELECT t.d_period_id, \n" + 
        "             max(t.metric) as max_metric, \n" + 
        "             min(t.metric) as min_metric, \n" + 
        "             avg(t.metric) as average_metric, \n" + 
        "             avg(avg(t.metric)) OVER (ORDER BY t.d_period_id ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) as moving_average, \n" + 
	"             sum(t.metric) as sum_metric, \n" +
        "             max(t.threshold_version_id) as threshold_version_id \n" + 
        "        FROM um.f_metric t, c \n" + 
        "       WHERE t.d_period_id > c.start_date \n" + 
        "         AND t.d_period_id < c.end_date \n" + 
        "         AND t.metric_definition_id = c.metric_definition_id \n" + 
	"         AND t.creation_date =   \n" +
	"                         (select max(fm2.creation_date) \n" +
 	"                          from   um.f_metric fm2 \n" +
	"                          where  t.d_period_id = fm2.d_period_id \n" + 
	"                          and    t.d_metric_id = fm2.d_metric_id \n" +
	"    --                      and    nvl(t.d_node_id,-1) = nvl(fm2.d_node_id,-1) \n" +
	"    --                      and    nvl(t.d_edge_id,-1) = nvl(fm2.d_edge_id,-1) \n" +
	"			   _WHERE_INNER_ \n" +
	"                          and    t.d_source_id = fm2.d_source_id \n" +
	"                          and    t.edr_type_id = fm2.edr_type_id \n" +
	"			   and	  fm2.d_period_id > ? \n" +
	"			   and	  fm2.d_period_id < ? \n" +
	"                          and    t.edr_sub_type_id = fm2.edr_sub_type_id) \n" +
        "         _WHERE_CLAUSES_" + 
        "       GROUP BY t.d_period_id, t.metric_definition_id \n" + 
        "    ), \n" + 
        "    t3 as \n" + 
        "    ( \n" + 
        "       SELECT mt.d_period_id as d_period_id, \n" + 
        "              round(sum(mt.max_metric),4) as max_metric, \n" + 
        "              round(sum(mt.min_metric),4) as min_metric, \n" + 
        "              round(sum(mt.average_metric),4) as average_metric, \n" + 
        "              round(sum(mt.moving_average),4) as moving_average, \n" + 
	"              round(sum(mt.sum_metric),4) as sum_metric, \n" +
        "              max(mt.threshold_version_id) as threshold_version_id \n" + 
        "        FROM \n" + 
        "        (   SELECT * from t1 \n" + 
        "             UNION ALL \n" + 
        "            SELECT * from t2 \n" + 
        "        ) mt \n" + 
        "       GROUP BY mt.d_period_id \n" + 
        "    ), \n" +
        "    t4 as \n" +
        "    (  SELECT /*+ materialize */ \n" +
        "              d_period_id, \n" + 
        "              max_metric, \n" + 
        "              min_metric, \n" + 
        "              average_metric, \n" + 
        "              moving_average, \n" + 
	"              sum_metric, \n" +
        "              c.forecast_metric_id, \n" + 
        "              c.metric_operator_id, \n" + 
        "              -- if forecast metric is defined, this overrides a last-value compare \n" + 
        "              nvl2(c.forecast_metric_id, 'Y', c.is_operator_relative) is_operator_relative, \n" + 
        "              -- value to apply threshold to (if not forecast) \n" + 
        "              -- if forecast metric id defined, then use forecast value (whether it exists or not) \n" + 
        "              -- else if active operator is defined as relative, use last value \n" + 
        "              -- otherwise active operator is absolute, use value defined in threshold \n" + 
        "              case when c.forecast_metric_id is not null \n" +
        "                   then forecasting.getForecast(c.forecast_metric_id, c.node_id, c.edge_id, c.source_id, c.edr_type_id, c.edr_sub_type_id, d_period_id, c.source_type_id) \n" + 
        "                   else decode(c.is_operator_relative, 'Y', metrics.getLastValue(d_period_id, c.node_id, c.edge_id, c.source_id, c.source_type_id, c.metric_operator_id, c.metric_definition_id, c.operator_order), 0) \n" +
        "              end compare_value, \n" + 
        "              nvl(t3.threshold_version_id, forecasting.getThresholdVersionId(c.edge_id, c.node_id, c.metric_definition_id, c.source_type_id, c.source_id, c.edr_type_id, c.edr_sub_type_id, d_period_id)) as threshold_version_id \n" + 
        "         FROM t3, c \n" +
        "    ) \n" +
        "SELECT d_period_id, \n" + 
        "       max_metric, \n" + 
        "       min_metric, \n" + 
        "       average_metric, \n" + 
        "       moving_average, \n" + 
        "       sum_metric, \n" +
        "       forecast_metric_id, \n" + 
        "       nvl2(forecast_metric_id, compare_value, null) as forecast_value, \n" + 
        "       is_operator_relative, \n" + 
        "       threshold_version_id \n" +
        "       _EXTRA_SELECT_ " +
        "  FROM t4 \n" + 
        "  ORDER BY d_period_id";
    private static final String _FILE_METRIC_SELECT_THRESHOLDS = 
        "       ,\n" +
        "       forecasting.getThresholdLimit(3000, 'MAX', threshold_version_id, compare_value, is_operator_relative) max_critical_threshold, \n" + 
        "       forecasting.getThresholdLimit(3000, 'MIN', threshold_version_id, compare_value, is_operator_relative) min_critical_threshold, \n" + 
        "       forecasting.getThresholdLimit(3001, 'MAX', threshold_version_id, compare_value, is_operator_relative) max_severe_threshold, \n" + 
        "       forecasting.getThresholdLimit(3001, 'MIN', threshold_version_id, compare_value, is_operator_relative) min_severe_threshold, \n" + 
        "       forecasting.getThresholdLimit(3002, 'MAX', threshold_version_id, compare_value, is_operator_relative) max_major_threshold, \n" + 
        "       forecasting.getThresholdLimit(3002, 'MIN', threshold_version_id, compare_value, is_operator_relative) min_major_threshold, \n" + 
        "       forecasting.getThresholdLimit(3003, 'MAX', threshold_version_id, compare_value, is_operator_relative) max_minor_threshold, \n" + 
        "       forecasting.getThresholdLimit(3003, 'MIN', threshold_version_id, compare_value, is_operator_relative) min_minor_threshold, \n" + 
        "       forecasting.getThresholdLimit(3004, 'MAX', threshold_version_id, compare_value, is_operator_relative) max_info_threshold, \n" + 
        "       forecasting.getThresholdLimit(3004, 'MIN', threshold_version_id, compare_value, is_operator_relative) min_info_threshold \n";

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
 	    String whereClauseInner = whereClause.replace("t.", "fm2.");        
 	    sql = sql.replaceFirst("_WHERE_INNER_",whereClauseInner); 

            if (thresholds)
            {
                sql = sql.replaceFirst("_EXTRA_SELECT_", _FILE_METRIC_SELECT_THRESHOLDS);       
            }
            else
            {
                sql = sql.replaceFirst("_EXTRA_SELECT_", "");
            }
            
            if (logger.isDebugEnabled())
            {
                logger.debug("MetricChartDAO.getMetricData(): Retrieving metric data points using sql - " + sql);
            }
            
            conn = UmDatabaseDAOUtils.getAutoConnection();
            cleaner.add(conn);

            // NOTE Avoid using bind variables as this can result in Oracle using
            // inappropriate/inefficient/cached execution plans
            Integer ALL_ID = new Integer(DropDown.ALL_ID);
            sql = sql.replaceFirst("\\?", nodeId == null || ALL_ID.equals(nodeId) ? "null" : nodeId.toString())
                     .replaceFirst("\\?", edgeId == null || ALL_ID.equals(edgeId) ? "null" : edgeId.toString())
                     .replaceFirst("\\?", sourceId == null || ALL_ID.equals(sourceId) ? "null" : sourceId.toString())
                     .replaceFirst("\\?", sourceTypeId == null || ALL_ID.equals(sourceTypeId) ? "null" : sourceTypeId.toString())
                     .replaceFirst("\\?", edrTypeId == null || ALL_ID.equals(edrTypeId) ? "null" : edrTypeId.toString())
                     .replaceFirst("\\?", edrSubTypeId == null || ALL_ID.equals(edrSubTypeId) ? "null" : edrSubTypeId.toString())
                     .replaceFirst("\\?", "to_date( '"+fromDate+"','DY, DD MONTH YYYY')")
                     .replaceFirst("\\?", "to_date( '"+toDate+"','DY, DD MONTH YYYY')")
                     .replaceFirst("\\?", metricDefinitionId.toString())
		     .replaceFirst("\\?", "to_date( '"+fromDate+"','DY, DD MONTH YYYY')")
                     .replaceFirst("\\?", "to_date( '"+toDate+"','DY, DD MONTH YYYY')");

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
                nodeId == null || DropDown.ALL_ID.equals(String.valueOf(nodeId)) ? null : nodeId,
                edgeId == null || DropDown.ALL_ID.equals(String.valueOf(edgeId)) ? null : edgeId,
                sourceId == null || DropDown.ALL_ID.equals(String.valueOf(sourceId)) ? null : sourceId,
                edrTypeId == null || DropDown.ALL_ID.equals(String.valueOf(edrTypeId)) ? null : edrTypeId,
                edrSubTypeId == null || DropDown.ALL_ID.equals(String.valueOf(edrSubTypeId)) ? null : edrSubTypeId,
                dPeriodId);

        if(forecast!=null)
        {
            returnValue = forecast.getYValue().doubleValue();
        }
        return returnValue;
    }
}

