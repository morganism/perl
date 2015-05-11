package uk.co.cartesian.ascertain.um.web.action.mrec;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.ResourceBundle;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.action.DynaActionForm;

import uk.co.cartesian.ascertain.imm.db.dao.ThresholdDefinitionRefDatabaseDAO;
import uk.co.cartesian.ascertain.imm.db.dao.ThresholdSequenceRefDatabaseDAO;
import uk.co.cartesian.ascertain.imm.db.dao.ThresholdVersionRefDatabaseDAO;
import uk.co.cartesian.ascertain.imm.db.dao.beans.ThresholdDefinitionRef;
import uk.co.cartesian.ascertain.imm.db.dao.beans.ThresholdSequenceRef;
import uk.co.cartesian.ascertain.imm.db.dao.beans.ThresholdVersionRef;
import uk.co.cartesian.ascertain.imm.web.action.ManageThresholdSequenceSetupAction;
import uk.co.cartesian.ascertain.imm.web.action.ThresholdVersionManagementProcessAction;
import uk.co.cartesian.ascertain.um.mrec.MrecRegenerationUtils;
import uk.co.cartesian.ascertain.um.persistence.bean.mrec.MrecDefinitionRef;
import uk.co.cartesian.ascertain.um.persistence.bean.mrec.MrecVersionRef;
import uk.co.cartesian.ascertain.um.persistence.dao.mrec.MrecDefinitionRefDatabaseDAO;
import uk.co.cartesian.ascertain.um.persistence.dao.mrec.MrecVersionRefDatabaseDAO;
import uk.co.cartesian.ascertain.utils.persistence.exceptions.CreateException;
import uk.co.cartesian.ascertain.utils.persistence.exceptions.DeleteException;
import uk.co.cartesian.ascertain.utils.persistence.exceptions.ReadException;
import uk.co.cartesian.ascertain.web.WebProperties;
import uk.co.cartesian.ascertain.web.action.AbstractDefinitionAction;
import uk.co.cartesian.ascertain.web.session.ClickStream;
import uk.co.cartesian.ascertain.web.session.bean.AscertainSessionUser;


public class MrecVersion extends AbstractDefinitionAction {
	
	private static final String ATTRIBUTE_THRESHOLD_LIST = "UM__MREC_THRESHOLD";
	private static final String ATTRIBUTE_THRESHOLD_SEQ_LIST = "UM__MREC_THRESHOLD_SEQ";
	
	private static final String FORM_DESCRIPTION = "description";
    private static final String ACTION_DRILL_THRESHOLD = "threshold";
    private static final String ACTION_DRILL_SEQUENCE = "sequence";
    
	static final String FORM_COPY = "isCopy";
	static final String FORM_STATUS = "status";
	static final String FORM_IS_THRESHOLD_SEQ = "chooseSeq";
	
	public static final String ATTRIBUTE_DAO_BEAN = "UM__MREC_VERSION_BEAN";
		
	private static final String FORWARD_DEFAULT = "success";
	private static final String FORWARD_DONE = "um_mrecVerTable";
    private static final String FORWARD_DRILL_TIMESLOT = "um_mrecMetricTable";
    private static final String FORWARD_DRILL_FILESET = "um_mrecFilesetMetricDisplay";
    
    private static final String FORWARD_DRILL_THRESHOLD = "threshold";
    private static final String FORWARD_DRILL_SEQUENCE = "sequence";
	

