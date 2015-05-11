package uk.co.cartesian.ascertain.imm.web.action;

import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import uk.co.cartesian.ascertain.imm.db.dao.AttributeRefDAO;
import uk.co.cartesian.ascertain.imm.db.dao.IMMDatabaseDAOUtils;
import uk.co.cartesian.ascertain.imm.db.dao.IssueAttributeDAO;
import uk.co.cartesian.ascertain.imm.db.dao.IssueDAO;
import uk.co.cartesian.ascertain.imm.db.dao.IssueLimitDAO;
import uk.co.cartesian.ascertain.imm.db.dao.IssueTypeAttributeDAO;
import uk.co.cartesian.ascertain.imm.db.dao.IssueTypeDAO;
import uk.co.cartesian.ascertain.imm.db.dao.IssueTypeVersionDAO;
import uk.co.cartesian.ascertain.imm.db.dao.beans.AttributeRef;
import uk.co.cartesian.ascertain.imm.db.dao.beans.Issue;
import uk.co.cartesian.ascertain.imm.db.dao.beans.IssueType;
import uk.co.cartesian.ascertain.imm.db.dao.beans.IssueTypeAttribute;
import uk.co.cartesian.ascertain.imm.db.dao.beans.IssueTypeVersion;
import uk.co.cartesian.ascertain.imm.db.utils.IssuePersistanceHelper;
import uk.co.cartesian.ascertain.imm.web.form.IssueDetailsForm;
import uk.co.cartesian.ascertain.imm.web.helpers.IssueDetailsTransactionManager;
import uk.co.cartesian.ascertain.imm.web.helpers.PrivilegeConstants;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;
import uk.co.cartesian.ascertain.utils.parse.AscertainParseException;
import uk.co.cartesian.ascertain.utils.parse.SquareBracketSubstitutionParser;
import uk.co.cartesian.ascertain.web.helpers.Utils;
import uk.co.cartesian.ascertain.web.session.bean.AscertainSessionUser;
import uk.co.cartesian.ascertain.web.tpm.ModularResultSetTPMConfiguration;
import uk.co.cartesian.ascertain.web.tpm.TPMColumnConfiguration;
import uk.co.cartesian.ascertain.web.tpm.TPMException;
import uk.co.cartesian.ascertain.web.tpm.action.TPMConfigurationRepository;
import uk.co.cartesian.ascertain.web.utils.StringUtils;

/**
 * <code>Action</code> to set up the Edit or View issue page.
 * 
 * @author Cartesian
 */
