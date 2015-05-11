package uk.co.cartesian.ascertain.um.mrec;

import java.util.Date;

import org.apache.log4j.Logger;

import uk.co.cartesian.ascertain.imm.db.dao.beans.ThresholdDefinitionRef;
import uk.co.cartesian.ascertain.imm.db.dao.beans.ThresholdSequenceRef;
import uk.co.cartesian.ascertain.um.UMProperties;
import uk.co.cartesian.ascertain.um.db.dao.FMrecDAO;
import uk.co.cartesian.ascertain.um.db.dao.MrecRegenCriteriaDAO;
import uk.co.cartesian.ascertain.um.db.dao.beans.MrecRegenCriteria;
import uk.co.cartesian.ascertain.um.persistence.bean.mrec.MrecDefinitionRef;
import uk.co.cartesian.ascertain.um.persistence.bean.mrec.MrecVersionRef;
import uk.co.cartesian.ascertain.um.persistence.dao.mrec.MrecDefinitionRefDatabaseDAO;
import uk.co.cartesian.ascertain.utils.log.LogInitialiser;

/**
 * @author darrell
 * Created on 10-Nov-2009
 */
public class MrecRegenerationUtils
{
    private static final Date _DEFAULT_VALID_FROM_DATE = new Date(0);

    static Logger logger = LogInitialiser.getLogger(MrecRegenerationUtils.class.getName());
    
    /**
     * Update Mrec Regen Queue
     * 
     * Assumption: only called after a mrec version is toggled to the Active State
     * 
     */
    public static void updateMrecRegenCriteria(MrecVersionRef mvr)
    throws MrecRegenException
    {
        try
        {
            String status = UMProperties.getInstance().getProperty("REGENERATION_MASTER_SWITCH", "ON");
            if("ON".equals(status))
            {
				// first get mrec_def so can test its type 
				MrecDefinitionRef mdr = new MrecDefinitionRef(mvr.getMrecDefinitionId());
				MrecDefinitionRefDatabaseDAO.read(mdr);

	            // populate the MREC REGEN QUEUE if this is a FILESET type reconciliation
				if ("F".equalsIgnoreCase(mdr.getMrecType())) // should be using ENUMS !!
	            {
	            	// use nextval here as currval is only valid in a session where nextval has been called
	                Integer maxFMrecId = FMrecDAO.getSeqNextVal();
	                MrecRegenCriteria mrq = new MrecRegenCriteria();
	                mrq.setMrecDefinitionId(mdr.getMrecDefinitionId());
	                mrq.setMaxFMrecId(maxFMrecId);
	                mrq.setValidFromDate(mvr.getValidFrom() == null ? _DEFAULT_VALID_FROM_DATE : mvr.getValidFrom()); 
	                MrecRegenCriteriaDAO.save(mrq);
	            }
            }
        }
        catch(Exception e)
        {
            String msg = "Could not create mrec regeneration queue data";
            logger.error("MrecRegenerationUtils:updateMrecRegenCriteria(MrecDefinitionRef...) - " + msg, e);
            throw new MrecRegenException(msg);
        }
    }

    /**
     * Update Mrec Regen Queue
     * after a ThresholdDefinition is changed
     */
    public static void updateMrecRegenCriteria(ThresholdDefinitionRef tdr)
    throws MrecRegenException
    {
        try
        {
            String status = UMProperties.getInstance().getProperty("REGENERATION_MASTER_SWITCH", "ON");
            if("ON".equals(status))
            {
            	// use nextval here as currval is only valid in a session where nextval has been called
                Integer maxFMrecId = FMrecDAO.getSeqNextVal();
                MrecRegenCriteria mrq = new MrecRegenCriteria();
                mrq.setThresholdDefinitionId(tdr.getThresholdDefinitionId());
                mrq.setMaxFMrecId(maxFMrecId);
                mrq.setValidFromDate(_DEFAULT_VALID_FROM_DATE); 
                MrecRegenCriteriaDAO.save(mrq);

            }
        }
        catch(Exception e)
        {
            String msg = "Could not create mrec regeneration queue data";
            logger.error("MrecRegenerationUtils:updateMrecRegenCriteria(ThresholdDefinitionRef...) - " + msg, e);
            throw new MrecRegenException(msg);
        }
    }

    /**
     * Update Mrec Regen Queue
     * after a ThresholdSequence is changed
     */
    public static void updateMrecRegenCriteria(ThresholdSequenceRef tsr)
    throws MrecRegenException
    {
        try
        {
            String status = UMProperties.getInstance().getProperty("REGENERATION_MASTER_SWITCH", "ON");
            if("ON".equals(status))
            {
                // use nextval here as currval is only valid in a session where nextval has been called
                Integer maxFMrecId = FMrecDAO.getSeqNextVal();
                MrecRegenCriteria mrq = new MrecRegenCriteria();
                mrq.setThresholdSequenceId(tsr.getThresholdSequenceId());
                mrq.setMaxFMrecId(maxFMrecId);
                mrq.setValidFromDate(_DEFAULT_VALID_FROM_DATE); 
                MrecRegenCriteriaDAO.save(mrq);
            
            }
        }
        catch(Exception e)
        {
            String msg = "Could not create mrec regeneration queue data";
            logger.error("MrecRegenerationUtils:updateMrecRegenCriteria(ThresholdSequenceRef...) - " + msg, e);
            throw new MrecRegenException(msg);
        }
    }

}
