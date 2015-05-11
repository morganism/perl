package uk.co.cartesian.ascertain.imm.web.action;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import uk.co.cartesian.ascertain.imm.db.dao.beans.AttributeFilterConfRef;
import uk.co.cartesian.ascertain.imm.db.dao.beans.AttributeRef;
import uk.co.cartesian.ascertain.imm.web.filters.FilterUtils;
import uk.co.cartesian.ascertain.imm.web.form.IssueManagementForm;
import uk.co.cartesian.ascertain.imm.web.helpers.PrivilegeConstants;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;
import uk.co.cartesian.ascertain.web.session.bean.AscertainSessionUser;
import uk.co.cartesian.ascertain.web.tpm.ModularResultSetTPM;
import uk.co.cartesian.ascertain.web.tpm.action.TPMRepository;

/**
 * @author Cartesian
 */
public class IssueManagementDisplayAction
extends Action
{
    private static Logger logger = LogInitialiser.getLogger(IssueManagementDisplayAction.class.getName());
    
    public static final String ISSUE_MANAGEMENT_SQL = "IMM__ISSUE_MANAGEMENT_SQL";
    
   /**
    * 
    */
   public ActionForward execute(ActionMapping mapping, ActionForm untypedForm, HttpServletRequest request, HttpServletResponse response)
   throws Exception
   {
       logger.debug("IssueManagementDisplayAction:execute(...) - START");
       String forward = "success";
       
       //Sort out the filters where clause.
        IssueManagementForm form = (IssueManagementForm) untypedForm;
        if ("true".equals(request.getParameter("clear")))
        {
    	   form.manualReset();
        }      

        //If the user does not have the power user privilege then they can only see there own issues 
       
        AscertainSessionUser asu = AscertainSessionUser.getSessionUser(request);
        if (!asu.hasPrivilege(PrivilegeConstants.IM_POWER_USER.getPrivilegeId()))
        {
            Map<String, String> ddfv = form.getDropDownFilterValues();
            ddfv.put(IssueManagementSetupAction.COLUMN_PREFIX + AttributeRef.OWNING_USER_ID_ATTRIBUTE_REF_ID, String.valueOf(asu.getAscertainUser().getUserId()));
        }
        boolean isGroupPowerUser = asu.hasPrivilege(PrivilegeConstants.IM_GROUP_POWER_USER.getPrivilegeId());
       
        //Sort out the Filters
        @SuppressWarnings("unchecked")
        List<AttributeFilterConfRef> attributeFilterConfRefList = (List<AttributeFilterConfRef>) request.getSession().getAttribute("IMM__ISSUE_MANAGEMENT_FILTER_CONF");
        form = FilterUtils.setRequestFilterValues(form, attributeFilterConfRefList, request);
        String whereClause = FilterUtils.generateWhereClauseFromFilterValues(attributeFilterConfRefList, form.getDateFilterValues(), form.getDateRangeFilterValues(), form.getDateTimeFilterValues(), form.getDropDownFilterValues(), form.getMultiSelectFilterValues(), form.getFreeTextFilterValues(), form.getFreeTextRegExpFilterValues(), form.getTagId(), isGroupPowerUser, asu);

        //Get the actual TPM we are dealing with
        ModularResultSetTPM tpm = (ModularResultSetTPM) TPMRepository.getTPM(request.getSession(), form.getTpmKey());
       
        //Update the where clause
        tpm.updateVariableWhereClauseElements(whereClause);
       
        //The bulk issue details update stuff needs to know what the SQL is
        if (form.getTpmKey().equals(IssueManagementSetupAction.MAIN_TPM_ID))
        {
            String sql = (String) request.getSession().getAttribute(ISSUE_MANAGEMENT_SQL);
            sql += whereClause;
            request.getSession().setAttribute(BulkUpdateIssueDetailsProcessAction.SELECTED_ISSUES_QUERY_SESSION_KEY, sql);
        }
       
        //Stuff the issue id into the request for the controller class
        request.setAttribute(IssuePopupController.ISSUE_ID_REQUEST_KEY, form.getIssueId());
       
        return mapping.findForward(forward);
    }
}
