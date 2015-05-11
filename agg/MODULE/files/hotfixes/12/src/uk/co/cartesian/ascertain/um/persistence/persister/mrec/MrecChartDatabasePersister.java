package uk.co.cartesian.ascertain.um.persistence.persister.mrec;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import org.apache.commons.lang.NotImplementedException;
import org.apache.log4j.Logger;
import org.apache.struts.util.LabelValueBean;

import uk.co.cartesian.ascertain.um.web.action.mrec.MrecChartSetup;
import uk.co.cartesian.ascertain.um.web.action.mrec.MrecChartable;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;
import uk.co.cartesian.ascertain.utils.persistence.Data;
import uk.co.cartesian.ascertain.utils.persistence.DatabasePersister;
import uk.co.cartesian.ascertain.utils.persistence.Resources;
import uk.co.cartesian.ascertain.utils.persistence.exceptions.ReadException;

public class MrecChartDatabasePersister extends DatabasePersister{

	protected static Logger logger = LogInitialiser.getLogger(MrecChartDatabasePersister.class.getName());

	public MrecChartDatabasePersister(Resources resources) {
		super(resources);
	}

	@Override
	protected void create(Data data, Connection conn) throws SQLException {
		throw new NotImplementedException();
	}

	@Override
	protected void delete(Data data, Connection conn) throws SQLException {
		throw new NotImplementedException();
	}

	@Override
	protected void read(Data data, Connection conn) throws SQLException, ReadException, IOException {
		throw new NotImplementedException();
	}

	@Override
	protected void readAll(List<Data> list, Connection conn) throws SQLException, ReadException, IOException {
		throw new NotImplementedException();
	}

	@Override
	protected void update(Data data, Connection conn) throws SQLException {
		throw new NotImplementedException();
	}

    private static final String CHARTDATA_SQL1 =
    	/* Get Aggregated Data from start of date range up to 
    	   the first d_period of current data in F_MREC in the date range */
        "SELECT 'y' as is_aggregate,\n" +
        "       afmc.d_day_id as d_period_id,\n" + 
        "       to_char(afmc.d_day_id,'DD/MM/YYYY HH24:MI') as d_period_string,\n" + 
        "       to_char(afmc.d_day_id,'DD-MM-YYYY-HH24-MI-SS') as d_period_url,\n" + 
        "       afmc.d_mrec_line_id,\n" +
        "       dmreclmv.mrec_line_type,\n" + 
        "       dmreclmv.mrec_line_name,\n" + 
        "       dmreclmv.mrec_definition_id,\n" +
        "       dmreclmv.mrec_version_id,\n" + 
        "       dmreclmv.mrec_type,\n" + 
        "       afmc.mrec,\n" + 
        "       null as issue_count\n" + 
        "FROM um.agg_f_mrec_chart afmc\n" + 
        "INNER JOIN um.d_mrec_line_mv dmreclmv\n" + 
        "        ON afmc.d_mrec_line_id = dmreclmv.d_mrec_line_id\n" + 
        "WHERE dmreclmv.mrec_definition_id = _MREC_DEF_ID_\n";
    
    private static final String CHARTDATA_SQL2 =
        "AND afmc.d_edge_id = _EDGE_ID_ \n";

    private static final String CHARTDATA_SQL3 =
        "AND afmc.d_day_id IN (\n" + 
        "    SELECT afmc2.d_day_id\n" + 
        "    FROM um.agg_f_mrec_chart afmc2\n" + 
        "    INNER JOIN um.d_mrec_line_mv dmreclmv2\n" + 
        "            ON afmc2.d_mrec_line_id = dmreclmv2.d_mrec_line_id\n" + 
        "    WHERE dmreclmv2.mrec_definition_id = _MREC_DEF_ID_\n";

    private static final String CHARTDATA_SQL4 =
        "    AND afmc2.d_edge_id = _EDGE_ID_ \n";

