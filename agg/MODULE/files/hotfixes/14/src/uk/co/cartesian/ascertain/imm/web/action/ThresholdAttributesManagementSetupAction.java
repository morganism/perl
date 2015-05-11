package uk.co.cartesian.ascertain.imm.web.action;

import java.io.IOException;
import java.util.List;
import java.util.Locale;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import uk.co.cartesian.ascertain.imm.db.dao.IMMDatabaseDAOUtils;
import uk.co.cartesian.ascertain.imm.db.dao.ThresholdDefinitionRefDatabaseDAO;
import uk.co.cartesian.ascertain.imm.db.dao.beans.ThresholdDefinitionRef;
import uk.co.cartesian.ascertain.imm.db.dao.beans.ThresholdVersionRef;
import uk.co.cartesian.ascertain.imm.db.jpa.IMMEntityManagerFactory;
import uk.co.cartesian.ascertain.imm.db.jpa.entity.CustomMetadataRef;
import uk.co.cartesian.ascertain.utils.exception.WebApplicationException;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;
import uk.co.cartesian.ascertain.utils.persistence.exceptions.ReadException;
import uk.co.cartesian.ascertain.web.session.bean.AscertainSessionUser;
import uk.co.cartesian.ascertain.web.tpm.ModularResultSetTPMConfiguration;
import uk.co.cartesian.ascertain.web.tpm.TPMColumnConfiguration;
import uk.co.cartesian.ascertain.web.tpm.TPMException;
import uk.co.cartesian.ascertain.web.tpm.action.TPMConfigurationRepository;

/**
 * @author imortimer
 * Created on 13-Jul-2004
 */
