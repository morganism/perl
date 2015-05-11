package uk.co.cartesian.ascertain.imm.web.filters;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import uk.co.cartesian.ascertain.imm.db.dao.IMMCpmWrapper;
import uk.co.cartesian.ascertain.imm.db.dao.beans.AttributeFilterConfRef;
import uk.co.cartesian.ascertain.imm.web.action.IssueManagementSetupAction;
import uk.co.cartesian.ascertain.imm.web.form.IssueManagementForm;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;
import uk.co.cartesian.ascertain.utils.parse.AscertainLabelValueBean;
import uk.co.cartesian.ascertain.utils.parse.AscertainParseException;
import uk.co.cartesian.ascertain.utils.parse.CurleyBracketLabelValuePairParser;
import uk.co.cartesian.ascertain.utils.parse.LabelValuePairParser;
import uk.co.cartesian.ascertain.utils.parse.SquareBracketSubstitutionParser;
import uk.co.cartesian.ascertain.utils.parse.SubstitutionParser;
import uk.co.cartesian.ascertain.web.helpers.Utils;
import uk.co.cartesian.ascertain.web.session.bean.AscertainSessionUser;

/**
 * @author Cartesian
 * Created on 04-Sep-2007
 */
public class FilterUtils
{
    static Logger logger = LogInitialiser.getLogger(FilterUtils.class.getName());
    
    private static final String _FILTER_ERROR_MESSAGE = "Filter error: Check logs and configuration";

    public static final String _FITLER_REQUEST_PREFIX = "filter_";

    public static final String DATE_RANGE_FROM_SUFFIX = "_from";
    public static final String DATE_RANGE_TO_SUFFIX = "_to";
    

    /**
     * 
     * @param string 
     * @param filterValues
     * @return
     */
    public static String generateWhereClauseFromFilterValues(
        final List<AttributeFilterConfRef> attributeFilterConfRefList,
        final Map<String, String> dateFilterValues, 
        final Map<String, String> dateRangeFilterValues, 
        final Map<String, String> dateTimeFilterValues,
        final Map<String, String> dropDownFilterValues, 
        final Map<String, String[]> multiSelectFilterValues, 
        final Map<String, String> freeTextFilterValues, 
        final Map<String, String> freeTextRegExpFilterValues,
        String tagId,
        boolean isGroupPowerUser,
        AscertainSessionUser asu
    ) 
    {
        
        String returnValue = "";
    
        String coreWhereClause = "";
        String userDefinedWhereClause = "WHERE 2=2";
        
        if(!isGroupPowerUser) // hard code owning group filter
        {
            coreWhereClause += "\nAND EXISTS(select jug.user_id from utils.join_user_group jug where jug.user_id="+asu.getAscertainUser().getUserId()+" and owning_group_id=group_id )";
        } 

        // Tag clause
        if (StringUtils.isNotEmpty(tagId))
        {
           // add tag_issue_jn where predicate
            coreWhereClause += 
               "AND EXISTS\n" +
               "  (\n" + 
               "   select 1 from tag_issue_jn tij\n" + 
               "   where\n" + 
               "   t.issue_id = tij.issue_id\n" + 
               "   and tij.tag_id = " + tagId +"\n" + 
               "  )";
        }
        
        if(attributeFilterConfRefList != null)
        {
            for(AttributeFilterConfRef attributeFilterConfRef : attributeFilterConfRefList)
            {
                //OK - we have to do different stuff according to whether this is a core attribute or a user defined attribute
                String columnId = IssueManagementSetupAction.COLUMN_PREFIX + attributeFilterConfRef.getAttributeRef().getAttributeId();
                if(columnId != null)
                {
                    String coreAttribute = attributeFilterConfRef.getAttributeRef().getIssueTableColumn();
                    if(coreAttribute != null)
                    {
                        coreWhereClause += processCoreAttributeFilterItem(coreAttribute, columnId, attributeFilterConfRef.getFilterType(), dateFilterValues, dateRangeFilterValues, dateTimeFilterValues, dropDownFilterValues, multiSelectFilterValues, freeTextFilterValues, freeTextRegExpFilterValues);
                    }
                    else
                    {
                        String userAttribute = IssueManagementSetupAction.COLUMN_PREFIX + attributeFilterConfRef.getAttributeRef().getAttributeId() + IssueManagementSetupAction.COLUMN_SUFFIX;
                        userDefinedWhereClause += processUserAttributeFilterItem(userAttribute, columnId, attributeFilterConfRef.getFilterType(), dateFilterValues, dateRangeFilterValues, dateTimeFilterValues, dropDownFilterValues, multiSelectFilterValues, freeTextFilterValues, freeTextRegExpFilterValues);
                    }
                }
            }
        }
        returnValue = coreWhereClause + "\n)\n" + userDefinedWhereClause;

        return returnValue;
    }
    