    private static final String CHARTDATA_SQL5A =
        "    AND afmc2.d_day_id >= _FROM_DATE_\n" + 
        "    AND afmc2.d_day_id < ( select trunc(min(f.d_period_id)) from f_mrec f \n" +
    	"						where f.d_period_id >= _FROM_DATE_  \n" +
    	"						AND f.d_period_id <= _TO_DATE_ )  \n" +
        ")\n" + 
    	"UNION ALL \n" +
    	/* Get NULL value (padding) for missing 
    	   Aggregated Data from start of date range up to 
    	   the first d_period of current data in F_MREC in the date range */
    	"(\n" +
    	"    SELECT 'y' as is_aggregate,\n" +
    	"           dd.d_day_id as d_period_id,\n" +
        "           to_char(dd.d_day_id,'DD/MM/YYYY HH24:MI') as d_period_string,\n" + 
        "           to_char(dd.d_day_id,'DD-MM-YYYY-HH24-MI-SS') as d_period_url,\n" + 
    	"           dmreclmv.d_mrec_line_id,\n" +
    	"           dmreclmv.mrec_line_type,\n" +
    	"           dmreclmv.mrec_line_name,\n" +
        "           dmreclmv.mrec_definition_id,\n" + 
        "           dmreclmv.mrec_version_id,\n" + 
        "           dmreclmv.mrec_type,\n" + 
    	"           null,\n" +
    	"           null\n" +
    	"    FROM um.d_mrec_line_mv  dmreclmv\n" +
    	"    FULL OUTER JOIN um.d_day dd\n" +
    	"                 ON 1=1\n" +
    	"    WHERE dmreclmv.mrec_definition_id = _MREC_DEF_ID_\n" + 
    	"    AND dd.d_day_id >= _FROM_DATE_\n" +
        "    AND dd.d_day_id < ( select trunc(min(f.d_period_id)) from f_mrec f \n" +
    	"					  	   where f.d_period_id >= _FROM_DATE_  \n" +
    	"						   AND f.d_period_id <= _TO_DATE_ )  \n" +
    	")\n" +
        "UNION ALL\n" + 
        "(\n" +
        "select\n" +
        "    'n' as is_aggregate,\n" +
        "    fmrec.d_period_id,\n" + 
        "    to_char(fmrec.d_period_id,'DD/MM/YYYY HH24:MI') as d_period_string,\n" + 
        "    to_char(fmrec.d_period_id,'DD-MM-YYYY-HH24-MI-SS') as d_period_url,\n" + 
        "    line.d_mrec_line_id,\n" + 
        "    line.mrec_line_type,\n" + 
        "    line.mrec_line_name,\n" + 
        "    line.mrec_definition_id,\n" + 
        "    line.mrec_version_id,\n" + 
        "    line.mrec_type,\n" + 
        "    sum(mrec),\n" + 
        "    null as issue_count\n" + 
        "from\n" + 
        "um.mrec mrec\n" + 
        "inner join um.f_mrec fmrec on mrec.mrec_id = fmrec.mrec_id and fmrec.mrec_set != 0\n" + 
        "inner join um.d_mrec_line_mv line on fmrec.d_mrec_line_id = line.d_mrec_line_id\n" + 
        "where mrec.mrec_definition_id = _MREC_DEF_ID_\n";
    
    private static final String CHARTDATA_SQL5B =
       "  and fmrec.d_period_id >= _FROM_DATE_\n" + 
        "  and fmrec.d_period_id <= _TO_DATE_\n" + 
        "group by fmrec.d_period_id, line.d_mrec_line_id, line.mrec_line_type, line.mrec_line_name, line.mrec_definition_id, line.mrec_version_id, line.mrec_type\n" + 
        "union all\n" + 
        "select\n" + 
        "    'n' as is_aggregate,\n" +
        "    fmrec.d_period_id,\n" + 
        "    to_char(fmrec.d_period_id,'DD/MM/YYYY HH24:MI') as d_period_string,\n" + 
        "    to_char(fmrec.d_period_id,'DD-MM-YYYY-HH24-MI-SS') as d_period_url,\n" + 
        "    line.d_mrec_line_id,\n" + 
        "    line.mrec_line_type,\n" + 
        "    line.mrec_line_name,\n" + 
        "    line.mrec_definition_id,\n" + 
        "    line.mrec_version_id,\n" + 
        "    line.mrec_type,\n" + 
        "    sum(mrec) as mrec,\n" + 
        "    decode (count(mij.issue_id), 0, null, count(mij.issue_id)) as issue_count\n" + 
        "from\n" + 
        "um.mrec mrec\n" + 
        "left outer join um.mrec_issue_jn mij on mrec.mrec_id = mij.mrec_id and mij.issue_status = 'O'\n" + 
        "inner join um.f_mrec fmrec on mrec.mrec_id = fmrec.mrec_id and fmrec.mrec_set = 0\n" + 
        "inner join um.d_mrec_line_mv line on fmrec.d_mrec_line_id = line.d_mrec_line_id\n" + 
        "where mrec.mrec_definition_id = _MREC_DEF_ID_";
        
    private static final String CHARTDATA_SQL6 =
        "    AND fmrec.d_edge_id = _EDGE_ID_ \n";

