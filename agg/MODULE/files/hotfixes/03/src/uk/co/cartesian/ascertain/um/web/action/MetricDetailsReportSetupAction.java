
package uk.co.cartesian.ascertain.um.web.action;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import uk.co.cartesian.ascertain.dgf.persistence.dropdown.EdgeRefDropDown;
import uk.co.cartesian.ascertain.dgf.persistence.dropdown.NodeRefDropDown;
import uk.co.cartesian.ascertain.imm.db.dao.dropdowns.ThresholdVersionRefDropDown;
import uk.co.cartesian.ascertain.um.UMProperties;
import uk.co.cartesian.ascertain.um.persistence.dropdown.EdrSubTypeRefDropDown;
import uk.co.cartesian.ascertain.um.persistence.dropdown.EdrTypeRefDropDown;
import uk.co.cartesian.ascertain.um.persistence.dropdown.MetricDefinitionRefDropDown;
import uk.co.cartesian.ascertain.um.persistence.dropdown.MetricTypeRefDropDown;
import uk.co.cartesian.ascertain.um.persistence.dropdown.SourceRefDropDown;
import uk.co.cartesian.ascertain.um.persistence.dropdown.SourceTypeRefDropDown;
import uk.co.cartesian.ascertain.um.persistence.dropdown.YesNoDropDown;
import uk.co.cartesian.ascertain.utils.exception.WebApplicationException;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;
import uk.co.cartesian.ascertain.web.helpers.Utils;
import uk.co.cartesian.ascertain.web.session.bean.AscertainSessionUser;
import uk.co.cartesian.ascertain.web.tpm.ModularResultSetTPMConfiguration;
import uk.co.cartesian.ascertain.web.tpm.TPMColumnConfiguration;
import uk.co.cartesian.ascertain.web.tpm.TPMException;
import uk.co.cartesian.ascertain.web.tpm.action.TPMConfigurationRepository;

/**
 * @author dplant
 */
