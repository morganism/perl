package uk.co.cartesian.ascertain.um.web.chart;

import java.awt.Color;
import java.awt.Image;
import java.awt.Paint;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.DateAxis;
import org.jfree.chart.axis.ValueAxis;
import org.jfree.chart.plot.XYPlot;
import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer;
import org.jfree.data.time.Hour;
import org.jfree.data.time.TimeSeries;
import org.jfree.data.time.TimeSeriesCollection;

import uk.co.cartesian.ascertain.um.persistence.bean.mrec.MrecDefinitionRef;
import uk.co.cartesian.ascertain.um.persistence.dao.mrec.MrecChartDatabaseDAO;
import uk.co.cartesian.ascertain.um.persistence.dao.mrec.MrecDefinitionRefDatabaseDAO;
import uk.co.cartesian.ascertain.um.web.action.mrec.MrecChartable;
import uk.co.cartesian.ascertain.um.web.servlets.MrecChartSwfDataServlet;
import uk.co.cartesian.ascertain.utils.persistence.exceptions.ReadException;
import uk.co.cartesian.ascertain.web.chart.AmChartPoint;

public class MRecChartImage
{
	public static final String LEFT_HAND_SIDE = "i Side";
	public static final String RIGHT_HAND_SIDE = "j Side";
	public static final String RECONCILIATION = "Reconciliation";
	
	public static final int SHOW_DETAILS_NONE = 0;
	public static final int SHOW_DETAILS_ALL = 1;
	public static final int SHOW_DETAILS_REC = 2;
	
