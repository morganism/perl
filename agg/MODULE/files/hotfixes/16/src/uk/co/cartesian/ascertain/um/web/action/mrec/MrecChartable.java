package uk.co.cartesian.ascertain.um.web.action.mrec;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.NotImplementedException;
import org.apache.struts.action.DynaActionForm;

import uk.co.cartesian.ascertain.um.persistence.bean.TimeSeriesChartable;
import uk.co.cartesian.ascertain.utils.persistence.Data;
import uk.co.cartesian.ascertain.utils.persistence.exceptions.ReadException;
import uk.co.cartesian.ascertain.web.helpers.Utils;

public class MrecChartable
extends Data
implements TimeSeriesChartable
{
    private String to;
    private Date toDate;
    private String from;
    private Date fromDate;
    private Integer mrecDefinitionId;
    private Integer edgeId;
    private String mrecType;
    private String includeThresholds;

    /**
     * 
     */
    public void setToDate(String to)
    {
        this.to = to;
        this.toDate = Utils.longDateStringToDate(to);
    }
    public void setToDate(Date to)
    {
        this.to = Utils.dateToLongString(to);
        this.toDate = to;
    }
    public String getToDate()
    {
        return this.to;
    }
    public Date getToDateAsDate()
    {
        return this.toDate;
    }
    
    /**
     * 
     */
    public void setFromDate(String from)
    {
        this.from = from;
        this.fromDate = Utils.longDateStringToDate(from);
    }
    public void setFromDate(Date from)
    {
        this.from = Utils.dateToLongString(from);
        this.fromDate = from;
    }
    public String getFromDate()
    {
        return this.from;
    }
    public Date getFromDateAsDate()
    {
        return this.fromDate;
    }
    
    
	public String[] getChartData() {
		return null;
	}
	public String getChartName() {
		// TODO Auto-generated method stub
		return null;
	}

	public void readAllChartData() throws ReadException {
		throw new NotImplementedException();		
	}

	
	public Object getDataMap() {
		// TODO Auto-generated method stub
		return null;
	}

	public Integer getMrecDefinitionId() {
		return mrecDefinitionId;
	}

	public void setMrecDefinitionId(Integer mrecDefinitionId) {
		this.mrecDefinitionId = mrecDefinitionId;
	}

	public static MrecChartable getRequestObject(HttpServletRequest request) {
		return (MrecChartable)request.getAttribute(MrecChartProcess.ATTRIBUTE_CHART_META);						
	}
	
	public static String getRequestParameters(HttpServletRequest request){
		MrecChartable mc = getRequestObject(request);
		if( mc == null )
			return "?id="+request.getParameter("id");
		
		StringBuffer rval = new StringBuffer();
		
		rval.append("?f="+mc.getFromDateAsDate().getTime()+
				"&t="+mc.getToDateAsDate().getTime()+
				"&m="+mc.getMrecDefinitionId()+
				"&id="+request.getParameter("id") );
		
		return rval.toString();
	}
	
    public Integer getEdgeId()
    {
        return edgeId;
    }

    public void setEdgeId(Integer edgeId)
    {
        this.edgeId = edgeId;
    }

    public String getMrecType()
    {
        return mrecType;
    }

    public void setMrecType(String mrecType)
    {
        this.mrecType = mrecType;
    }
    
    public String getIncludeThresholds() 
    {
		return includeThresholds;
	}
    
	public void setIncludeThresholds(String includeThresholds) 
	{
		this.includeThresholds = includeThresholds;
	}

	public static MrecChartable mrecChartableFactoryMethod(DynaActionForm dForm)
    {
        final MrecChartable chartable = new MrecChartable();
        chartable.setToDate(((String)dForm.get(MrecChartSetup.FORM_TO_DATE)));
        chartable.setFromDate(((String)dForm.get(MrecChartSetup.FORM_FROM_DATE)));
        chartable.setMrecType((String)dForm.get(MrecChartSetup.FORM_MREC_TYPE));
        if(MrecChartSetup.MREC_TYPE_FILE_VALUE.equals(chartable.getMrecType()))
        {
            chartable.setMrecDefinitionId(Integer.valueOf((String)dForm.get(MrecChartSetup.FORM_MREC_DEFINITION_ID_FILE)));
            chartable.setEdgeId((Integer)dForm.get(MrecChartSetup.FORM_EDGE_ID));
        }
        else
        {
            chartable.setMrecDefinitionId(Integer.valueOf((String)dForm.get(MrecChartSetup.FORM_MREC_DEFINITION_ID_TIME)));
            chartable.setEdgeId(null);
        }
        
        chartable.setIncludeThresholds(dForm.getString("includeThresholds"));
        
        return chartable;
    }
    
	public void setMrecTypeDecode(String mrecTypeCoded)
	{
		if (mrecTypeCoded == null) return;
		// No consistency in code on how to represent Fileset / Time based type
		// so here assume anything starts with 'f' or 'F' is a fileset mrec
		// else then Time based!
		mrecType = mrecTypeCoded.toLowerCase().startsWith("f") ?
							MrecChartSetup.MREC_TYPE_FILE_VALUE :MrecChartSetup.MREC_TYPE_TIME_VALUE;
	}
}