public class ThresholdAttributesManagementSetupAction 
extends Action
{
    static Logger logger = LogInitialiser.getLogger(ThresholdAttributesManagementSetupAction.class.getName());
    
    private static final String _THRESHOLD_SEVERITIES_SQL =
        "    SELECT DECODE(sr.icon,'','','<img src=\"' || sr.icon || '\" border=\"0\" alt=\"[Icon]\" title=\"' || sr.name || '\"/>') AS icon,\n" +
        "           tsr.threshold_severity_id,\n" + 
        "           sr.name severity,\n" +
        "           pr.name priority,\n" +
        "           DECODE(tdr.type, \n" +
        "           'Percentage', TO_CHAR(tsr.value*100,'S99G999G999G999G999G999G999G999G999G999G999D99') || '%', \n" +
        "           TO_CHAR(tsr.value,'S99G999G999G999G999G999G999G999G999G999G999D99')) AS value,\n" + 
        "           tsr.operator,\n" + 
        "           tsr.raise_issue,\n" +
        "           itr.name,\n" +
        "           ag.group_name,\n" + 
        "           au.alias\n" + 
        "      FROM imm.threshold_severity_ref tsr \n" + 
        "INNER JOIN imm.threshold_version_ref svr \n" +
        "        ON svr.threshold_version_id = tsr.threshold_version_id \n" +
        "INNER JOIN imm.threshold_definition_ref tdr \n" +
        "        ON tdr.threshold_definition_id = svr.threshold_definition_id \n" +
        "INNER JOIN imm.severity_ref sr\n" + 
        "        ON sr.severity_id = tsr.severity_id\n" + 
        "INNER JOIN imm.priority_ref pr\n" + 
        "        ON pr.priority_id = tsr.priority_id\n" + 
        "LEFT JOIN imm.issue_type_ref itr\n" +
        "        ON itr.issue_type_id = tsr.issue_type_id\n" +
        " LEFT JOIN utils.ascertain_group ag\n" + 
        "        ON ag.group_id = tsr.start_group_id\n" + 
        " LEFT JOIN utils.ascertain_user au\n" + 
        "        ON au.user_id = tsr.start_user_id\n" + 
        "     WHERE tsr.threshold_version_id = ";

    private static final String _APPLICABLE_DAYS_SQL =
        "    SELECT dtr.day_threshold_id,\n" +
        "           dtr.day_id,\n" +
        "           wdr.day,\n" + 
        "           substr('00'||trunc(dtr.from_time/60/60),-2) || ':' || substr('00'||trunc(mod(dtr.from_time,3600)/60),-2) || ':' || substr('00'||trunc(mod(mod(dtr.from_time,3600),60)),-2) AS from_time,\n" + 
        "           substr('00'||trunc(dtr.to_time/60/60),-2) || ':' || substr('00'||trunc(mod(dtr.to_time,3600)/60),-2) || ':' || substr('00'||trunc(mod(mod(dtr.to_time,3600),60)),-2) AS to_time\n" + 
        "      FROM imm.day_threshold_ref dtr\n" + 
        "INNER JOIN imm.week_day_ref wdr\n" + 
        "        ON wdr.day_id = dtr.day_id\n" + 
        "     WHERE dtr.threshold_version_id = ";

    private static final String _EXCEPTIONAL_DATES_SQL =
        "    SELECT dtr.date_threshold_id,\n" +
        "           dtr.exception_date_id,\n" +
        "           edr.description,\n" + 
        "           substr('00'||trunc(dtr.from_time/60/60),-2) || ':' || substr('00'||trunc(mod(dtr.from_time,3600)/60),-2) || ':' || substr('00'||trunc(mod(mod(dtr.from_time,3600),60)),-2) AS from_time,\n" + 
        "           substr('00'||trunc(dtr.to_time/60/60),-2) || ':' || substr('00'||trunc(mod(dtr.to_time,3600)/60),-2) || ':' || substr('00'||trunc(mod(mod(dtr.to_time,3600),60)),-2) AS to_time\n" + 
        "      FROM imm.date_threshold_ref dtr\n" + 
        "INNER JOIN imm.exception_date_ref edr\n" + 
        "        ON edr.exception_date_id = dtr.exception_date_id\n" + 
        "     WHERE dtr.threshold_version_id = ";

    
    /**
     * Process the specified HTTP request, and create the corresponding HTTP
     * response (or forward to another web component that will create it).
     * Return an <code>ActionForward</code> instance describing where and how
     * control should be forwarded, or <code>null</code> if the response has
     * already been completed.
     *
     * @param mapping The ActionMapping used to select this instance
     * @param form The optional ActionForm bean for this request (if any)
     * @param request The HTTP request we are processing
     * @param response The HTTP response we are creating
     *
     * @exception java.io.IOException if an input/output error occurs
     * @exception javax.servlet.ServletException if a servlet exception occurs
     */
    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
    throws IOException, ServletException
    {
        if (logger.isDebugEnabled()) logger.debug("ManageThresholdAttributeSetupAction:execute(...) - START");
        ActionForward returnValue = mapping.findForward("success");
        
        try
        {
            //Get the Threshold out of the session
            ThresholdVersionRef tvr = (ThresholdVersionRef)request.getSession().getAttribute("IMM__THRESHOLD_VERSION_REF");
            
            //Get threshold severities configuration data
            ModularResultSetTPMConfiguration thresholdSeveritiesConfig = getThresholdSeveritiesConfig(tvr, AscertainSessionUser.getLocale(request));
            TPMConfigurationRepository.add(request, thresholdSeveritiesConfig, "uk.co.cartesian.ascertain.imm.web.action.ThresholdAttributesManagement_ThresholdSeverities");
            
            //Get applicable days configuration data
            ModularResultSetTPMConfiguration applicableDaysConfig = getApplicableDaysConfig(tvr, AscertainSessionUser.getLocale(request));
            TPMConfigurationRepository.add(request, applicableDaysConfig, "uk.co.cartesian.ascertain.imm.web.action.ThresholdAttributesManagement_ApplicableDays");
            
            //Get Exception dates configuration data
            ModularResultSetTPMConfiguration exceptionalDatesConfig = getExceptionalDatesConfig(tvr, AscertainSessionUser.getLocale(request));
            TPMConfigurationRepository.add(request, exceptionalDatesConfig, "uk.co.cartesian.ascertain.imm.web.action.ThresholdAttributesManagement_ExceptionalDates");
            
            // now set up the custom metadata stuff
            setupCustomMetadata(tvr, request);
        }
        catch(Exception e)
        {
            String msg = "Could not initialise the page. \n" + e.toString();
            logger.error("ManageThresholdAttributesSetupAction:exeute(...) - " + msg, e);
            throw new WebApplicationException(msg);
        }
        
        return returnValue;
    }
    
    /**
     * @param query
     * @return
     * @throws ReadException 
     */
    private ModularResultSetTPMConfiguration getThresholdSeveritiesConfig(ThresholdVersionRef tvr, Locale locale)
    throws TPMException, ReadException
    {
    	ThresholdDefinitionRef tdr = new ThresholdDefinitionRef(tvr.getThresholdDefinitionId());
    	ThresholdDefinitionRefDatabaseDAO.read(tdr);
    	
        ModularResultSetTPMConfiguration returnValue = new ModularResultSetTPMConfiguration(locale);
        returnValue.setConnectionPool(IMMDatabaseDAOUtils.getAutoConnectionName());
        returnValue.setFixedQuery(_THRESHOLD_SEVERITIES_SQL + tvr.getThresholdVersionId().toString());
        returnValue.setPageSize(0);
        returnValue.setShowNavigationBar(false);
        returnValue.setRowHandlerJsp("/jsp/imm/ThresholdSeveritiesManagementRow.jsp");
        if(tvr.getStatus().equals(ThresholdVersionRef.STATUS_NEW))
        {
            returnValue.setRowHeaderHandlerJsp("/jsp/web/tpm/DefaultRowHeaderPlus3.jsp");
        }
        else
        {
            returnValue.setRowHeaderHandlerJsp("/jsp/web/tpm/DefaultRowHeader.jsp");
        }
        
        TPMColumnConfiguration column = new TPMColumnConfiguration("threshold_severity_id");
        column.setState(TPMColumnConfiguration.HIDDEN);
        column.setUniqueKey(true);
        returnValue.addColumn(column);
            
        column = new TPMColumnConfiguration("icon", "");
        column.setType(TPMColumnConfiguration.ICON_TYPE);
        column.setCollapsible(false);
        column.setOrderByState(TPMColumnConfiguration.OrderByState.DISABLED);
        returnValue.addColumn(column);

        column = new TPMColumnConfiguration("severity", "Severity", "Severity Description");
        returnValue.addColumn(column);

        column = new TPMColumnConfiguration("priority", "Priority", "Priority");
        returnValue.addColumn(column);

        column = new TPMColumnConfiguration("operator", "Operator", "Severity Operator");
        returnValue.addColumn(column);

        if (ThresholdDefinitionRef.PERCENTAGE.equals(tdr.getType()))
        {
            column = new TPMColumnConfiguration("value", "Percentage", "Threshold Severity Percentage");
        }
        else
        {
            column = new TPMColumnConfiguration("value", "Value", "Threshold Severity Value");
        }
        column.setType(TPMColumnConfiguration.NUMBER_TYPE);
        column.setOrderByState(TPMColumnConfiguration.OrderByState.ASCENDING);
        column.setOrderByColumnId("tsr.value");
        returnValue.addColumn(column);

        column = new TPMColumnConfiguration("raise_issue", "Raise Issue");
        returnValue.addColumn(column);
        
        column = new TPMColumnConfiguration("name", "Issue Type", "Issue Type Of Any Raised Issue");
        returnValue.addColumn(column);

        column = new TPMColumnConfiguration("group_name", "Group", "Initial Group Of Any Raised Issue");
        returnValue.addColumn(column);
        
        column = new TPMColumnConfiguration("alias", "User", "Alias Of Initial Owner Of Any Raised Issue");
        returnValue.addColumn(column);

        return returnValue;
    }

    /**
     * @param query
     * @return
     */
    private ModularResultSetTPMConfiguration getApplicableDaysConfig(ThresholdVersionRef tvr, Locale locale)
    throws TPMException
    {
        ModularResultSetTPMConfiguration returnValue = new ModularResultSetTPMConfiguration(locale);
        returnValue.setConnectionPool(IMMDatabaseDAOUtils.getAutoConnectionName());
        returnValue.setFixedQuery(_APPLICABLE_DAYS_SQL + tvr.getThresholdVersionId().toString());
        returnValue.setPageSize(0);
        returnValue.setShowNavigationBar(false);
        returnValue.setRowHandlerJsp("/jsp/imm/ThresholdApplicableDaysManagementRow.jsp");
        if(tvr.getStatus().equals(ThresholdVersionRef.STATUS_NEW))
        {
            returnValue.setRowHeaderHandlerJsp("/jsp/web/tpm/DefaultRowHeaderPlus3.jsp");
        }
        else
        {
            returnValue.setRowHeaderHandlerJsp("/jsp/web/tpm/DefaultRowHeader.jsp");
        }
        
        TPMColumnConfiguration column = new TPMColumnConfiguration("day_threshold_id");
        column.setState(TPMColumnConfiguration.HIDDEN);
        column.setUniqueKey(true);
        returnValue.addColumn(column);
            
        column = new TPMColumnConfiguration("day", "Day");
        column.setOrderByState(TPMColumnConfiguration.OrderByState.ASCENDING);
        column.setOrderByColumnId("wdr.day_id");
        returnValue.addColumn(column);
            
        column = new TPMColumnConfiguration("from_time", "From", "From Time");
        column.setOrderByColumnId("dtr.from_time");
        returnValue.addColumn(column);
            
        column = new TPMColumnConfiguration("to_time", "To", "To Time");
        column.setOrderByColumnId("dtr.to_time");
        returnValue.addColumn(column);
            
        return returnValue;
    }

    /**
     * @param query
     * @return
     */
    private ModularResultSetTPMConfiguration getExceptionalDatesConfig(ThresholdVersionRef tvr, Locale locale)
    throws TPMException
    {
        ModularResultSetTPMConfiguration returnValue = new ModularResultSetTPMConfiguration(locale);
        returnValue.setConnectionPool(IMMDatabaseDAOUtils.getAutoConnectionName());
        returnValue.setFixedQuery(_EXCEPTIONAL_DATES_SQL + tvr.getThresholdVersionId().toString());
        returnValue.setOrderByClause("ORDER BY edr.exception_date DESC");
        returnValue.setPageSize(0);
        returnValue.setShowNavigationBar(false);
        returnValue.setRowHandlerJsp("/jsp/imm/ThresholdExceptionalDatesManagementRow.jsp");
        if(tvr.getStatus().equals(ThresholdVersionRef.STATUS_NEW))
        {
            returnValue.setRowHeaderHandlerJsp("/jsp/web/tpm/DefaultRowHeaderPlus3.jsp");
        }
        else
        {
            returnValue.setRowHeaderHandlerJsp("/jsp/web/tpm/DefaultRowHeader.jsp");
        }
        
        TPMColumnConfiguration column = new TPMColumnConfiguration("date_threshold_id");
        column.setState(TPMColumnConfiguration.HIDDEN);
        column.setUniqueKey(true);
        returnValue.addColumn(column);
            
        column = new TPMColumnConfiguration("description", "Description");
        returnValue.addColumn(column);
            
        column = new TPMColumnConfiguration("from_time", "From", "From Time");
        column.setOrderByColumnId("dtr.from_time");
        returnValue.addColumn(column);
            
        column = new TPMColumnConfiguration("to_time", "To", "To Time");
        column.setOrderByColumnId("dtr.to_time");
        returnValue.addColumn(column);
            
        return returnValue;
    }
    
    /**
     * Sets up the custom metadata ref stuff
     * 
     * @param tvr
     * @param request
     */
    private void setupCustomMetadata(ThresholdVersionRef tvr, HttpServletRequest request)
    {
    	EntityManager em = IMMEntityManagerFactory.createEntityManager();
    	Query query = em.createNamedQuery(CustomMetadataRef.QUERY_GET_LEAF_NODES);
    	
    	@SuppressWarnings("unchecked")
    	List<CustomMetadataRef> list = query.getResultList();
    	
    	request.setAttribute("ChildCustomMetadataRefs", list);
    }
}

