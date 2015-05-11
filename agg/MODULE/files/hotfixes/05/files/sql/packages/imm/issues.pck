create or replace package issues is

  -- Author  : DPLANT
  -- Created : 21/09/2006 10:13:27
  -- Purpose : Inserting and Managing Issues

  TYPE bin_array IS TABLE OF VARCHAR2(4000) INDEX BY BINARY_INTEGER;
  DEFAULT_BIN_ARRAY bin_array;

  -----------------------------------------------
  -- Public Functions and Procedures
  -----------------------------------------------
  function insertIssue(
    issueType     integer,
    issueSeverity integer,
    issuePriority integer,
    issueTitle    varchar2,
    raisedBy      integer,
    owningGroupId integer,
    owningUserId  integer default null,
    dateRaised    date default sysdate,
    parentIssueId integer default null,
    issueAttrs    bin_array default DEFAULT_BIN_ARRAY,
    skipLimitCheck boolean default false
  )
  return integer;

  function insertIssueFromTemplate(
  	issueTemplate integer,
    issueTitle    varchar2,
    dateRaised    date default sysdate,
    parentIssueId integer default null,
    issueAttrs    bin_array default DEFAULT_BIN_ARRAY,
    skipLimitCheck boolean default false
  )
  return integer;

  procedure addNote(
    issueId    number,
		addedBy    number,
		noteTypeId number,
		note       varchar2,
		attachName varchar2 default null,
		attachment varchar2 default null
  );

  procedure linkIssues(issueId1 number, issueId2 number);

  function closeIssue(
    issueId	   number,
		stateId	   number,
		resolutionId number,
		closedBy	   number,
		dateClosed   date default null
  ) return boolean;

  function incrementIssueLimit(issueTypeId number) return boolean;

  function incrementIssueLimitJava(issueTypeId number) return number;

  procedure incrementIssueLimitTable(p_issueClass number, p_issueType  number, p_issuecount number);

  -----------------------------------------------
  -- CONSTANTS
  -----------------------------------------------

  DAILY_LIMIT_BREACH_FLAG constant number := -1;
  NO_ACTIVE_VERSION_FLAG constant number := -2;