    /**
     * 
     * @param coreAttribute
     * @param filterType
     * @param dateFilterValues
     * @param dateRangeFilterValues
     * @param dateTimeFilterValues
     * @param dropDownFilterValues
     * @param freeTextFilterValues
     * @param freeTextRegExpFilterValues
     * @return
     */
    private static String processCoreAttributeFilterItem (
        String coreAttribute,
        String property,
        AttributeFilterConfRef.FilterType filterType,
        final Map<String, String> dateFilterValues, 
        final Map<String, String> dateRangeFilterValues, 
        final Map<String, String> dateTimeFilterValues,
        final Map<String, String> dropDownFilterValues, 
        final Map<String, String[]> multiSelectFilterValues, 
        final Map<String, String> freeTextFilterValues, 
        final Map<String, String> freeTextRegExpFilterValues 
    ) {
        String returnValue = "";
        String value = null;
        if(filterType.equals(AttributeFilterConfRef.FilterType.DATE))
        {
            value = dateFilterValues.get(property);
            if( (value != null) && (!value.trim().equals("")) )
            {
                returnValue += "\nAND " + coreAttribute + " = TO_DATE('" + value + "','" + Utils.ORACLE_LONG_DATE_FORMAT + "')";
            }
        }
        else if(filterType.equals(AttributeFilterConfRef.FilterType.DATERANGE))
        {
            value = dateRangeFilterValues.get(property + "_from");
            if( (value != null) && (!value.trim().equals("")) )
            {
                returnValue += "\nAND " + coreAttribute + " >= TO_DATE('" + value + "','" + Utils.ORACLE_LONG_DATE_FORMAT + "')";
            }
            value = dateRangeFilterValues.get(property + "_to");
            if( (value != null) && (!value.trim().equals("")) )
            {
                returnValue += "\nAND " + coreAttribute + " < TO_DATE('" + value + "','" + Utils.ORACLE_LONG_DATE_FORMAT + "') + 1";
            }
        }
        else if(filterType.equals(AttributeFilterConfRef.FilterType.DATETIME))
        {
            value = dateTimeFilterValues.get(property);
            if( (value != null) && (!value.trim().equals("")) )
            {
                returnValue += "\nAND " + coreAttribute + " = TO_DATE('" + value + "','" + Utils.ORACLE_LONG_DATE_TIME_FORMAT + "')";
            }
        }
        else if(filterType.equals(AttributeFilterConfRef.FilterType.DROPDOWN))
        {
            value = dropDownFilterValues.get(property);
            if( (value != null) && (!IMMFilter.ALL_VALUE.equals(value)) && (!IMMFilter.NOT_FOUND_VALUE.equals(value)) )
            {
                if(IMMFilter.NULL_VALUE.equals(value))
                {
                    returnValue += "\nAND " + coreAttribute + " IS NULL";
                }
                else
                {
                    returnValue += "\nAND " + coreAttribute + " = '" + value + "'";
                }
            }
        }
        else if(filterType.equals(AttributeFilterConfRef.FilterType.MULTISELECT))
        {
            String values[] = multiSelectFilterValues.get(property);
            if(values != null && values.length > 0)
            {
                returnValue += "\nAND (";
                boolean addOr = false;
                for(String v : values) 
                {
                    if(addOr) returnValue += " OR ";
                    if(IMMFilter.NULL_VALUE.equals(v))
                    {
                        returnValue += coreAttribute + " IS NULL";
                    }
                    else
                    {
                        returnValue += coreAttribute + " = '" + v + "'";
                    }
                    addOr = true;
                }
                returnValue += ")";
            }
        }
        else if(filterType.equals(AttributeFilterConfRef.FilterType.FREETEXT))
        {
            value = freeTextFilterValues.get(property);
            if( (value != null) && (!value.trim().equals("")) )
            {
                value = value.replaceAll("\\*", "%");
                value = value.replaceAll("\\?", "_");
                returnValue += "\nAND " + coreAttribute + " LIKE '" + value + "'";
            }
        }
        else if(filterType.equals(AttributeFilterConfRef.FilterType.FREETEXT_REG))
        {
            value = freeTextRegExpFilterValues.get(property);
            if( (value != null) && (!value.trim().equals("")) && (!value.equals(FreeTextRegExpFilter.DEFAULT_TEXT)) )
            {
                returnValue += "\nAND REGEXP_LIKE (NVL(TO_CHAR(" + coreAttribute + "),'\n'),'" + value + "')";
            }
        }
        return returnValue;
    }
    