    private static final String CHARTDATA_SQL7 =
        "    AND fmrec.d_period_id >= _FROM_DATE_\n" + 
        "    AND fmrec.d_period_id <= _TO_DATE_\n" + 
        "    GROUP BY fmrec.d_period_id, line.d_mrec_line_id, line.mrec_line_type, line.mrec_line_name, line.mrec_definition_id, line.mrec_version_id, line.mrec_type\n" + 
        ")\n" +
    	"UNION ALL \n" +
    		/* Get NULL value padding for any missing d_periods */
		"(\n" +
		"    SELECT 'n' as is_aggregate,\n" +
		"           dp.d_period_id,\n" +
        "           to_char(dp.d_period_id,'DD/MM/YYYY HH24:MI') as d_period_string,\n" + 
        "           to_char(dp.d_period_id,'DD-MM-YYYY-HH24-MI-SS') as d_period_url,\n" + 
		"           dmreclmv.d_mrec_line_id,\n" +
		"           dmreclmv.mrec_line_type,\n" +
		"           dmreclmv.mrec_line_name,\n" +
        "           dmreclmv.mrec_definition_id,\n" + 
        "           dmreclmv.mrec_version_id,\n" + 
        "           dmreclmv.mrec_type,\n" + 
		"           null,\n" +
		"           null\n" +
		"    FROM um.d_mrec_line_mv  dmreclmv\n" +
		"    FULL OUTER JOIN um.d_period dp\n" +
		"                 ON 1=1\n" +
		"    WHERE dmreclmv.mrec_definition_id = _MREC_DEF_ID_\n" + 
        "    AND dp.d_period_id >= ( select min(f.d_period_id) from f_mrec f \n" +
	    "					  	   where f.d_period_id >= _FROM_DATE_  \n" +
	    "						   AND f.d_period_id <= _TO_DATE_ )  \n" +
		"    AND dp.d_period_id <= _TO_DATE_\n" +
		")\n";         
    
    private static final String CHARTDATA_PARENT_QUERY = 
        "mrec_summ as ( \n" +
        "  SELECT /*+ materialize */ t.*, \n" + 
        "          CASE WHEN t.mrec_line_name = 'Reconciliation' AND mrec IS NOT NULL \n" + 
        "               THEN volumetricrec.getThreshVerIdForDPeriod(t.mrec_version_id, t.d_period_id) \n" + 
        "               ELSE NULL \n" +
        "          END threshold_version_id, \n" +
        "          i.i_sum_mrec \n" +
        "     FROM t \n" +
        "     LEFT OUTER JOIN (SELECT is_aggregate, d_period_id, SUM(mrec) AS i_sum_mrec \n" +
        "                        FROM t \n" +
        "                       WHERE mrec_line_type IN ('i File Set', 'i Side') \n" +
        "                       GROUP BY is_aggregate, d_period_id) i \n" +
        "                  ON t.is_aggregate = i.is_aggregate \n" +
        "                 AND t.d_period_id = i.d_period_id \n" +
        "                 AND t.mrec IS NOT NULL \n" +
        "                 AND t.mrec_line_name = 'Reconciliation' \n" +
        ") \n" +
        "SELECT is_aggregate, d_period_id, d_period_string, d_period_url, d_mrec_line_id, mrec_line_type, mrec_line_name, mrec_definition_id, mrec_type, mrec, issue_count \n" + 
        "       _THRESHOLDS_SELECT_" +
        "  FROM mrec_summ \n";

    private static final String _FILE_METRIC_SELECT_THRESHOLDS = 
        "       , volumetricrec.getThresholdLimit(3000, 'MAX', threshold_version_id, i_sum_mrec) max_critical_threshold \n" +
        "       , volumetricrec.getThresholdLimit(3000, 'MIN', threshold_version_id, i_sum_mrec) min_critical_threshold \n" +
        "       , volumetricrec.getThresholdLimit(3001, 'MAX', threshold_version_id, i_sum_mrec) max_severe_threshold \n" +
        "       , volumetricrec.getThresholdLimit(3001, 'MIN', threshold_version_id, i_sum_mrec) min_severe_threshold \n" +
        "       , volumetricrec.getThresholdLimit(3002, 'MAX', threshold_version_id, i_sum_mrec) max_major_threshold \n" +
        "       , volumetricrec.getThresholdLimit(3002, 'MIN', threshold_version_id, i_sum_mrec) min_major_threshold \n" +
        "       , volumetricrec.getThresholdLimit(3003, 'MAX', threshold_version_id, i_sum_mrec) max_minor_threshold \n" +
        "       , volumetricrec.getThresholdLimit(3003, 'MIN', threshold_version_id, i_sum_mrec) min_minor_threshold \n" +
        "       , volumetricrec.getThresholdLimit(3004, 'MAX', threshold_version_id, i_sum_mrec) max_info_threshold \n" +
        "       , volumetricrec.getThresholdLimit(3004, 'MIN', threshold_version_id, i_sum_mrec) min_info_threshold \n";

    private static final String _FILE_METRIC_SELECT_NO_THRESHOLDS = 
        "       , null max_critical_threshold \n" +
        "       , null min_critical_threshold \n" +
        "       , null max_severe_threshold \n" +
        "       , null min_severe_threshold \n" +
        "       , null max_major_threshold \n" +
        "       , null min_major_threshold \n" +
        "       , null max_minor_threshold \n" +
        "       , null min_minor_threshold \n" +
        "       , null max_info_threshold \n" +
        "       , null min_info_threshold \n";


