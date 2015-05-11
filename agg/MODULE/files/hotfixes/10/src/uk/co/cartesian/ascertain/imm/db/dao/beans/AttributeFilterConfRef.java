package uk.co.cartesian.ascertain.imm.db.dao.beans;




/**
 * @author Cartesian
 * Created on July 2008
 */
public class AttributeFilterConfRef
{
    public enum FilterType
    {
        DATE("DATE"), 
        DATERANGE("DATERANGE"), 
        DATETIME("DATETIME"),
        DROPDOWN("DROPDOWN"), 
        MULTISELECT("MULTISELECT"), 
        FREETEXT("FREETEXT"),
        FREETEXT_REG("FREETEXT_REG");
        
        private String description = null;
        FilterType(String description)
        {
            this.description = description;
        }
        
        public String getDescription()
        {
            return this.description;
        }
    }

    private Integer imId;
    private AttributeRef attributeRef;
    private Integer columnNumber;
    private Integer rowNumber;
    private Boolean isSpanColumn = false;
    private FilterType filterType;
    private String dropdownValuesAsSql;
    private String dropdownValuesAsList;
    private Boolean dropdownHasNull = false;
    private Boolean dropdownHasAll = false;
    private Integer childAttributeId;
    private String linkField;
    
    
    public Integer getImId()
    {
        return imId;
    }
    public void setImId(Integer imId)
    {
        this.imId = imId;
    }
    public AttributeRef getAttributeRef()
    {
        return attributeRef;
    }
    public void setAttributeRef(AttributeRef attributeRef)
    {
        this.attributeRef = attributeRef;
    }
    public Integer getColumnNumber()
    {
        return columnNumber;
    }
    public void setColumnNumber(Integer filterColumn)
    {
        this.columnNumber = filterColumn;
    }
    public Integer getRowNumber()
    {
        return rowNumber;
    }
    public void setRowNumber(Integer filterPosition)
    {
        this.rowNumber = filterPosition;
    }
    public Boolean getIsSpanColumn()
    {
        return isSpanColumn;
    }
    public void setIsSpanColumn(Boolean isSpanColumn)
    {
        this.isSpanColumn = isSpanColumn;
    }
    public FilterType getFilterType()
    {
        return filterType;
    }
    public void setFilterType(FilterType filterType)
    {
        this.filterType = filterType;
    }
    public String getDropdownValuesAsSql()
    {
        return dropdownValuesAsSql;
    }
    public void setDropdownValuesAsSql(String dropdownValueAsSql)
    {
        this.dropdownValuesAsSql = dropdownValueAsSql;
    }
    public String getDropdownValuesAsList()
    {
        return dropdownValuesAsList;
    }
    public void setDropdownValuesAsList(String dropdownValuesAsList)
    {
        this.dropdownValuesAsList = dropdownValuesAsList;
    }
    public Boolean getDropdownHasNull()
    {
        return dropdownHasNull;
    }
    public void setDropdownHasNull(Boolean dropdownHasNull)
    {
        this.dropdownHasNull = dropdownHasNull;
    }
    public Boolean getDropdownHasAll()
    {
        return dropdownHasAll;
    }
    public void setDropdownHasAll(Boolean dropdownHasAll)
    {
        this.dropdownHasAll = dropdownHasAll;
    }
	public Integer getChildAttributeId()
	{
		return childAttributeId;
	}
	public void setChildAttributeId(Integer childAttributeId)
	{
		this.childAttributeId = childAttributeId;
	}
	public String getLinkField()
	{
		return linkField;
	}
	public void setLinkField(String linkField)
	{
		this.linkField = linkField;
	}
    
}
