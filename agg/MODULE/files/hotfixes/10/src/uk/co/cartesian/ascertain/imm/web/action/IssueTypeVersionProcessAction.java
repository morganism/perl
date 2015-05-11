package uk.co.cartesian.ascertain.imm.web.action;

import java.sql.Connection;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.actions.DispatchAction;

import uk.co.cartesian.ascertain.imm.db.dao.IMMDatabaseDAOUtils;
import uk.co.cartesian.ascertain.imm.db.dao.IssueTypeAttributeDAO;
import uk.co.cartesian.ascertain.imm.db.dao.IssueTypeVersionDAO;
import uk.co.cartesian.ascertain.imm.db.dao.StateTransitionRefDAO;
import uk.co.cartesian.ascertain.imm.db.dao.beans.IssueTypeVersion;
import uk.co.cartesian.ascertain.imm.db.dao.beans.IssueTypeVersion.IssueTypeVersionState;
import uk.co.cartesian.ascertain.imm.db.dao.beans.StateTransitionRef;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;
import uk.co.cartesian.ascertain.utils.parse.AscertainLabelValueBean;
import uk.co.cartesian.ascertain.utils.parse.AscertainParseException;
import uk.co.cartesian.ascertain.utils.parse.CurleyBracketLabelValuePairParser;
import uk.co.cartesian.ascertain.web.session.bean.AscertainSessionUser;

public class IssueTypeVersionProcessAction
extends DispatchAction 
{
	private static Logger logger = LogInitialiser.getLogger(IssueTypeVersionProcessAction.class.getName());
    
	/**
     * Adds an Issue Type
     */
    public ActionForward add(ActionMapping mapping, 
            ActionForm form, 
            HttpServletRequest request, 
            HttpServletResponse response)
    throws Exception
    {
        //This is the add button being pressed
        if (logger.isDebugEnabled()) logger.debug("IssueTypeVersionProcessAction:add(...) - START");
        if (logger.isDebugEnabled()) logger.debug("IssueTypeVersionProcessAction:add(...) - END");

        return mapping.findForward("add");
    }
	
    /**
     * Deep copy of the Issue Type Version, Issue Type Attributes amd State Transition Refs 
     */
    public ActionForward copy(ActionMapping mapping, 
    		ActionForm form, 
    		HttpServletRequest request, 
    		HttpServletResponse response)
    throws Exception
    {
        //This is the copy button being pressed
        if (logger.isDebugEnabled()) logger.debug("IssueTypeVersionProcessAction:copy(...) - START");

        setIssueTypeVersionForRequest(request, request.getParameter("rowId"));
        
        Integer baseIssueTypeVersionId = Integer.parseInt((String)request.getAttribute("issue_Type_Version_Id"));
        IssueTypeVersion issueTypeVersion = IssueTypeVersionDAO.read(baseIssueTypeVersionId);
       
        Connection connection = IMMDatabaseDAOUtils.getManualConnection();
        String userAlias = AscertainSessionUser.getSessionUser(request).getAscertainUser().getAlias();
        try
        {
            //copy issue type version
            IssueTypeVersionDAO.copyIssueTypeVersion(issueTypeVersion, userAlias, connection);
            
            //copy attributes
            IssueTypeAttributeDAO.copy(baseIssueTypeVersionId, issueTypeVersion.getIssueTypeVersionId(), connection);
            
            //copy states
            List<StateTransitionRef> stateTransitionRefs = StateTransitionRefDAO.readAllForVersion(baseIssueTypeVersionId);
            if(stateTransitionRefs.size() != 0)
            {
                StateTransitionRefDAO.insert(issueTypeVersion.getIssueTypeVersionId(), stateTransitionRefs, connection);
            }
            connection.commit();
        }
        catch(Exception e)
        {
            connection.rollback();
            logger.error("IssueTypeVersionProcessAction:execute(...) - Error!!!", e);
        }
        finally
        {
            try{connection.close();} catch(Exception e) {}; 
        }
        if (logger.isDebugEnabled()) logger.debug("IssueTypeVersionProcessAction:copy(...) - END");
        
        int baseIssueTypeId = issueTypeVersion.getIssueTypeId();
        
        ActionForward actionForward = mapping.findForward("success");
        ActionForward result = new ActionForward(actionForward);
        result.setPath(actionForward.getPath() + "&filter_3130=" + baseIssueTypeId + "&sqlParameters={ISSUE_TYPE_ID,"+baseIssueTypeId+"}");
        result.setRedirect(true);
        return result;
    }
    
    /**
     * Updates an Issue Type Version Status
     */
    public ActionForward toggleStatus(ActionMapping mapping, 
    		ActionForm form, 
    		HttpServletRequest request, 
    		HttpServletResponse response)
    throws Exception
    { 
        //This is the Status button being pressed 
        if (logger.isDebugEnabled()) logger.debug("IssueTypeVersionProcessAction:toggleStatus(...) - START");    
                
        
        ActionForward actionFroward = mapping.findForward("success");
        ActionForward result = new ActionForward(actionFroward); 
        
    	ActionMessages messages = new ActionMessages();
        
        setIssueTypeVersionForRequest(request, request.getParameter("rowId"));
        
		try  
		{
			IssueTypeVersion issueTypeVersion = IssueTypeVersionDAO.read(Integer.parseInt((String)request.getAttribute("issue_Type_Version_Id")));
			String asUser = AscertainSessionUser.getSessionUser(request).getAscertainUser().getAlias();
			issueTypeVersion.nextStatus();

			int baseIssueTypeId = issueTypeVersion.getIssueTypeId();
			
			//If our new one is to become active then need to set previous active one to inactive
			if(issueTypeVersion.getState().getValue().equalsIgnoreCase(IssueTypeVersionState.ACTIVE.getValue()))
			{
				IssueTypeVersion oldActiveVersion = IssueTypeVersionDAO.readActiveIssueTypeVersion(baseIssueTypeId);
				if(oldActiveVersion != null)
				{
					oldActiveVersion.nextStatus();
					IssueTypeVersionDAO.update(oldActiveVersion, asUser);
				}
			}

			//Now update current to active
			IssueTypeVersionDAO.update(issueTypeVersion, asUser);
			
			result.setPath(actionFroward.getPath() + "&filter_3130=" + baseIssueTypeId + "&sqlParameters={ISSUE_TYPE_ID,"+baseIssueTypeId+"}");
			result.setRedirect(true);
		}		
		catch (Exception e)
		{
			if (logger.isDebugEnabled()) logger.debug("IssueTypeVersionProcessAction:toggleStatus - Exception in toggle-" + e.getMessage());
		
            actionFroward = mapping.getInputForward();
            saveMessages(request, messages);
		}

        if (logger.isDebugEnabled()) logger.debug("IssueTypeVersionProcessAction:toggleStatus(...) - END");

        return result;
        
    }

    /**
     * 
     * @param request
     * @param paramString
     * @throws AscertainParseException
     */
    private void setIssueTypeVersionForRequest(HttpServletRequest request, String paramString) throws AscertainParseException
    {
    	CurleyBracketLabelValuePairParser param = new CurleyBracketLabelValuePairParser();
		List<AscertainLabelValueBean> paramList = param.parse(paramString);	
		
		int i = 0;		
		while(!(paramList.get(i).getLabel().equals("ISSUE_TYPE_VERSION_ID")))i++;				
		
        request.setAttribute("issue_Type_Version_Id", paramList.get(i).getValue());
    }

}