    /**
     * 
     * @param coreColumn
     * @param filterType
     * @param dateFilterValues
     * @param dateRangeFilterValues
     * @param dateTimeFilterValues
     * @param dropDownFilterValues
     * @param freeTextFilterValues
     * @param freeTextRegExpFilterValues
     * @return
     */
    private static String processUserAttributeFilterItem (
        String userAttribute,
        String property,
        AttributeFilterConfRef.FilterType filterType,
        final Map<String, String> dateFilterValues, 
        final Map<String, String> dateRangeFilterValues, 
        final Map<String, String> dateTimeFilterValues,
        final Map<String, String> dropDownFilterValues, 
        final Map<String, String[]> multiSelectFilterValues, 
        final Map<String, String> freeTextFilterValues, 
        final Map<String, String> freeTextRegExpFilterValues 
    ) {
        String returnValue = "";
        String value = null;
        if(filterType.equals(AttributeFilterConfRef.FilterType.DATE))
        {
            value = dateFilterValues.get(property);
            if( (value != null) && (!value.trim().equals("")) )
            {
                returnValue += "\nAND TO_DATE(" + userAttribute + ",'" + Utils.ORACLE_LONG_DATE_FORMAT + "')" + " = TO_DATE('" + value + "','" + Utils.ORACLE_LONG_DATE_FORMAT + "')";
            }
        }
        else if(filterType.equals(AttributeFilterConfRef.FilterType.DATERANGE))
        {
            value = dateRangeFilterValues.get(property + "_from");
            if( (value != null) && (!value.trim().equals("")) )
            {
                returnValue += "\nAND TO_DATE(" + userAttribute + ",'" + Utils.ORACLE_LONG_DATE_FORMAT + "')" + " >= TO_DATE('" + value + "','" + Utils.ORACLE_LONG_DATE_FORMAT + "')";
            }
            value = dateRangeFilterValues.get(property + "_to");
            if( (value != null) && (!value.trim().equals("")) )
            {
                returnValue += "\nAND TO_DATE(" + userAttribute + ",'" + Utils.ORACLE_LONG_DATE_FORMAT + "')" + " < TO_DATE('" + value + "','" + Utils.ORACLE_LONG_DATE_FORMAT + "') + 1";
            }
        }
        else if(filterType.equals(AttributeFilterConfRef.FilterType.DATETIME))
        {
            value = dateTimeFilterValues.get(property);
            if( (value != null) && (!value.trim().equals("")) )
            {
                returnValue += "\nAND TO_DATE(" + userAttribute + ",'" + Utils.ORACLE_LONG_DATE_TIME_FORMAT + "')" + " = TO_DATE('" + value + "','" + Utils.ORACLE_LONG_DATE_TIME_FORMAT + "')";
            }
        }
        else if(filterType.equals(AttributeFilterConfRef.FilterType.DROPDOWN))
        {
            value = dropDownFilterValues.get(property);
            if( (value != null) && (!IMMFilter.ALL_VALUE.equals(value)) && (!IMMFilter.NOT_FOUND_VALUE.equals(value)) )
            {
                if(IMMFilter.NULL_VALUE.equals(value))
                {
                    returnValue += "\nAND " + userAttribute + " IS NULL";
                }
                else
                {
                    returnValue += "\nAND " + userAttribute + " = '" + value + "'";
                }
            }
        }
        else if(filterType.equals(AttributeFilterConfRef.FilterType.MULTISELECT))
        {
            String values[] = multiSelectFilterValues.get(property);
            if(values != null && values.length > 0)
            {
                returnValue += "\nAND (";
                boolean addOr = false;
                for(String v : values) 
                {
                    if(addOr) returnValue += " OR ";
                    if(IMMFilter.NULL_VALUE.equals(v))
                    {
                        returnValue += userAttribute + " IS NULL";
                    }
                    else
                    {
                        returnValue += userAttribute + " = '" + v + "'";
                    }
                    addOr = true;
                }
                returnValue += ")";
            }
        }
        else if(filterType.equals(AttributeFilterConfRef.FilterType.FREETEXT))
        {
            value = freeTextFilterValues.get(property);
            if( (value != null) && (!value.trim().equals("")) )
            {
                value = value.replaceAll("\\*", "%");
                value = value.replaceAll("\\?", "_");
                returnValue += "\nAND " + userAttribute + " LIKE '" + value + "'";
            }
        }
        else if(filterType.equals(AttributeFilterConfRef.FilterType.FREETEXT_REG))
        {
            value = freeTextRegExpFilterValues.get(property);
            if( (value != null) && (!value.trim().equals("")) && (!value.equals(FreeTextRegExpFilter.DEFAULT_TEXT)) )
            {
                returnValue += "\nAND REGEXP_LIKE (NVL(TO_CHAR(" + userAttribute + "),'\n'),'" + value + "')";
            }
        }
        return returnValue;
    }
    
