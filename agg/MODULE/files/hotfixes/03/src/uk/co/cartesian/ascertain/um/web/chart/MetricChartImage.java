package uk.co.cartesian.ascertain.um.web.chart;

import java.awt.Color;
import java.awt.Image;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;

import org.apache.log4j.Logger;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.DateAxis;
import org.jfree.chart.axis.ValueAxis;
import org.jfree.chart.plot.XYPlot;
import org.jfree.data.time.Hour;
import org.jfree.data.time.TimeSeries;
import org.jfree.data.time.TimeSeriesCollection;

import uk.co.cartesian.ascertain.um.persistence.dao.MetricChartDAO;
import uk.co.cartesian.ascertain.utils.database.DBCleaner;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;
import uk.co.cartesian.ascertain.utils.persistence.DatabasePersister;

public class MetricChartImage
{
    private static Logger logger = LogInitialiser.getLogger(MetricChartImage.class.getName());
    
	static synchronized JFreeChart generateChart(
		Date fromDate,
		Date toDate,
		Integer metricDefinitionId,
		Integer nodeId,
		Integer edgeId,
        Integer sourceTypeId,
        Integer sourceId,
		Integer edrTypeId,
		Integer edrSubTypeId,
		boolean isMin,
		boolean isMax,
		boolean isAverage,
		boolean isMovingAverage,
		boolean isForecast,
		Color bgColor)
	    throws IOException
	{
		JFreeChart chart;

		TimeSeriesCollection dataset = new TimeSeriesCollection();
		DBCleaner cleaner = new DBCleaner();
        // set default if not specified
		fromDate = fromDate == null ? getDefaultFromDate() : fromDate;
		toDate = toDate == null ? getDefaultToDate() : toDate;

		try {
			ResultSet rs = MetricChartDAO.getMetricData(
			    fromDate,
			    toDate,
			    metricDefinitionId,
			    nodeId,
			    edgeId,
                sourceTypeId,
                sourceId,
			    edrTypeId,
			    edrSubTypeId,
			    false,
			    cleaner);
			
            Timestamp dPeriodId;
            Double maxMetricValue;
            Double minMetricValue;
            Double averageMetricValue;
            Double movingAverageMetricValue;
            Integer forecastMetricId;
            
            TimeSeries tsMin = new TimeSeries("Min", Hour.class);
            TimeSeries tsMax = new TimeSeries("Max", Hour.class);
            TimeSeries tsAverage = new TimeSeries("Average", Hour.class);
            TimeSeries tsMovingAverage = new TimeSeries("Moving Average", Hour.class);
            TimeSeries tsForecast = new TimeSeries("Forecast", Hour.class);
            
            while(rs.next())
            {
                dPeriodId = rs.getTimestamp("d_period_id");
                maxMetricValue = DatabasePersister.getDouble(rs, "max_metric");
                minMetricValue = DatabasePersister.getDouble(rs, "min_metric");
                averageMetricValue = DatabasePersister.getDouble(rs, "average_metric");
                movingAverageMetricValue = DatabasePersister.getDouble(rs, "moving_average");
                forecastMetricId = DatabasePersister.getInteger(rs, "forecast_metric_id");

                if (isMin && minMetricValue != null)
                {
                	tsMin.addOrUpdate(new Hour(dPeriodId), minMetricValue);
                }
                
                if (isMax && maxMetricValue != null)
                {
                	tsMax.addOrUpdate(new Hour(dPeriodId), maxMetricValue);
                }
                
                if (isAverage && averageMetricValue != null)
                {
                    tsAverage.addOrUpdate(new Hour(dPeriodId), averageMetricValue);
                }

                if (isMovingAverage && movingAverageMetricValue != null)
                {
                    tsMovingAverage.addOrUpdate(new Hour(dPeriodId), movingAverageMetricValue);
                }

                if (isForecast && forecastMetricId != null)
                {
                    Double forecastValue = MetricChartDAO.getForecastValue(
                        forecastMetricId,
                    	dPeriodId,
                    	metricDefinitionId, 
                    	nodeId,
                    	edgeId,
                        sourceId,
                		edrTypeId,
                		edrSubTypeId);
                    tsForecast.addOrUpdate(new Hour(dPeriodId), forecastValue);
                }
            }

            if (isMin)
            {
            	dataset.addSeries(tsMin);
            }
            if (isMax)
            {
            	dataset.addSeries(tsMax);
            }
            if (isAverage)
            {
            	dataset.addSeries(tsAverage);
            }
            if (isMovingAverage)
            {
            	dataset.addSeries(tsMovingAverage);
            }
            if (isForecast)
            {
            	dataset.addSeries(tsForecast);
            }
		}
		catch (Exception e)
		{
		    logger.error("MetricChartImage:generateChart(...) - Error generating chart", e);
			throw new IOException(e);
		}
		finally
		{
			cleaner.close();
		}

		chart = ChartFactory.createTimeSeriesChart(
		    null,
		    null,
		    null,
		    dataset,
		    true,
		    false,
		    false);
		
		chart.setBackgroundPaint(bgColor);

        int i;
        for (i = 0; i < 2; i++)
        {
            ValueAxis axis = ((XYPlot) chart.getPlot()).getDomainAxis(i);
            if (axis instanceof DateAxis)
            {
            	DateAxis dateAxis = (DateAxis)axis;
            	dateAxis.setMinimumDate(fromDate);
            	dateAxis.setMaximumDate(toDate);
            }
        }
		return chart;
	}
	