	private static final String READ_MREC_CHARTDATA_DISCRETE_ORDER =
		"ORDER BY d_period_id, mrec_line_type\n";


	/**
	 * 
	 * @param chartable
	 * @return
	 */
	public static String getChartSql(MrecChartable chartable)
	{
        // NOTE Avoid using bind variables as this can result in Oracle using
        // inappropriate/inefficient/cached execution plans

	    String sql = CHARTDATA_SQL1;
		
		if(MrecChartSetup.MREC_TYPE_FILE_VALUE.equals(chartable.getMrecType()) && chartable.getEdgeId() != null && chartable.getEdgeId() != 0)
		{
		    //This is a file set reconciliation so we need to add the edge stuff
		    sql += CHARTDATA_SQL2 + CHARTDATA_SQL3 + CHARTDATA_SQL4 + CHARTDATA_SQL5A + CHARTDATA_SQL6 + CHARTDATA_SQL5B + CHARTDATA_SQL6 + CHARTDATA_SQL7;

		    //Substitute our edge value
	        sql = sql.replaceAll("_EDGE_ID_", chartable.getEdgeId().toString());
		}
		else
		{
            //This is a time based reconciliation so we do not need to add the edge stuff
            sql += CHARTDATA_SQL3 + CHARTDATA_SQL5A + CHARTDATA_SQL5B + CHARTDATA_SQL7;
		}

		//Substitute in our dates
		sql = sql.replaceAll("_FROM_DATE_", "to_date( '"+chartable.getFromDate()+"','DY, DD MONTH YYYY')")
		         .replaceAll("_TO_DATE_", "to_date( '"+chartable.getToDate()+"','DY, DD MONTH YYYY')");

        //Substitute our mrec definition value
        sql = sql.replaceAll("_MREC_DEF_ID_", chartable.getMrecDefinitionId().toString());

        sql = "WITH t AS ( \n" + sql + "), \n" +
              CHARTDATA_PARENT_QUERY.replace("_THRESHOLDS_SELECT_", chartable.getIncludeThresholds() != null && chartable.getIncludeThresholds().equalsIgnoreCase("true") ? _FILE_METRIC_SELECT_THRESHOLDS : _FILE_METRIC_SELECT_NO_THRESHOLDS);

		return sql;
	}

	/**
	 * Returns the result set inserting an 'order by' clause into the query. Independently on how the 
	 * data table is ordered on the page, the result set used to create the chart has to be always ordered by date.
	 */
	public ResultSet readOrderedChartResults(Statement stmt, MrecChartable chartable) throws SQLException
	{
		String chartSql = getChartSql(chartable);
		int orderByClausePosition = chartSql.toLowerCase().lastIndexOf("order by");		
		if (orderByClausePosition > 0)
		{
			chartSql = chartSql.substring(0, orderByClausePosition);
		}
				
		chartSql = chartSql + READ_MREC_CHARTDATA_DISCRETE_ORDER;

		logger.debug("MrecChartDatabasePersister.readOrderedChartResults(...) - Statement: \n" + chartSql);
		
		return stmt.executeQuery(chartSql);
		
	}


	private static final String READ_ALL_LINES =
		"SELECT t.d_mrec_line_id, t.mrec_line_name\n" +
		"  FROM\n" + 
		"       um.d_mrec_line_mv t\n" + 
		" WHERE\n" + 
		"   t.mrec_definition_id = ?\n" + 
		" ORDER BY t.mrec_line_name";
	
	public void readAllLineIds(MrecChartable chartable, List<LabelValueBean> mrecLines, Connection conn)
	throws SQLException, ReadException
	{
		Statement stmnt = null;
		ResultSet results = null;
		try
		{
			// NOTE Avoid using bind variables as this can result in Oracle using
			// inappropriate/inefficient/cached execution plans
			String readAllLineIdsSQL = READ_ALL_LINES.replaceFirst("\\?", chartable.getMrecDefinitionId().toString());

			logger.debug("MrecChartDatabasePersister:readAllLineIds(...) - SQL: \n" + readAllLineIdsSQL);

			stmnt = conn.createStatement();
			results = stmnt.executeQuery(readAllLineIdsSQL);
			while(results.next())
			{
				mrecLines.add(new LabelValueBean(results.getString("mrec_line_name"), results.getString("d_mrec_line_id")));
			}
		}
		finally
		{
			try { results.close(); } catch (Throwable te) {}
			try { stmnt.close(); } catch (Throwable te) {}
		}
	}

	public static Object getChartAggDataSql(MrecChartable chartable) 
	{
		String sql = getChartSql(chartable);
		return sql;
	}

}