public class MetricDetailsReportSetupAction
extends Action
{
	static Logger logger = LogInitialiser.getLogger(MetricDetailsReportSetupAction.class.getName());

	public static final String FORM_EDGE_METRIC_DEF_ID = "edgeMetricId";
	public static final String FORM_NODE_METRIC_DEF_ID = "nodeMetricId";
	public static final String FORM_NODE_ID = "nodeId";
	public static final String FORM_EDGE_ID = "edgeId";
	public static final String FORM_EDR_TYPE_ID = "edrTypeId";
	public static final String FORM_EDR_SUB_TYPE_ID = "edrSubTypeId";
    public static final String FORM_SOURCE_TYPE_ID = "sourceTypeId";
    public static final String FORM_SOURCE_ID = "sourceId";
	public static final String FORM_SAMPLE_DATE_FROM = "fromDate";
	public static final String FORM_SAMPLE_DATE_TO = "toDate";
	public static final String FORM_IS_ISSUE = "isIssue";
	public static final String FORM_IS_COMPARATOR = "isComparator";
	public static final String FORM_IS_NODE_SELECTED = "isNodeSelected";

	public static final String TPM_UID = "uk.co.cartesian.ascertain.um.web.action.MetricDetailsReport";

	private final String FIXED_CLAUSE = 
		"select fm.f_metric_id,\n" +
		"       to_char(fm.sample_date,'"+Utils.ORACLE_SHORT_DATE_TIME_FORMAT+"') as sample_date_short,\n" + 
		"       to_char(fm.creation_date,'"+Utils.ORACLE_SHORT_DATE_TIME_FORMAT+"') as creation_date_short,\n" + 
		"       fm.sample_date,\n" + 
		"       fm.creation_date,\n" + 
		"       to_char(fm.d_period_id,'"+Utils.URL_FRIENDLY_LONG_DATE_FORMAT+"') as d_period_id,\n" + 
		"       fm.d_metric_id,\n" + 
		"       mdr.metric_type_id,\n" +
		"       fm.d_node_id,\n" + 
		"       fm.d_edge_id,\n" + 
		"       fm.d_source_id,\n" + 
		"       fm.source_type_id,\n" + 
		"       fm.edr_type_id,\n" + 
		"       fm.edr_sub_type_id,\n" + 
		"       fm.threshold_version_id,\n" + 
		"       to_char(fm.forecast_value,'99999999990D9999') as forecast_value,\n" + 
		"       to_char(fm.i_value,'99999999990D99') as i_value,\n" + 
		"       to_char(fm.j_value,'99999999990D99') as j_value,\n" + 
		"       fm.raw_value,\n" + 
		"       to_char(fm.metric,'99999999990D9999') as metric,\n" + 
		"       to_char(fm.comparison,'99999999990D9999') as comparison,\n" + 
		"       fm.is_issue,\n" + 
		"       fm.is_comparator\n" + 
		"  from f_metric fm, metric_definition_ref mdr\n" +
		"  where 1=1\n" +
		"  and fm.metric_definition_id = mdr.metric_definition_id \n";
	
	private final String FIXED_CLAUSE_DISTINCT = 
		"select fm.f_metric_id,\n" +
		"       to_char(fm.sample_date,'"+Utils.ORACLE_SHORT_DATE_TIME_FORMAT+"') as sample_date_short,\n" + 
		"       to_char(fm.creation_date,'"+Utils.ORACLE_SHORT_DATE_TIME_FORMAT+"') as creation_date_short,\n" + 
		"       fm.sample_date,\n" + 
		"       fm.creation_date,\n" + 
		"       to_char(fm.d_period_id,'"+Utils.URL_FRIENDLY_LONG_DATE_FORMAT+"') as d_period_id,\n" + 
		"       fm.d_metric_id,\n" + 
		"       mdr.metric_type_id,\n" +
		"       fm.d_node_id,\n" + 
		"       fm.d_edge_id,\n" + 
		"       fm.d_source_id,\n" + 
		"       fm.source_type_id,\n" + 
		"       fm.edr_type_id,\n" + 
		"       fm.edr_sub_type_id,\n" + 
		"       fm.threshold_version_id,\n" + 
		"       to_char(fm.forecast_value,'99999999990D9999') as forecast_value,\n" + 
		"       to_char(fm.i_value,'99999999990D99') as i_value,\n" + 
		"       to_char(fm.j_value,'99999999990D99') as j_value,\n" + 
		"       fm.raw_value,\n" + 
		"       to_char(fm.metric,'99999999990D9999') as metric,\n" + 
		"       to_char(fm.comparison,'99999999990D9999') as comparison,\n" + 
		"       fm.is_issue,\n" + 
		"       fm.is_comparator\n" + 
		"  from ( \n" +
		"        select f.*, \n" + 
                "               rank() OVER ( partition by f.d_period_id, d_metric_id, d_node_id, d_edge_id, \n" + 
		"               d_source_id, source_type_id, f.edr_type_id, f.edr_sub_type_id ORDER BY creation_date ) rank \n" +
		"        from   um.f_metric f \n" +
		"	) fm \n " +
		"    , metric_definition_ref mdr\n" +
		"  where 1=1\n" +
		"  and fm.metric_definition_id = mdr.metric_definition_id \n" + 
		"  and fm.rank = 1 \n";
	/**
	 */
	public ActionForward execute(ActionMapping mapping,
			ActionForm form,
			HttpServletRequest request,
			HttpServletResponse response)
	throws IOException, ServletException
	{
		if (logger.isDebugEnabled()) logger.debug("MetricDetailsReportSetupAction:execute(...) - START");
		ActionForward returnValue = mapping.findForward("success");

		final DynaActionForm dForm = (DynaActionForm)form;

		try
		{
			//Initialise the meta data
			ModularResultSetTPMConfiguration sourcesMetaData = initialiseTPM(dForm, request);

			//Place metadata in the request
			TPMConfigurationRepository.add(request, sourcesMetaData, TPM_UID);
		}
		catch(Exception e)
		{
			String msg = "Could not initialise the TPM. \n" + e.toString();
			logger.error("MetricDetailsReportSetupAction:exeute(...) - " + msg, e);
			throw new WebApplicationException(msg);
		}

		return returnValue;
	}


	/**
	 * @param query
	 * @return
	 */
	private ModularResultSetTPMConfiguration initialiseTPM(DynaActionForm dForm,
			HttpServletRequest request)
	throws SQLException, TPMException
	{
		ModularResultSetTPMConfiguration returnValue = new ModularResultSetTPMConfiguration( AscertainSessionUser.getLocale(request) );
		returnValue.setConnectionPool(UMProperties.getInstance().getProperty("CP_NAME"));

		StringBuffer sqlQuery = new StringBuffer();
		
		String excludeDuplicates = request.getParameter("excludeDuplicates");
        if (excludeDuplicates == null || "false".equals(excludeDuplicates))
        {
	        sqlQuery.append(FIXED_CLAUSE);
        }
        else
        {
	        sqlQuery.append(FIXED_CLAUSE_DISTINCT);
        }

		Integer metricDefId = null;
		Integer nodeId = null;
		Integer edgeId = null;
		if(dForm.get(FORM_IS_NODE_SELECTED) != null)
		{
			if(((Boolean)dForm.get(FORM_IS_NODE_SELECTED)).booleanValue())
	        {
				nodeId = (Integer)dForm.get(FORM_NODE_ID);
				metricDefId = (Integer)dForm.get(FORM_NODE_METRIC_DEF_ID);
				edgeId = null;
	        }
	        else
	        {
				edgeId = (Integer)dForm.get(FORM_EDGE_ID);
				metricDefId = (Integer)dForm.get(FORM_EDGE_METRIC_DEF_ID);
				nodeId = null;
	        }
		}

		Integer edrTypeId = (Integer)dForm.get(FORM_EDR_TYPE_ID);
		Integer edrSubTypeId = (Integer)dForm.get(FORM_EDR_SUB_TYPE_ID);
        Integer sourceTypeId = (Integer)dForm.get(FORM_SOURCE_TYPE_ID);
        Integer sourceId = (Integer)dForm.get(FORM_SOURCE_ID);
		String sampleDateFrom = (String)dForm.get(FORM_SAMPLE_DATE_FROM);
		String sampleDateTo = (String)dForm.get(FORM_SAMPLE_DATE_TO);
		String isIssue = (String)dForm.get(FORM_IS_ISSUE);
		String isComparator = (String)dForm.get(FORM_IS_COMPARATOR);
		String action = request.getParameter("action");
		if (!"clear".equalsIgnoreCase(action)) {
			if (metricDefId != null && metricDefId.intValue() != 0) {
				sqlQuery.append("\n and d_metric_id = ").append(metricDefId);
			}
			if (nodeId != null && nodeId.intValue() != 0) {
				sqlQuery.append("\n and d_node_id = ").append(nodeId);
			}
			if (edgeId != null && edgeId.intValue() != 0) {
				sqlQuery.append("\n and d_edge_id = ").append(edgeId);
			}
			if (edrTypeId != null && edrTypeId.intValue() != 0) {
				sqlQuery.append("\n and edr_type_id = ").append(edrTypeId);
			}
			if (edrSubTypeId != null && edrSubTypeId.intValue() != 0) {
				sqlQuery.append("\n and edr_sub_type_id = ").append(edrSubTypeId);
			}
            if (sourceTypeId != null && sourceTypeId.intValue() != 0) {
                sqlQuery.append("\n and source_type_id = ").append(sourceTypeId);
            }
            if (sourceId != null && sourceId.intValue() != 0) {
                sqlQuery.append("\n and d_source_id = ").append(sourceId);
            }
			// use today if sample date not given
			if(sampleDateFrom != null && sampleDateTo != null)
			{
				sqlQuery.append("\n and d_period_id >= to_date('")
				.append(sampleDateFrom)
				.append("','Dy, DD Month YYYY HH24:MI')");

				sqlQuery.append("\n and d_period_id < to_date('")
				.append(sampleDateTo)
				.append("','Dy, DD Month YYYY HH24:MI')");				
			}
			else
			{
				sqlQuery.append("\n and d_period_id >= trunc(sysdate)");
				sqlQuery.append("\n and d_period_id < trunc(sysdate + 1)");
			}
			if ((isIssue != null) && (isIssue.length() > 0)) 
			{
				if ("Y".equalsIgnoreCase(isIssue) || "N".equalsIgnoreCase(isIssue)) 
				{
					sqlQuery.append("\n and is_issue = '").append(isIssue).append("'");
				}
			}
			if ((isComparator != null) && (isComparator.length() > 0)) 
			{
				if ("Y".equalsIgnoreCase(isComparator) || "N".equalsIgnoreCase(isComparator)) 
				{
					sqlQuery.append("\n and is_comparator = '").append(isComparator).append("'");
				}
			}
		}
		else
		{ // On clear, set date to today
			sqlQuery.append("\n and d_period_id >= trunc(sysdate)");
			sqlQuery.append("\n and d_period_id < trunc(sysdate + 1)");
		}

		returnValue.setFixedQuery(sqlQuery.toString());

		// order by f_metric_id by default
		//returnValue.setOrderByClause("\n ORDER BY f_metric_id");

		// row handler
		returnValue.setRowHandlerJsp("/jsp/um/MetricDetailsReportRow.jsp");
		returnValue.setShowRowLevelSelections(true);

		// Rows per page
		returnValue.setPageSize(50);

		// Filters and Mappings -- KEEP as used within the TPM
		MetricDefinitionRefDropDown mddd = new MetricDefinitionRefDropDown(true, false);
		request.setAttribute("MD_REP_METRIC_DEFINITION_DROP_DOWN", mddd);

		NodeRefDropDown nrdd = new NodeRefDropDown(true, false); 
		request.setAttribute("MD_REP_NODE_DROP_DOWN", nrdd);

		EdgeRefDropDown erdd = new EdgeRefDropDown(true, false); 
		request.setAttribute("MD_REP_EDGE_DROP_DOWN", erdd);

        SourceTypeRefDropDown stdd = new SourceTypeRefDropDown(true, false); 
        request.setAttribute("MD_REP_SOURCE_TYPE_DROP_DOWN", stdd);

        SourceRefDropDown srdd = new SourceRefDropDown(true, false); 
        request.setAttribute("MD_REP_SOURCE_DROP_DOWN", srdd);

		SourceTypeRefDropDown strdd = new SourceTypeRefDropDown(true, false); 
		request.setAttribute("MD_REP_SOURCE_TYPE_DROP_DOWN", strdd);

		MetricTypeRefDropDown mtrdd = new MetricTypeRefDropDown(true, false); 
		request.setAttribute("MD_REP_METRIC_TYPE_DROP_DOWN", mtrdd);

		EdrTypeRefDropDown edrdd = new EdrTypeRefDropDown(true, false); 
		request.setAttribute("MD_REP_EDR_TYPE_DROP_DOWN", edrdd);

		EdrSubTypeRefDropDown edrsdd = new EdrSubTypeRefDropDown(true, false); 
		request.setAttribute("MD_REP_EDR_SUB_TYPE_DROP_DOWN", edrsdd);

		ThresholdVersionRefDropDown tvrdd = new ThresholdVersionRefDropDown(true, false); 
		request.setAttribute("MD_REP_THRESHOLD_VERSION_DROP_DOWN", tvrdd);

		YesNoDropDown yorndd = new YesNoDropDown(true, false);
		request.setAttribute("MD_REP_Y_OR_N_DROP_DOWN", yorndd);

		TPMColumnConfiguration column = new TPMColumnConfiguration("d_period_id", "dp", "dp");
		column.setType(TPMColumnConfiguration.DATE_TYPE);
		column.setState(TPMColumnConfiguration.HIDDEN);
		returnValue.addColumn(column);

		column = new TPMColumnConfiguration("f_metric_id", "ID", "Metric Id");
		column.setType(TPMColumnConfiguration.NUMBER_TYPE);
		column.setUniqueKey(true);
		returnValue.addColumn(column);

		column = new TPMColumnConfiguration("sample_date_short", "Sample Date", "Sample Date");
		column.setType(TPMColumnConfiguration.DATE_TYPE);
		// ORDER on the full date column for accuracy and speed (indexes)
		column.setOrderByColumnId("sample_date");
		returnValue.addColumn(column);

		column = new TPMColumnConfiguration("sample_date", "Sample Date Full", "Sample Date Full");
		column.setType(TPMColumnConfiguration.DATE_TYPE);
		column.setState(TPMColumnConfiguration.HIDDEN);
		returnValue.addColumn(column);

		column = new TPMColumnConfiguration("creation_date_short", "Creation Date", "Creation Date");
		column.setType(TPMColumnConfiguration.DATE_TYPE);
		// ORDER on the full date column for accuracy and speed (indexes)
		column.setOrderByColumnId("creation_date");
		returnValue.addColumn(column);

		column = new TPMColumnConfiguration("creation_date", "Creation Date Full", "Creation Date Full");
		column.setType(TPMColumnConfiguration.DATE_TYPE);
		column.setState(TPMColumnConfiguration.HIDDEN);
		returnValue.addColumn(column);

		column = new TPMColumnConfiguration("d_metric_id", "Metric Definition", "Metric Definition");
		column.setType(TPMColumnConfiguration.STRING_TYPE);
		// set the value mapping from the drop down
		column.setMapping(mddd);        
		returnValue.addColumn(column);

		column = new TPMColumnConfiguration("d_node_id", "Node", "Node");
		column.setType(TPMColumnConfiguration.STRING_TYPE);
		// set the value mapping from the drop down
		column.setMapping(nrdd);        
		returnValue.addColumn(column);

		column = new TPMColumnConfiguration("d_edge_id", "Edge", "Edge");
		column.setType(TPMColumnConfiguration.STRING_TYPE);
		// set the value mapping from the drop down
		column.setMapping(erdd);        
		returnValue.addColumn(column);

		column = new TPMColumnConfiguration("d_source_id", "Source", "Source");
		column.setType(TPMColumnConfiguration.STRING_TYPE);
		// set the value mapping from the drop down
		column.setMapping(srdd);        
		returnValue.addColumn(column);

		column = new TPMColumnConfiguration("source_type_id", "Source Type", "Source Type");
		column.setType(TPMColumnConfiguration.STRING_TYPE);
		// set the value mapping from the drop down
		column.setMapping(strdd);        
		returnValue.addColumn(column);

		column = new TPMColumnConfiguration("edr_type_id", "EDR Type", "EDR Type");
		column.setType(TPMColumnConfiguration.STRING_TYPE);
		// set the value mapping from the drop down
		column.setMapping(edrdd);        
		returnValue.addColumn(column);

		column = new TPMColumnConfiguration("edr_sub_type_id", "EDR Subtype", "EDR Subtype");
		column.setType(TPMColumnConfiguration.STRING_TYPE);
		// set the value mapping from the drop down
		column.setMapping(edrsdd);        
		returnValue.addColumn(column);

		column = new TPMColumnConfiguration("threshold_version_id", "Threshold Version", "Threshold Version");
		column.setType(TPMColumnConfiguration.STRING_TYPE);
		// set the value mapping from the drop down
		column.setMapping(tvrdd);        
		returnValue.addColumn(column);

		column = new TPMColumnConfiguration("i_value", "i", "i Value");
		column.setType(TPMColumnConfiguration.NUMBER_TYPE);
		returnValue.addColumn(column);

		column = new TPMColumnConfiguration("j_value", "j", "j Value");
		column.setType(TPMColumnConfiguration.NUMBER_TYPE);
		returnValue.addColumn(column);

		// hidden as usually equal to metric - adds very little value
		column = new TPMColumnConfiguration("raw_value", "Raw", "Raw Value");
		column.setType(TPMColumnConfiguration.NUMBER_TYPE);
		column.setState(TPMColumnConfiguration.HIDDEN);
		returnValue.addColumn(column);

		column = new TPMColumnConfiguration("metric", "Metric", "Metric");
		column.setType(TPMColumnConfiguration.NUMBER_TYPE);
		returnValue.addColumn(column);

		column = new TPMColumnConfiguration("forecast_value", "Forecast", "Forecast Value");
		column.setType(TPMColumnConfiguration.NUMBER_TYPE);
		returnValue.addColumn(column);

		column = new TPMColumnConfiguration("comparison", "Comparison", "Comparison - ABS : m-f  REL: (m-f)/f or (m-f)/m where f = 0");
		column.setType(TPMColumnConfiguration.NUMBER_TYPE);
		returnValue.addColumn(column);

		column = new TPMColumnConfiguration("is_issue", "Issues", "Issues");
		column.setType(TPMColumnConfiguration.STRING_TYPE);
		returnValue.addColumn(column);

		column = new TPMColumnConfiguration("is_comparator", "Is Comparator", "Is Comparator");
		column.setType(TPMColumnConfiguration.STRING_TYPE);
		returnValue.addColumn(column);

		return returnValue;

	}
}
