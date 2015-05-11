package uk.co.cartesian.ascertain.um.web.action.mrec;

import java.sql.SQLException;
import java.util.Locale;
import java.util.ResourceBundle;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.cxf.common.util.StringUtils;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import uk.co.cartesian.ascertain.um.UMProperties;
import uk.co.cartesian.ascertain.utils.exception.WebApplicationException;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;
import uk.co.cartesian.ascertain.utils.parameters.Parameter;
import uk.co.cartesian.ascertain.utils.parameters.ParameterManager;
import uk.co.cartesian.ascertain.web.session.bean.AscertainSessionUser;
import uk.co.cartesian.ascertain.web.tpm.ModularResultSetTPMConfiguration;
import uk.co.cartesian.ascertain.web.tpm.TPMColumnConfiguration;
import uk.co.cartesian.ascertain.web.tpm.TPMException;
import uk.co.cartesian.ascertain.web.tpm.action.TPMConfigurationRepository;

public class MrecDefinitionSetup extends Action {

	private static final Logger logger = LogInitialiser.getLogger(MrecDefinitionSetup.class.getName());

	//Page specific constants
	public static final String TMP_UID = "uk.co.cartesian.ascertain.um.web.action.mrec.MrecDefinition";

	private static final String JSP_ROW_HANDLER = "/jsp/um/mrec/MrecDefinitionRow.jsp";

	private static final String SQL_STATEMENT1 = 
		"SELECT t.mrec_definition_id,\n" +
		"       t.name,\n" + 
		"       t.description,\n" + 
		"       t0.category,\n" + 
		"       t1.name graph_name,\n" + 
		"       decode(t.mrec_type, 'T', 'Timeslot', 'F', 'Fileset') type,\n" + 
		"       t1.graph_id as network_graph_id,\n"; 

	private static final String SQL_STATEMENT2 = 
		"       as web_graph_id,\n" + 
		"       'ScenarioModel' as web_graph_name,\n" + 
		"       edge_associations\n" + 
		"  FROM um.mrec_definition_ref t\n" + 
		"  LEFT OUTER JOIN (select mrec_definition_id,\n" + 
		"                          decode(count(*), '', 'N', 'Y') as edge_associations\n" + 
		"                     from um.edge_mrec_jn te\n" + 
		"                    group by te.mrec_definition_id) mejn ON mejn.mrec_definition_id =\n" + 
		"                                                            t.mrec_definition_id,\n" + 
		" um.mrec_category_ref t0,\n" + 
		" dgf.graph_ref t1\n" + 
		" WHERE t.mrec_category_id = t0.mrec_category_id\n" + 
		"   AND t.graph_id = t1.graph_id\n";
	
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
	throws Exception {
		
		logger.debug("MrecDefinitionSetup:execute(...) - START");
		String sql = null;
		try {
			ParameterManager pm = ParameterManager.getInstance();
			Parameter parameter = pm.getParameter("Graph ID", "SCENARIO_MODEL_OVERVIEW");
			sql = SQL_STATEMENT1 + parameter.getValue() + SQL_STATEMENT2;
			
			//Initialise the meta data
			Locale locale = AscertainSessionUser.getLocale( request );
			ModularResultSetTPMConfiguration sourcesMetaData = initialiseSourcesView(sql,locale);

			//Place metadata in the request
			TPMConfigurationRepository.add(request, sourcesMetaData, TMP_UID);
		} catch (Exception e) {
			String msg = "Could not initialise the page. \n" + e.toString();
			logger.error("MrecDefinitionSetup:exeute(...) - "
					+ msg, e);
			throw new WebApplicationException(msg);
		}

		DynaActionForm dForm = (DynaActionForm)form;
		try
		{
			String iSideTitle = ResourceBundle.getBundle("ApplicationResource", AscertainSessionUser.getLocale(request)).getString("um.metric_reconciliation.label.i_side");
			dForm.set("iSideTitle", iSideTitle);
		}
		catch (Exception e)
		{
		}
		try
		{
			String jSideTitle = ResourceBundle.getBundle("ApplicationResource", AscertainSessionUser.getLocale(request)).getString("um.metric_reconciliation.label.j_side");
			dForm.set("jSideTitle", jSideTitle);
		}
		catch (Exception e)
		{
		}
		
		return mapping.findForward("success");
	}	

	/**
	 * @param sql_statement 
	 * @param query
	 * @return
	 */
	private ModularResultSetTPMConfiguration initialiseSourcesView(String sql,Locale locale )
	throws SQLException, TPMException
	{
		ModularResultSetTPMConfiguration returnValue = new ModularResultSetTPMConfiguration(locale);
		returnValue.setConnectionPool(UMProperties.getInstance().getProperty("CP_NAME"));
		returnValue.setFixedQuery(sql);
		//returnValue.setOrderByClause( " ORDER BY t.name" );

		returnValue.setRowHandlerJsp(JSP_ROW_HANDLER);
		returnValue.setRowHeaderHandlerJsp("/jsp/web/tpm/DefaultRowHeaderPlus5.jsp");

		TPMColumnConfiguration column = new TPMColumnConfiguration("mrec_definition_id", "ID", "Metric Reconciliation Id");
		column.setType(TPMColumnConfiguration.NUMBER_TYPE);
		column.setUniqueKey(true);
		returnValue.addColumn(column);

		column = new TPMColumnConfiguration("name", "Name", "Name");
		column.setType(TPMColumnConfiguration.STRING_TYPE);
		returnValue.addColumn(column);
		column.setOrderByState(TPMColumnConfiguration.OrderByState.ASCENDING);

		column = new TPMColumnConfiguration("description", "Description");
		column.setType(TPMColumnConfiguration.STRING_TYPE);
		returnValue.addColumn(column);		

		column = new TPMColumnConfiguration("type", "Type");
		column.setType(TPMColumnConfiguration.STRING_TYPE);
		returnValue.addColumn(column);		

		column = new TPMColumnConfiguration("category", "Category");
		column.setType(TPMColumnConfiguration.STRING_TYPE);
		returnValue.addColumn(column);

		column = new TPMColumnConfiguration("graph_name", "Billing Chain", "Billing Chain");
		column.setType(TPMColumnConfiguration.STRING_TYPE);
		returnValue.addColumn(column);

        column = new TPMColumnConfiguration("network_graph_id");
        column.setState(TPMColumnConfiguration.HIDDEN);
        column.setLabel("Network Graph ID");
        returnValue.addColumn(column);
        
        column = new TPMColumnConfiguration("web_graph_id");
        column.setState(TPMColumnConfiguration.HIDDEN);
        column.setLabel("Graph ID");
        returnValue.addColumn(column);
        
        column = new TPMColumnConfiguration("web_graph_name");
        column.setState(TPMColumnConfiguration.HIDDEN);
        column.setLabel("Web Graph Name");
        returnValue.addColumn(column);
        
        column = new TPMColumnConfiguration("edge_associations", "Edge Associations");
        column.setType(TPMColumnConfiguration.STRING_TYPE);
        column.setState(TPMColumnConfiguration.HIDDEN);
        returnValue.addColumn(column);
        
        returnValue.setAddButtonURL( "/cwe/wizardEngineDisplay.do?weId=36300" );

        return returnValue;
	}
}