    /**
     * Return a long string representation of the date.
     * 
     * @return
     */
    public static String getInitialValueAsDate(String value, boolean dateTime, boolean nullable)
    {
        String returnValue = "";
        Date theDate = null;
        if( (value != null) && (!value.equals("")) )
        {
            try
            {
                if(value.startsWith(IMMFilter.ROLLING_DATE_MARKER))
                {
                    //We are dealing with a rolling date
                    Calendar c = new GregorianCalendar();
                    
                    String temp = value.substring(IMMFilter.ROLLING_DATE_MARKER.length());
                    if(temp.length() > 0)
                    {
                        String sign = temp.substring(0, 1);
                        if( ("+".equals(sign)) || (" ".equals(sign)) )
                        {
                            //The + sign gets stripped in the URL I am going to assume it's a plus
                            //No doubt this will come back to bite me in the arse, but time is no longer on my side!
                            int i = Integer.valueOf(temp.substring(1).trim());
                            c.add(Calendar.DAY_OF_YEAR, i);
                        }
                        else if("-".equals(sign))
                        {
                            String amount = sign + temp.substring(1).trim();
                            int i = Integer.valueOf(amount);
                            c.add(Calendar.DAY_OF_YEAR, i);
                        }
                    }
                    theDate = c.getTime();
                }
                else
                {
                    if(dateTime) 
                    {
                        theDate = Utils.urlFreindlyDateTimeToDate(value);
                    }
                    else
                    {
                        theDate = Utils.shortFileNameDateStringToDate(value);
                    }
                }
            }
            catch(Exception e)
            {
                logger.warn("FilterUtils:getDateFilter(...) - Could not initialize the date filter", e);
            }
        }
        
        if( (theDate == null) && (!nullable) )
        {
            //If this date field is not nullable then use todays date as default
            theDate = new Date();
        }
        
        if(theDate != null)
        {
            if(dateTime)
            {
                returnValue = Utils.dateToLongDateAndShortTimeString(theDate);
            }
            else
            {
                returnValue = Utils.dateToLongString(theDate);
            }
        }

        return returnValue;
    }

    
    /**
     * 
     * @param emId
     * @return
     * @throws SQLException
     */
    public static IMMFilter getFilter(AttributeFilterConfRef attributeFilterConfRef, Map<String, String> variables)
    {
        IMMFilter returnValue = getFreeTextFilter(attributeFilterConfRef);
        boolean error=false;
     
        try
        {
            if(attributeFilterConfRef.getFilterType().equals(AttributeFilterConfRef.FilterType.DATE))
            {
                returnValue = getDateFilter(attributeFilterConfRef);
            }
            else if(attributeFilterConfRef.getFilterType().equals(AttributeFilterConfRef.FilterType.DATERANGE))
            {
                returnValue = getDateRangeFilter(attributeFilterConfRef);
            }
            else if(attributeFilterConfRef.getFilterType().equals(AttributeFilterConfRef.FilterType.DATETIME))
            {
                returnValue = getDateTimeFilter(attributeFilterConfRef);
            }
            else if(attributeFilterConfRef.getFilterType().equals(AttributeFilterConfRef.FilterType.DROPDOWN))
            {
                returnValue = getDropDownFilter(attributeFilterConfRef, variables);
            }
            else if(attributeFilterConfRef.getFilterType().equals(AttributeFilterConfRef.FilterType.MULTISELECT))
            {
                returnValue = getMultiSelectFilter(attributeFilterConfRef, variables);
            }
            else if(attributeFilterConfRef.getFilterType().equals(AttributeFilterConfRef.FilterType.FREETEXT_REG))
            {
                returnValue = getFreeTextRegExpFilter(attributeFilterConfRef);
            }
        }
        catch(Exception e)
        {
            logger.error("FilterUtils:getFilter(...) - Error creating filter!", e);
            error=true;
        }
                
        returnValue.setId(attributeFilterConfRef.getAttributeRef().getAttributeId());
        returnValue.setLabel(attributeFilterConfRef.getAttributeRef().getName());
        returnValue.setColumnId(IssueManagementSetupAction.COLUMN_PREFIX + attributeFilterConfRef.getAttributeRef().getAttributeId());
        returnValue.setSpanColumns(attributeFilterConfRef.getIsSpanColumn());
        
        if(error)
        {
            returnValue.setError(true);
        }
        else
        {
            returnValue.setChildAttributeId(attributeFilterConfRef.getChildAttributeId());
            returnValue.setLinkField(attributeFilterConfRef.getLinkField());
        }
        
        return returnValue;
    }

