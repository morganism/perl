package uk.co.cartesian.ascertain.um.persistence.dao.mrec;

import java.sql.Connection;
import java.sql.Statement;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.apache.struts.util.LabelValueBean;

import uk.co.cartesian.ascertain.um.persistence.bean.mrec.MrecChartBean;
import uk.co.cartesian.ascertain.um.persistence.dao.UmDatabaseDAOUtils;
import uk.co.cartesian.ascertain.um.persistence.factory.mrec.MrecChartDatabaseResults;
import uk.co.cartesian.ascertain.um.persistence.persister.mrec.MrecChartDatabasePersister;
import uk.co.cartesian.ascertain.um.web.action.mrec.MrecChartable;
import uk.co.cartesian.ascertain.um.web.action.mrec.MrecSet;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;
import uk.co.cartesian.ascertain.utils.persistence.DAO;
import uk.co.cartesian.ascertain.utils.persistence.Resources;
import uk.co.cartesian.ascertain.utils.persistence.exceptions.ReadException;
import uk.co.cartesian.ascertain.web.chart.AmChartPoint;

public class MrecChartDatabaseDAO extends DAO {

	protected static Logger logger = LogInitialiser.getLogger(MrecChartDatabaseDAO.class.getName());
	
	public static MrecChartDatabaseResults readChartResults(MrecChartable chartable) 
	throws ReadException 
	{
		Connection connection = null;
		Statement stmt = null;
		MrecChartDatabaseResults mrecChartDatabaseResults = null;
		try
		{
			connection = UmDatabaseDAOUtils.getAutoConnection();
			stmt = connection.createStatement();
			Resources resources = getResources(connection);
			MrecChartDatabasePersister persister = new MrecChartDatabasePersister(resources);
			mrecChartDatabaseResults = new MrecChartDatabaseResults(connection, stmt, persister.readOrderedChartResults(stmt, chartable));
		}
		catch(Exception e)
		{
			String msg = "Could not read readChartResults. " + e.getMessage();
			logger.error("MrecChartDatabaseDAO:readChartData(...) - " + msg, e);
			try {stmt.close();} catch (Exception e1) {};
			try {connection.close();} catch (Exception e1) {};
			try {mrecChartDatabaseResults.closeResults();} catch (Exception e1) {};
			throw new ReadException(msg);
		}
		return mrecChartDatabaseResults;
	}

	public static void readAllLines(MrecChartable chartable, List<LabelValueBean> mrecLines) 
	throws ReadException 
	{
		Connection connection = null;
		try
		{
			connection = UmDatabaseDAOUtils.getAutoConnection();
			Resources resources = getResources(connection);
			MrecChartDatabasePersister persister = new MrecChartDatabasePersister(resources);
			persister.readAllLineIds(chartable, mrecLines, connection);
			return;
		}
		catch(Exception e)
		{
			String msg = "Could not read readAllLines. " + e.getMessage();
			logger.error("MrecChartDatabaseDAO:readChartData(...) - " + msg, e);
			throw new ReadException(msg);
		}
		finally
		{
			try {connection.close();} catch (Exception e1) {};
		}
	}
	
	public static void buildChartData(
		final MrecChartable chartable,
		Map<Long, Integer> dateMap,
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
		Map<Integer, AmChartPoint> minInfoLine)
	throws ReadException
	{
		MrecChartDatabaseResults results;
		results = MrecChartDatabaseDAO.readChartResults(chartable);

		Long dPeriodId = null;
		Integer xid = null;
		String lineName = null;

		try
		{
			for (MrecChartBean bean : results)
			{				
				dPeriodId = bean.getPeriod();
				lineName = bean.getLineName();

				xid = dateMap.get(dPeriodId);              	
				//if the map doesn't already contain the retrieved date, add it to the map
				if (null == xid)
				{	      
					xid = dateMap.size();
			    	dateMap.put(dPeriodId, xid);
				}
				
				switch (bean.getSet()) {
					case LHS_TIME:
					case LHS_FILE:
					
						//add the element to the child line if the line name is not empty
						if (null != lineName) 
						{
		 	   				// get the date map of the child line of the left side hand
		 	   				Map<Integer, AmChartPoint> childLeftMap = leftHandSideLinesMap.get(lineName);
		    				if (childLeftMap == null) 
		    				{
		    					childLeftMap = new HashMap<Integer, AmChartPoint>();
		    					leftHandSideLinesMap.put(lineName, childLeftMap);
		    				}
		    				updateMapValue(childLeftMap, xid, bean);
						}
					
						//add the element to the main left line	        		
						updateMapValue(leftHandSideMainLine, xid, bean);
					
						break;
					case RHS_TIME:
					case RHS_FILE:
						//add the element to the child line

						if (null != lineName) 
						{
		    				// get the date map of the child line of the right side hand
		    				Map<Integer, AmChartPoint> childRightMap = rightHandSideLinesMap.get(lineName);
		    				if (childRightMap == null) 
		    				{
		    					childRightMap = new HashMap<Integer, AmChartPoint>();
		    					rightHandSideLinesMap.put(lineName, childRightMap);
		    				}
		    				updateMapValue(childRightMap, xid, bean);
						}
					
						updateMapValue(rightHandSideMainLine, xid, bean);

						break;
					case MREC:
						//add the element to the reconciliation line map	        			
						updateReconciliationLine(reconciliationLine, 
								maxCriticalLine, minCriticalLine, 
								maxSevereLine, minSevereLine, 
								maxMajorLine, minMajorLine, 
								maxMinorLine, minMinorLine, 
								maxInfoLine, minInfoLine, 
								xid, bean);
					
						break;
					default:
						throw new IllegalArgumentException();
				}
			}
		}
		finally
		{
			results.closeResults();
		}
	}

