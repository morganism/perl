package uk.co.cartesian.ascertain.um.web.action.mrec;

import java.sql.SQLException;
import java.util.Locale;
import java.util.ResourceBundle;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import uk.co.cartesian.ascertain.um.UMProperties;
import uk.co.cartesian.ascertain.um.persistence.persister.mrec.MrecChartDatabasePersister;
import uk.co.cartesian.ascertain.utils.exception.WebApplicationException;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;
import uk.co.cartesian.ascertain.web.session.bean.AscertainSessionUser;
import uk.co.cartesian.ascertain.web.tpm.ModularResultSetTPMConfiguration;
import uk.co.cartesian.ascertain.web.tpm.TPMColumnConfiguration;
import uk.co.cartesian.ascertain.web.tpm.TPMException;
import uk.co.cartesian.ascertain.web.tpm.TPMColumnConfiguration.OrderByState;
import uk.co.cartesian.ascertain.web.tpm.action.TPMConfigurationRepository;

public class MrecChartDataSetup extends Action {

	public static final String TMP_UID = "uk.co.cartesian.ascertain.um.web.action.mrec.MrecChartDataSetup";
	private static final Logger logger = LogInitialiser.getLogger(MrecChartDataSetup.class.getName());


	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
	throws Exception 
	{
		logger.debug("MrecChartDataSetup:execute(...) - START");

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

		try {
			//Initialise the meta data
			final MrecChartable chartable = MrecChartable.mrecChartableFactoryMethod((DynaActionForm)form);
			
			Locale locale = AscertainSessionUser.getLocale( request );
            ModularResultSetTPMConfiguration sourcesMetaData = initialiseSourcesView(chartable, form,locale);

			//Place metadata in the request
			TPMConfigurationRepository.add(request, sourcesMetaData, TMP_UID);				
			
		} catch (Exception e) {
			String msg = "Could not initialise the page. \n" + e.toString();
			logger.error("MrecChartDataSetup:execute(...) - " + msg, e);
			throw new WebApplicationException(msg);
		}
		
		return mapping.findForward("success");
	}

	/**
	 * @param form 
	 * @param query
	 * @return
	 */
	private ModularResultSetTPMConfiguration initialiseSourcesView(MrecChartable chartable, ActionForm form,Locale locale )
	throws SQLException, TPMException
	{
		ModularResultSetTPMConfiguration tmpConfig = new ModularResultSetTPMConfiguration( locale );

		StringBuffer sql = new StringBuffer("select * from ( \n");
		sql.append(MrecChartDatabasePersister.getChartAggDataSql(chartable));
		sql.append(" ) a\n");
		sql.append(" where 1=1 \n");

		// strip nulls (main query, used for charts, includes null)
		// this may be very inefficient!
		sql.append(" and a.mrec is not null \n");

		// is there a filter to apply
		DynaActionForm dform = (DynaActionForm)form;
		String mrecLineName = (String)dform.get("mrecLineId");

		if (!mrecLineName.isEmpty() && !mrecLineName.equals("-2")) {
			sql.append(" and mrec_line_name = '" + mrecLineName + "'");	
		}
		
		tmpConfig.setConnectionPool(UMProperties.getInstance().getProperty("CP_NAME"));
		tmpConfig.setFixedQuery(sql.toString());
		
		logger.debug("MrecChartDataSetup.initialiseSourcesView(...) - SQL: " + sql.toString());

		tmpConfig.setRowHandlerJsp("/jsp/um/mrec/MrecChartDataRow.jsp");
		tmpConfig.setRowHeaderHandlerJsp("/jsp/web/tpm/DefaultRowHeader.jsp");		

		TPMColumnConfiguration column = null;

		column = new TPMColumnConfiguration("d_mrec_line_id", "ID", "Reconciliation Line Id");
		column.setType(TPMColumnConfiguration.NUMBER_TYPE);
		column.setUniqueKey(true);
		column.setState(TPMColumnConfiguration.HIDDEN);
		tmpConfig.addColumn(column);

		column = new TPMColumnConfiguration("d_period_string", "Date");
		column.setType(TPMColumnConfiguration.DATE_TYPE);		
		column.setOrderByState(OrderByState.ASCENDING);
		column.setOrderByPosition(1);		
		tmpConfig.addColumn(column);

		column = new TPMColumnConfiguration("d_period_url", "Date URL");
		column.setType(TPMColumnConfiguration.DATE_TYPE);		
		column.setState(TPMColumnConfiguration.HIDDEN);
		tmpConfig.addColumn(column);

		column = new TPMColumnConfiguration("mrec_line_type", "Type", "Reconciliation Set Type");
		column.setType(TPMColumnConfiguration.STRING_TYPE);
		column.setOrderByState(OrderByState.ASCENDING);
		column.setOrderByPosition(2);		
		tmpConfig.addColumn(column);

		column = new TPMColumnConfiguration("mrec_line_name", "Line", "Reconciliation Line Name");
		column.setType(TPMColumnConfiguration.STRING_TYPE);
		tmpConfig.addColumn(column);

		column = new TPMColumnConfiguration("mrec_definition_id", "MREC ID", "Reconciliation Id");
		column.setType(TPMColumnConfiguration.NUMBER_TYPE);
		column.setState(TPMColumnConfiguration.HIDDEN);
		tmpConfig.addColumn(column);

		column = new TPMColumnConfiguration("mrec_type", "Type");
		column.setType(TPMColumnConfiguration.STRING_TYPE);
		column.setState(TPMColumnConfiguration.HIDDEN);
		tmpConfig.addColumn(column);

		column = new TPMColumnConfiguration("mrec", "Value", "Reconciliation Value");
		column.setType(TPMColumnConfiguration.NUMBER_TYPE);
		tmpConfig.addColumn(column);

		column = new TPMColumnConfiguration("issue_count", "Issue Count", "Issue Count");
		column.setType(TPMColumnConfiguration.NUMBER_TYPE);
		tmpConfig.addColumn(column);

		return tmpConfig;
	}
}
