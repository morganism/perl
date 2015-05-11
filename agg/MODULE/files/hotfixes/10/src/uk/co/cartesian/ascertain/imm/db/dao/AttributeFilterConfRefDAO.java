package uk.co.cartesian.ascertain.imm.db.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import uk.co.cartesian.ascertain.imm.db.dao.beans.AttributeFilterConfRef;
import uk.co.cartesian.ascertain.imm.db.dao.beans.AttributeRef;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;

/**
 * @author Cartesian
 * Created on 19-Nov-2007
 */
public class AttributeFilterConfRefDAO
{
    static Logger logger = LogInitialiser.getLogger(AttributeFilterConfRefDAO.class.getName());

    private static final String _READ_ALL =
        "select t.im_id,\n" +
        "       t.attribute_id,\n" +
        "       t.column_number,\n" + 
        "       t.row_number,\n" + 
        "       t.is_span_columns,\n" + 
        "       t.filter_type,\n" + 
        "       t.dropdown_values_as_sql,\n" + 
        "       t.dropdown_values_as_list,\n" + 
        "       t.dropdown_has_null,\n" + 
        "       t.dropdown_has_all,\n" + 
        "       t.child_attribute_id,\n" + 
        "       t.link_field\n" + 
        "from imm.attribute_filter_conf_ref t\n";
    
    private static final String _READ_ALL_FOR_IM_ID =
        _READ_ALL + "\n" +
        "where t.im_id = ?";
   

    /**
     * @param actionGroupId
     * @return
     * @throws SQLException 
     */
    public static List<AttributeFilterConfRef> readAllForImId(Integer imId, Map<String, String> parameters, boolean isGroupPowerUser) 
    throws Exception
    {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet results = null;

        List<AttributeFilterConfRef> returnValue = new ArrayList<AttributeFilterConfRef>();
        try
        {
            connection = IMMDatabaseDAOUtils.getAutoConnection();
            statement = connection.prepareStatement(_READ_ALL_FOR_IM_ID);
            statement.setInt(1, imId);

            results = statement.executeQuery();
            AttributeFilterConfRef AttributeFilterConfRef = read(results, parameters, isGroupPowerUser, connection);
            while (AttributeFilterConfRef != null)
            {
                returnValue.add(AttributeFilterConfRef);
                AttributeFilterConfRef = read(results, parameters, isGroupPowerUser, connection);
            }
        }
        catch (SQLException e)
        {
            logger.error("AttributeFilterConfRefDAO:readAll() - Failed to read attribute column configuration.", e);
            throw e;
        }
        finally
        {
            try{results.close();} catch(Exception e) {};
            try{statement.close();} catch(Exception e) {};
            try{connection.close();} catch(Exception e) {};
        }
        return returnValue;
    }

    /**
     * 
     * @param rs
     * @return
     */
    private static AttributeFilterConfRef read(ResultSet rs, Map<String, String> parameters, boolean isGroupPowerUser, Connection connection)
    throws Exception
    {
        AttributeFilterConfRef returnValue = null;
        if(rs.next())
        {
            returnValue = new AttributeFilterConfRef();
            returnValue.setImId(rs.getInt("im_id"));
            int attributeId = rs.getInt("attribute_id");
            AttributeRef attributeRef = AttributeRefDAO.read(attributeId, null, isGroupPowerUser);
            returnValue.setAttributeRef(attributeRef);
            returnValue.setColumnNumber(rs.getInt("column_number"));
            returnValue.setRowNumber(rs.getInt("row_number"));
            String isSpanColumns = rs.getString("is_span_columns");
            returnValue.setIsSpanColumn("Y".equalsIgnoreCase(isSpanColumns) ? true : false);
            returnValue.setChildAttributeId(rs.getInt("child_attribute_id"));
            returnValue.setLinkField(rs.getString("link_field"));
                
            String filterType = rs.getString("filter_type");
            if(AttributeFilterConfRef.FilterType.DATE.getDescription().equals(filterType))
            {
                returnValue.setFilterType(AttributeFilterConfRef.FilterType.DATE);
            }
            else if(AttributeFilterConfRef.FilterType.DATERANGE.getDescription().equals(filterType))
            {
                returnValue.setFilterType(AttributeFilterConfRef.FilterType.DATERANGE);
            }
            else if(AttributeFilterConfRef.FilterType.DATETIME.getDescription().equals(filterType))
            {
                returnValue.setFilterType(AttributeFilterConfRef.FilterType.DATETIME);
            }
            else if(AttributeFilterConfRef.FilterType.DROPDOWN.getDescription().equals(filterType))
            {
                returnValue.setFilterType(AttributeFilterConfRef.FilterType.DROPDOWN);
            }
            else if(AttributeFilterConfRef.FilterType.MULTISELECT.getDescription().equals(filterType))
            {
                returnValue.setFilterType(AttributeFilterConfRef.FilterType.MULTISELECT);
            }
            else if(AttributeFilterConfRef.FilterType.FREETEXT_REG.getDescription().equals(filterType))
            {
                returnValue.setFilterType(AttributeFilterConfRef.FilterType.FREETEXT_REG);
            }
            else
            {
                returnValue.setFilterType(AttributeFilterConfRef.FilterType.FREETEXT);
            }

            returnValue.setDropdownValuesAsSql(rs.getString("dropdown_values_as_sql"));
            returnValue.setDropdownValuesAsList(rs.getString("dropdown_values_as_list"));
            
            //The drop down for the owning group attribute is hard coded
            if(AttributeRef.OWNING_GROUP_ID_ATTRIBUTE_REF_ID.intValue() == returnValue.getAttributeRef().getAttributeId())
            {
                if(isGroupPowerUser)
                {
                	returnValue.setDropdownValuesAsSql(AttributeRefDAO._GROUP_POWER_USER_SQL);
                }
                else
                {
                	returnValue.setDropdownValuesAsSql(AttributeRefDAO._NON_GROUP_POWER_USER_SQL);
                }
            }            

            String dropdownIsNull = rs.getString("dropdown_has_null");
            returnValue.setDropdownHasNull("Y".equalsIgnoreCase(dropdownIsNull) ? true : false);
            
            String dropdownHasAll = rs.getString("dropdown_has_all");
            returnValue.setDropdownHasAll("Y".equalsIgnoreCase(dropdownHasAll) ? true : false);
        }
        return returnValue;
    }
    
}
