package uk.co.cartesian.ascertain.ble.cd.db.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import uk.co.cartesian.ascertain.ble.cd.db.dao.beans.DashboardBLE;
import uk.co.cartesian.ascertain.ble.db.dao.BleCpmWrapper;
import uk.co.cartesian.ascertain.utils.database.DBCleaner;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;

public class DashboardBLEDAO
{
    private static Logger logger = LogInitialiser.getLogger(DashboardBLEDAO.class.getName());
    
    private static String SELECT_DASHBOARD_BLE_FROM_ID = "select ble_id CONTAINER_ID, label, pdf_parameters, is_nav_bar from CD_BLE_REF where instance_id = ?";

    /**
     * 
     * @param instanceId
     * @return
     * @throws SQLException
     */
    public static DashboardBLE load(int instanceId)
    throws SQLException
    {
    	DashboardBLE dashboard = null;
    	
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet rs = null;
        DBCleaner cleaner = new DBCleaner();

        try
        {
            connection = BleCpmWrapper.getAutoConnection();
            cleaner.add(connection);
            statement = connection.prepareStatement(SELECT_DASHBOARD_BLE_FROM_ID);
            cleaner.add(statement);
            statement.setInt(1, instanceId);

            rs = statement.executeQuery();
            cleaner.add(rs);
            if(rs.next())
            {
            	dashboard = new DashboardBLE();
            	dashboard.setInstanceId(instanceId);
            	dashboard.setContainerId(rs.getInt("CONTAINER_ID"));
            	dashboard.setLabel(rs.getString("LABEL"));
            	dashboard.setPdfParameters(rs.getString("PDF_PARAMETERS"));
            	String isNavBar = rs.getString("IS_NAV_BAR");
            	dashboard.setNavBar(isNavBar == null ? true : "N".equals(isNavBar) ? false : true);
            }
        }
        catch (SQLException e)
        {
            String msg = "Could not load Dashboard reference data from database!";
            logger.error("DashboardDAO:load(...) - " + msg, e);
            logger.error(SELECT_DASHBOARD_BLE_FROM_ID);
            throw e;
        }
        finally
        {
        	cleaner.close();
        }    	
    	
    	return dashboard;
    }
}