	/**
	 * Create AmChartPoint here:
	 * add the element to the line 
	 * set bullet type here
	 * NULL is used to represent a missing value 
	 */
    private static void updateMapValue(Map<Integer, AmChartPoint> lineMap, Integer xid, MrecChartBean bean)
    {
    	// create AmChartPoint - value
    	AmChartPoint amChartPoint = new AmChartPoint(bean.getValue());
    	
    	//  + bullet  - no bullets for MREC line								
    	if ( bean.getSet()!= MrecSet.MREC) {
    		amChartPoint.setBullet( bean.getIsAggregate() ? AmChartPoint.Bullet.SQUARE : AmChartPoint.Bullet.ROUND);
    	}
    		
    	// Is there already a value (could be null)
		if (lineMap.containsKey(xid)) 
		{
	    	Double memorizedValue = (Double)lineMap.get(xid).getValue();
	    	
	    	// if current value is null, then override
	    	if (memorizedValue == null)
	    	{
				lineMap.put(xid, amChartPoint);
	    	}
	    	// if new value is non-null, then sum values
	    	else if (bean.getValue() != null)
	    	{
	    		amChartPoint.setValue(bean.getValue() + memorizedValue);
				lineMap.put(xid, amChartPoint);
	    	}

	    	// otherwise current value is non-null and new value is null, so ignore
		}
		else 
		{
			// add the value for the date corresponding at this xid
			// may be null or non-null
			lineMap.put(xid, amChartPoint);
		}

    }

	/**
	 * Create AmChartPoint here:
	 * add the element to the line 
	 * set bullet type here
	 * NULL is used to represent a missing value 
	 */
    private static void updateReconciliationLine(
    		Map<Integer, AmChartPoint> lineMap,
    		Map<Integer, AmChartPoint> maxCriticalLineMap,
    		Map<Integer, AmChartPoint> minCriticalLineMap,
    		Map<Integer, AmChartPoint> maxSevereLineMap,
    		Map<Integer, AmChartPoint> minSevereLineMap,
    		Map<Integer, AmChartPoint> maxMajorLineMap,
    		Map<Integer, AmChartPoint> minMajorLineMap,
    		Map<Integer, AmChartPoint> maxMinorLineMap,
    		Map<Integer, AmChartPoint> minMinorLineMap,
    		Map<Integer, AmChartPoint> maxInfoLineMap,
    		Map<Integer, AmChartPoint> minInfoLineMap,
    		Integer xid, MrecChartBean bean)
    {
    	updateMapValue(lineMap, xid, bean);

    	// now fill in the threshold graphs
		if(bean.getMaxCriticalThreshold() != null)
			maxCriticalLineMap.put(xid, new AmChartPoint(bean.getMaxCriticalThreshold()));
		
		if(bean.getMinCriticalThreshold() != null)
			minCriticalLineMap.put(xid, new AmChartPoint(bean.getMinCriticalThreshold()));

		if(bean.getMaxSevereThreshold() != null)
			maxSevereLineMap.put(xid, new AmChartPoint(bean.getMaxSevereThreshold()));
		
		if(bean.getMinSevereThreshold() != null)
			minSevereLineMap.put(xid, new AmChartPoint(bean.getMinSevereThreshold()));

		if(bean.getMaxMajorThreshold() != null)
			maxMajorLineMap.put(xid, new AmChartPoint(bean.getMaxMajorThreshold()));
		
		if(bean.getMinMajorThreshold() != null)
			minMajorLineMap.put(xid, new AmChartPoint(bean.getMinMajorThreshold()));

		if(bean.getMaxMinorThreshold() != null)
			maxMinorLineMap.put(xid, new AmChartPoint(bean.getMaxMinorThreshold()));
		
		if(bean.getMinMinorThreshold() != null)
			minMinorLineMap.put(xid, new AmChartPoint(bean.getMinMinorThreshold()));

		if(bean.getMaxInfoThreshold() != null)
			maxInfoLineMap.put(xid, new AmChartPoint(bean.getMaxInfoThreshold()));
		
		if(bean.getMinInfoThreshold() != null)
			minInfoLineMap.put(xid, new AmChartPoint(bean.getMinInfoThreshold()));
    }
}