	public static byte[] generateImageData(
        Date fromDate,
		Date toDate,
		Integer metricDefinitionId,
		Integer nodeId,
		Integer edgeId,
        Integer sourceTypeId,
        Integer sourceId,
		Integer edrTypeId,
		Integer edrSubTypeId,
		boolean isMin,
		boolean isMax,
		boolean isAverage,
		boolean isMovingAverage,
		boolean isForecast,
		int width,
		int height,
		Color bgColor)
	{
	    byte[] image = null;
        JFreeChart chart;
        try
        {
	        chart = generateChart(
	        	fromDate,
	        	toDate,
	        	metricDefinitionId,
	        	nodeId,
	        	edgeId,
                sourceTypeId,
                sourceId,
	        	edrTypeId,
	        	edrSubTypeId,
	        	isMin,
	        	isMax,
	        	isAverage,
	        	isMovingAverage,
	        	isForecast,
	        	bgColor);

		    ByteArrayOutputStream out = new ByteArrayOutputStream();
            ChartUtilities.writeChartAsPNG(out, chart, width, height);
		    image = out.toByteArray();
		    out.close();
        }
        catch (IOException e)
        {
            logger.error("MetricChartImage:generateChart(...) - Error generating chart image", e);
        }
		return image;
	}
	
	public static Image generateImage(
        Date fromDate,
		Date toDate,
		Integer metricId,
		Integer nodeId,
		Integer edgeId,
        Integer sourceTypeId,
        Integer sourceId,
		Integer edrTypeId,
		Integer edrSubTypeId,
		boolean isMin,
		boolean isMax,
		boolean isAverage,
		boolean isMovingAverage,
		boolean isForecast,
		int width,
		int height,
		Color bgColor)
	{
        JFreeChart chart = null;
	    try {
			chart = generateChart(
				fromDate,
				toDate,
				metricId,
				nodeId,
				edgeId,
                sourceTypeId,
                sourceId,
				edrTypeId,
				edrSubTypeId,
	        	isMin,
	        	isMax,
	        	isAverage,
	        	isMovingAverage,
	        	isForecast,
	        	bgColor);
		} 
	    catch (IOException e) {
            logger.error("MetricChartImage:generateChart(...) - Error generating chart image", e);
		}
		Image img = chart.createBufferedImage(width, height);
		return img;
	}


    /**
     * Get default fromDate if not specified.
     * @return one week ago today 
     */
    protected static Date getDefaultFromDate() 
    {
    	Calendar result = Calendar.getInstance();
    	result.add(Calendar.DATE, -7);
    	return result.getTime();
    }

    /**
     * Get default toDate if not specified.
     * @return today 
     */
    protected static Date getDefaultToDate() 
    {
    	return Calendar.getInstance().getTime();
    }
}
