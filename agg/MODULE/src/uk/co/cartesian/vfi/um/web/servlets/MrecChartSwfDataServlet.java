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
import java.text.DecimalFormat;
import java.text.NumberFormat;

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
    
    Integer minIssueGraceXid = -1;
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
        
	Integer activeThresholds = 0;

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
			
			Long issueGraceCutoff = new Long (MrecChartDatabaseDAO.readIssueGracePeriod(chartable));
			int isIssueGrace = 0;

			activeThresholds = new Integer (MrecChartDatabaseDAO.readActiveThreshold(chartable));

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
				if (period > issueGraceCutoff && isIssueGrace == 0 )
				{
					isIssueGrace = 1;
					seriesValue.setAttribute("event_start","issue_grace");
					seriesValue.setAttribute("event_color","#9a9a9a");
	//				seriesValue.setAttribute("show","true");
					seriesValue.setAttribute("event_description","The greyed out area of the chart indicates a grace period where we are not expecting reconciliations to match because of latency differences between the data sources. If thresholds are active, issues will not be raised for this period.");
					minIssueGraceXid = dateMap.get(period);
				}
	
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

		buildGraphsNode(chartable, leftHandSideLinesMap, rightHandSideLinesMap, 
				leftHandSideMainLine, rightHandSideMainLine,
				reconciliationLine, 
				maxCriticalLine, minCriticalLine,
				maxSevereLine, minSevereLine,
				maxMajorLine, minMajorLine,
				maxMinorLine, minMinorLine,
				maxInfoLine, minInfoLine, graphs, request, activeThresholds);

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
			MrecChartable chartable,
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
			HttpServletRequest request,
			Integer activeThresholds) {
		
        //children lines are hidden by default on the chart
        boolean hidden = true;
        boolean doHide = false;
        
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

		if (chartable.getDisplayType().equalsIgnoreCase("percentage")) {
			doHide = true;
		}

		Element leftHandSideMainLineGraph = buildGraph(leftHandSideMainLine, iSideTitle, -1, "#0033FF", doHide, true, chartable);
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
	    		graphs.addContent(buildGraph(aLineMap, lineName, graphId, color, hidden, true, chartable));
	    		graphId--;
	    	}	
		}
    	    	
		//the main right hand side line always has graphId = 1;
		Element rightHandSideMainLineGraph = buildGraph(rightHandSideMainLine, jSideTitle, 1, "#FF0000", doHide, true, chartable);
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
        		graphs.addContent(buildGraph(aLineMap, lineName, graphId, color, hidden, true, chartable));
        		graphId++;
        	}	
    	}

	String recLineName = "Reconciliation";
	if (chartable.getReconciliationType().equalsIgnoreCase("forecast")) {
		recLineName = "Forecast Reconciliation";
	}
	// the reconciliation line has always graphId = 0
    	graphs.addContent(buildGraph(reconciliationLine, recLineName, 0, "#000000", chartable));
    	
	if (chartable.getIncludeThresholds().equalsIgnoreCase("true") && activeThresholds > 0) {

 	   	// the threshold lines start at graphId = 105
 	   	int graphId = 105;
  	  	graphs.addContent(buildGraph(maxCriticalLine, "Critical Threshold", graphId++, "#646464", true, true, chartable));
  	  	graphs.addContent(buildGraph(minCriticalLine, "Critical Threshold", graphId++, "#646464", true, false, chartable));
   	 	graphs.addContent(buildGraph(maxSevereLine, "Severe Threshold", graphId++, "#7D7D7D", true, true, chartable));
   	 	graphs.addContent(buildGraph(minSevereLine, "Severe Threshold", graphId++, "#7D7D7D", true, false, chartable));
   	 	graphs.addContent(buildGraph(maxMajorLine, "Major Threshold", graphId++, "#969696", true, true, chartable));
   	 	graphs.addContent(buildGraph(minMajorLine, "Major Threshold", graphId++, "#969696", true, false, chartable));
   	 	graphs.addContent(buildGraph(maxMinorLine, "Minor Threshold", graphId++, "#AFAFAF", true, true, chartable));
   	 	graphs.addContent(buildGraph(minMinorLine, "Minor Threshold", graphId++, "#AFAFAF", true, false, chartable));
   	 	graphs.addContent(buildGraph(maxInfoLine, "Info Threshold", graphId++, "#C8C8C8", true, true, chartable));
    		graphs.addContent(buildGraph(minInfoLine, "Info Threshold", graphId++, "#C8C8C8", true, false, chartable));
	}
	}
    
    
    private Element buildGraph(
    		Map<Integer, AmChartPoint> leftHandSideMainLine,
    		String lineName,
    		int graphId,
    		String color,
		MrecChartable chartable
    		) 
    {    	
    	return buildGraph(leftHandSideMainLine, lineName, graphId, color, false, true, chartable);
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
    		boolean visibleInLegend,
		MrecChartable chartable
    		) 
    {
    	Element newGraph = new Element("graph");
    	if (null != lineName) 
    	{
    		newGraph.setAttribute("title", lineName);
    	}
    	newGraph.setAttribute("gid", graphId+"");
    	newGraph.setAttribute("color", color);
	newGraph.setAttribute("balloon_text", "<b>{description}</b>");
    	if (hidden)
    	{
    		newGraph.setAttribute("hidden", "true");
    	}
    	if (false == visibleInLegend)
    	{
    		newGraph.setAttribute("visible_in_legend", "false");
    	}
 
	NumberFormat formatter;
	NumberFormat formatterPerc;
	formatter = new DecimalFormat("#,###,###.#");
	formatterPerc = new DecimalFormat("#,###,###.#'%'");
    	Collection<Integer> xids = leftHandSideMainLine.keySet();
    	Iterator<Integer> xidsIterator = xids.iterator();
    	while (xidsIterator.hasNext()) 
    	{
    		Integer xid = xidsIterator.next();
    		AmChartPoint point = leftHandSideMainLine.get(xid);
    		
        	Element mrec = new Element("value");

		Boolean isIssue = false;

        	mrec.setAttribute("xid", xid.toString());
        	// set the point's bullet type
        	if (point.getBullet()!=null && point.getBullet() != AmChartPoint.Bullet.NONE) {
        		mrec.setAttribute("bullet", point.getBullet().getName());
			mrec.setAttribute("bulletSize","20");
			if (lineName.equals("Reconciliation") || lineName.equals("Forecast Reconciliation")) {
				mrec.setAttribute("bullet_size","9");
				mrec.setAttribute("bullet_color","#fdd912");
				isIssue = true;
			}
        	}

		String issueGraceDesc = new String("");

		if (xid > minIssueGraceXid && (lineName.equals("Reconciliation") || lineName.equals("Forecast Reconciliation")) && !isIssue ) {
			issueGraceDesc = " (In Grace Period)";
		}

        	//set the value of mrec into the 'value' node
        	if (point.getValue() != null) {
        		mrec.addContent(point.getValue().toString());
			if (chartable.getDisplayType().equalsIgnoreCase("percentage") ) {
				if (isIssue) {
					mrec.setAttribute("description",formatterPerc.format(point.getValue()) + "<br>Issue!</br>");
				} 
				else {
					mrec.setAttribute("description",formatterPerc.format(point.getValue()) + issueGraceDesc);
				}
			}
			else {	
				if (isIssue) {
					mrec.setAttribute("description",formatter.format(point.getValue()) + "<br>Issue!</br>");
				}
				else {
					mrec.setAttribute("description",formatter.format(point.getValue()) + issueGraceDesc);
				}
			}
        	} else {
        		mrec.addContent("");
			mrec.setAttribute("description","");
        	}
        	// add the 'value' node to the 'graph' node
        	newGraph.addContent(mrec);

    	}
    	return newGraph;
    }
        
}