    /**
     * 
     * @return
     */
    private static IMMFilter getDateFilter(AttributeFilterConfRef emFilterRef)
    {
        DateFilter returnValue = new DateFilter();
        return returnValue;
    }
    
    /**
     * 
     * @return
     */
    private static IMMFilter getDateRangeFilter(AttributeFilterConfRef emFilterRef)
    {
        DateRangeFilter returnValue = new DateRangeFilter();
        return returnValue;
    }
    
    /**
     * TODO maybe a bit more error checking
     * @return
     */
    private static IMMFilter getDateTimeFilter(AttributeFilterConfRef emFilterRef)
    {
        DateTimeFilter returnValue = new DateTimeFilter();
        return returnValue;
    }
    
    /**
     * 
     * @return
     */
    private static IMMFilter getDropDownFilter(AttributeFilterConfRef emFilterRef, Map<String, String> variables)
    throws SQLException, AscertainParseException
    {
        DropDownFilter returnValue = new DropDownFilter();
        boolean itemAdded = false;
        if(emFilterRef.getDropdownHasAll())
        {
            AscertainLabelValueBean lvb = new AscertainLabelValueBean(IMMFilter.ALL_LABEL, IMMFilter.ALL_VALUE);
            returnValue.addOption(lvb);
            itemAdded = true;
        }
        if(emFilterRef.getDropdownHasNull())
        {
            AscertainLabelValueBean lvb = new AscertainLabelValueBean(IMMFilter.NULL_LABEL, IMMFilter.NULL_VALUE);
            returnValue.addOption(lvb);
            itemAdded = true;
        }
        if( (emFilterRef.getDropdownValuesAsSql() != null) && (!emFilterRef.getDropdownValuesAsSql().equals("")) )
        {
            Connection connection = null;
            PreparedStatement statement = null;
            ResultSet rs = null;

            try
            {
                //Parse the given filter SQL
                SubstitutionParser p = new SquareBracketSubstitutionParser(variables);
                String ddSql = p.parse(emFilterRef.getDropdownValuesAsSql());

                //Get our drop down values
                connection = IMMCpmWrapper.getAutoConnection();
                statement = connection.prepareStatement(ddSql);

                rs = statement.executeQuery();
                AscertainLabelValueBean lvb = null;
                while(rs.next())
                {
                    lvb = new AscertainLabelValueBean();
                    lvb.setLabel(rs.getString("label"));
                    lvb.setValue(rs.getString("value"));
                    returnValue.addOption(lvb);
                    itemAdded = true;
                }
                
                if(!itemAdded)
                {
                    lvb = new AscertainLabelValueBean(IMMFilter.NOT_FOUND_LABEL, IMMFilter.NOT_FOUND_VALUE);
                    returnValue.addOption(lvb);
                }
            }
            catch (SQLException e)
            {
                String msg = "Could not load drop down filter data. The SQL\n" + emFilterRef.getDropdownValuesAsSql() + "\ndoes not appear to be valid!";
                logger.error("EMRefDAO:load(...) - " + msg, e);
                throw e;
            }
            finally
            {
                try {rs.close();} catch (Exception e) { }
                try {statement.close();} catch (Exception e) { }
                try {connection.close();} catch (Exception e) { }
            }
        }
        String csv = emFilterRef.getDropdownValuesAsList();
        if( (csv != null) && (!csv.trim().equals("")) )
        {
            try
            {
                LabelValuePairParser parser = new CurleyBracketLabelValuePairParser();
                List<AscertainLabelValueBean> alvbs = parser.parse(csv);
                returnValue.addOptions(alvbs);
            }
            catch(AscertainParseException e)
            {
                String msg = "Could not parse drop down values as list.\n" + e.toString();
                logger.error("EMRefDAO:load(...) - " + msg, e);
                throw e;
            }
        }
        return returnValue;
    }

