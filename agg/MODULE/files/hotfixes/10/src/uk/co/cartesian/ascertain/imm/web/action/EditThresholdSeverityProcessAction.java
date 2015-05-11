package uk.co.cartesian.ascertain.imm.web.action;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.actions.LookupDispatchAction;

import uk.co.cartesian.ascertain.imm.db.dao.ThresholdSeverityRefDatabaseDAO;
import uk.co.cartesian.ascertain.imm.db.dao.beans.AttributeRef;
import uk.co.cartesian.ascertain.imm.db.dao.beans.ThresholdSeverityRef;
import uk.co.cartesian.ascertain.imm.web.form.EditThresholdSeverityForm;
import uk.co.cartesian.ascertain.utils.exception.WebApplicationException;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;
import uk.co.cartesian.ascertain.utils.persistence.dropdown.DropDown;
import uk.co.cartesian.ascertain.web.WebProperties;
import uk.co.cartesian.ascertain.web.session.bean.AscertainSessionUser;

/**
 * @author imortimer
 * Created on 13-Jul-2004
 */
public class EditThresholdSeverityProcessAction 
extends LookupDispatchAction
{
    static Logger logger = LogInitialiser.getLogger(EditThresholdSeverityProcessAction.class.getName());

    /**
     * 
     */
    protected Map<String, String> getKeyMethodMap() 
    {
        Map<String, String> map = new HashMap<String, String>();
        map.put("imm.button.cancel", "cancel");
        map.put("imm.button.save", "save");
        return map;
    }
    
    
    /**
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws IOException
     * @throws ServletException
     */
    public ActionForward cancel(
        ActionMapping mapping,
        ActionForm form,
        HttpServletRequest request,
        HttpServletResponse response)
    throws IOException, ServletException 
    {
        logger.debug("EditThresholdSeverityProcessAction:cancel(...) - START");

        String forward = "finished";

        return  mapping.findForward(forward);
    }

    /**
     * 
     * @param mapping
     * @param form
     * @param request
     * @param response
     * @return
     * @throws IOException
     * @throws ServletException
     */
    public ActionForward save(
            ActionMapping mapping,
            ActionForm untypedForm,
            HttpServletRequest request,
            HttpServletResponse response)
    throws IOException, ServletException 
    {
        logger.debug("EditThresholdSeverityProcessAction:save(...) - START");
        String forward="finished";
        
        try 
        {
            EditThresholdSeverityForm form = (EditThresholdSeverityForm)untypedForm;
            
            ThresholdSeverityRef tsr = (ThresholdSeverityRef)request.getSession().getAttribute("IMM__THRESHOLD_SEVERITY_REF");

            if (!isNumber(form.getValue()))
            {
                ActionMessages messages = new ActionMessages();
                ActionMessage message = new ActionMessage("imm.errors.number", "Value");
                messages.add(WebProperties.DEFAULT_ERROR_TAG, message);
                saveMessages(request, messages);
                return mapping.findForward("refresh");
            }

            updateBean(form, tsr);
            AscertainSessionUser asu = AscertainSessionUser.getSessionUser(request);

            //Now lets put the changes into the DB
            if(form.getCopy().equals("true"))
            {
                //If it a copy then we call deepCopy to create a copy of every thing
                ThresholdSeverityRefDatabaseDAO.deepCopy(tsr, asu.getAscertainUser().getAlias());
            }
            else
            {
                //Just do a save
                ThresholdSeverityRefDatabaseDAO.save(tsr, asu.getAscertainUser().getAlias());
            }
        }
        catch(Exception e)
        {
            String msg = "Could not save Threshold Severity Changes.";
            logger.error("EditThresholdSeverityProcessAction:save(...) - " + msg, e);
            throw new WebApplicationException(msg + "\n" + e.toString());
        }

        return mapping.findForward(forward);
    }
    
    /**
     * 
     *
     */
    private void updateBean(EditThresholdSeverityForm form, ThresholdSeverityRef tsr)
    {
        tsr.setSeverityId(Integer.valueOf(form.getSeverityId()));
        tsr.setPriorityId(Integer.valueOf(form.getPriorityId()));
        tsr.setValue(Double.valueOf(form.getValue()));
        tsr.setOperator(form.getOperator());
        if((form.getRaiseIssue() == true))
        {
            tsr.setRaiseIssue("Y");
            tsr.setIssueTypeId(Integer.valueOf(form.getIssueTypeId()));
            
            // Group should always be set
            tsr.setStartGroupId(Integer.valueOf(form.getAttributes(AttributeRef.OWNING_GROUP_ID_ATTRIBUTE_REF_ID.toString())));
            
            // Check if the user is set
            String userId = form.getAttributes(AttributeRef.OWNING_USER_ID_ATTRIBUTE_REF_ID.toString());
            if(userId.equals(DropDown.NONE_ID))
            {
            	tsr.setStartUserId(null);
            }
            else
            {
            	tsr.setStartUserId(Integer.valueOf(userId));
            }
        }
        else
        {
            tsr.setRaiseIssue("N");
            tsr.setIssueTypeId(null);
            tsr.setStartGroupId(null);
            tsr.setStartUserId(null);
        }
    }

    private boolean isNumber(String in)
    {
        try
        {
            Double.parseDouble(in);
        }
        catch (NumberFormatException ex)
        {
            return false;
        }

        return true;
    }
}
