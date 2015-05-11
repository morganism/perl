package uk.co.cartesian.ascertain.imm.web.form;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

/**
 * @author Cartesian
 * July 2008 
 */
public class IssueManagementForm
extends ActionForm
implements Serializable
{
    private static final long serialVersionUID = 1L;

    private String tpmKey;
    private String issueId; // issue Id (parent id) linked to function, might be null
	private String transactionId; //transaction id (i.e. what connection are we using, might be null
	private String classId;
    private Map<String, String> dateFilterValues = new HashMap<String, String>();
    private Map<String, String> dateRangeFilterValues = new HashMap<String, String>();
    private Map<String, String> dateTimeFilterValues = new HashMap<String, String>();
    private Map<String, String> dropDownFilterValues = new HashMap<String, String>();
    private Map<String, String[]> multiSelectFilterValues = new HashMap<String, String[]>();
    private Map<String, String> freeTextFilterValues = new HashMap<String, String>();
    private Map<String, String> freeTextRegExpFilterValues = new HashMap<String, String>();

    // Issue Tag is not an attribute
    private String tagId;
    
    public String getTagId() 
    {
		return tagId;
	}

	public void setTagId(String tagId) 
	{
		this.tagId = tagId;
	}

	/**
     * @return Returns the tpmRepositoryKey.
     */
    public String getTpmKey()
    {
        return tpmKey;
    }

    /**
     * @param emRepositoryKey The emRepositoryKey to set.
     */
    public void setTpmKey(String emRepositoryKey)
    {
        this.tpmKey = emRepositoryKey;
    }

    public Map<String, String> getDateFilterValues()
    {
        return dateFilterValues;
    }

    public Map<String, String> getDateRangeFilterValues()
    {
        return dateRangeFilterValues;
    }

    public Map<String, String> getDateTimeFilterValues()
    {
        return dateTimeFilterValues;
    }

    public Map<String, String> getDropDownFilterValues()
    {
        return dropDownFilterValues;
    }
    
    public Map<String, String[]> getMultiSelectFilterValues()
    {
        return multiSelectFilterValues;
    }
    
    public Map<String, String> getFreeTextFilterValues()
    {
        return freeTextFilterValues;
    }

    public Map<String, String> getFreeTextRegExpFilterValues()
    {
        return freeTextRegExpFilterValues;
    }

    public void setDateFilterValue(String key, String value)
    {
        dateFilterValues.put(key, value);
    }

    public String getDateFilterValue(String key)
    {
        return dateFilterValues.get(key);
    }

    public void setDateRangeFilterValue(String key, String value)
    {
        dateRangeFilterValues.put(key, value);
    }

    public String getDateRangeFilterValue(String key)
    {
        return dateRangeFilterValues.get(key);
    }

    public void setDateTimeFilterValue(String key, String value)
    {
        dateTimeFilterValues.put(key, value);
    }

    public String getDateTimeFilterValue(String key)
    {
        return dateTimeFilterValues.get(key);
    }

    public void setDropDownFilterValue(String key, String value)
    {
        dropDownFilterValues.put(key, value);
    }

    public void setMultiSelectFilterValue(String key, String[] value)
    {
        multiSelectFilterValues.put(key, value);
    }

    public String getDropDownFilterValue(String key)
    {
        return dropDownFilterValues.get(key);
    }

    public String[] getMultiSelectFilterValue(String key)
    {
        return multiSelectFilterValues.get(key);
    }

    public void setFreeTextFilterValue(String key, String value)
    {
        freeTextFilterValues.put(key, value);
    }

    public String getFreeTextFilterValue(String key)
    {
        return freeTextFilterValues.get(key);
    }

    public void setFreeTextRegExpFilterValue(String key, String value)
    {
        this.freeTextRegExpFilterValues.put(key, value);
    }

    public String getFreeTextRegExpFilterValue(String key)
    {
        return freeTextRegExpFilterValues.get(key);
    }
    
	public String getIssueId() 
	{
		return issueId;
	}

	public void setIssueId(String linkedIssueId) 
	{
		this.issueId = linkedIssueId;
	}

	public String getClassId() 
    {
        return classId;
    }

    public void setClassId(String classId) 
    {
        this.classId = classId;
    }
    
	public String getTransactionId()
    {
        return transactionId;
    }

    public void setTransactionId(String transactionId)
    {
        this.transactionId = transactionId;
    }

    @Override
    public void reset(ActionMapping mapping, HttpServletRequest request)
    {
        multiSelectFilterValues.clear();
    }
    
    @Override
    public void reset(ActionMapping mapping, ServletRequest request)
    {
        multiSelectFilterValues.clear();
    }
    
    public void manualReset()
    {
        dateFilterValues.clear();
        dateRangeFilterValues.clear();
        dateTimeFilterValues.clear();
        dropDownFilterValues.clear();
        multiSelectFilterValues.clear();
        freeTextFilterValues.clear();
        freeTextRegExpFilterValues.clear();
        tagId=null;
    }
}
