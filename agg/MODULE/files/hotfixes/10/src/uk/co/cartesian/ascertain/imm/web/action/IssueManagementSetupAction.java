package uk.co.cartesian.ascertain.imm.web.action;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import uk.co.cartesian.ascertain.imm.IMMProperties;
import uk.co.cartesian.ascertain.imm.db.dao.AttributeColumnConfRefDAO;
import uk.co.cartesian.ascertain.imm.db.dao.AttributeFilterConfRefDAO;
import uk.co.cartesian.ascertain.imm.db.dao.IssueClassDAO;
import uk.co.cartesian.ascertain.imm.db.dao.beans.AttributeColumnConfRef;
import uk.co.cartesian.ascertain.imm.db.dao.beans.AttributeFilterConfRef;
import uk.co.cartesian.ascertain.imm.db.dao.beans.AttributeRef;
import uk.co.cartesian.ascertain.imm.web.filters.DateFilter;
import uk.co.cartesian.ascertain.imm.web.filters.DateRangeFilter;
import uk.co.cartesian.ascertain.imm.web.filters.DateTimeFilter;
import uk.co.cartesian.ascertain.imm.web.filters.DropDownFilter;
import uk.co.cartesian.ascertain.imm.web.filters.FilterUtils;
import uk.co.cartesian.ascertain.imm.web.filters.FreeTextFilter;
import uk.co.cartesian.ascertain.imm.web.filters.FreeTextRegExpFilter;
import uk.co.cartesian.ascertain.imm.web.filters.IMMFilter;
import uk.co.cartesian.ascertain.imm.web.filters.MultiSelectFilter;
import uk.co.cartesian.ascertain.imm.web.filters.UIFilterRow;
import uk.co.cartesian.ascertain.imm.web.form.IssueManagementForm;
import uk.co.cartesian.ascertain.imm.web.helpers.IssueDetailsTransactionManager;
import uk.co.cartesian.ascertain.imm.web.helpers.PrivilegeConstants;
import uk.co.cartesian.ascertain.utils.exception.WebApplicationException;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;
import uk.co.cartesian.ascertain.utils.parse.AscertainParseException;
import uk.co.cartesian.ascertain.utils.parse.SquareBracketSubstitutionParser;
import uk.co.cartesian.ascertain.web.em.db.dao.beans.EMFieldTypeRef;
import uk.co.cartesian.ascertain.web.helpers.Utils;
import uk.co.cartesian.ascertain.web.session.bean.AscertainSessionUser;
import uk.co.cartesian.ascertain.web.tpm.ModularResultSetTPMConfiguration;
import uk.co.cartesian.ascertain.web.tpm.TPMColumnConfiguration;
import uk.co.cartesian.ascertain.web.tpm.TPMColumnConfiguration.OrderByState;
import uk.co.cartesian.ascertain.web.tpm.TPMConfiguration;
import uk.co.cartesian.ascertain.web.tpm.TPMException;
import uk.co.cartesian.ascertain.web.tpm.action.TPMConfigurationRepository;
import uk.co.cartesian.ascertain.web.utils.StringUtils;

/**
 * @author Cartesian
 */