	public static synchronized JFreeChart generateChart(
		Date fromDate,
		Date toDate,
		Integer mrecDefinitionId,
		Integer edgeId,
		int showDetails,
		Color bgColor)
	{
		ArrayList<Paint> linePaints = new ArrayList<Paint>();
		MrecChartable chartable = new MrecChartable();
		int i;

		TimeSeriesCollection dataset = null;
		try
		{
			chartable.setFromDate(fromDate);
			chartable.setToDate(toDate);
			chartable.setMrecDefinitionId(mrecDefinitionId);
			chartable.setEdgeId(edgeId);

			// determine type of mrec
			MrecDefinitionRef mrecDefRef = new MrecDefinitionRef(chartable.getMrecDefinitionId());
			MrecDefinitionRefDatabaseDAO.read(mrecDefRef);
			chartable.setMrecTypeDecode(mrecDefRef.getMrecType());
			
			Map<Long, Integer> dateMap = new HashMap<Long, Integer>();
	
	        Map<String, Map<Integer, AmChartPoint>> leftHandSideLinesMap = new HashMap<String, Map<Integer, AmChartPoint>>();
	        Map<String, Map<Integer, AmChartPoint>> rightHandSideLinesMap = new HashMap<String, Map<Integer, AmChartPoint>>();
	
	        Map<Integer, AmChartPoint> leftHandSideMainLine = new HashMap<Integer, AmChartPoint>();
	        Map<Integer, AmChartPoint> rightHandSideMainLine = new HashMap<Integer, AmChartPoint>();
	        Map<Integer, AmChartPoint> reconciliationLine = new HashMap<Integer, AmChartPoint>();
	        Map<Integer, AmChartPoint> maxCriticalLine = new HashMap<Integer, AmChartPoint>();
	        Map<Integer, AmChartPoint> minCriticalLine = new HashMap<Integer, AmChartPoint>();
	        Map<Integer, AmChartPoint> maxSevereLine = new HashMap<Integer, AmChartPoint>();
	        Map<Integer, AmChartPoint> minSevereLine = new HashMap<Integer, AmChartPoint>();
	        Map<Integer, AmChartPoint> maxMajorLine = new HashMap<Integer, AmChartPoint>();
	        Map<Integer, AmChartPoint> minMajorLine = new HashMap<Integer, AmChartPoint>();
	        Map<Integer, AmChartPoint> maxMinorLine = new HashMap<Integer, AmChartPoint>();
	        Map<Integer, AmChartPoint> minMinorLine = new HashMap<Integer, AmChartPoint>();
	        Map<Integer, AmChartPoint> maxInfoLine = new HashMap<Integer, AmChartPoint>();
	        Map<Integer, AmChartPoint> minInfoLine = new HashMap<Integer, AmChartPoint>();
	        Map<Integer, Date> dates = new HashMap<Integer, Date>();
	
			dataset = new TimeSeriesCollection();
			MrecChartDatabaseDAO.buildChartData(
					chartable,
					dateMap,
					leftHandSideLinesMap,
					rightHandSideLinesMap,
					leftHandSideMainLine,
					rightHandSideMainLine,
					reconciliationLine,
					maxCriticalLine, minCriticalLine,
					maxSevereLine, minSevereLine,
					maxMajorLine, minMajorLine,
					maxMinorLine, minMinorLine,
					maxInfoLine, minInfoLine);

    		Iterator<Long> periodsIterator = dateMap.keySet().iterator();
    		while (periodsIterator.hasNext()) 
    		{
    			Long period = periodsIterator.next();
    			Integer id = dateMap.get(period);
    			dates.put(id, new Date(period));
    		}

			dataset.addSeries(buildTimeSeries(RECONCILIATION, reconciliationLine, dates));
			linePaints.add(Color.BLACK);

    		if (showDetails != SHOW_DETAILS_REC)
    		{
			    dataset.addSeries(buildTimeSeries(LEFT_HAND_SIDE, leftHandSideMainLine, dates));
			    linePaints.add(Color.BLUE);
			    dataset.addSeries(buildTimeSeries(RIGHT_HAND_SIDE, rightHandSideMainLine, dates));
			    linePaints.add(Color.RED);
    		}

    		if (showDetails == SHOW_DETAILS_ALL)
    		{
			    Iterator<String> itStr;
			    Color col;
    			itStr = leftHandSideLinesMap.keySet().iterator();
    			i = 0;
		    	while (itStr.hasNext())
			    {
			    	String str = itStr.next();
  			        dataset.addSeries(buildTimeSeries(str, leftHandSideLinesMap.get(str), dates));
  			        col = Color.decode(MrecChartSwfDataServlet.RED_COLORS[i % MrecChartSwfDataServlet.RED_COLORS.length]);
  			        linePaints.add(col);
  			        i++;
		    	}

			    itStr = rightHandSideLinesMap.keySet().iterator();
			    i = 0;
			    while (itStr.hasNext())
		    	{
			    	String str = itStr.next();
  			        dataset.addSeries(buildTimeSeries(str, rightHandSideLinesMap.get(str), dates));
  			        col = Color.decode(MrecChartSwfDataServlet.BLUE_COLORS[i % MrecChartSwfDataServlet.BLUE_COLORS.length]);
  			        linePaints.add(col);
  			        i++;
	    		}
    		}
		} catch (ReadException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		JFreeChart chart;
		chart = ChartFactory.createTimeSeriesChart(
		    null,
		    null,
		    null,
		    dataset,
		    true,
		    false,
		    false);
		
		XYPlot plot = (XYPlot)chart.getPlot();
		XYLineAndShapeRenderer renderer = (XYLineAndShapeRenderer)plot.getRenderer();
		chart.setBackgroundPaint(bgColor);
        
        for (i = 0; i < linePaints.size(); i++)
        {
        	renderer.setSeriesPaint(i, linePaints.get(i));
        }

        // Force the dates to those requested
        for (i = 0; i < 2; i++)
        {
            ValueAxis axis = plot.getDomainAxis(i);
            if (axis instanceof DateAxis)
            {
            	DateAxis dateAxis = (DateAxis)axis;
            	dateAxis.setMinimumDate(fromDate);
            	dateAxis.setMaximumDate(toDate);
            }
        }

		return chart;
	}
	
	private static TimeSeries buildTimeSeries(String title, Map<Integer, AmChartPoint> data, Map<Integer, Date> dates)
	{
		TimeSeries ts = new TimeSeries(title, Hour.class);
		Iterator<Integer> it;
		it = data.keySet().iterator();

		while (it.hasNext())
		{
			Integer i = it.next();
			if (data.get(i).getValue() != null ) {
 	 			ts.add(new Hour(dates.get(i)), data.get(i).getValue());
			}
		}
		
		return ts;
	}

	public static byte[] generateImageData(
		Date fromDate,
		Date toDate,
		Integer mrecDefinitionId,
		Integer edgeId,
		int showDetails,
		int width,
		int height,
		Color bgColor)
	{
	    byte[] image = null;
        try
        {
            JFreeChart chart = generateChart(
            	fromDate,
            	toDate,
            	mrecDefinitionId,
            	edgeId,
            	showDetails,
            	bgColor);
 
		    ByteArrayOutputStream out = new ByteArrayOutputStream();
            ChartUtilities.writeChartAsPNG(out, chart, width, height);
		    image = out.toByteArray();
		    out.close();
        }
        catch (IOException e)
        {
	        // TODO Auto-generated catch block
	        e.printStackTrace();
        }
		return image;
	}
	
	public static Image generateImage(
		Date fromDate,
		Date toDate,
		Integer mrecDefinitionId,
		Integer edgeId,
		int showDetails,
		int width,
		int height,
		Color bgColor)
	{
        JFreeChart chart = generateChart(
        	fromDate,
        	toDate,
        	mrecDefinitionId,
    		edgeId,
        	showDetails,
        	bgColor);
		Image img = chart.createBufferedImage(width, height);
		return img;
	}
}
