package uk.co.cartesian.ascertain.imm.web.filters;

import java.util.ArrayList;
import java.util.List;

import uk.co.cartesian.ascertain.imm.db.dao.beans.AttributeFilterConfRef;
import uk.co.cartesian.ascertain.utils.parse.AscertainLabelValueBean;

/**
 * @author imortimer
 * Created on 29-Aug-2007
 */
public class DropDownFilter
extends IMMFilter
{
    private String value = null;
    private List<AscertainLabelValueBean> options = new ArrayList<AscertainLabelValueBean>();
    
    /**
     * 
     */
    public String getTypeDescription()
    {
        return AttributeFilterConfRef.FilterType.DROPDOWN.getDescription();
    }
    
    /**
     * @return Returns the value.
     */
    public String getValue()
    {
        return value;
    }
    /**
     * @param value The value to set.
     */
    public void setValue(String value)
    {
        this.value = value;
    }
    
    /**
     * @return Returns the values.
     */
    public List<AscertainLabelValueBean> getOptions()
    {
        return options;
    }
    /**
     * @param options The values to set.
     */
    public void addOption(AscertainLabelValueBean lvb)
    {
        this.options.add(lvb);
    }
    /**
     * @param options The values to set.
     */
    public void addOption(String label, String value)
    {
        this.options.add(new AscertainLabelValueBean(label, value));
    }
    /**
     * @param values The values to set.
     */
    public void addOptions(List<AscertainLabelValueBean> values)
    {
        this.options.addAll(values);
    }
    /**
     * @param options The values to set.
     */
    public void setOptions(List<AscertainLabelValueBean> lvbs)
    {
        this.options = lvbs;
    }
}