    /**
     * 
     */
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) 
    throws Exception 
	{
		final HttpSession session = request.getSession();
		final DynaActionForm dForm = (DynaActionForm)form;
		final String action = request.getParameter(ACTION);
		final ActionMessages messages = new ActionMessages();
		final String edit_id = request.getParameter(ACTION_ID);
		
		String forward = FORWARD_DEFAULT;
		
		if( edit_id!=null && action!=null ){			
			if( edit_id.matches("\\d+") )
			{
				final MrecVersionRef verRef = new MrecVersionRef(new Integer(edit_id));
				MrecVersionRefDatabaseDAO.read(verRef);
				session.setAttribute(ATTRIBUTE_DAO_BEAN, verRef);			
				
				String mrecDefName = MrecDefinition.ATTRIBUTE_DAO_BEAN;
				MrecDefinitionRef mrecDefRef = ( MrecDefinitionRef ) session.getAttribute( mrecDefName ); 
				if( mrecDefRef == null || mrecDefRef.getMrecDefinitionId() != verRef.getMrecDefinitionId() )
				{
					mrecDefRef = new MrecDefinitionRef( verRef.getMrecDefinitionId() );
					MrecDefinitionRefDatabaseDAO.read( mrecDefRef );
					session.setAttribute( MrecDefinition.ATTRIBUTE_DAO_BEAN , mrecDefRef );
				}
				
				BeanUtils.copyProperties(dForm, verRef);
				
				//Editing when action is edit
				if( ACTION_EDIT.equals(action) )
				{				
					editVersion(request, dForm, verRef);
				} 
				else if ( ACTION_TOGGLE.equals(action))
				{
					forward = toggleVersion(request, messages, verRef);
				}
                else if ( ACTION_DRILL.equals(action))
                {
                	String type = request.getParameter("type");
                	if ("Fileset".equalsIgnoreCase(type))
                	{
                		// start clickstream here
                    	ClickStream clickStream = ClickStream.findClickStream(request);
                    	clickStream.setAttribute("MREC_VERSION_REF", verRef);
                		forward = FORWARD_DRILL_FILESET;
                	}
                	else
                	{
                		forward = FORWARD_DRILL_TIMESLOT;
                	}
                }
                else if ( ACTION_DRILL_THRESHOLD.equals(action))
                {
                    prepareSessionForThresholdView(request, verRef);
                    forward = FORWARD_DRILL_THRESHOLD;
                }
                else if ( ACTION_DRILL_SEQUENCE.equals(action))
                {
                    prepareSessionForSequenceView(request, verRef);
                    forward = FORWARD_DRILL_SEQUENCE;
                }
				else if( ACTION_COPY.equals(action) )
				{
					copyVersion(request, dForm, verRef);					
				}
				else if( ACTION_DELETE.equals(action) )
				{
					forward = deleteVersion(request, messages, verRef);
				}
			} 
			else
			{
				messages.add(WebProperties.DEFAULT_ERROR_TAG, new ActionMessage("um.fm.editidErr", edit_id.substring(0, 6)));
			}
		}
		//Create new
		else {
			session.removeAttribute(ATTRIBUTE_DAO_BEAN);			
			dForm.initialize(mapping);
			dForm.set(FORM_DESCRIPTION, "New Version");
			setValidFromDate(dForm, new Date(System.currentTimeMillis()));
			setValidToDate(dForm);
			setLists(request);
		}

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
		
		saveMessages(request, messages);
		return mapping.findForward(forward);
	}

	private String deleteVersion(HttpServletRequest request, final ActionMessages messages, final MrecVersionRef verRef) {
		String forward;
		try{						
			MrecVersionRefDatabaseDAO.delete(verRef, getUserAlias(request));			
		} 
		catch (DeleteException ce) 
		{
			messages.add(WebProperties.DEFAULT_ERROR_TAG, new ActionMessage(MSG_DB_ERR,ce.getMessage()));
		} 
		catch (Exception e) 
		{
			messages.add(WebProperties.DEFAULT_ERROR_TAG, new ActionMessage(MSG_UNKNOWN_ERR, e.getCause() + " - " + e.getMessage()));
		}
		forward = FORWARD_DONE;
		return forward;
	}

	private String toggleVersion(HttpServletRequest request, final ActionMessages messages, final MrecVersionRef verRef)
	{
		try {
			if( STATUS_NEW.equals(verRef.getStatus()) ){
				// check if toggle-able
				if (verRef.isConfigured()) {
					verRef.setStatus(STATUS_ACTIVE);

		            // may need to populate the MREC REGEN QUEUE...
	            	MrecRegenerationUtils.updateMrecRegenCriteria(verRef);

				} else {
					messages.add(WebProperties.DEFAULT_MESSAGE_TAG, new ActionMessage("um.mrec.version.not.configured"));
					return FORWARD_DONE;
				}
			} else if( STATUS_INACTIVE.equals(verRef.getStatus()) ){
				verRef.setStatus(STATUS_ACTIVE);						
			} else {
				verRef.setStatus(STATUS_INACTIVE);
			}
			// toggle!
			MrecVersionRefDatabaseDAO.save(verRef, super.getUserAlias(request));
			
		} catch (ReadException ce) {
			messages.add(WebProperties.DEFAULT_ERROR_TAG, new ActionMessage(MSG_DB_ERR,ce.getMessage()));
		} catch (CreateException ce) {
			messages.add(WebProperties.DEFAULT_ERROR_TAG, new ActionMessage(MSG_DB_ERR,ce.getMessage()));
		} catch (SQLException ce) {
			messages.add(WebProperties.DEFAULT_ERROR_TAG, new ActionMessage(MSG_DB_ERR,ce.getMessage()));
		} catch (Exception e) {
			messages.add(WebProperties.DEFAULT_ERROR_TAG, 
					new ActionMessage(MSG_UNKNOWN_ERR, e.getCause() + " - " + e.getMessage()));
		}	

		return FORWARD_DONE;
	}

	private void editVersion(HttpServletRequest request, final DynaActionForm dForm, final MrecVersionRef verRef) {
		if( verRef.getThresholdDefinitionId() != null ){					
			dForm.set(FORM_IS_THRESHOLD_SEQ, "false");
		}
		else if( verRef.getThresholdSequenceId() != null ){					
			dForm.set(FORM_IS_THRESHOLD_SEQ, "true");
		}
		else{			
			dForm.set(FORM_IS_THRESHOLD_SEQ, "none");
		}
		
		dForm.set(FORM_COPY, new Boolean(false));
		if( verRef.getValidTo()!=null )
		{
			setValidToDate(dForm, verRef.getValidTo());						
		}
		setValidFromDate(dForm, verRef.getValidFrom());
		setLists(request);
	}
	
    private void copyVersion(HttpServletRequest request, final DynaActionForm dForm, final MrecVersionRef verRef) {
        editVersion(request, dForm, verRef);
        
        //copy in the process action
        dForm.set(FORM_COPY, new Boolean(true));
        dForm.set(FORM_DESCRIPTION,"Copy of " + verRef.getDescription());   
        dForm.set(FORM_STATUS, "N");
        setValidFromDate(dForm, new Date(System.currentTimeMillis()));	
    }
    
    
    private void prepareSessionForThresholdView(HttpServletRequest request, MrecVersionRef mvrId) 
    throws ReadException
    {
        //Create the threshold version ref object
        ThresholdDefinitionRef thresholdDefinitionRef = new ThresholdDefinitionRef(mvrId.getThresholdDefinitionId());
        ThresholdDefinitionRefDatabaseDAO.read(thresholdDefinitionRef);
        
        //Read all active threshold definition refs - there should only be one - and stick it in the session
        List<ThresholdVersionRef> list = new ArrayList<ThresholdVersionRef>();
        ThresholdVersionRefDatabaseDAO.readAllActiveForThresholdDefinition(thresholdDefinitionRef, list);
        request.getSession().setAttribute(ThresholdVersionManagementProcessAction.IMM_THRESHOLD_VERSION_ATTRIBUTE_ID, list.get(0));

        //Place the Threshold Definition Ref object into the session (!)
        request.getSession().setAttribute("IMM__THRESHOLD_DEFINITION_REF", thresholdDefinitionRef);
    }
    
    private void prepareSessionForSequenceView(HttpServletRequest request, MrecVersionRef mvrId) 
    throws ReadException
    {
        //Turn off the edit
        request.getSession().setAttribute(ManageThresholdSequenceSetupAction.IMM_THRESHOLD_SEQUENCE_EDIT_ATTRIBUTE_ID, "false");

        //Get the threshold version ref object and stick it in the session
        ThresholdSequenceRef thresholdSequenceRef = new ThresholdSequenceRef(mvrId.getThresholdSequenceId());
        ThresholdSequenceRefDatabaseDAO.read(thresholdSequenceRef);
        request.getSession().setAttribute(ManageThresholdSequenceSetupAction.IMM_THRESHOLD_SEQUENCE_ATTRIBUTE_ID, thresholdSequenceRef);
        //Place the Threshold Sequence Ref object into the session (!)
        request.getSession().setAttribute("IMM__THRESHOLD_SEQUENCE_REF", thresholdSequenceRef);
    }
    
	static void setLists(HttpServletRequest request){
		try {
			ArrayList list = new ArrayList();			
			ThresholdDefinitionRefDatabaseDAO.readAllActive(list);
			request.setAttribute(ATTRIBUTE_THRESHOLD_LIST, list);	
			
			list = new ArrayList();
			ThresholdSequenceRefDatabaseDAO.readAll(list);
			request.setAttribute(ATTRIBUTE_THRESHOLD_SEQ_LIST, list);	
			
		} catch (ReadException e) {
			//TODO log exception
		}
	}
	
	
}
