package uk.co.cartesian.ascertain.um.web.servlets;

import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.DynaActionForm;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.output.XMLOutputter;

import uk.co.cartesian.ascertain.um.persistence.dao.mrec.MrecChartDatabaseDAO;
import uk.co.cartesian.ascertain.um.web.action.mrec.MrecChartable;
import uk.co.cartesian.ascertain.um.web.chart.MRecChartImage;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;
import uk.co.cartesian.ascertain.web.chart.AmChartPoint;
import uk.co.cartesian.ascertain.web.session.bean.AscertainSessionUser;

/**
 * Servlet to set up the chart configuration for Metric Reconciliation.
 *  
 * @author smorstabilini
 *
 */
public class MrecChartSwfDataServlet
extends HttpServlet
{
    private static final long serialVersionUID = 1L;

    private static Logger logger = LogInitialiser.getLogger(MrecChartSwfDataServlet.class.getName());

	public static final String[] RED_COLORS = new String[]{"#FF6666", "#FFAAAA", "#FFCCCC", "#FFEEEE", "#FF4200", "#FF7200", "#FFA200", "#FFD100", "#FFFF00", "#FF0000",};
	public static final String[] BLUE_COLORS = new String[]{"#6666FF", "#DFDFFF", "#9FE6FF", "#66FFFF", "#66FFD1", "#00FF00", "#0000FF"};
    
    /**
     * 
     */
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
    throws IOException, ServletException
    {
        logger.debug("MrecChartSwfDataServlet:doPost(...)");
        doGet(req, res);
    }

    /**
     * 
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse resp)
    throws IOException, ServletException
    {
        logger.debug("MrecChartSwfDataServlet:doGet(...)");
        
        //Get our current values from the form
        DynaActionForm form = (DynaActionForm)request.getSession().getAttribute("mrecChartDform");
        
		final MrecChartable chartable = MrecChartable.mrecChartableFactoryMethod((DynaActionForm)form);
		
		// this map will be used to create the elements into the "series" node of the xml source for the graph.
        // The key is a long representing a date, the value is an integer representing the xid element in the "series" nodes		
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
        
        //jdom objects
        Document mrecSource = new Document();
        Element series = new Element("series");
        Element chartEl = new Element("chart");      
        Element graphs = new Element("graphs");
        chartEl.addContent(series);
        chartEl.addContent(graphs);            
        mrecSource.setRootElement(chartEl);
        
        try {
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

			java.text.SimpleDateFormat dateFormatter = new java.text.SimpleDateFormat("dd MMM HH:mm");
			Element seriesValue = null;
			
  	  		Set<Long> periods = dateMap.keySet();
  	  		List<Long> dates = new ArrayList<Long>();
    		Iterator<Long> periodsIterator;

    		// Sort the dates as the hash map will have jumbled them all up
    		periodsIterator = periods.iterator();
    		while (periodsIterator.hasNext()) 
    		{
    			dates.add(periodsIterator.next());
    		}
    		Collections.sort(dates);

    		periodsIterator = dates.iterator();
    		while (periodsIterator.hasNext()) 
    		{
    			Long period = periodsIterator.next();
				seriesValue = new Element("value");
				seriesValue.setAttribute("xid", dateMap.get(period).toString());
				String date = dateFormatter.format(new java.util.Date(period));
				seriesValue.addContent(date);            		
		    	series.addContent(seriesValue);
    		}

			// insert a date to avoid an empty "series" node
			if (series.getChildren().size() == 0) {
				seriesValue = new Element("value");
				seriesValue.addContent(dateFormatter.format(new java.util.Date()));
				series.addContent(seriesValue);
			}
		} catch (Exception e) {
			logger.warn("MrecChartSeriesFactory:getSeriesCollection(...) - ", e);
		}	

		buildGraphsNode(leftHandSideLinesMap, rightHandSideLinesMap, 
				leftHandSideMainLine, rightHandSideMainLine,
				reconciliationLine, 
				maxCriticalLine, minCriticalLine,
				maxSevereLine, minSevereLine,
				maxMajorLine, minMajorLine,
				maxMinorLine, minMinorLine,
				maxInfoLine, minInfoLine, graphs, request);

        OutputStream os = resp.getOutputStream();
        OutputStreamWriter osw = new OutputStreamWriter(os);
        XMLOutputter xmlOutputter = new XMLOutputter();            
        osw.write(xmlOutputter.outputString(mrecSource));
        osw.flush();

    }

    
    /**
     * build the <graphs> node with the left hand side main line, the left hand side children line (if more then 1),
     * the right hand side main line, the right hand side children line (if more then 1) and the metric reconciliation
     * line.
     * @param leftHandSideLinesMap
     * @param rightHandSideLinesMap
     * @param leftHandSideMainLine
     * @param rightHandSideMainLine
     * @param reconciliationLine
     * @param graphs
     */
	private void buildGraphsNode(
			Map<String, Map<Integer, AmChartPoint>> leftHandSideLinesMap,
			Map<String, Map<Integer, AmChartPoint>> rightHandSideLinesMap,
			Map<Integer, AmChartPoint> leftHandSideMainLine,
			Map<Integer, AmChartPoint> rightHandSideMainLine,
			Map<Integer, AmChartPoint> reconciliationLine, 
			Map<Integer, AmChartPoint> maxCriticalLine,
			Map<Integer, AmChartPoint> minCriticalLine,
			Map<Integer, AmChartPoint> maxSevereLine,
			Map<Integer, AmChartPoint> minSevereLine,
			Map<Integer, AmChartPoint> maxMajorLine,
			Map<Integer, AmChartPoint> minMajorLine,
			Map<Integer, AmChartPoint> maxMinorLine,
			Map<Integer, AmChartPoint> minMinorLine,
			Map<Integer, AmChartPoint> maxInfoLine,
			Map<Integer, AmChartPoint> minInfoLine,
			Element graphs,
			HttpServletRequest request) {
		
        //children lines are hidden by default on the chart
        boolean hidden = true;
        
		//the main left hand side line always has graphId = -1;
        String iSideTitle = MRecChartImage.LEFT_HAND_SIDE;
        try
        {
        	iSideTitle = ResourceBundle.getBundle("ApplicationResource", AscertainSessionUser.getLocale(request)).getString("um.metric_reconciliation.label.i_side");
        }
        catch (Exception e)
        {
        }
        
		String jSideTitle = MRecChartImage.RIGHT_HAND_SIDE;
		try
		{
			jSideTitle = ResourceBundle.getBundle("ApplicationResource", AscertainSessionUser.getLocale(request)).getString("um.metric_reconciliation.label.j_side");
		}
		catch (Exception e)
		{
		}

		Element leftHandSideMainLineGraph = buildGraph(leftHandSideMainLine, iSideTitle, -1, "#0033FF");
		leftHandSideMainLineGraph.setAttribute("line_width", "1");
		graphs.addContent(leftHandSideMainLineGraph);
		
		if (leftHandSideLinesMap.size() > 0) {
			Collection<String> leftHandSideLinesName = leftHandSideLinesMap.keySet();
	    	Iterator<String> lhsLinesIterator = leftHandSideLinesName.iterator();
	    	int graphId = -2;
	    	String color = null;
	    	while (lhsLinesIterator.hasNext()) 
	    	{
	    		String lineName = lhsLinesIterator.next();
	        	Map<Integer, AmChartPoint> aLineMap = leftHandSideLinesMap.get(lineName);
	        	color = BLUE_COLORS[-graphId % BLUE_COLORS.length];
	        	// the main left hand side line has graphid = -1, the first child has graphId = -2, etc...
	    		graphs.addContent(buildGraph(aLineMap, lineName, graphId, color, hidden, true));
	    		graphId--;
	    	}	
		}
    	    	
		//the main right hand side line always has graphId = 1;
		Element rightHandSideMainLineGraph = buildGraph(rightHandSideMainLine, jSideTitle, 1, "#FF0000");
		rightHandSideMainLineGraph.setAttribute("line_width", "1");
		graphs.addContent(rightHandSideMainLineGraph);
		
    	if (leftHandSideLinesMap.size() > 0) 
    	{
    		Collection<String> rightHandSideLinesName = rightHandSideLinesMap.keySet();
        	Iterator<String> rhsLinesIterator = rightHandSideLinesName.iterator();
        	int graphId = 2;
        	String color = null;
        	while (rhsLinesIterator.hasNext()) 
        	{
        		String lineName = rhsLinesIterator.next();
            	Map<Integer, AmChartPoint> aLineMap = rightHandSideLinesMap.get(lineName);
            	color = RED_COLORS[graphId % RED_COLORS.length];
            	// the main right hand side line has graphid = 1, the first child has graphId = 2, etc...
        		graphs.addContent(buildGraph(aLineMap, lineName, graphId, color, hidden, true));
        		graphId++;
        	}	
    	}

		// the reconciliation line has always graphId = 0
    	graphs.addContent(buildGraph(reconciliationLine, "Reconciliation", 0, "#000000"));
    	
    	// the threshold lines start at graphId = 105
    	int graphId = 105;
    	graphs.addContent(buildGraph(maxCriticalLine, "Critical Threshold", graphId++, "#646464", true, true));
    	graphs.addContent(buildGraph(minCriticalLine, "Critical Threshold", graphId++, "#646464", true, false));
    	graphs.addContent(buildGraph(maxSevereLine, "Severe Threshold", graphId++, "#7D7D7D", true, true));
    	graphs.addContent(buildGraph(minSevereLine, "Severe Threshold", graphId++, "#7D7D7D", true, false));
    	graphs.addContent(buildGraph(maxMajorLine, "Major Threshold", graphId++, "#969696", true, true));
    	graphs.addContent(buildGraph(minMajorLine, "Major Threshold", graphId++, "#969696", true, false));
    	graphs.addContent(buildGraph(maxMinorLine, "Minor Threshold", graphId++, "#AFAFAF", true, true));
    	graphs.addContent(buildGraph(minMinorLine, "Minor Threshold", graphId++, "#AFAFAF", true, false));
    	graphs.addContent(buildGraph(maxInfoLine, "Info Threshold", graphId++, "#C8C8C8", true, true));
    	graphs.addContent(buildGraph(minInfoLine, "Info Threshold", graphId++, "#C8C8C8", true, false));
	}
    
    
    private Element buildGraph(
    		Map<Integer, AmChartPoint> leftHandSideMainLine,
    		String lineName,
    		int graphId,
    		String color
    		) 
    {    	
    	return buildGraph(leftHandSideMainLine, lineName, graphId, color, false, true);
    }
    
    
    /**
     * Build the xml node representing a line
     * @param leftHandSideMainLine the map with the metric values
     * @param lineName
     * @param graphId
     * @param color
     * @param bullet 
     * @param hidden set it to true to hide the line in the chart; the user can activate the line clicking on the chart legend.
     * @return
     */
    private Element buildGraph(
    		Map<Integer, AmChartPoint> leftHandSideMainLine,
    		String lineName,
    		int graphId,
    		String color,
    		boolean hidden,
    		boolean visibleInLegend
    		) 
    {
    	Element newGraph = new Element("graph");
    	if (null != lineName) 
    	{
    		newGraph.setAttribute("title", lineName);
    	}
    	newGraph.setAttribute("gid", graphId+"");
    	newGraph.setAttribute("color", color);
    	if (hidden)
    	{
    		newGraph.setAttribute("hidden", "true");
    	}
    	if (false == visibleInLegend)
    	{
    		newGraph.setAttribute("visible_in_legend", "false");
    	}
    
    	Collection<Integer> xids = leftHandSideMainLine.keySet();
    	Iterator<Integer> xidsIterator = xids.iterator();
    	while (xidsIterator.hasNext()) 
    	{
    		Integer xid = xidsIterator.next();
    		AmChartPoint point = leftHandSideMainLine.get(xid);
    		
        	Element mrec = new Element("value");
        	mrec.setAttribute("xid", xid.toString());
        	// set the point's bullet type
        	if (point.getBullet()!=null && point.getBullet() != AmChartPoint.Bullet.NONE) {
        		mrec.setAttribute("bullet", point.getBullet().getName());
        	}
        	//set the value of mrec into the 'value' node
        	if (point.getValue() != null) {
        		mrec.addContent(point.getValue().toString());
        	} else {
        		mrec.addContent("");
        	}
        	// add the 'value' node to the 'graph' node
        	newGraph.addContent(mrec);

    	}
    	return newGraph;
    }
        
}
