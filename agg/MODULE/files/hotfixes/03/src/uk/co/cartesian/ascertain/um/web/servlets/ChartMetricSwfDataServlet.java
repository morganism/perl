package uk.co.cartesian.ascertain.um.web.servlets;

import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import uk.co.cartesian.ascertain.um.persistence.dao.MetricChartDAO;
import uk.co.cartesian.ascertain.um.web.action.chartmetric.ChartableMetric;
import uk.co.cartesian.ascertain.utils.database.DBCleaner;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;
import uk.co.cartesian.ascertain.utils.persistence.DatabasePersister;
import uk.co.cartesian.ascertain.web.helpers.Utils;
import uk.co.cartesian.ascertain.web.session.ClickStream;

public class ChartMetricSwfDataServlet
extends HttpServlet
{
    private static final long serialVersionUID = 1L;

    private static Logger logger = LogInitialiser.getLogger(ChartMetricSwfDataServlet.class.getName());

    /**
     * 
     */
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
    throws IOException, ServletException
    {
        logger.debug("MetricChartDataServlet:doPost(...)");
        doGet(req, res);
    }

    /**
     * 
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse resp)
    throws IOException, ServletException
    {
        logger.debug("MetricChartDataServlet:doGet(...)");

        // Get our current values from the form (accessed via clickStream)
	    ClickStream clickStream = ClickStream.getClickStream(request.getParameter("clickStreamId"), request.getSession());
	    ChartableMetric chartForm = (ChartableMetric)clickStream.getAttribute("CHARTABLE_FORM");

        //Get the output stream and send the required XML to it
        OutputStream os = resp.getOutputStream();
        OutputStreamWriter osw = new OutputStreamWriter(os);
        
        boolean thresholds = false;
        logger.error("XXX: ChartMetricSwfDataServlet.doGet: includeThreshold=" + request.getParameter("includeThresholds"));
        if ("true".equals(request.getParameter("includeThresholds")))
        {
        	thresholds = true;
        }
        
        writeMetricDataPointToOutputStream(
            osw,
            chartForm.getFromDate(),
            chartForm.getToDate(),
        	chartForm.getMetricId(),
        	chartForm.getNodeId(),
        	chartForm.getEdgeId(),
            chartForm.getSourceTypeId(),
            chartForm.getSourceId(),
        	chartForm.getEdrTypeId(),
        	chartForm.getEdrSubTypeId(),
        	thresholds);
        osw.flush();
    }
    
    /**
     */
    private void writeMetricDataPointToOutputStream(OutputStreamWriter osw, String fromDate, String toDate,
    												  Integer metricId, Integer nodeId, Integer edgeId, Integer sourceTypeId, Integer sourceId,
    												    Integer edrTypeId, Integer edrSubTypeId, boolean thresholds)
    throws IOException, ServletException
    {
        ResultSet rs = null;
        DBCleaner cleaner = new DBCleaner();
        try
        {
            rs = MetricChartDAO.getMetricData(
            	fromDate,
            	toDate,
            	metricId,
            	nodeId,
            	edgeId,
                sourceTypeId,
                sourceId,
            	edrTypeId,
            	edrSubTypeId,
            	thresholds,
            	cleaner);

            String series = "\n\t<series>";
            String gid0 = "\n\t\t<graph gid=\"0\" title=\"Max Value\" hidden=\"True\">";
            String gid1 = "\n\t\t<graph gid=\"1\" title=\"Min Value\" hidden=\"True\">";
            String gid2 = "\n\t\t<graph gid=\"2\" title=\"Average Value\">";
            String gid3 = "\n\t\t<graph gid=\"3\" title=\"Simple Moving Average\">";
            String gid4 = "\n\t\t<graph gid=\"4\" title=\"Forecast\">";
            String gid5 = "\n\t\t<graph gid=\"5\" title=\"Critical Threshold\" hidden=\"True\" color=\"#646464\">";
            String gid6 = "\n\t\t<graph gid=\"6\" title=\"Critical Threshold\" hidden=\"True\" color=\"#646464\" visible_in_legend=\"false\">";
            String gid7 = "\n\t\t<graph gid=\"7\" title=\"Severe Threshold\" hidden=\"True\" color=\"#7D7D7D\">";
            String gid8 = "\n\t\t<graph gid=\"8\" title=\"Severe Threshold\" hidden=\"True\" color=\"#7D7D7D\" visible_in_legend=\"false\">";
            String gid9 = "\n\t\t<graph gid=\"9\" title=\"Major Threshold\" hidden=\"True\" color=\"#969696\">";
            String gid10 = "\n\t\t<graph gid=\"10\" title=\"Major Threshold\" hidden=\"True\" color=\"#969696\" visible_in_legend=\"false\">";
            String gid11 = "\n\t\t<graph gid=\"11\" title=\"Minor Threshold\" hidden=\"True\" color=\"#AFAFAF\">";
            String gid12 = "\n\t\t<graph gid=\"12\" title=\"Minor Threshold\" hidden=\"True\" color=\"#AFAFAF\" visible_in_legend=\"false\">";
            String gid13 = "\n\t\t<graph gid=\"13\" title=\"Info Threshold\" hidden=\"True\" color=\"#C8C8C8\">";
            String gid14 = "\n\t\t<graph gid=\"14\" title=\"Info Threshold\" hidden=\"True\" color=\"#C8C8C8\" visible_in_legend=\"false\">";
            int counter = 0;
            Timestamp dPeriodId;
            Double maxMetricValue, minMetricValue, averageMetricValue, movingAverageMetricValue, forecastValue, thresholdValue;
            String value;
            while(rs.next())
            {
                dPeriodId = rs.getTimestamp("d_period_id");
                series += "\n\t\t<value xid=\"" + counter + "\">" + Utils.dateToShortDateAndTimeString(new Date(dPeriodId.getTime())) + "</value>";
                
                maxMetricValue = DatabasePersister.getDouble(rs, "max_metric");
                value = maxMetricValue == null ? "" : maxMetricValue.toString();
                gid0 += "\n\t\t\t<value xid=\"" + counter + "\">" + value + "</value>";

                minMetricValue = DatabasePersister.getDouble(rs, "min_metric");
                value = minMetricValue == null ? "" : minMetricValue.toString();
                gid1 += "\n\t\t\t<value xid=\"" + counter + "\">" + value + "</value>";
                
                averageMetricValue = DatabasePersister.getDouble(rs, "average_metric");
                value = averageMetricValue == null ? "" : averageMetricValue.toString();
                gid2 += "\n\t\t\t<value xid=\"" + counter + "\">" + value + "</value>";

                movingAverageMetricValue = DatabasePersister.getDouble(rs, "moving_average");
                value = movingAverageMetricValue == null ? "" : movingAverageMetricValue.toString();
                gid3 += "\n\t\t\t<value xid=\"" + counter + "\">" + value + "</value>";

                forecastValue = DatabasePersister.getDouble(rs, "forecast_value");
                value = forecastValue == null ? "" : forecastValue.toString();
                gid4 += "\n\t\t\t<value xid=\"" + counter + "\">" + value + "</value>";
                if (thresholds)
                {
                    thresholdValue = DatabasePersister.getDouble(rs, "max_critical_threshold");
                    value = thresholdValue == null ? "" : thresholdValue.toString();
                    gid5 += "\n\t\t\t<value xid=\"" + counter + "\">" + value + "</value>";
                
                    thresholdValue = DatabasePersister.getDouble(rs, "min_critical_threshold");
                    value = thresholdValue == null ? "" : thresholdValue.toString();
                    gid6 += "\n\t\t\t<value xid=\"" + counter + "\">" + value + "</value>";
                
                    thresholdValue = DatabasePersister.getDouble(rs, "max_severe_threshold");
                    value = thresholdValue == null ? "" : thresholdValue.toString();
                    gid7 += "\n\t\t\t<value xid=\"" + counter + "\">" + value + "</value>";
                
                    thresholdValue = DatabasePersister.getDouble(rs, "min_severe_threshold");
                    value = thresholdValue == null ? "" : thresholdValue.toString();
                    gid8 += "\n\t\t\t<value xid=\"" + counter + "\">" + value + "</value>";
                
                    thresholdValue = DatabasePersister.getDouble(rs, "max_major_threshold");
                    value = thresholdValue == null ? "" : thresholdValue.toString();
                    gid9 += "\n\t\t\t<value xid=\"" + counter + "\">" + value + "</value>";
                
                    thresholdValue = DatabasePersister.getDouble(rs, "min_major_threshold");
                    value = thresholdValue == null ? "" : thresholdValue.toString();
                    gid10 += "\n\t\t\t<value xid=\"" + counter + "\">" + value + "</value>";
                
                    thresholdValue = DatabasePersister.getDouble(rs, "max_minor_threshold");
                    value = thresholdValue == null ? "" : thresholdValue.toString();
                    gid11 += "\n\t\t\t<value xid=\"" + counter + "\">" + value + "</value>";
                
                    thresholdValue = DatabasePersister.getDouble(rs, "min_minor_threshold");
                    value = thresholdValue == null ? "" : thresholdValue.toString();
                    gid12 += "\n\t\t\t<value xid=\"" + counter + "\">" + value + "</value>";
                
                    thresholdValue = DatabasePersister.getDouble(rs, "max_info_threshold");
                    value = thresholdValue == null ? "" : thresholdValue.toString();
                    gid13 += "\n\t\t\t<value xid=\"" + counter + "\">" + value + "</value>";
                
                    thresholdValue = DatabasePersister.getDouble(rs, "min_info_threshold");
                    value = thresholdValue == null ? "" : thresholdValue.toString();
                    gid14 += "\n\t\t\t<value xid=\"" + counter + "\">" + value + "</value>";
                }
                counter++;
            }
            series += "\n\t</series>";
            
            gid0 += "\n\t\t</graph>";
            gid1 += "\n\t\t</graph>";
            gid2 += "\n\t\t</graph>";
            gid3 += "\n\t\t</graph>";
            gid4 += "\n\t\t</graph>";
            if (thresholds)
            {
                gid5 += "\n\t\t</graph>";
                gid6 += "\n\t\t</graph>";
                gid7 += "\n\t\t</graph>";
                gid8 += "\n\t\t</graph>";
                gid9 += "\n\t\t</graph>";
                gid10 += "\n\t\t</graph>";
                gid11 += "\n\t\t</graph>";
                gid12 += "\n\t\t</graph>";
                gid13 += "\n\t\t</graph>";
                gid14 += "\n\t\t</graph>";
            }
            
            String response = "<chart>" + series + "\n\t<graphs>" + gid0 + gid1 + gid2 + gid3 + gid4;
            if (thresholds)
            {
                response += gid5 + gid6 + gid7 + gid8 + gid9 + gid10 + gid11 + gid12 + gid13 + gid14;
            }
            response += "\n\t</graphs>\n</chart>";
            osw.write(response);
        }
        catch (SQLException e)
        {
            logger.error("writeFileMetricDataPointToOutputStream(...) - Database error!", e);
            throw new ServletException("Database error! " + e.getMessage());
        }
        catch (IOException e)
        {
            logger.error("writeFileMetricDataPointToOutputStream(...) - IO error!", e);
            throw e;
        }
        finally
        {
        	cleaner.close();
        }
    }
}