    /**
     * 
     * @return
     */
    private static IMMFilter getMultiSelectFilter(AttributeFilterConfRef emFilterRef, Map<String, String> variables)
    throws SQLException, AscertainParseException
    {
        MultiSelectFilter returnValue = new MultiSelectFilter();
        boolean itemAdded = false;
        if(emFilterRef.getDropdownHasNull())
        {
            AscertainLabelValueBean lvb = new AscertainLabelValueBean(IMMFilter.NULL_LABEL, IMMFilter.NULL_VALUE);
            returnValue.addOption(lvb);
            itemAdded = true;
        }
        if( (emFilterRef.getDropdownValuesAsSql() != null) && (!emFilterRef.getDropdownValuesAsSql().equals("")) )
        {
            Connection connection = null;
            PreparedStatement statement = null;
            ResultSet rs = null;

            try
            {
                //Parse the given filter SQL
                SubstitutionParser p = new SquareBracketSubstitutionParser(variables);
                String ddSql = p.parse(emFilterRef.getDropdownValuesAsSql());

                //Get our drop down values
                connection = IMMCpmWrapper.getAutoConnection();
                statement = connection.prepareStatement(ddSql);

                rs = statement.executeQuery();
                AscertainLabelValueBean lvb = null;
                while(rs.next())
                {
                    lvb = new AscertainLabelValueBean();
                    lvb.setLabel(rs.getString("label"));
                    lvb.setValue(rs.getString("value"));
                    returnValue.addOption(lvb);
                    itemAdded = true;
                }
                
                if(!itemAdded)
                {
                    lvb = new AscertainLabelValueBean(IMMFilter.NOT_FOUND_LABEL, IMMFilter.NOT_FOUND_VALUE);
                    returnValue.addOption(lvb);
                }
            }
            catch (SQLException e)
            {
                String msg = "Could not load drop down filter data. The SQL\n" + emFilterRef.getDropdownValuesAsSql() + "\ndoes not appear to be valid!";
                logger.error("EMRefDAO:load(...) - " + msg, e);
                throw e;
            }
            finally
            {
                try {rs.close();} catch (Exception e) { }
                try {statement.close();} catch (Exception e) { }
                try {connection.close();} catch (Exception e) { }
            }
        }
        String csv = emFilterRef.getDropdownValuesAsList();
        if( (csv != null) && (!csv.trim().equals("")) )
        {
            try
            {
                LabelValuePairParser parser = new CurleyBracketLabelValuePairParser();
                List<AscertainLabelValueBean> alvbs = parser.parse(csv);
                returnValue.addOptions(alvbs);
            }
            catch(AscertainParseException e)
            {
                String msg = "Could not parse drop down values as list.\n" + e.toString();
                logger.error("EMRefDAO:load(...) - " + msg, e);
                throw e;
            }
        }
        return returnValue;
    }