end;
/
create or replace package body issues is

  -----------------------------------------------
  --Function/Procedure body implementation
  -----------------------------------------------

  /**
  * Core Issue Attribute Ids:
  *  3001,Issue Id
  *  3002,Issue Type
  *  3003,Severity
  *  3004,Priority
  *  3005,Raised By
  *  3006,Owning Group
  *  3007,Owning User
  *  3008,Workflow State
  *  3009,Title
  *  3010,Date Raised
  *  3011,Resolution Code
  *  3012,Date Closed
  *  3014,Parent Issue Id
  *  3015,Is Parent Issue
  *  3016,Time Open
  *  3017,Issue Status
  */
  function insertIssue(issueType     integer,
		       issueSeverity integer,
		       issuePriority integer,
		       issueTitle    varchar2,
		       raisedBy      integer,
		       owningGroupId integer,
		       owningUserId  integer default null,
		       dateRaised    date default sysdate,
		       parentIssueId integer default null,
		       issueAttrs    bin_array default DEFAULT_BIN_ARRAY,
		       skipLimitCheck boolean default false)
    return integer as

    l_issueTypeVersionId	 integer;
    l_issueClassId	       integer;
    l_historyId	           integer;
    l_issueId	             integer;
    l_stateId	             integer;

    cursor attributes(issueTypeVersionId integer) is
      SELECT ATTRIBUTE_ID, A.ISSUE_TABLE_COLUMN, ITA.INITIAL_VALUE
    	FROM IMM.ATTRIBUTE_REF A
    	JOIN IMM.ISSUE_TYPE_ATTRIBUTE ITA
       USING (ATTRIBUTE_ID)
       WHERE ITA.ISSUE_TYPE_VERSION_ID = issueTypeVersionId
       	 AND A.IS_DUPLICATE = 'N';

    v_attributeValue varchar2(4000);
    v_attributeId integer;

    v_actionQueueId integer;
    v_actionQueueFirstRow boolean := true;

  begin

    if not skipLimitCheck then
      -- increment the ISSUE_LIMIT_COUNT
      -- if this function returns false, then limit has been reached
      -- otherwise the limit_count has been incremented and not breached
      if not incrementIssueLimit(issueType) then
	       return DAILY_LIMIT_BREACH_FLAG;
      end if;
    end if;

    -- read all our values in from the DB - do this in one go so as to be efficient
    begin
        select issue_id.nextval,
               issue_history_id.nextval,
               itvr.issue_type_version_id,
               itr.issue_class_id,
               3000
        into l_issueId, l_historyId, l_issueTypeVersionId, l_issueClassId, l_stateId
        from imm.issue_type_ref itr
        inner join imm.issue_type_version_ref itvr
            on itvr.issue_type_id = itr.issue_type_id
        where itvr.state='A'
        and itr.issue_type_id = issueType;
    exception
        when TOO_MANY_ROWS then
            RAISE_APPLICATION_ERROR(
              -20001,
              'More than one active version for issue type: ' || issueType || ' found: ' || SUBSTR(SQLERRM, 1, 4000));
    end;

    -- check we have an active version
    if l_issueTypeVersionId is null then
        return DAILY_LIMIT_BREACH_FLAG;
    end if;
    
    -- INSERT_ISSUE_SQL
    INSERT INTO imm.issue
      (issue_id,
       issue_class_id,
       issue_type_id,
       issue_type_version_id,
       severity_id,
       priority_id,
       raised_by,
       owning_group_id,
       owning_user_id,
       state_id,
       title,
       date_raised,
       resolution_id,
       date_closed,
       d_day_id
       )
    VALUES
      (l_issueId,
       l_issueClassId,
       issueType,
       l_issueTypeVersionId,
       issueSeverity,
       issuePriority,
       raisedBy,
       owningGroupId,
       owningUserId,
       l_stateId,
       issueTitle,
       dateRaised,
       null,
       null,
       trunc(dateRaised));

    -- add History
    INSERT INTO ISSUE_HISTORY
      (ISSUE_HISTORY_ID, ISSUE_ID, STATE_ID, CHANGE_BY_ID, CHANGE_DATE)
    VALUES
      (l_historyId, l_issueId, l_stateId, raisedBy, dateRaised);

    -- add Attribute Values and Attribute History
    FOR attribute IN attributes(l_issueTypeVersionId) LOOP

      -- important!
      v_attributeValue := null;
      v_attributeId := attribute.attribute_id;

      -- 1. add attribute values contained within the "issueAttrs" array
      -- 2. add core attribute values - ie those inserted into the ISSUE table (above)
      -- 3. leave any others empty
      if issueAttrs.exists(attribute.attribute_id) then
         v_attributeValue := issueAttrs(attribute.attribute_id);
      else
        case v_attributeId
           WHEN 3001 THEN v_attributeValue := to_char(l_issueId);
           WHEN 3002 THEN v_attributeValue := to_char(issueType);
           WHEN 3003 THEN v_attributeValue := to_char(issueSeverity);
           WHEN 3004 THEN v_attributeValue := to_char(issuePriority);
           WHEN 3005 THEN v_attributeValue := to_char(raisedBy);
           WHEN 3006 THEN v_attributeValue := to_char(owningGroupId);
           WHEN 3007 THEN v_attributeValue := to_char(owningUserId);
           WHEN 3008 THEN v_attributeValue := to_char(l_stateId);
           WHEN 3009 THEN v_attributeValue := issueTitle;
           WHEN 3010 THEN v_attributeValue := to_char(dateRaised, 'Dy, DD FMMonth YYYY') || to_char(dateRaised, ' HH24:MI:SS');
           WHEN 3014 THEN v_attributeValue := parentIssueId;
           WHEN 3015 THEN v_attributeValue := 'N';
           WHEN 3019 THEN v_attributeValue := to_char(l_issueTypeVersionId);
           -- ignore others
           ELSE v_attributeValue := null;
        end case;
      end if;

      if v_attributeValue is not null then
        -- insert issue_attribute
        INSERT INTO IMM.ISSUE_ATTRIBUTE
        	(ISSUE_ID, ATTRIBUTE_ID, VALUE)
        VALUES
        	(l_issueId, v_attributeId, v_attributeValue);

        -- insert issue_history_attribute
        INSERT INTO IMM.ISSUE_HISTORY_ATTRIBUTE
        	(ISSUE_ID, ISSUE_HISTORY_ID, ATTRIBUTE_ID, VALUE)
        VALUES
          (l_issueId, l_historyId, v_attributeId, v_attributeValue);

        -- populate Action Queue, we always have to do this to ensure the tagging stuff works correctly
        if v_actionQueueFirstRow then
          v_actionQueueFirstRow := false;

          -- insert into ActionQueue
          select seq_action_queue_id.nextval
          into v_actionQueueId
          from dual;

          insert into action_queue (action_queue_id, state_id, status)
          values (v_actionQueueId, l_stateId, 'I');
        end if;

        -- insert action queue attribute
        insert into action_queue_attribute (action_queue_id, attribute_id, attribute_value)
        values (v_actionQueueId, v_attributeId, v_attributeValue);

      end if;
    END LOOP;

    -- set the Action Queue status to 'Q' (for Queued)
    update action_queue set status='Q' where action_queue_id = v_actionQueueId;

    return l_issueId;

  end;

  /***************
  * should really supply dateRaised
  * when adding a note
  ************************/
  procedure addNote(issueId    number,
		    addedBy    number,
		    noteTypeId number,
		    note       varchar2,
		    attachName varchar2 default null,
		    attachment varchar2 default null)

   is
  begin

    -- add the note!
    -- usually with an empty attachment
  	if attachment is not null then
  		insert into note
  	      (note_id,
  	       issue_id,
  	       added_by,
  	       note_type_id,
  	       date_created,
  	       note,
  	       attachment_name,
  	       attachment)
  	    values
  	      (note_id.nextval,
  	       issueId,
  	       addedBy,
  	       noteTypeId,
  	       sysdate,
  	       note,
  	       attachName,
  	       attachment);
  	else
  		insert into note
  	      (note_id,
  	       issue_id,
  	       added_by,
  	       note_type_id,
  	       date_created,
  	       note,
  	       attachment_name,
  	       attachment)
  	    values
  	      (note_id.nextval,
  	       issueId,
  	       addedBy,
  	       noteTypeId,
  	       sysdate,
  	       note,
  	       null,
  	       EMPTY_BLOB());
  	end if;
  end;

  function insertIssueFromTemplate(
  	issueTemplate integer,
    issueTitle    varchar2,
    dateRaised    date default sysdate,
    parentIssueId integer default null,
    issueAttrs    bin_array default DEFAULT_BIN_ARRAY,
    skipLimitCheck boolean default false
  )
  return integer IS
		v_issueType     integer;
		v_issueSeverity integer;
		v_issuePriority integer;
		v_raisedBy      integer;
		v_owningGroupId integer;
		v_owningUserId  integer;
  BEGIN

  	SELECT
	  	issue_type_id,
	  	severity_id,
	    priority_id,
	    raised_by,
	    owning_group_id,
	    owning_user_id
	INTO
	  	v_issueType,
	  	v_issueSeverity,
	    v_issuePriority,
	    v_raisedBy,
	    v_owningGroupId,
	    v_owningUserId
	FROM issue_template_ref
	WHERE issue_template_id = issueTemplate;

  	RETURN insertIssue(
		issueType => v_issueType,
		issueSeverity => v_issueSeverity,
		issuePriority => v_issuePriority,
		issueTitle => issueTitle,
		raisedBy => v_raisedBy,
		owningGroupId =>v_owningGroupId,
		owningUserId => v_owningUserId,
		dateRaised => dateRaised,
		parentIssueId => parentIssueId,
		issueAttrs => issueAttrs,
		skipLimitCheck => skipLimitCheck);
  END;

  /***********************************************************/

  function closeIssue(issueId	   number,
		      stateId	   number,
		      resolutionId number,
		      closedBy	   number,
		      dateClosed   date default null) return boolean as
    openIssueId number;
    closeDate	date;
    closeDateAttr varchar2(100);
    historyId	  integer;

  begin

    -- check open and exists
    select issue_id
      into openIssueId
      from issue
     where issue_id = issueId
       and date_closed is null;

    closeDate := dateClosed;
    if closeDate is null then
      closeDate := sysdate;
    end if;

    -- update Issue
    update issue
       set state_id	 = stateId,
	   resolution_id = resolutionId,
	   date_closed	 = closeDate
     where issue_id = issueId;

    -- add History
    select issue_history_id.nextval into historyId from dual;
    insert into issue_history
      (issue_history_id, issue_id, state_id, change_by_id, change_date)
    values
      (historyId, issueId, stateId, closedBy, closeDate);

	-- attributes
    closeDateAttr := to_char(closeDate, 'Dy, DD FMMonth YYYY') || to_char(closeDate, ' HH24:MI:SS');

	-- upsert closed_date issue_attribute
    -- Attribute:   3012,Date Closed
    MERGE INTO IMM.ISSUE_ATTRIBUTE ia
    USING (
      select issueId issueId, 3012
      FROM dual ) a
    ON (ia.issue_id = a.issueId
            and ia.attribute_id = 3012)
    WHEN MATCHED THEN
      UPDATE SET ia.VALUE = closeDateAttr
    WHEN NOT MATCHED THEN
      INSERT (ISSUE_ID, ATTRIBUTE_ID, VALUE)
      VALUES (issueId, 3012, closeDateAttr);

    -- upsert issue_history_attribute
    MERGE INTO IMM.ISSUE_HISTORY_ATTRIBUTE iha
    USING (
      select issueId issueId, historyId historyId, 3012
      FROM dual ) a
    ON (iha.issue_id = a.issueId
                     and iha.issue_history_id = a.historyId
                        and iha.attribute_id = 3012)
    WHEN MATCHED THEN
      UPDATE SET iha.VALUE = closeDateAttr
    WHEN NOT MATCHED THEN
      INSERT (ISSUE_ID, ISSUE_HISTORY_ID, ATTRIBUTE_ID, VALUE)
      VALUES (issueId, historyId, 3012, closeDateAttr);


    return true;

  exception
    when no_data_found then
      return false;
    when others then
      return false;

  end;


  /**
  *
  */
  procedure linkIssues(issueId1 number, issueId2 number)

   is
  begin
    insert into related_issue values (issueId1, issueId2);

    insert into related_issue values (issueId2, issueId1);
  end;


  /******
  * Try to increment the issue count for this issue_type / issue_class
  *
  * return FALSE if limit has been breached
  * return TRUE otherwise
  *
  * BOOLEAN return types won't work in JAVA!
  * so
  * return 1 for true and 0 for false
  ******/
  function incrementIssueLimitJava(
      issueTypeId number
  )
  return number as
  begin
    return incrementIssueLimitJava(issueTypeId);
  end;


  /**
  *
  */
  function incrementIssueLimit(issueTypeId number) return boolean as
    v_limit_reached_flag  varchar2(1);
    v_issue_type_limit	  number;
    v_issue_default_limit number;
    v_issue_class_id	  integer;
    v_today		  date := trunc(sysdate, 'DD');
  begin

    -- grab the issue_limit_id and issue_limit for this issue_type
    begin
      select it.issue_class_id, it.issue_type_limit
	    into v_issue_class_id, v_issue_type_limit
	    from imm.issue_type_ref it
      where it.issue_type_id = issueTypeId;

      select ic.issue_default_limit
	    into v_issue_default_limit
	    from imm.issue_class_ref ic
      where ic.issue_class_id = v_issue_class_id;
    end;

    -- there must be an issue limit for every issue class!

    -- update issue counts in ISSUE_LIMIT table

    -- update issue type counts

    v_limit_reached_flag := 'Y';

    if v_issue_type_limit = 0 then
        v_issue_type_limit := v_issue_default_limit;
        if v_issue_default_limit = 0 then
	        v_limit_reached_flag := 'N';
        end if;
    end if;

    begin
      merge into issue_limit il
      using (select v_today          as limit_date,
                    v_issue_class_id as issue_class_id,
                    issueTypeId      as issue_type_id
               from dual) a
      on (il.limit_date = a.limit_date and il.issue_class_id = a.issue_class_id and il.issue_type_id = a.issue_type_id)
      when matched then
        update
           set il.issue_count   = il.issue_count + (case
                                    when il.issue_count >= v_issue_type_limit then
                                     0
                                    else
                                     1
                                  end),
               il.limit_reached =
               (case
                 when il.issue_count >= v_issue_type_limit then
                  v_limit_reached_flag
                 else
                  'N'
               end) when not matched then insert values(v_issue_class_id, issueTypeId, v_today, 1, 'N');

    exception
      when DUP_VAL_ON_INDEX then
        null;
    end;

    -- check issue reached flag in ISSUE_LIMIT table
    -- the above sql guarantess that a matching row will
    -- exist, and there can only be one fir issue type
    select il.limit_reached
      into v_limit_reached_flag
      from issue_limit il
     where il.limit_date = v_today
       and il.issue_class_id = v_issue_class_id
       and il.issue_type_id = issueTypeId;

    if v_limit_reached_flag = 'Y' then
      return false;
    else
      return true;
    end if;
  end;


  /******
  * Simply incrememnt the Issue_Limit count by 'issuecount'
  * disregarding the actual limit for this issue_type
  ******/
  procedure incrementIssueLimitTable(
    p_issueClass number,
  	p_issueType  number,
		p_issuecount number
  ) as
    v_issuecount     integer := p_issuecount - 1;
    v_limit_id	     integer;
    v_issue_limit    number;
    v_issue_class_id integer := p_issueClass;
    v_breach	     boolean;

  begin
    -- start by calling incrementIssueLimit
    -- which will ensure that a row for this issue_type/day will exist
    v_breach := incrementIssueLimit(p_issueType);
    if v_breach then
      null;
    end if; -- get rid of compile warnings

    -- then update the limit count by (p_issuecount - 1)
    -- grab the issue_limit_id and issue_limit for this issue_type

    select itr.issue_type_id, itr.issue_type_limit
      into v_limit_id, v_issue_limit
      from imm.issue_class_ref icr, imm.issue_type_ref itr
     where icr.issue_class_id = itr.issue_class_id
       and icr.issue_class_id = v_issue_class_id
       and itr.issue_type_id = p_issueType;

    -- update the issue_limit count for this issueType
    update imm.issue_limit il
       set il.issue_count   = il.issue_count + v_issuecount,
	   il.limit_reached = (case when il.issue_count + v_issuecount > v_issue_limit then 'Y' else 'N' end)
     where il.limit_date = trunc(sysdate)
       and il.issue_type_id = p_issueType
       and il.issue_type_id = v_limit_id;

  end;


end issues;
/
exit;
