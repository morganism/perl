package uk.co.cartesian.ascertain.um.persistence.factory.mrec;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ConcurrentModificationException;
import java.util.Iterator;

import org.apache.commons.lang.NotImplementedException;
import org.apache.log4j.Logger;

import uk.co.cartesian.ascertain.um.persistence.bean.mrec.MrecChartBean;
import uk.co.cartesian.ascertain.um.web.action.mrec.MrecSet;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;


//TODO create super class or interface to abstract this?

public class MrecChartDatabaseResults implements Iterable<MrecChartBean>{

	private static final String LINE_NAME = "MREC_LINE_NAME";
	private static final String MREC = "MREC";
	private static final String LINE_TYPE = "MREC_LINE_TYPE";
	private static final String PERIOD_ID = "D_PERIOD_ID";
	private static final String IS_AGGREGATE = "IS_AGGREGATE";
	private static final String MAX_CRITICAL_THRESHOLD = "MAX_CRITICAL_THRESHOLD";
	private static final String MIN_CRITICAL_THRESHOLD = "MIN_CRITICAL_THRESHOLD";
	private static final String MAX_SEVERE_THRESHOLD = "MAX_SEVERE_THRESHOLD";
	private static final String MIN_SEVERE_THRESHOLD = "MIN_SEVERE_THRESHOLD";
	private static final String MAX_MAJOR_THRESHOLD = "MAX_MAJOR_THRESHOLD";
	private static final String MIN_MAJOR_THRESHOLD = "MIN_MAJOR_THRESHOLD";
	private static final String MAX_MINOR_THRESHOLD = "MAX_MINOR_THRESHOLD";
	private static final String MIN_MINOR_THRESHOLD = "MIN_MINOR_THRESHOLD";
	private static final String MAX_INFO_THRESHOLD = "MAX_INFO_THRESHOLD";
	private static final String MIN_INFO_THRESHOLD = "MIN_INFO_THRESHOLD";

	private static Logger logger = LogInitialiser.getLogger(MrecChartDatabaseResults.class.getName());
		
	private final ResultSet results;
	private final Connection connection;
	private final Statement stmt;

	public MrecChartDatabaseResults( Connection connection, Statement stmt, ResultSet results){
		this.results = results;
		this.connection = connection;
		this.stmt = stmt;
	}
	
	public void closeResults(){
		try {
			if (results != null) results.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}		
		try {
			if (stmt != null) stmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}		
		try {
			if (connection != null) connection.close();
		} catch ( Exception e ){
			e.printStackTrace();
		}
	}
	
	private MrecChartBean readFromResults() 
	throws SQLException
	{
		MrecChartBean mcb = new MrecChartBean();
		
		mcb.setIsAggregate( "Y".equalsIgnoreCase(results.getString(IS_AGGREGATE)) ? true : false  );
		mcb.setPeriod(new Long( results.getTimestamp(PERIOD_ID).getTime() ));
		mcb.setSet(MrecSet.getMrecSet(results.getString(LINE_TYPE)));
		{
			// don't separate/reorder
			mcb.setValue(new Double(results.getDouble(MREC)));
			// null is used to indicate 'missing value or not-a-value'
			if (results.wasNull()) {mcb.setValue(null);} 
		}
		mcb.setLineName(results.getString(LINE_NAME));

		mcb.setMaxCriticalThreshold(results.getDouble(MAX_CRITICAL_THRESHOLD));
		if (results.wasNull()) {mcb.setMaxCriticalThreshold(null);} 
		mcb.setMinCriticalThreshold(results.getDouble(MIN_CRITICAL_THRESHOLD));
		if (results.wasNull()) {mcb.setMinCriticalThreshold(null);} 
		mcb.setMaxSevereThreshold(results.getDouble(MAX_SEVERE_THRESHOLD));
		if (results.wasNull()) {mcb.setMaxSevereThreshold(null);} 
		mcb.setMinSevereThreshold(results.getDouble(MIN_SEVERE_THRESHOLD));
		if (results.wasNull()) {mcb.setMinSevereThreshold(null);} 
		mcb.setMaxMajorThreshold(results.getDouble(MAX_MAJOR_THRESHOLD));
		if (results.wasNull()) {mcb.setMaxMajorThreshold(null);} 
		mcb.setMinMajorThreshold(results.getDouble(MIN_MAJOR_THRESHOLD));
		if (results.wasNull()) {mcb.setMinMajorThreshold(null);} 
		mcb.setMaxMinorThreshold(results.getDouble(MAX_MINOR_THRESHOLD));
		if (results.wasNull()) {mcb.setMaxMinorThreshold(null);} 
		mcb.setMinMinorThreshold(results.getDouble(MIN_MINOR_THRESHOLD));
		if (results.wasNull()) {mcb.setMinMinorThreshold(null);} 
		mcb.setMaxInfoThreshold(results.getDouble(MAX_INFO_THRESHOLD));
		if (results.wasNull()) {mcb.setMaxInfoThreshold(null);} 
		mcb.setMinInfoThreshold(results.getDouble(MIN_INFO_THRESHOLD));
		if (results.wasNull()) {mcb.setMinInfoThreshold(null);} 

		return mcb;
	}
	

	public Iterator<MrecChartBean> iterator() {		
		return new ResultsIterator(this);
	}

	/**
	 * Iterate through the results
	 * @author catkinson
	 * 
	 */
	public class ResultsIterator implements Iterator<MrecChartBean>{
		
		private final MrecChartDatabaseResults mrecChartDatabaseResults;
		
		ResultsIterator(MrecChartDatabaseResults mrecChartDatabaseResults){
			this.mrecChartDatabaseResults = mrecChartDatabaseResults;
		}
		
		private boolean hasNext = false;
		private boolean nextChecked = false;
		
		public boolean hasNext(){
			nextChecked = true;
			try {
				if( mrecChartDatabaseResults.results.next() ){
					hasNext = true;
					return true;
				}
			} catch (SQLException e) {
				logger.error("MrecChartSqlResults::ResultsIterator.hasNext() -  Cannot read from result set", e );
			}
			return false;
		}
		
		public MrecChartBean next() {
			MrecChartBean mcb = null;
		
			if( nextChecked ){
				nextChecked = false;
				try {
					if( hasNext ){
						hasNext = false;
						mcb = readFromResults();
					}
				} catch (SQLException e) {
					logger.error("MrecChartSqlResults::ResultsIterator.next() -  Cannot read from result set", e );
					throw new IllegalStateException("MrecChartSqlResults::ResultsIterator.next() -  Cannot read from result set" , e );
				}
				return mcb;
			}
			throw new ConcurrentModificationException(); 
		}
		
		public void remove() {
			throw new NotImplementedException();			
		}		
	}
	
//	@Override
//	protected void finalize() throws Throwable {
//		closeResults();
//		super.finalize();
//	}
}