    /**
     * 
     * @return
     */
    private static IMMFilter getFreeTextFilter(AttributeFilterConfRef emFilterRef)
    {
        FreeTextFilter returnValue = new FreeTextFilter();
        return returnValue;
    }

    /**
     * 
     * @return
     */
    private static IMMFilter getFreeTextRegExpFilter(AttributeFilterConfRef emFilterRef)
    {
        FreeTextRegExpFilter returnValue = new FreeTextRegExpFilter();
        return returnValue;
    }

    public static IssueManagementForm setRequestFilterValues(IssueManagementForm form, List<AttributeFilterConfRef> attributeFilterConfRefList, final HttpServletRequest request)
    throws AscertainParseException, SQLException
    {
                
        String value = null;
        IssueManagementForm returnValue = form;
        IMMFilter filter;
        
        if(attributeFilterConfRefList != null)
        {
            for(AttributeFilterConfRef attributeFilterConfRef : attributeFilterConfRefList)
            {
                filter = FilterUtils.getFilter(attributeFilterConfRef, AscertainSessionUser.getParameters(request));
                Integer id = filter.getId();
                value = request.getParameter(FilterUtils._FITLER_REQUEST_PREFIX + id);
                if(filter.getError())
                {
                    form.setFreeTextFilterValue(filter.getColumnId(), _FILTER_ERROR_MESSAGE);
                }
                else if( (value != null)  && (!value.trim().equals("")) )
                {
                    if(filter instanceof DateFilter)
                    {
                        if("null".equals(value))
                        {
                            value="";
                        }
                        value = FilterUtils.getInitialValueAsDate(value, false, true);
                        form.setDateFilterValue(filter.getColumnId(), value);
                    }
                    else if(filter instanceof DateRangeFilter)
                    {
                        int index=value.indexOf(",");
                        String from = value.substring(0, index).trim();
                        if("null".equals(from))
                        {
                            from="";
                        }
                        from = FilterUtils.getInitialValueAsDate(from, false, true);
                        form.setDateRangeFilterValue(filter.getColumnId() + FilterUtils.DATE_RANGE_FROM_SUFFIX, from);
        
                        String to = value.substring(index+1, value.length()).trim();
                        if("null".equals(to))
                        {
                            to="";
                        }
                        to = FilterUtils.getInitialValueAsDate(to, false, true);
                        form.setDateRangeFilterValue(filter.getColumnId() + FilterUtils.DATE_RANGE_TO_SUFFIX, to);
                    }
                    else if(filter instanceof DateTimeFilter)
                    {
                        //Do the date portion
                        String date = value;
                        int index = date.indexOf('.');
                        if(index > 0)
                        {
                            date = date.substring(0, index);
                        }
                        if("null".equals(date))
                        {
                            date="";
                        }
                        date = FilterUtils.getInitialValueAsDate(date, true, true);
                        form.setDateTimeFilterValue(filter.getColumnId(), date);
                    }
                    else if(filter instanceof DropDownFilter)
                    {
                        if("null".equals(value))
                        {
                            value=IMMFilter.NULL_VALUE;
                        }
                        else if("all".equals(value))
                        {
                            value=IMMFilter.ALL_VALUE;
                        }
                        form.setDropDownFilterValue(filter.getColumnId(), value);
                    }
                    else if(filter instanceof FreeTextFilter)
                    {
                        if("null".equals(value))
                        {
                            value="";
                        }
                        form.setFreeTextFilterValue(filter.getColumnId(), value);
                    }
                    else if(filter instanceof FreeTextRegExpFilter)
                    {
                        if("null".equals(value))
                        {
                            value="";
                        }
                        form.setFreeTextRegExpFilterValue(filter.getColumnId(), value);
                    }
                }
            }
        }
        
        return returnValue;
    }

    
}