public class IssueManagementSetupAction
extends Action
{
    private static Logger logger = LogInitialiser.getLogger(IssueManagementSetupAction.class.getName());

    public static final String COLUMN_PREFIX = "COL_";
    public static final String COLUMN_SUFFIX = "_VALUE";
    
    public static final String ISSUE_ID_ID = "issue_identifier";
    //public static final String ISSUE_DATE_RAISED_ID = "issue_date_raised";
    
    public static final String MAIN_TPM_ID = "uk.co.cartesian.ascertain.imm.web.action.IssueManagement";
    public static final String CHILD_TPM_ID = "uk.co.cartesian.ascertain.imm.web.action.IssueManagement.child";
    public static final String LINKS_TPM_ID = "uk.co.cartesian.ascertain.imm.web.action.IssueManagement.links";   
    public static final String PARENT_TPM_ID = "uk.co.cartesian.ascertain.imm.web.action.IssueManagement.parent";    

    /**
     * 
     */
    public ActionForward execute(ActionMapping mapping, ActionForm untypedForm, HttpServletRequest request, HttpServletResponse response)
    throws Exception
    {
        logger.debug("IssueManagementSetupAction:execute(...) - START");;
        String forward = "success";
        IssueManagementForm imForm = (IssueManagementForm)untypedForm;
        
        //Get IM_REF ID from the request
        String imId = request.getParameter("imId");
        String classId = request.getParameter("classId");
        if(imId == null || imId.trim().equals(""))
        {
            //try to get the classId
            if(classId != null && !classId.isEmpty())
            {
                imForm.setClassId(classId);
            }
            else
            {
                throw new WebApplicationException("Missing parameter 'imId'");
            }
        }
        else
        {
        	imForm.setImId(imId);
        	imForm.setClassId(classId);
          	//set out the classId and filter_3018 parameters 
            if(imId.equals("3001") || imId.equals("3002") || imId.equals("3003"))
            {
                imForm.setClassId(imId);
            }
        }
        
  		// reset the session form so we don't pick up previous filter values
        imForm.manualReset();

        AscertainSessionUser asu = AscertainSessionUser.getSessionUser(request);
        boolean isGroupPowerUser = asu.hasPrivilege(PrivilegeConstants.IM_GROUP_POWER_USER.getPrivilegeId());

        //Sort out the Filters
        Integer id = Integer.valueOf(imForm.getClassId());
        List<AttributeFilterConfRef> attributeFilterConfRefList = AttributeFilterConfRefDAO.readAllForImId((!StringUtils.isEmpty(imId) ? Integer.valueOf(imId) : id), asu.getParameters(), isGroupPowerUser);
        List<IMMFilter> hiddenFilters = new ArrayList<IMMFilter>();
        Collection<UIFilterRow> filterRows = getFilters(hiddenFilters, attributeFilterConfRefList,asu.getParameters());
        
        //Set the filter initial filter values
        for(UIFilterRow row : filterRows)
        {
            setInitialFormValues(imForm, row.getCol1());
            setInitialFormValues(imForm, row.getCol2());
        }
    	
        //Sort out the TPM configuration
        List<AttributeColumnConfRef> attributeColumnConfRefList = AttributeColumnConfRefDAO.readAllForImId((!StringUtils.isEmpty(imId) ? Integer.valueOf(imId) : id), isGroupPowerUser);
        TPMConfiguration tpmConfig = getTpmConfiguration(request, attributeColumnConfRefList, attributeFilterConfRefList, imForm, asu);
        
        //Stick the configuration in the repository using the correct key
        TPMConfigurationRepository.add(request, tpmConfig, imForm.getTpmKey());
                     
        //We put the filters in the session for the UI and the filter configuration in the session for the back end
        request.getSession().setAttribute("IMM__ISSUE_MANAGEMENT_FILTER_CONF", attributeFilterConfRefList);
        request.getSession().setAttribute("IMM__ISSUE_MANAGEMENT_FILTER_ROWS", filterRows);
        request.getSession().setAttribute("IMM__ISSUE_MANAGEMENT_HIDDEN_FILTERS", hiddenFilters);
            
        return mapping.findForward(forward);
    }
 
    
    /**
     * 
     * @return
     */
    public static IssueManagementForm setInitialFormValues(IssueManagementForm form, IMMFilter filter)
    {
        IssueManagementForm returnValue = form;
        if(filter instanceof DateFilter)
        {
            form.setDateFilterValue(filter.getColumnId(), ((DateFilter)filter).getValue());
        }
        else if(filter instanceof DateRangeFilter)
        {
            String from = ((DateRangeFilter)filter).getFromDate();
            form.setDateRangeFilterValue(filter.getColumnId() + FilterUtils.DATE_RANGE_FROM_SUFFIX, from);
            String to = ((DateRangeFilter)filter).getToDate();
            form.setDateRangeFilterValue(filter.getColumnId() + FilterUtils.DATE_RANGE_TO_SUFFIX, to);
        }
        else if(filter instanceof DateTimeFilter)
        {
            form.setDateTimeFilterValue(filter.getColumnId(), ((DateTimeFilter)filter).getDate());
        }
        else if(filter instanceof DropDownFilter)
        {
            String value = ((DropDownFilter)filter).getValue();
            if( (value != null) && (!value.trim().equals("")) )
            {
                form.setDropDownFilterValue(filter.getColumnId(), value);
            }
        }
        else if(filter instanceof MultiSelectFilter)
        {
            String[] value = ((MultiSelectFilter)filter).getValue();
            if(value != null)
            {
                form.setMultiSelectFilterValue(filter.getColumnId(), value);
            }
        }
        else if(filter instanceof FreeTextFilter)
        {
            form.setFreeTextFilterValue(filter.getColumnId(), ((FreeTextFilter)filter).getValue());
        }
        else if(filter instanceof FreeTextRegExpFilter)
        {
            form.setFreeTextRegExpFilterValue(filter.getColumnId(), ((FreeTextRegExpFilter)filter).getValue());
        }
        return returnValue;
    }
    

    /**
     * This method does not construct valid SQL it only becomes valid after the bodged where clause is added!
     * 
     * @param attributeColumnConfRef
     * @return
     * @throws AscertainParseException 
     */
    private TPMConfiguration getTpmConfiguration(HttpServletRequest request, List<AttributeColumnConfRef> attributeColumnConfRefList, List<AttributeFilterConfRef> attributeFilterConfRefList, IssueManagementForm imForm, AscertainSessionUser asu)
    throws TPMException, SQLException, AscertainParseException
    {
        ModularResultSetTPMConfiguration tpmConfiguration = new ModularResultSetTPMConfiguration(AscertainSessionUser.getLocale(request));
        
        //Go through order list and create our TPM configuration
        String sql = "SELECT * FROM (\nSELECT t.issue_id as " + ISSUE_ID_ID + ",\n       t.owning_group_id as group_identifier";
        String reportSql = "SELECT * FROM (\nSELECT t.issue_id as " + ISSUE_ID_ID + ",\n       t.owning_group_id as group_identifier";
        String format = null;
        String sqlItem = null;
        String reportSqlItem = null;
        String columnAlias = null;

        // add issue at least once and hidden to ensure a unique key is present.
        TPMColumnConfiguration column = new TPMColumnConfiguration(ISSUE_ID_ID, "Issue Identifier", "Issue Identifier");
        column.setType(TPMColumnConfiguration.NUMBER_TYPE);
        column.setUniqueKey(true);
        column.setState(TPMColumnConfiguration.HIDDEN);
        tpmConfiguration.addColumn(column);        

        column = new TPMColumnConfiguration("group_identifier", "Group Identifier", "Group Identifier");
        column.setType(TPMColumnConfiguration.NUMBER_TYPE);
        column.setState(TPMColumnConfiguration.HIDDEN);
        tpmConfiguration.addColumn(column);        

        //Now sort out the rest of the column configuration
        for(AttributeColumnConfRef attributeColumnConfRef : attributeColumnConfRefList)
        {
            sql += ",\n       ";
            reportSql += ",\n       ";
            
            columnAlias = COLUMN_PREFIX + attributeColumnConfRef.getAttributeRef().getAttributeId(); 
              
            //Configure our column
            column = new TPMColumnConfiguration(columnAlias, attributeColumnConfRef.getAttributeRef().getName(), attributeColumnConfRef.getAttributeRef().getDescription());
            if(attributeColumnConfRef.getColumnType().getType().equals(EMFieldTypeRef.IMAGE_TYPE))
            {
                column.setType(TPMColumnConfiguration.ICON_TYPE);
                column.setLabel("");
                column.setCollapsible(false);
                column.setOrderByState(OrderByState.DISABLED);
            }
            else if(attributeColumnConfRef.getColumnType().getType().equals(EMFieldTypeRef.NUMBER_TYPE))
            {
                column.setType(TPMColumnConfiguration.NUMBER_TYPE);
            }
            else if(attributeColumnConfRef.getColumnType().getType().equals(EMFieldTypeRef.DATE_TYPE))
            {
                column.setType(TPMColumnConfiguration.DATE_TYPE);
            }
            else if(attributeColumnConfRef.getColumnType().getType().equals(EMFieldTypeRef.DATE_TIME_TYPE))
            {
                column.setType(TPMColumnConfiguration.DATE_TYPE);
            }
            else
            {
                column.setType(TPMColumnConfiguration.STRING_TYPE);
            }
            
            if((COLUMN_PREFIX+AttributeRef.ISSUE_ID_ATTRIBUTE_REF_ID).equals(columnAlias)) 
            {
                if("true".equalsIgnoreCase(IMMProperties.getInstance().getProperty(IMMProperties.ORDER_ISSUE_MANAGEMENT_SCREEN)))
                {
                    //Short term solution to suppress the ordering of issue management data using a Cartesian property
                    column.setOrderByColumnId(ISSUE_ID_ID);
                    column.setOrderByState(OrderByState.DESCENDING);
                }
                if( 
                    ("true".equals(request.getParameter("child_issues"))) || 
                    ("true".equals(request.getParameter("linked_issues"))) || 
                    ("true".equals(request.getParameter("parent_issues")))
                ) {
            		// hide issue id field and replace with a non liked version.
            		column.setState(TPMColumnConfiguration.HIDDEN);            		

                    tpmConfiguration.addColumn(column);        
                    column = new TPMColumnConfiguration(ISSUE_ID_ID, "Issue Identifier", "Issue Identifier");
                    column.setType(TPMColumnConfiguration.NUMBER_TYPE);
            	}            	
            }            	
            
            //Add our configured column to the configuration
            tpmConfiguration.addColumn(column);

            //Figure out what the SQL is going to be
            format = attributeColumnConfRef.getColumnType().getFormatString(); 
            if(attributeColumnConfRef.getAttributeRef().getIssueTableColumn() != null)
            {
                //This is one of the core attributes in the IMM.ISSUE table
                if(attributeColumnConfRef.getDisplaySql() != null)
                {
                    sqlItem = attributeColumnConfRef.getDisplaySql() + " AS " + columnAlias;
                }
                else
                {
                    sqlItem = attributeColumnConfRef.getAttributeRef().getIssueTableColumn();
                    if(format != null && !format.trim().equals(""))
                    {
                        sqlItem = "TO_CHAR(" + sqlItem + ", '" + format + "')";
                    }
                    sqlItem += " AS " + columnAlias;
                }
                
                if(attributeColumnConfRef.getReportSql() != null)
                {
                    reportSqlItem = attributeColumnConfRef.getReportSql() + " AS " + columnAlias;
                }
                else
                {
                    reportSqlItem = attributeColumnConfRef.getAttributeRef().getIssueTableColumn() + " AS " + columnAlias;
                }
            }
            else
            {
                //This is one of the user defined attributes
                if(attributeColumnConfRef.getDisplaySql() != null)
                {
                    sqlItem = attributeColumnConfRef.getDisplaySql() + " AS " + columnAlias;
                }
                else
                {
                    if(attributeColumnConfRef.getAttributeRef().getDataType() == AttributeRef.DataType.DATE)
                    {
                        sqlItem = "(SELECT to_date(ia.value,'" + Utils.ORACLE_LONG_DATE_FORMAT + "') FROM imm.issue_attribute ia WHERE ia.issue_id = t.issue_id AND ia.attribute_id=" + attributeColumnConfRef.getAttributeRef().getAttributeId() + ")";
                    }
                    else if(attributeColumnConfRef.getAttributeRef().getDataType() == AttributeRef.DataType.DATETIME)
                    {
                        sqlItem = "(SELECT to_date(ia.value,'" + Utils.ORACLE_LONG_DATE_TIME_FORMAT + "') FROM imm.issue_attribute ia WHERE ia.issue_id = t.issue_id AND ia.attribute_id=" + attributeColumnConfRef.getAttributeRef().getAttributeId() + ")";
                    }
                    else
                    {
                        sqlItem = "(SELECT ia.value FROM imm.issue_attribute ia WHERE ia.issue_id = t.issue_id AND ia.attribute_id=" + attributeColumnConfRef.getAttributeRef().getAttributeId() + ")";
                    }
                    if(format != null && !format.trim().equals(""))
                    {
                        sqlItem = "TO_CHAR(" + sqlItem + ", '" + format + "')";
                    }

                    //Now sort out the prefix stuff
                    //TODO Figure out a way of doing both prefix and suffix with out creating the SQL from hell 
                    String xyxfix = attributeColumnConfRef.getColumnType().getPrefix();
                    if( (xyxfix != null) && (!xyxfix.equals("")) )
                    {
                        sqlItem = "DECODE (" + sqlItem + ",'','','" + xyxfix + "' || " + sqlItem + ")";
                    }
                    sqlItem += " AS " + columnAlias;
                }

                if(attributeColumnConfRef.getReportSql() != null)
                {
                    reportSqlItem = attributeColumnConfRef.getReportSql() + " AS " + columnAlias;
                }
                else
                {
                    if(attributeColumnConfRef.getAttributeRef().getDataType() == AttributeRef.DataType.DATE)
                    {
                        reportSqlItem = "(SELECT to_date(ia.value,'" + Utils.ORACLE_LONG_DATE_FORMAT + "') FROM imm.issue_attribute ia WHERE ia.issue_id = t.issue_id AND ia.attribute_id=" + attributeColumnConfRef.getAttributeRef().getAttributeId() + ")";
                    }
                    else if(attributeColumnConfRef.getAttributeRef().getDataType() == AttributeRef.DataType.DATETIME)
                    {
                        reportSqlItem = "(SELECT to_date(ia.value,'" + Utils.ORACLE_LONG_DATE_TIME_FORMAT + "') FROM imm.issue_attribute ia WHERE ia.issue_id = t.issue_id AND ia.attribute_id=" + attributeColumnConfRef.getAttributeRef().getAttributeId() + ")";
                    }
                    else
                    {
                        reportSqlItem = "(SELECT ia.value FROM imm.issue_attribute ia WHERE ia.issue_id = t.issue_id AND ia.attribute_id=" + attributeColumnConfRef.getAttributeRef().getAttributeId() + ")";
                    }
                    reportSqlItem += " AS " + columnAlias;
                }
            }
            sql += sqlItem;
            reportSql += reportSqlItem;
        }
        
        // add raw value to sql for any filters using a custom attribute
        for(AttributeFilterConfRef attributeFilterConfRef : attributeFilterConfRefList) 
        {
        	if(attributeFilterConfRef.getAttributeRef().getIssueTableColumn() == null)
        	{
        		sql += ",\n       (SELECT ia.value FROM imm.issue_attribute ia WHERE ia.issue_id = t.issue_id AND ia.attribute_id=" + attributeFilterConfRef.getAttributeRef().getAttributeId() + ") AS " + COLUMN_PREFIX + attributeFilterConfRef.getAttributeRef().getAttributeId() + COLUMN_SUFFIX; 
                reportSql += ",\n       (SELECT ia.value FROM imm.issue_attribute ia WHERE ia.issue_id = t.issue_id AND ia.attribute_id=" + attributeFilterConfRef.getAttributeRef().getAttributeId() + ") AS " + COLUMN_PREFIX + attributeFilterConfRef.getAttributeRef().getAttributeId() + COLUMN_SUFFIX; 
        	}
        }
        
        sql += "\nFROM imm.issue t\nLEFT OUTER JOIN imm.parent_child_issue_jn t2\n    ON t2.child_issue_id = t.issue_id";
        reportSql += "\nFROM imm.issue t\nLEFT OUTER JOIN imm.parent_child_issue_jn t2\n    ON t2.child_issue_id = t.issue_id";
        
        //We need to alter the SQL a little bit if this is a linked or child issue management screen
        String parentIssueId = (String)request.getParameter("parent_issue_id");
        String transactionId = (String)request.getParameter("transaction_id");
        if(parentIssueId != null && parentIssueId != "")
        {
            //This is a linked issue or child issue management screen.
            imForm.setIssueId(parentIssueId);
            imForm.setTransactionId(transactionId);
            if("true".equals(request.getParameter("child_issues")))
            {
                imForm.setTpmKey(CHILD_TPM_ID);
                sql += "\nWHERE NOT t.issue_id = " + parentIssueId; // prevent issue from adding itself 
                sql += "\nAND t.issue_type_id IN(SELECT itrA.issue_type_id from IMM.ISSUE_TYPE_HIERARCHY JOIN IMM.ISSUE_TYPE_REF itrA ON(child_issue_type_id=itrA.issue_type_id) JOIN IMM.ISSUE_TYPE_REF itrB ON(parent_issue_type_id=itrB.issue_type_id) JOIN IMM.ISSUE i ON(i.issue_type_id=itrB.issue_type_id) where i.issue_id = "+parentIssueId+")";
                sql += "\nAND t2.parent_issue_id is null";

                reportSql += "\nWHERE NOT t.issue_id = " + parentIssueId; // prevent issue from adding itself 
                reportSql += "\nAND t.issue_type_id IN(SELECT itrA.issue_type_id from IMM.ISSUE_TYPE_HIERARCHY JOIN IMM.ISSUE_TYPE_REF itrA ON(child_issue_type_id=itrA.issue_type_id) JOIN IMM.ISSUE_TYPE_REF itrB ON(parent_issue_type_id=itrB.issue_type_id) JOIN IMM.ISSUE i ON(i.issue_type_id=itrB.issue_type_id) where i.issue_id = "+parentIssueId+")";
                reportSql += "\nAND t2.parent_issue_id is null";
                
                //Need special row handler because the issue PK needs both id and date raised
                tpmConfiguration.setRowHandlerJsp("/jsp/imm/IssueManagementChildRowHandler.jsp");
            }
            else if ("true".equals(request.getParameter("linked_issues")))
            {  
                imForm.setTpmKey(LINKS_TPM_ID);
                sql += "\nWHERE NOT t.issue_id = " + parentIssueId; // prevent issue from adding itself 
                sql += "\nAND NOT t.issue_id IN(SELECT RI.ISSUE_ID FROM IMM.RELATED_ISSUE RI WHERE RI.RELATED_ISSUE_ID = "+parentIssueId+")";

                reportSql += "\nWHERE NOT t.issue_id = " + parentIssueId; // prevent issue from adding itself 
                reportSql += "\nAND NOT t.issue_id IN(SELECT RI.ISSUE_ID FROM IMM.RELATED_ISSUE RI WHERE RI.RELATED_ISSUE_ID = "+parentIssueId+")";
            } 
            
            tpmConfiguration.setShowRowLevelSelections(true);
            Connection connection = IssueDetailsTransactionManager.getInstance().getTransaction(transactionId);
            tpmConfiguration.setConnection(connection);
        }
        else
        {
            if ("true".equals(request.getParameter("parent_issues")))
            {             	              	  
                imForm.setTransactionId(transactionId);
                imForm.setTpmKey(PARENT_TPM_ID);
                                 
                String clauseSQL = null;
                
                //What type of update are we doing?
    	        String updateType = (String)request.getSession().getAttribute(BulkUpdateIssueDetailsProcessAction.SELECTED_ISSUES_UPDATE_TYPE_SESSION_KEY);
    	        if(BulkUpdateIssueDetailsProcessAction.SELECTED_ISSUES_UPDATE_TYPE_SELECTED.equals(updateType))
    	        {
    	            //We are going to work on a list of id's
    	            @SuppressWarnings("unchecked")
    	            Map<String, String> selectedRows = (Map<String, String>)request.getSession().getAttribute(BulkUpdateIssueDetailsProcessAction.SELECTED_ISSUES_LIST_SESSION_KEY);
    	           
    	        	Integer counter=0;
                    String issueCSV = "";
                    Set<String> idsSet = selectedRows.keySet();
                    for(String issueId : idsSet)
                    {
                        //Get the PK from the ROW_ID
                    	issueCSV+=(issueCSV.equals("")?"":",")+issueId;
                        counter++;
                    }
                    
    	        	clauseSQL = 
                        "\nwhere not t.issue_id in("+issueCSV+")\n"+
                        " and exists (select distinct prnt.issue_type_id\n" +
                        "  from (select count(distinct ijoin.issue_id) counter,\n" + 
                        "               ich.parent_issue_type_id\n" + 
                        "          from imm.issue_type_ref itr\n" + 
                        "          join imm.issue_type_hierarchy ich\n" +
                        "            on ich.child_issue_type_id = itr.issue_type_id\n" + 
                        "          join (select i.issue_type_id,\n" + 
                        "						i.issue_id\n" + 
                        "                 from imm.issue i\n" + 
                        "                where i.issue_id IN ("+issueCSV+")) ijoin\n" +
                        "            on ijoin.issue_type_id = itr.issue_type_id\n" + 
                        "         group by ich.parent_issue_type_id\n" + 
                        "        having count(distinct ijoin.issue_id) = "+String.valueOf(counter)+") chld\n" + 
                        "  join (select itr2.issue_type_id,\n" + 
                        "               itr2.issue_class_id\n" + 
                        "          from imm.issue_type_ref itr2\n" + 
                        "         ) prnt\n" + 
                        "on chld.parent_issue_type_id = prnt.issue_type_id\n"+
                        "where prnt.issue_type_id=t.issue_type_id)";
    	        }
    	        else
    	        {
    	            //We are going to work on all id's in the given query
    	            String bulkSql = (String)request.getSession().getAttribute(BulkUpdateIssueDetailsProcessAction.SELECTED_ISSUES_QUERY_SESSION_KEY);
    	            
    	            Set<Integer> classIds = IssueClassDAO.getClassIds(bulkSql, Long.valueOf(transactionId));

                    Integer counter=0;
                    String classCSV = "";
                    for(Integer id : classIds)
                    {
                        classCSV+=(classCSV.equals("")?"":",")+String.valueOf(id);
                        counter++;
                    }
                    
                    clauseSQL = 
                        "\nwhere not t.issue_id in(select "+IssueManagementSetupAction.ISSUE_ID_ID+" as issue_id from ("+bulkSql+"))\n"+
                        " and exists (select distinct prnt.issue_type_id\n" +
                        "  from (select count(distinct itr.issue_class_id) counter,\n" + 
                        "               ich.parent_issue_type_id\n" + 
                        "          from imm.issue_type_ref itr\n" + 
                        "          join imm.issue_type_hierarchy ich\n" +
                        "            on ich.child_issue_type_id = itr.issue_type_id\n" + 
                        "          where itr.issue_class_id IN ("+classCSV+") \n"+
                        "         group by ich.parent_issue_type_id\n" + 
                        "        having count(distinct itr.issue_class_id) = "+String.valueOf(counter)+") chld\n" + 
                        "  join (select itr2.issue_type_id,\n" + 
                        "               itr2.issue_class_id\n" +  
                        "          from imm.issue_type_ref itr2\n" + 
                        "         ) prnt\n" + 
                        "on chld.parent_issue_type_id = prnt.issue_type_id)";
    	        }
                sql += clauseSQL;
                sql += "\nAND t.date_closed is null";
                
                reportSql += clauseSQL;
                reportSql += "\nAND t.date_closed is null";
                
	            Connection connection = IssueDetailsTransactionManager.getInstance().getTransaction(transactionId);
	            tpmConfiguration.setConnection(connection);
	            tpmConfiguration.setRowHandlerJsp("/jsp/imm/IssueManagementParentRowHandler.jsp");
	            tpmConfiguration.setRowHeaderHandlerJsp("/jsp/web/tpm/DefaultRowHeaderPlus1NoSorting.jsp");
            }
            else
            {
                sql += "\nWHERE 1=1";
                reportSql += "\nWHERE 1=1";
	            imForm.setTpmKey(MAIN_TPM_ID);
	            tpmConfiguration.setRowHandlerJsp("/jsp/imm/IssueManagementRowHandler.jsp");
	            tpmConfiguration.setNavigatorJsp("/jsp/imm/IssueManagementNavigationBar.jsp");
	            tpmConfiguration.setConnectionPool("IMMCP");
	            tpmConfiguration.setShowRowLevelSelections(true);
	            //The bulk issue details update stuff needs to know what the SQL is
	            request.getSession().setAttribute(IssueManagementDisplayAction.ISSUE_MANAGEMENT_SQL, sql);
            }
        }
        
        //Parse our sql
        Map<String, String> parameters = new HashMap<String, String>();
        parameters.putAll(asu.getParameters());
        parameters.put("TPM_REPOSITORY_KEY", imForm.getTpmKey());
        SquareBracketSubstitutionParser parser = new SquareBracketSubstitutionParser(parameters);
        sql = parser.parse(sql);
        reportSql = parser.parse(reportSql);

        //Set our SQL
        tpmConfiguration.setFixedQuery(sql);
        tpmConfiguration.setReportQuery(reportSql);
        
        return tpmConfiguration;
    }
    
    
    /**
     * 
     * @param attributeFilterConfRefList
     * @return
     */
    private Collection<UIFilterRow> getFilters(List<IMMFilter> hiddenFilters, final List<AttributeFilterConfRef> attributeFilterConfRefList, final Map<String, String> variables)
    throws AscertainParseException, SQLException
    {
        Map<Integer, UIFilterRow> filterRows = new TreeMap<Integer, UIFilterRow>();

        IMMFilter filter;
        UIFilterRow filterRow;
        for(AttributeFilterConfRef attributeFilterConfRef : attributeFilterConfRefList)
        {
            filter = FilterUtils.getFilter(attributeFilterConfRef,  variables);
            if(attributeFilterConfRef.getRowNumber() == null || attributeFilterConfRef.getRowNumber() == 0)
            {
                //This is a hidden filter
                hiddenFilters.add(filter);
            }
            else 
            {
                //Get the filter row - might have to create a new one
                if(filterRows.containsKey(attributeFilterConfRef.getRowNumber()))
                {
                    filterRow = filterRows.get(attributeFilterConfRef.getRowNumber());
                }
                else
                {
                    filterRow = new UIFilterRow();
                    filterRows.put(attributeFilterConfRef.getRowNumber(), filterRow);
                }
    
                //Set the filter value in the row
                if(attributeFilterConfRef.getColumnNumber() == 1)
                {
                    filterRow.setCol1(filter);
                }
                else
                {
                    filterRow.setCol2(filter);
                }
            }
        }
        
        Collection<UIFilterRow> returnValue = filterRows.values();
        return returnValue;
    }
}