public class IssueDetailsSetupAction
extends Action
{
    private static Logger logger = LogInitialiser.getLogger(IssueDetailsSetupAction.class.getName());
    
    public static final String ISSUE_ID_REQUEST_ATTRIBUTE = "ISSUE_ID";
    public static final String ISSUE_ID_SESSION_PARAMETER_KEY = "IMM__ISSUE_ID";
    public static final String ISSUE_TYPE_VERSION_ID_SESSION_PARAMETER_KEY = "IMM__ISSUE_TYPE_VERSION_ID";
    public static final String STATE_ID_SESSION_PARAMETER_KEY = "IMM__STATE_ID";

    public static final String LINKED_ISSUES_TPM_ID = "uk.co.cartesian.ascertain.imm.web.action.IssueDetails.LinkedIssues_";
    
    // TODO DPP need two date_raised fields in the RELATED_ISSUE table 
    private static final String _LINKED_ISSUES_QUERY = 
        "SELECT i.issue_id,\n" +
        "       i.title,\n" + 
        "       to_char(i.date_raised,'" + Utils.ORACLE_SHORT_DATE_TIME_FORMAT + "') as date_raised,\n" + 
        "       to_char(i.date_raised,'" + Utils.URL_FRIENDLY_LONG_DATE_FORMAT + "') as date_raised_for_url\n" +
        "FROM imm.issue i\n" + 
        "INNER JOIN imm.related_issue ri\n" + 
        "        ON ri.issue_id = i.issue_id\n" + 
        "       AND ri.related_issue_id = ";

    public static final String CHILD_ISSUES_TPM_ID = "uk.co.cartesian.ascertain.imm.web.action.IssueDetails.ChildIssues_";
    
    // TODO DPP use parent_issue_jn table
    private static final String _CHILD_ISSUES_QUERY = 
        "SELECT i.issue_id,\n" +
        "       i.title,\n" + 
        "       to_char(i.date_raised,'" + Utils.ORACLE_SHORT_DATE_TIME_FORMAT + "') as date_raised,\n" + 
        "       to_char(i.date_raised,'" + Utils.URL_FRIENDLY_LONG_DATE_FORMAT + "') as date_raised_for_url\n" + 
        "FROM imm.issue i\n" + 
        "INNER JOIN imm.parent_child_issue_jn pcij\n" +
        "    ON pcij.child_issue_id = i.issue_id\n" +
        "WHERE pcij.parent_issue_id = ";
    
    public static final String TAGS_TPM_ID = "uk.co.cartesian.ascertain.imm.web.action.IssueDetails.Tags_";
    
    private static final String _TAG_SQL =
        "select tr.tag_id,\n" +
        "       tij.issue_id,\n" + 
        "       tr.name,\n" + 
        "       tr.description\n" + 
        "from imm.tag_ref tr\n" + 
        "inner join imm.tag_issue_jn tij\n" + 
        "        on tr.tag_id = tij.tag_id\n" + 
        "where tij.issue_id = _ISSUE_ID_";
    
    
    /**
     * 
     */
    public ActionForward execute(ActionMapping mapping, ActionForm untypedForm, HttpServletRequest request, HttpServletResponse response)
    throws Exception
    {
        logger.debug("IssueDetailsSetupAction:execute(...) - START");
        String forward = "success";      
        
        Long issueId = null;
        Connection connection = null;
    	
        String transactionIdString = request.getParameter("transaction_id");
        String parentIssueId = request.getParameter("parent_issue_id");
        
        String classIssueId = request.getParameter("class_issue_id");
        Integer issueClassId = null;
	    if(classIssueId != null)
	    {
	        issueClassId = Integer.parseInt(classIssueId);
	    }

        Long transactionId = null;
    	if("true".equals(request.getParameter("new_issue")))
    	{
            //This is a new issue (could be a child issue!)
            IssueTypeVersion issueTypeVersion = null;
    	    String param = request.getParameter("issue_type_version_id");
    	    if(param != null)
    	    {
    	        Integer issueTypeVersionId = Integer.parseInt(param);
                issueTypeVersion = IssueTypeVersionDAO.read(issueTypeVersionId);
    	    }
    	    else
    	    {
                //If no issue type version id is set then we MUST have a issue type id
    	        param = request.getParameter("issue_type_id");
                Integer issueTypeId = Integer.parseInt(param);
                issueTypeVersion = IssueTypeVersionDAO.readActiveIssueTypeVersion(issueTypeId);
    	    }
            logger.debug("IssueDetailsSetupAction:execute(...) - Creating new issue of type '" + issueTypeVersion.getIssueTypeId() + "' and version '" + issueTypeVersion.getIssueTypeVersionId() + "'");

            try 
            {
                //First off check daily issue limits.
                if (checkLimitHit(issueTypeVersion.getIssueTypeId()))
                {
                    forward = "limit";
                    return mapping.findForward(forward);                    
                }

                //New issue but is it in an existing transaction (i.e. a child)?
                Issue issue = null;
                AscertainSessionUser asu = AscertainSessionUser.getSessionUser(request);
        	    if(transactionIdString == null)
        	    {
        	        //Brand new issue issue - create new issue within a new transaction
        	        issue = new Issue();
                    issue.setIssueClassId(IssueTypeDAO.read(issueTypeVersion.getIssueTypeId()).getIssueClassId());
                    issue.setIssueTypeId(issueTypeVersion.getIssueTypeId());
                    issue.setIssueTypeVersionId(issueTypeVersion.getIssueTypeVersionId());
        	        issue.setRaisedBy(asu.getAscertainUser().getUserId());
                    issue = IssueDAO.createNewIssue(issue, false, null);
                    
                    issueId = issue.getIssueId();
                    transactionId = issueId;
                    issueClassId = issue.getIssueClassId();
        	    }
        	    else
        	    {
        	        //Create new issue using existing transaction (i.e. a child issue, or a parent issue)
        	        transactionId = Long.valueOf(transactionIdString);
                    issue = new Issue();
                    issue.setIssueClassId(IssueTypeDAO.read(issueTypeVersion.getIssueTypeId()).getIssueClassId());
                    issue.setIssueTypeId(issueTypeVersion.getIssueTypeId());
                    issue.setIssueTypeVersionId(issueTypeVersion.getIssueTypeVersionId());
                    issue.setRaisedBy(asu.getAscertainUser().getUserId());
                    issue = IssueDAO.createNewIssue(issue, false, transactionId);

                    issueId = issue.getIssueId();
                    if(parentIssueId!=null && parentIssueId != "") 
                    {
                        //This is a new child issue - update parents count of children
                        Long parentIssuePK = Long.valueOf(parentIssueId);
            			IssuePersistanceHelper.updateChildCount(parentIssuePK, 1, transactionId);
                    }
                    
                    issueClassId = issue.getIssueClassId();
        	    }

                //Read in all attributes applicable to this issue type
                connection = IssueDetailsTransactionManager.getInstance().getTransaction(transactionId);
                asu.setParameter(ISSUE_ID_SESSION_PARAMETER_KEY, String.valueOf(issue.getIssueId()));
                asu.setParameter(STATE_ID_SESSION_PARAMETER_KEY, String.valueOf(issue.getStateId()));
                asu.setParameter(ISSUE_TYPE_VERSION_ID_SESSION_PARAMETER_KEY, String.valueOf(issue.getIssueTypeVersionId()));
                List<AttributeRef> attributes = AttributeRefDAO.readAll(issue, asu.getParameters(), asu.hasPrivilege(PrivilegeConstants.IM_GROUP_POWER_USER.getPrivilegeId()), connection);
                boolean isPowerUser = asu.hasPrivilege(PrivilegeConstants.IM_GROUP_POWER_USER.getPrivilegeId());
                Map<Integer, IssueTypeAttribute> issueTypeAttributes = IssueTypeAttributeDAO.read(issue.getIssueTypeVersionId(), connection);

                //Set all attribute values to be the initial values
                attributes = setAttributeValuesFromInitialValues(issue, parentIssueId, issueTypeAttributes, asu.getParameters(), isPowerUser, connection);
                
                //Write our issue and attribute values to the DB
                String javaFieldName = null;
                String value = null;
                Long issuePK = issueId;
                for(AttributeRef attribute : attributes)
                {
                    //Go through each attribute and set any required values in the issue
                    value = attribute.getValue();
                    if( (value != null) && (attribute.getIssueTableColumn() != null) && (!attribute.getIssueTableColumn().equals("")) )
                    {
                        if( (attribute.getDataType() == AttributeRef.DataType.DATE) || (attribute.getDataType() == AttributeRef.DataType.DATETIME) )
                        {
                            //Do nothing - leave the raised date and closed data as is.  
                            //The 'issue.dateRaised' & 'issue.dateClosed' precision is seconds the corresponding attribute precision is in minutes
                        }
                        else
                        {
                            javaFieldName = StringUtils.convertFieldNametoJavaName(attribute.getIssueTableColumn());
                            BeanUtils.copyProperty(issue, javaFieldName, value);
                        }
                    }
                    //Update the issue attribute // new issue
                    IssueAttributeDAO.insert(issuePK, attribute.getAttributeId(), value, connection);
                }
                //Update the [new] issue
                IssueDAO.update(issue, connection);
            }
            catch (Exception e)
            {
                logger.error("IssueDetailsSetupAction:execute(...) - Could not create new issue.", e);
                throw e;
            }
    	}
    	else
        {
            //This is an existing issue so we definitely have a transaction id
            issueId = Long.valueOf(request.getParameter("issue_id"));
            
            // should also find a dateRaisedURL value
            transactionId = Long.valueOf(transactionIdString);
            logger.debug("IssueDetailsSetupAction:execute(...) - Got issue id of " + issueId);
            connection = IssueDetailsTransactionManager.getInstance().getTransaction(transactionId);
        }
    	
        //Populate our form with some of the required values
        IssueDetailsForm form = (IssueDetailsForm)untypedForm;
        form.setIssueId(String.valueOf(issueId));
        form.setTransactionId(String.valueOf(transactionId));
        form.setParentIssueId(parentIssueId);
        
        //Get the classId from the request
        //String classId = request.getParameter("classId");
        String classId = String.valueOf(issueClassId);
        if ((classId != null) && (classId.equals("3001") || classId.equals("3002") || classId.equals("3003")))
        {
            form.setClassId(classId);
        }
        
        //We have a couple of TPM's to set up
        //TPM configuration for the linked issues
        ModularResultSetTPMConfiguration linkedIssuesConfig = getTPMConfigurationForLinkedIssues(issueId, AscertainSessionUser.getLocale(request));
        TPMConfigurationRepository.add(request, linkedIssuesConfig, LINKED_ISSUES_TPM_ID + issueId);
        linkedIssuesConfig.setConnection(connection);
        linkedIssuesConfig.setPageSize(10);
        linkedIssuesConfig.setNavigatorJsp("/jsp/imm/IssueDetailsLinksNavigationBar.jsp");
        linkedIssuesConfig.setRowHandlerJsp("/jsp/imm/IssueDetailsLinksRow.jsp");
        linkedIssuesConfig.setRowHeaderHandlerJsp("/jsp/web/tpm/DefaultRowHeaderPlus1NoSorting.jsp");
        
        //TPM configuration for the issue tags
        String tpmRefId = TAGS_TPM_ID + issueId;
        ModularResultSetTPMConfiguration tagsConfig = getTPMConfigurationForTags(issueId, transactionId, tpmRefId, AscertainSessionUser.getLocale(request));
        TPMConfigurationRepository.add(request, tagsConfig, tpmRefId);
        tagsConfig.setConnection(connection);
        tagsConfig.setPageSize(10);
        tagsConfig.setNavigatorJsp("/jsp/imm/IssueDetailsTagsNavigationBar.jsp");
        tagsConfig.setRowHandlerJsp("/jsp/imm/IssueDetailsTagsRow.jsp");
        tagsConfig.setRowHeaderHandlerJsp("/jsp/web/tpm/DefaultRowHeaderPlus1NoSorting.jsp");
        
        //TPM configuration for the child issues
        ModularResultSetTPMConfiguration childIssuesConfig = getTPMConfigurationForChildIssues(issueId, AscertainSessionUser.getLocale(request));
        TPMConfigurationRepository.add(request, childIssuesConfig, CHILD_ISSUES_TPM_ID + issueId);
        childIssuesConfig.setConnection(connection);
        childIssuesConfig.setPageSize(10);
        childIssuesConfig.setNavigatorJsp("/jsp/imm/IssueDetailsChildrenNavigationBar.jsp");
        childIssuesConfig.setRowHandlerJsp("/jsp/imm/IssueDetailsChildrenRow.jsp");
        childIssuesConfig.setRowHeaderHandlerJsp("/jsp/web/tpm/DefaultRowHeaderPlus1NoSorting.jsp");
        
        ActionForward newForward = copyForward(mapping, forward);
        newForward.setPath(newForward.getPath()+"&issue_id="+String.valueOf(issueId)+"&transaction_id="+String.valueOf(transactionId)+"&classId="+form.getClassId());

        return newForward;
    }
    
    
    private ActionForward copyForward(ActionMapping mapping, String forward)
	{
        ActionForward oldForward = mapping.findForward(forward);
        ActionForward newForward = new ActionForward();
        newForward.setModule(oldForward.getModule());
        newForward.setName("copyOf"+oldForward.getName());
        newForward.setPath(oldForward.getPath());
        newForward.setRedirect(oldForward.getRedirect());
        
    	return newForward;
	}
    
    
    /**
     * TODO use DATE_RAISED in linked issue query 
     * 
     * @param issueId
     * @return
     * @throws TPMException
     */
    private ModularResultSetTPMConfiguration getTPMConfigurationForLinkedIssues(Long issueId, Locale locale)
    throws TPMException
    {
        ModularResultSetTPMConfiguration returnValue = new ModularResultSetTPMConfiguration(locale);
        
        //Create some columns
        //****** This column needs to be created first for the JSP to work ******//
        TPMColumnConfiguration tpmColumn = new TPMColumnConfiguration("date_raised_for_url", "Date Raised For Url");
        tpmColumn.setState(TPMColumnConfiguration.HIDDEN);
        returnValue.addColumn(tpmColumn);
        //****** This column needs to be created first for the JSP to work ******//

        tpmColumn = new TPMColumnConfiguration("issue_id", "Id", "Issue Id");
        tpmColumn.setUniqueKey(true);
        returnValue.addColumn(tpmColumn);
        
        tpmColumn = new TPMColumnConfiguration("title", "Title", "Issue Title");
        returnValue.addColumn(tpmColumn);
        
        tpmColumn = new TPMColumnConfiguration("date_raised", "Date Raised");
        returnValue.addColumn(tpmColumn);
        
        //Set the SQL for the TPM
        returnValue.setFixedQuery(_LINKED_ISSUES_QUERY + issueId);
        
        return returnValue;
    }
    
    /**
     */
    private ModularResultSetTPMConfiguration getTPMConfigurationForTags(Long issueId, Long transactionId, String tpmRefId, Locale locale)
    throws TPMException
    {
        ModularResultSetTPMConfiguration returnValue = new ModularResultSetTPMConfiguration(locale);

        //Create some columns
        TPMColumnConfiguration tpmColumn = new TPMColumnConfiguration("tag_id", "Tag Id", "Tag Id");
        tpmColumn.setState(TPMColumnConfiguration.HIDDEN);
        returnValue.addColumn(tpmColumn);
        
        tpmColumn = new TPMColumnConfiguration("issue_id", "Issue Id", "Issue Id");
        tpmColumn.setState(TPMColumnConfiguration.HIDDEN);
        returnValue.addColumn(tpmColumn);
        
        tpmColumn = new TPMColumnConfiguration("name", "Name", "Tag Name");
        returnValue.addColumn(tpmColumn);
        
        tpmColumn = new TPMColumnConfiguration("description", "Description");
        returnValue.addColumn(tpmColumn);
        
        //Set the SQL for the TPM
        String sql = _TAG_SQL.replaceAll("_ISSUE_ID_", issueId.toString());
        returnValue.setFixedQuery(sql);
        
        return returnValue;
    }
    
        
    /**
     * TODO use DATE_RAISED in child issue query - may require schema changes!
     * @param issueId
     * @return
     * @throws TPMException
     */
    private ModularResultSetTPMConfiguration getTPMConfigurationForChildIssues(Long issueId, Locale locale)
    throws TPMException
    {
        ModularResultSetTPMConfiguration returnValue = new ModularResultSetTPMConfiguration(locale);

        //Create some columns
        //****** This column needs to be created first for the JSP to work ******//
        TPMColumnConfiguration tpmColumn = new TPMColumnConfiguration("date_raised_for_url", "Date Raised For Url");
        tpmColumn.setState(TPMColumnConfiguration.HIDDEN);
        returnValue.addColumn(tpmColumn);
        //****** This column needs to be created first for the JSP to work ******//
        
        tpmColumn = new TPMColumnConfiguration("issue_id", "Id", "Issue Id");
        tpmColumn.setUniqueKey(true);
        returnValue.addColumn(tpmColumn);
        
        tpmColumn = new TPMColumnConfiguration("title", "Title", "Issue Title");
        returnValue.addColumn(tpmColumn);
        
        tpmColumn = new TPMColumnConfiguration("date_raised", "Date Raised");
        returnValue.addColumn(tpmColumn);
        
        //Set the SQL for the TPM
        returnValue.setFixedQuery(_CHILD_ISSUES_QUERY + issueId);
        
        return returnValue;
    }
    
    
    /**
     * 
     * @param attributes
     * @return
     */
    private List<AttributeRef> setAttributeValuesFromInitialValues(Issue issue, String parentIssueId, Map<Integer, IssueTypeAttribute> issueTypeAttributes, Map<String, String> parameters, boolean isPowerUser, Connection connection)
    throws AscertainParseException, SQLException
    {
        ArrayList<AttributeRef> returnValue = new ArrayList<AttributeRef>();
        String value = null;
        String initialValue = null;
        for(Integer attributeId : issueTypeAttributes.keySet())
        {
            value = null;
            //The issue id and issue type id are always set
            if(attributeId.intValue() == AttributeRef.ISSUE_ID_ATTRIBUTE_REF_ID.intValue())
            {
                value = String.valueOf(issue.getIssueId());
            }
            else if(attributeId.intValue() == AttributeRef.ISSUE_TYPE_VERSION_ID_ATTRIBUTE_REF_ID.intValue())
            {
                value = String.valueOf(issue.getIssueTypeId());
            }
            else if(attributeId.intValue() == AttributeRef.DATE_RAISED_ATTRIBUTE_REF_ID.intValue())
            {
                value = Utils.dateToLongDateAndTimeString(issue.getDateRaised());
            }
            else if(attributeId.intValue() == AttributeRef.PARENT_ID_ATTRIBUTE_REF_ID.intValue())
            {
                value = parentIssueId;
            }
            else if(attributeId.intValue() == AttributeRef.STATE_ID_ATTRIBUTE_REF_ID.intValue())
            {
                value = String.valueOf(issue.getStateId());
            }
            else
            {
                initialValue = issueTypeAttributes.get(attributeId).getInitialValue();
                if(initialValue != null && !initialValue.equals(""))
                {
                    //Initial value is a piece of SQL that we need to execute in order to get the actual initial value
                    SquareBracketSubstitutionParser p = new SquareBracketSubstitutionParser(parameters);
                    initialValue = p.parse(initialValue);
                    value = IssueTypeAttributeDAO.getInitialValue(initialValue, connection);
                }
            }
            AttributeRef attribute = AttributeRefDAO.read(attributeId, parameters, isPowerUser);   
            attribute.setValue(value);
            returnValue.add(attribute);
        }
        
        return returnValue;
    }
    
    /**
     * 
     * @param issueTypeId
     * @return
     * @throws Exception
     */
    private Boolean checkLimitHit(Integer issueTypeId)
    throws Exception
    {
    	IssueType issueType = null;
    	Connection connection = null;
    	try
    	{
	    	Date limitDate = new Date(GregorianCalendar.getInstance().getTimeInMillis());
	    	connection = IMMDatabaseDAOUtils.getAutoConnection();
	    	//get object from issueTypeId and populate issue Limits.
			issueType = IssueLimitDAO.readDailyCount(IssueTypeDAO.read(issueTypeId), limitDate, connection);		
						    
    	}
    	catch (Exception e)
    	{
            logger.error("SQL Error trying determine issue limit status issueType="+ issueTypeId, e);
    	}
    	finally
    	{
            try{connection.close();} catch(Exception e) {};
    	}

		return (issueType.getIssueLimit().getLimitReached());
    }
    
}
