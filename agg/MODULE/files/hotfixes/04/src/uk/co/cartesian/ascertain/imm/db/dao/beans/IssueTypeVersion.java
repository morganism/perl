package uk.co.cartesian.ascertain.imm.db.dao.beans;

import java.io.Serializable;
import java.sql.Date;

/**
 * Class to represent an IMM issue type.
 */
public class IssueTypeVersion 
implements Serializable
{
    private static final long serialVersionUID = 1L;

    public static Integer BASE_ISSUE_TYPE_ID = 3001;
	
    public enum IssueTypeVersionState 
    {
        NEW("N"), ACTIVE("A"), INACTIVE("I");
        
        private String value;
        
        private IssueTypeVersionState(String state)
        {
            this.value = state;
        }
        
        public String getValue()
        {
            return value;
        }
        
        public static IssueTypeVersionState getIssueStateType(String value)
        {
            IssueTypeVersionState returnValue = null;
            if(value.equals(NEW.getValue()))
            {
                returnValue = IssueTypeVersionState.NEW;
            }
            else if(value.equals(ACTIVE.getValue()))
            {
                returnValue = IssueTypeVersionState.ACTIVE;
            }
            else if(value.equals(INACTIVE.getValue()))
            {
                returnValue = IssueTypeVersionState.INACTIVE;
            }
            return returnValue;
        }
    }
    
    private Integer issueTypeVersionId = null;
	private Integer issueTypeId;
	private String name;
	private String description;
	private IssueTypeVersionState state;
	private Integer creatorId;
	private Date createDate;

	private IssueType issueType;
	
	public IssueTypeVersion()
	{}
	
	public IssueTypeVersion(int issueTypeVersionId)
	{
		this.issueTypeVersionId = issueTypeVersionId;  
	}
	  
	public IssueTypeVersion(Integer issueTypeVersionId, Integer issueTypeId, String name, String description, IssueTypeVersionState state, Integer creatorId, Date createDate)
	{
	    this.issueTypeVersionId = issueTypeVersionId;
	    this.issueTypeId = issueTypeId;
	    this.name = name;
	    this.description = description;
	    this.state = state;
	    this.creatorId = creatorId;
        this.createDate = createDate;
	}
	
	public void nextStatus()
	{
		if (this.getState().value.equals(IssueTypeVersionState.NEW.getValue()))
		{
			this.setState(IssueTypeVersionState.ACTIVE);
		}
		else if (this.getState().value.equals(IssueTypeVersionState.ACTIVE.getValue()))
		{
			this.setState(IssueTypeVersionState.INACTIVE);
		}
		else
		{
			this.setState(IssueTypeVersionState.ACTIVE); // alternate between A and I
		}
	}

	 /**
     * @return the issueTypeVersionId
     */
    public Integer getIssueTypeVersionId() {
        return issueTypeVersionId;
    }
    
    /**
     * @param issueTypeVersionId the issueTypeVersionId to set
     */
    public void setIssueTypeVersionId(Integer issueTypeVersionId) {
        this.issueTypeVersionId = issueTypeVersionId;
    }
	
    /**
     * @return the issueType
     */
    public IssueType getIssueType() {
        return issueType;
    }
    
    /**
     * @param issueType the issueType to set
     */
    public void setIssueType(IssueType issueType) {
        this.issueType = issueType;
    }
    
    /**
	 * @return the issueTypeId
	 */
	public Integer getIssueTypeId() {
		return issueTypeId;
	}
	
	/**
	 * @param issueTypeId the issueTypeId to set
	 */
	public void setIssueTypeId(Integer issueTypeId) {
		this.issueTypeId = issueTypeId;
	}
	
	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}
	
	/**
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}
	
	/**
	 * @return the description
	 */
	public String getDescription() {
		return description;
	}
	
	/**
	 * @param description the description to set
	 */
	public void setDescription(String description) {
		this.description = description;
	}
	
	/**
	 * @return the status
	 */
	public IssueTypeVersionState getState() {
		return state;
	}
	
	/**
	 * @param status the status to set
	 */
	public void setState(IssueTypeVersionState state) {
		this.state = state;
	}
	
	/**
	 * @return the workflowId
	 */
	public Integer getCreatorId() {
		return creatorId;
	}
	
	/**
	 * @param workflowId the workflowId to set
	 */
	public void setCreatorId(Integer creatorId) {
		this.creatorId = creatorId;
	}
	
	/**
	 * @return the is_System
	 */
	public Date getCreateDate() {
		return createDate;
	}
	
	/**
	 * @param is_System the is_System to set
	 */
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	
	public String toString()
	  {
	    return "IssueTypeVersion[" + issueTypeVersionId + "," 
						    + issueTypeId + "," 
						    + name + "," 
						    + description + "," 
						    + state + "," 
						    + creatorId + "," 
						    + createDate + "]";
	  }
	
	
}