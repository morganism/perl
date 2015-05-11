create or replace package etl is


  function get_d_period(period_date date) return date;

  function get_d_node(node number) return number;

  function get_d_source(source number) return number;

  function get_source(p_node_id number, p_description varchar2) return number;

  function md5sum_numeric(P_STRING IN VARCHAR2) RETURN NUMBER;

  function md5sum(P_STRING IN VARCHAR2) RETURN VARCHAR2;

  -- manage/merge um staging tables
  procedure addStagingStatusRecord(p_batch_id integer, status varchar);
  procedure createStagingPartitions(p_job_id integer);
  procedure mergeStagingTables(tmpStatusTble varchar2);
  procedure updateLateFileMatchQueue;

  function getDPeriodResolutionMinutes(a_day date) return integer;

  function get_token(the_list  varchar2, the_index number, delim varchar2 := ',') return varchar2;
  function get_parameter (p_str in varchar2, p_parameter in varchar2) return varchar2 deterministic;


  procedure writeDebug(tmpStatusTble varchar2,
                       p_batch_id    varchar2,
                       p_status      varchar2,
                       p_msg         varchar2);

end etl;
/
create or replace package body etl is

---------------------------------------------------
-- Private procedures and functions declarations
---------------------------------------------------

    function mergeStagingTablesForId(p_job_id number, p_batch_id number, tmpStatusTble varchar2) return boolean;
    procedure sleep(n integer);

    procedure insertIntoFAttribute(p_job_id number, p_batch_id number);
    procedure processNewDataOnly(p_job_id number, p_batch_id number);
    procedure processMixedData(p_batch_id number, v_max_sample_date date, v_min_sample_date date);
    procedure mergeInto_AGG_F_FILE(p_job_id number, p_batch_id number);
    procedure insertIntoFmo_Match_Queue(p_batch_id number);
    procedure insertIntoFmo_Match_Count(p_batch_id number);



---------------------------------------------------
-- Procedure and function implementations
---------------------------------------------------

  -- get_d_period
  -- Given a date, usually based on the creation date associated with log
  -- records, this function will return the appropriate period ID from
  -- the D_PERIOD dimension table
  function get_d_period(period_date date) return date is
    v_period_id date;
  begin
    select max(d_period_id)
      into v_period_id
      from um.d_period
     where d_period_id <= period_date;
    return v_period_id;
  end;

  function get_d_node(node number) return number is
  begin
    return node;
  end;

  function get_d_source(source number) return number is
  begin
    return source;
  end;

  -- get_source
  -- Given the node identifier, obtained from one of the job parameters, and
  -- the source description, this function will return the source ID. The source
  -- ID is the same as the dimension source ID from the table D_SOURCE_MV
  -- (a materialised view).

  function get_source(p_node_id number, p_description varchar2) return number is
    v_source_id number;
  begin
    select sdr.source_id
      into v_source_id
      from um.source_desc_ref sdr
     where sdr.node_id = p_node_id
       and sdr.source_description = p_description;
    return v_source_id;
  end;

  -- md5sum_numeric
  -- Returns the numeric (decimal) value of
  FUNCTION md5sum_numeric(P_STRING IN VARCHAR2) RETURN NUMBER IS
    lv_hash_value  VARCHAR2(32);
    lv_hash_number NUMBER;
  BEGIN
    lv_hash_value := dbms_obfuscation_toolkit.md5(input_string => P_STRING);
    -- conversion to number

    SELECT TO_NUMBER(RAWTOHEX(lv_hash_value),
                     'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
      INTO lv_hash_number
      FROM DUAL;

    RETURN lv_hash_number;
  END;

  -- md5sum
  -- Returns the md5 hash of the give string
  FUNCTION md5sum(P_STRING IN VARCHAR2) RETURN VARCHAR2 IS
    lv_hash_value VARCHAR2(32);
    --  lv_hash_number NUMBER;
  BEGIN
    lv_hash_value := dbms_obfuscation_toolkit.md5(input_string => P_STRING);
    -- conversion to number

    SELECT RAWTOHEX(lv_hash_value) INTO lv_hash_value FROM DUAL;

    RETURN lv_hash_value;
  END;

  -----------------------------------------------------------------------
  -- Create a record in the STAGING_JOB_STATUS table
  -----------------------------------------------------------------------
  procedure addStagingStatusRecord(p_batch_id integer, status varchar)
  is
  begin
     insert into STAGING_BATCH_STATUS
       (batch_id, status, batch_date)
     values
       (p_batch_id, status, sysdate);
  end;

  -----------------------------------------------------------------------
  -- Create partitons on tables F_FILE_STAGING and LOG_RECORD_STAGING
  -- this is a LIST partition that contains the single value $JOB_ID
  -----------------------------------------------------------------------
  procedure createStagingPartitions(p_job_id integer)
  is
     v_ff_part_sql varchar(100);
     v_lr_part_sql varchar(100);
     v_job_id_pad varchar(9);
     v_partcount integer := 0;

     resource_busy exception;
     pragma exception_init (resource_busy,-54);
     v_max_wait integer; -- max number of wait cycles
  begin
     select lpad(p_job_id,9,'0')
     into v_job_id_pad
     from dual;

     -- check if partition already exists
     select count(*)
     into v_partcount
     from all_tab_partitions t
     where t.table_owner = 'UM' and t.table_name = 'F_FILE_STAGING'
     and t.partition_name= 'F_FILE_STAGING_P' || v_job_id_pad;

     -- create if partition doesn't exist
     if v_partcount = 0 then
       v_ff_part_sql := 'alter table F_FILE_STAGING add partition F_FILE_STAGING_P' || v_job_id_pad ||
                           ' VALUES (' || p_job_id || ')';

       -- this loop will avoid "resourse_busy" ORA-00054 errors
       -- that may occur when createStagingPartitions is called in parallel
       v_max_wait := 1000;
       loop
         v_max_wait := v_max_wait - 1;
         if v_max_wait <= 0 then
            raise resource_busy;
         end if;

         begin
              execute immediate v_ff_part_sql;
              exit; -- break out of the loop on success
         exception
           when resource_busy then
              sleep(1);
         end;
       end loop;
     end if;

     -- check if partition already exists
     select count(*)
     into v_partcount
     from all_tab_partitions t
     where t.table_owner = 'UM' and t.table_name = 'LOG_RECORD_STAGING'
     and t.partition_name= 'LOG_RECORD_STAGING_P' || v_job_id_pad;

     -- create if partition doesn't exist
     if v_partcount = 0 then
       v_lr_part_sql := 'alter table LOG_RECORD_STAGING add partition LOG_RECORD_STAGING_P' || v_job_id_pad ||
                           ' VALUES (' || p_job_id || ')';


       -- this loop will avoid "resourse_busy" ORA-00054 errors
       -- that may occur when createStagingPartitions is called in parallel
       v_max_wait := 1000;
       loop
         v_max_wait := v_max_wait - 1;
         if v_max_wait <= 0 then
            raise resource_busy;
         end if;

         begin
              execute immediate v_lr_part_sql;
              exit; -- break out of the loop on success
         exception
           when resource_busy then
              sleep(1);
         end;
       end loop;
     end if;
  exception
    when resource_busy then
               RAISE_APPLICATION_ERROR(-20001,
                              'Exception: MAX WAIT exceeded while waiting for staging table resource.');

  end;


  ------------------------------------------------------------
  -- Insert F_FILE_STAGING and LOG_RECORD_STAGING
  -- into F_FILE, F_ATTRIBUTE and LOG_RECORD
  -- and MERGE F_FILE_STAGING into AGG_F_FILE
  --
  -- tmpStatusTble used by BLE logging
  ------------------------------------------------------------
  procedure mergeStagingTables(tmpStatusTble varchar2)

  is
    v_merge_ok boolean := true;
    v_batches integer  := 0;

    -- list the distinct job_ids that appear in log_record_staging,
    -- are completed jobs, and have not yet been merged
    cursor cur_staging_batch_id is
      select distinct lrs.job_id, lrs.batch_id
      from um.log_record_staging lrs
           join jobs.batch b on (lrs.batch_id = b.batch_id and b.batch_status_id = 4)
           left outer join um.staging_batch_status sjs on (lrs.batch_id = sjs.batch_id)
      where
        not exists (select null from staging_batch_status s where s.batch_id = lrs.batch_id)
      order by batch_id asc;

  begin

    -- for each batch_id > 0
    for r_staging_batch_id in cur_staging_batch_id loop




       -- attempt the merge
        v_merge_ok := mergeStagingTablesForId(r_staging_batch_id.job_id, r_staging_batch_id.batch_id, tmpStatusTble);

        if v_merge_ok = true then

          -- in case of daemon job there could be a job_id with different batch_ids.
          -- After processing each batch, we have to delete the records related to it;
          -- After processing the last batch we can drop the partition.
          select count(distinct(batch_id)) into v_batches
            from UM.F_FILE_STAGING ffs
           where FFS.JOB_ID = r_staging_batch_id.job_id;

          if v_batches > 1 then
            -- delete from staging partitions
            execute immediate 'delete from F_FILE_STAGING where batch_id = ' || r_staging_batch_id.batch_id;
            execute immediate 'delete from LOG_RECORD_STAGING where batch_id = ' || r_staging_batch_id.batch_id;
            execute immediate 'delete from FMO_MATCH_QUEUE_STAGING where batch_id = ' || r_staging_batch_id.batch_id;

          else
            -- drop the staging partitions
            begin
              execute immediate 'alter table F_FILE_STAGING drop partition F_FILE_STAGING_P' || lpad(r_staging_batch_id.job_id,9,'0');
            exception
              when OTHERS then
                if SQLCODE = -14083 then
                  execute immediate 'truncate table F_FILE_STAGING';
                else
                  raise;
                end if;
            end;

            begin
              execute immediate 'alter table LOG_RECORD_STAGING drop partition LOG_RECORD_STAGING_P' || lpad(r_staging_batch_id.job_id,9,'0');
            exception
              when OTHERS then
                if SQLCODE = -14083 then
                  execute immediate 'truncate table LOG_RECORD_STAGING';
                else
                  raise;
                end if;
            end;

            execute immediate 'delete from FMO_MATCH_QUEUE_STAGING where batch_id = ' || r_staging_batch_id.batch_id;
          end if;


          addStagingStatusRecord(r_staging_batch_id.batch_id, 'S');


        else
          addStagingStatusRecord(r_staging_batch_id.batch_id, 'B');

        end if;

        commit;
    end loop;

    -- update the LATE_FILE_MATCH_QUEUE table
    -- set status = 'L' for loaded late files
    updateLateFileMatchQueue;

  exception
  -- return any exception message
  when others then
      RAISE_APPLICATION_ERROR(-20001,
                              'Exception: ' || SUBSTR(SQLERRM, 1, 4000));

  end;



  ------------------------------------------------------------
  -- Insert F_FILE_STAGING and LOG_RECORD_STAGING
  -- into F_FILE and LOG_RECORD
  -- and MERGE
  -- F_FILE_STAGING into AGG_F_FILE
  -- for staging_id (batch) = p_staging_id
  ------------------------------------------------------------
  function mergeStagingTablesForId(p_job_id number, p_batch_id number, tmpStatusTble varchar2)
  return boolean is
       v_reload_count integer;
       v_max_sample_date date;
       v_min_sample_date date;

       v_status integer;
       v_msg varchar(4000);
       v_sql varchar(4000) := '';
       v_partition_name varchar2(100);

  begin

--writeDebug(tmpStatusTble, p_batch_id, 0, 'mergeStagingTablesForId - START');
  select 'F_FILE_STAGING_P' || lpad(p_job_id,9,'0')
	into v_partition_name
	from dual;

	dbms_stats.gather_table_stats('UM','F_FILE_STAGING',partname => v_partition_name);
--writeDebug(tmpStatusTble, p_batch_id, 0, 'After gather stats on F_FILE_STAGING');

	select 'LOG_RECORD_STAGING_P' || lpad(p_job_id,9,'0')
	into v_partition_name
	from dual;

	dbms_stats.gather_table_stats('UM','LOG_RECORD_STAGING',partname => v_partition_name);
--writeDebug(tmpStatusTble, p_batch_id, 0, 'After gather stats on LOG_RECORD_STAGING');

        -- Merge into LOG_RECORD
    -- TODO merge /append */ can lock, could try insert /* append no parallel */??
        merge into LOG_RECORD lr
        using (
            select *
            from LOG_RECORD_STAGING
            where job_id = p_job_id
            and batch_id = p_batch_id
        ) lrs
        on (lr.log_record_id = lrs.log_record_id and lr.d_period_id = get_d_period(lrs.sample_date))
        when matched then
          update set lr.is_re_presented = 'Y'
        when not matched then
            insert (
             D_PERIOD_ID,
             LOG_RECORD_ID,
             SAMPLE_DATE,
             BATCH_ID,
             NODE_ID,
             SOURCE_ID,
             FILE_TYPE,
             PROCESS_DATE,
             CREATION_DATE,
             RECORD_NO,
             RECORD_CHECKSUM,
             IS_MISSING_PREDECESSOR,
             IS_MISSING_SUCCESSOR,
             FILE_NAME,
             OUT_FILE_NAME
            )
            values (
             get_d_period(lrs.SAMPLE_DATE),
             lrs.LOG_RECORD_ID,
             lrs.SAMPLE_DATE,
             lrs.BATCH_ID,
             lrs.NODE_ID,
             lrs.SOURCE_ID,
             lrs.FILE_TYPE,
             lrs.PROCESS_DATE,
             lrs.CREATION_DATE,
             lrs.RECORD_NO,
             lrs.RECORD_CHECKSUM,
             lrs.IS_MISSING_PREDECESSOR,
             lrs.IS_MISSING_SUCCESSOR,
             lrs.FILE_NAME,
             lrs.OUT_FILE_NAME
           );
--writeDebug(tmpStatusTble, p_batch_id, 0, 'After merge into LOG_RECORD');

        -- Check to see if we have any records marked as reload
        -- truncate the min date to capture metrics calculated with daily precision filesets
        select count(lrs.is_reload),
               trunc(min(lrs.sample_date)),
               max(lrs.sample_date)
        into v_reload_count, v_min_sample_date, v_max_sample_date
        from log_record_staging lrs
        where lrs.is_reload = 'Y'
        and lrs.batch_id = p_batch_id;

        --Insert into f_attribute
        insertIntoFAttribute(p_job_id, p_batch_id);
--writeDebug(tmpStatusTble, p_batch_id, 0, 'After insertIntoFAttribute');

        insertIntoFmo_Match_Queue(p_batch_id);
--writeDebug(tmpStatusTble, p_batch_id, 0, 'After insertIntoFmo_Match_Queue');


        -- Load the data depending on what sort of data we have (new or represented)
        if v_reload_count = 0 then
           begin
               --Fast optionized for new data only
               processNewDataOnly(p_job_id, p_batch_id);
           end;
        else
           begin
               --Slower so only do if we have to
               processMixedData(p_batch_id, v_max_sample_date, v_min_sample_date);
           end;
        end if;

        mergeInto_AGG_F_FILE(p_job_id, p_batch_id);
--writeDebug(tmpStatusTble, p_batch_id, 0, 'After mergeInto_AGG_F_FILE');

        -- log msg
        v_status := 0;
        v_msg := 'Success';

        -- log/status message to tmpStatusTble
        v_sql := 'insert into '|| tmpStatusTble ||' (gdlJobId, status, msg) values (';
        v_sql := v_sql || p_batch_id || ', ' || v_status || ', ''' || v_msg || ''')';

        execute immediate v_sql;

        -- commit
        commit;

        -- FMO match count needs the records to be present in FMO match queue
        -- so have to commit them before running this
        insertIntoFmo_Match_Count(p_batch_id);
--writeDebug(tmpStatusTble, p_batch_id, 0, 'After insertIntoFmo_Match_Count');
        commit;

        return true;

    exception
      when others then
        rollback;

        -- log msg
        v_status := 1;
        v_msg :=  SUBSTR(SQLERRM, 1, 4000);

        -- log/status message to tmpStatusTble
        v_sql := 'insert into '|| tmpStatusTble ||' (gdlJobId, status, msg) values (';
        v_sql := v_sql || p_batch_id || ', ' || v_status || ', ''' || v_msg || ''')';

        execute immediate v_sql;
        commit;

        return false;
  end;


    /**
    *
    */
    procedure insertIntoFAttribute(p_job_id number, p_batch_id number)
    is
    begin
        -- Insert into F_ATTRIBUTE
      INSERT INTO UM.F_ATTRIBUTE fa
        select um.seq_f_attribute_id.nextval,
               a.*
        from (
           select distinct ffs.d_node_id,
                                ffs.d_source_id,
                                ffs.d_edr_type_id,
                                ffs.d_measure_type_id,
                                ffs.d_billing_type_id,
                                ffs.d_payment_type_id,
                                ffs.d_call_type_id,
                                ffs.d_customer_type_id,
                                ffs.d_service_provider_id,
                                ffs.d_custom_01_id,
                                ffs.d_custom_02_id,
                                ffs.d_custom_03_id,
                                ffs.d_custom_04_id,
                                ffs.d_custom_05_id,
                                ffs.d_custom_06_id,
                                ffs.d_custom_07_id,
                                ffs.d_custom_08_id,
                                ffs.d_custom_09_id,
                                ffs.d_custom_10_id,
                                ffs.d_custom_11_id,
                                ffs.d_custom_12_id,
                                ffs.d_custom_13_id,
                                ffs.d_custom_14_id,
                                ffs.d_custom_15_id,
                                ffs.d_custom_16_id,
                                ffs.d_custom_17_id,
                                ffs.d_custom_18_id,
                                ffs.d_custom_19_id,
                                ffs.d_custom_20_id
                  FROM um.F_FILE_STAGING FFS
           WHERE FFS.JOB_ID = P_JOB_ID
           AND FFS.BATCH_ID = p_batch_id
                   AND NOT EXISTS
           (
               SELECT 1
                          from um.f_attribute fa
                         WHERE 1 = 1
                           and ffs.d_node_id = fa.d_node_id
                           and ffs.d_source_id = fa.d_source_id
                           and ffs.d_edr_type_id = fa.d_edr_type_id
                           and ffs.d_measure_type_id = fa.d_measure_type_id
               and ((ffs.d_billing_type_id = fa.d_billing_type_id) or (ffs.d_billing_type_id is null and fa.d_billing_type_id is null))
               and ((ffs.d_payment_type_id = fa.d_payment_type_id) or (ffs.d_payment_type_id is null and fa.d_payment_type_id is null))
               and ((ffs.d_call_type_id = fa.d_call_type_id) or (ffs.d_call_type_id is null and fa.d_call_type_id is null))
               and ((ffs.d_customer_type_id = fa.d_customer_type_id) or (ffs.d_customer_type_id is null and fa.d_customer_type_id is null))
               and ((ffs.d_service_provider_id = fa.d_service_provider_id) or (ffs.d_service_provider_id is null and fa.d_service_provider_id is null))
               and ((ffs.d_custom_01_id = fa.d_custom_01_id) or (ffs.d_custom_01_id is null and fa.d_custom_01_id is null))
               and ((ffs.d_custom_02_id = fa.d_custom_02_id) or (ffs.d_custom_02_id is null and fa.d_custom_02_id is null))
               and ((ffs.d_custom_03_id = fa.d_custom_03_id) or (ffs.d_custom_03_id is null and fa.d_custom_03_id is null))
               and ((ffs.d_custom_04_id = fa.d_custom_04_id) or (ffs.d_custom_04_id is null and fa.d_custom_04_id is null))
               and ((ffs.d_custom_05_id = fa.d_custom_05_id) or (ffs.d_custom_05_id is null and fa.d_custom_05_id is null))
               and ((ffs.d_custom_06_id = fa.d_custom_06_id) or (ffs.d_custom_06_id is null and fa.d_custom_06_id is null))
               and ((ffs.d_custom_07_id = fa.d_custom_07_id) or (ffs.d_custom_07_id is null and fa.d_custom_07_id is null))
               and ((ffs.d_custom_08_id = fa.d_custom_08_id) or (ffs.d_custom_08_id is null and fa.d_custom_08_id is null))
               and ((ffs.d_custom_09_id = fa.d_custom_09_id) or (ffs.d_custom_09_id is null and fa.d_custom_09_id is null))
               and ((ffs.d_custom_10_id = fa.d_custom_10_id) or (ffs.d_custom_10_id is null and fa.d_custom_10_id is null))
               and ((ffs.d_custom_11_id = fa.d_custom_11_id) or (ffs.d_custom_11_id is null and fa.d_custom_11_id is null))
               and ((ffs.d_custom_12_id = fa.d_custom_12_id) or (ffs.d_custom_12_id is null and fa.d_custom_12_id is null))
               and ((ffs.d_custom_13_id = fa.d_custom_13_id) or (ffs.d_custom_13_id is null and fa.d_custom_13_id is null))
               and ((ffs.d_custom_14_id = fa.d_custom_14_id) or (ffs.d_custom_14_id is null and fa.d_custom_14_id is null))
               and ((ffs.d_custom_15_id = fa.d_custom_15_id) or (ffs.d_custom_15_id is null and fa.d_custom_15_id is null))
               and ((ffs.d_custom_16_id = fa.d_custom_16_id) or (ffs.d_custom_16_id is null and fa.d_custom_16_id is null))
               and ((ffs.d_custom_17_id = fa.d_custom_17_id) or (ffs.d_custom_17_id is null and fa.d_custom_17_id is null))
               and ((ffs.d_custom_18_id = fa.d_custom_18_id) or (ffs.d_custom_18_id is null and fa.d_custom_18_id is null))
               and ((ffs.d_custom_19_id = fa.d_custom_19_id) or (ffs.d_custom_19_id is null and fa.d_custom_19_id is null))
               and ((ffs.d_custom_20_id = fa.d_custom_20_id) or (ffs.d_custom_20_id is null and fa.d_custom_20_id is null))
           )
        ) a;
    end;

    /**
    *
    */
    procedure processNewDataOnly(p_job_id number, p_batch_id number)
    is
    begin
        -- Insert into F_FILE
      insert into um.f_file
        select get_d_period(ffs.sample_date),
               ffs.f_file_id,
               ffs.sample_date,
               ffs.log_record_id,
               fa.f_attribute_id,
               ffs.edr_count,
               ffs.edr_value,
               ffs.edr_duration,
               ffs.edr_bytes
          from um.f_file_staging ffs, um.f_attribute fa
        where ffs.job_id = p_job_id
        and ffs.batch_id = p_batch_id
        and not exists (
             --Check there isn't a newer batch with this log record in...
             select 1
                  from um.f_file_staging ffs2
                 where 1 = 1
                   and ffs2.log_record_id = ffs.log_record_id
                   and ffs2.d_measure_type_id = ffs.d_measure_type_id
             and ffs2.batch_id > ffs.batch_id
        )
           and ffs.d_node_id = fa.d_node_id
           and ffs.d_source_id = fa.d_source_id
           and ffs.d_edr_type_id = fa.d_edr_type_id
           and ffs.d_measure_type_id = fa.d_measure_type_id
        and ((ffs.d_billing_type_id = fa.d_billing_type_id) or (ffs.d_billing_type_id is null and fa.d_billing_type_id is null))
        and ((ffs.d_payment_type_id = fa.d_payment_type_id) or (ffs.d_payment_type_id is null and fa.d_payment_type_id is null))
        and ((ffs.d_call_type_id = fa.d_call_type_id) or (ffs.d_call_type_id is null and fa.d_call_type_id is null))
        and ((ffs.d_customer_type_id = fa.d_customer_type_id) or (ffs.d_customer_type_id is null and fa.d_customer_type_id is null))
        and ((ffs.d_service_provider_id = fa.d_service_provider_id) or (ffs.d_service_provider_id is null and fa.d_service_provider_id is null))
        and ((ffs.d_custom_01_id = fa.d_custom_01_id) or (ffs.d_custom_01_id is null and fa.d_custom_01_id is null))
        and ((ffs.d_custom_02_id = fa.d_custom_02_id) or (ffs.d_custom_02_id is null and fa.d_custom_02_id is null))
        and ((ffs.d_custom_03_id = fa.d_custom_03_id) or (ffs.d_custom_03_id is null and fa.d_custom_03_id is null))
        and ((ffs.d_custom_04_id = fa.d_custom_04_id) or (ffs.d_custom_04_id is null and fa.d_custom_04_id is null))
        and ((ffs.d_custom_05_id = fa.d_custom_05_id) or (ffs.d_custom_05_id is null and fa.d_custom_05_id is null))
        and ((ffs.d_custom_06_id = fa.d_custom_06_id) or (ffs.d_custom_06_id is null and fa.d_custom_06_id is null))
        and ((ffs.d_custom_07_id = fa.d_custom_07_id) or (ffs.d_custom_07_id is null and fa.d_custom_07_id is null))
        and ((ffs.d_custom_08_id = fa.d_custom_08_id) or (ffs.d_custom_08_id is null and fa.d_custom_08_id is null))
        and ((ffs.d_custom_09_id = fa.d_custom_09_id) or (ffs.d_custom_09_id is null and fa.d_custom_09_id is null))
        and ((ffs.d_custom_10_id = fa.d_custom_10_id) or (ffs.d_custom_10_id is null and fa.d_custom_10_id is null))
        and ((ffs.d_custom_11_id = fa.d_custom_11_id) or (ffs.d_custom_11_id is null and fa.d_custom_11_id is null))
        and ((ffs.d_custom_12_id = fa.d_custom_12_id) or (ffs.d_custom_12_id is null and fa.d_custom_12_id is null))
        and ((ffs.d_custom_13_id = fa.d_custom_13_id) or (ffs.d_custom_13_id is null and fa.d_custom_13_id is null))
        and ((ffs.d_custom_14_id = fa.d_custom_14_id) or (ffs.d_custom_14_id is null and fa.d_custom_14_id is null))
        and ((ffs.d_custom_15_id = fa.d_custom_15_id) or (ffs.d_custom_15_id is null and fa.d_custom_15_id is null))
        and ((ffs.d_custom_16_id = fa.d_custom_16_id) or (ffs.d_custom_16_id is null and fa.d_custom_16_id is null))
        and ((ffs.d_custom_17_id = fa.d_custom_17_id) or (ffs.d_custom_17_id is null and fa.d_custom_17_id is null))
        and ((ffs.d_custom_18_id = fa.d_custom_18_id) or (ffs.d_custom_18_id is null and fa.d_custom_18_id is null))
        and ((ffs.d_custom_19_id = fa.d_custom_19_id) or (ffs.d_custom_19_id is null and fa.d_custom_19_id is null))
        and ((ffs.d_custom_20_id = fa.d_custom_20_id) or (ffs.d_custom_20_id is null and fa.d_custom_20_id is null));
    end;


    /**
    * If there are any represents in this data set then we ...
    */
    procedure processMixedData(p_batch_id number, v_max_sample_date date, v_min_sample_date date)
    is
       v_max_d_period_id date;
       v_min_d_period_id date;
    begin
        -- get min/max d_period_ids in staging table
        -- (needed for the partition pruning clauses
        v_min_d_period_id := get_d_period( v_min_sample_date );
        v_max_d_period_id := get_d_period( v_max_sample_date );

        -- Insert into F_FILE
        -- there may be many values - so we group/sum thus producing a single delta value for this reload
        insert /*+ append */ into F_FILE
        with t_matched_records as (
            select ffs.*,
                   fa.f_attribute_id
            from um.f_file_staging ffs
            inner join um.f_attribute fa
                    on ffs.d_node_id = fa.d_node_id
		           and ffs.d_source_id = fa.d_source_id
		           and ffs.d_edr_type_id = fa.d_edr_type_id
		           and ffs.d_measure_type_id = fa.d_measure_type_id
                   and ((ffs.d_billing_type_id = fa.d_billing_type_id) or (ffs.d_billing_type_id is null and fa.d_billing_type_id is null))
                   and ((ffs.d_payment_type_id = fa.d_payment_type_id) or (ffs.d_payment_type_id is null and fa.d_payment_type_id is null))
                   and ((ffs.d_call_type_id = fa.d_call_type_id) or (ffs.d_call_type_id is null and fa.d_call_type_id is null))
                   and ((ffs.d_customer_type_id = fa.d_customer_type_id) or (ffs.d_customer_type_id is null and fa.d_customer_type_id is null))
                   and ((ffs.d_service_provider_id = fa.d_service_provider_id) or (ffs.d_service_provider_id is null and fa.d_service_provider_id is null))
                   and ((ffs.d_custom_01_id = fa.d_custom_01_id) or (ffs.d_custom_01_id is null and fa.d_custom_01_id is null))
                   and ((ffs.d_custom_02_id = fa.d_custom_02_id) or (ffs.d_custom_02_id is null and fa.d_custom_02_id is null))
                   and ((ffs.d_custom_03_id = fa.d_custom_03_id) or (ffs.d_custom_03_id is null and fa.d_custom_03_id is null))
                   and ((ffs.d_custom_04_id = fa.d_custom_04_id) or (ffs.d_custom_04_id is null and fa.d_custom_04_id is null))
                   and ((ffs.d_custom_05_id = fa.d_custom_05_id) or (ffs.d_custom_05_id is null and fa.d_custom_05_id is null))
                   and ((ffs.d_custom_06_id = fa.d_custom_06_id) or (ffs.d_custom_06_id is null and fa.d_custom_06_id is null))
                   and ((ffs.d_custom_07_id = fa.d_custom_07_id) or (ffs.d_custom_07_id is null and fa.d_custom_07_id is null))
                   and ((ffs.d_custom_08_id = fa.d_custom_08_id) or (ffs.d_custom_08_id is null and fa.d_custom_08_id is null))
                   and ((ffs.d_custom_09_id = fa.d_custom_09_id) or (ffs.d_custom_09_id is null and fa.d_custom_09_id is null))
                   and ((ffs.d_custom_10_id = fa.d_custom_10_id) or (ffs.d_custom_10_id is null and fa.d_custom_10_id is null))
                   and ((ffs.d_custom_11_id = fa.d_custom_11_id) or (ffs.d_custom_11_id is null and fa.d_custom_11_id is null))
                   and ((ffs.d_custom_12_id = fa.d_custom_12_id) or (ffs.d_custom_12_id is null and fa.d_custom_12_id is null))
                   and ((ffs.d_custom_13_id = fa.d_custom_13_id) or (ffs.d_custom_13_id is null and fa.d_custom_13_id is null))
                   and ((ffs.d_custom_14_id = fa.d_custom_14_id) or (ffs.d_custom_14_id is null and fa.d_custom_14_id is null))
                   and ((ffs.d_custom_15_id = fa.d_custom_15_id) or (ffs.d_custom_15_id is null and fa.d_custom_15_id is null))
                   and ((ffs.d_custom_16_id = fa.d_custom_16_id) or (ffs.d_custom_16_id is null and fa.d_custom_16_id is null))
                   and ((ffs.d_custom_17_id = fa.d_custom_17_id) or (ffs.d_custom_17_id is null and fa.d_custom_17_id is null))
                   and ((ffs.d_custom_18_id = fa.d_custom_18_id) or (ffs.d_custom_18_id is null and fa.d_custom_18_id is null))
                   and ((ffs.d_custom_19_id = fa.d_custom_19_id) or (ffs.d_custom_19_id is null and fa.d_custom_19_id is null))
                   and ((ffs.d_custom_20_id = fa.d_custom_20_id) or (ffs.d_custom_20_id is null and fa.d_custom_20_id is null))
        ),
        t_staging_data as (
            select t_mr.*,
                   lrs.is_delta
            from t_matched_records t_mr
            inner join um.log_record_staging lrs
                    on lrs.log_record_id = t_mr.log_record_id
            where t_mr.batch_id = p_batch_id
            --and lrs.is_reload = 'Y'
            and not exists (
                --Check there isn't a newer batch with this log record in...
                select ffsg.log_record_id
                from um.f_file_staging ffsg
                where ffsg.log_record_id = t_mr.log_record_id
                and ffsg.d_measure_type_id = t_mr.d_measure_type_id
                and ffsg.batch_id > t_mr.batch_id
            )
        ),
        t_matched_f_file_sum as (
            select ff.log_record_id,
                   ff.f_attribute_id,
                   ff.sample_date,
                   sum(ff.edr_count) as current_edr_count_sum,
                   sum(ff.edr_value) as current_edr_value_sum,
                   sum(ff.edr_duration) as current_edr_duration_sum,
                   sum(ff.edr_bytes) as current_edr_bytes_sum
            from um.f_file ff
            where exists (
                select 1
                from t_matched_records t_mr
                where t_mr.log_record_id = ff.log_record_id
            )
            and ff.d_period_id between v_min_d_period_id and v_max_d_period_id
            group by ff.log_record_id, ff.f_attribute_id, ff.sample_date
        ), --select * from t_matched_f_file_sum
        t_matched_f_file_staging_sum as (
            select t_sd.log_record_id,
                   t_sd.f_attribute_id,
                   t_sd.is_delta,
                   t_sd.sample_date,
                   max(t_sd.f_file_id) as f_file_id,
                   sum(t_sd.edr_count) as current_edr_count_sum,
                   sum(t_sd.edr_value) as current_edr_value_sum,
                   sum(t_sd.edr_duration) as current_edr_duration_sum,
                   sum(t_sd.edr_bytes) as current_edr_bytes_sum
            from um.t_staging_data t_sd
            group by t_sd.log_record_id, t_sd.f_attribute_id, t_sd.is_delta, t_sd.sample_date
        ) --select * from t_matched_f_file_staging_sum
        select case when t_mffs.sample_date is null then um.etl.get_d_period(t_mffss.sample_date)
                   else um.etl.get_d_period(t_mffs.sample_date)
               end,
               t_mffss.f_file_id,
               case when t_mffs.sample_date is null then t_mffss.sample_date
                   else t_mffs.sample_date
               end,
               t_mffss.log_record_id,
               t_mffss.f_attribute_id,
               decode(t_mffss.is_delta, 'Y', t_mffss.current_edr_count_sum, (t_mffss.current_edr_count_sum-nvl(t_mffs.current_edr_count_sum,0))),
               decode(t_mffss.is_delta, 'Y', t_mffss.current_edr_value_sum, (t_mffss.current_edr_value_sum-nvl(t_mffs.current_edr_value_sum,0))),
               decode(t_mffss.is_delta, 'Y', t_mffss.current_edr_duration_sum, (t_mffss.current_edr_duration_sum-nvl(t_mffs.current_edr_duration_sum,0))),
               decode(t_mffss.is_delta, 'Y', t_mffss.current_edr_bytes_sum, (t_mffss.current_edr_bytes_sum-nvl(t_mffs.current_edr_bytes_sum,0)))
        from t_matched_f_file_staging_sum t_mffss
        left outer join t_matched_f_file_sum t_mffs
                on t_mffs.log_record_id = t_mffss.log_record_id
               and t_mffs.f_attribute_id = t_mffss.f_attribute_id;


        -- insert metrics to be regenerated
        -- ie. where log_record_id exists in fmo_fileset and those filesets exists in f_metric
        insert into um.metric_regen_queue mrq (f_metric_id, regen_reason)
        select distinct fm.f_metric_id,
               'R'
        from log_record_staging lrs, fmo_fileset ff, f_metric fm
        where lrs.is_reload = 'Y'
        and lrs.batch_id = p_batch_id
        and lrs.log_record_id = ff.log_record_id
        and (ff.fileset_id = fm.i_fileset_id OR ff.fileset_id = fm.j_fileset_id)
        and (ff.d_period_id between v_min_d_period_id AND v_max_d_period_id)
        and (fm.d_period_id between v_min_d_period_id AND v_max_d_period_id);

        -- insert mrecs to be regenerated
        -- ie. where log_record_id exists in fmo_fileset and those filesets exists in mrec_fileset
        insert into um.mrec_regen_queue mrq (mrec_id, d_period_id, regen_reason)
        select distinct
        mr.mrec_id,
        mr.mrec_d_period_id,
        'R'
        from um.log_record_staging lrs
        inner join um.fmo_fileset ff on ff.log_record_id = lrs.log_record_id
        inner join um.mrec_fileset mr on (ff.fileset_id = mr.fileset_id)
                                      and (ff.d_period_id = mr.fileset_d_period_id)
        where lrs.is_reload = 'Y'
        and lrs.batch_id = p_batch_id
        and (ff.d_period_id between v_min_d_period_id AND v_max_d_period_id);

    end;

    /**
    *
    */
    procedure mergeInto_AGG_F_FILE(p_job_id number, p_batch_id number)
    is
    begin
        -- Merge into AGG_F_FILE
        MERGE INTO AGG_F_FILE a
        USING  ( select trunc(SAMPLE_DATE) D_DAY_ID,
                 D_EDR_TYPE_ID D_EDR_TYPE_ID,
                 D_NODE_ID D_NODE_ID,
                 D_MEASURE_TYPE_ID D_MEASURE_TYPE_ID,
                 D_SOURCE_ID D_SOURCE_ID,
                 sum(fsg.EDR_COUNT) EDR_COUNT,
                 sum(fsg.EDR_DURATION) EDR_DURATION,
                 sum(fsg.EDR_VALUE) EDR_VALUE,
                 sum(fsg.EDR_BYTES) EDR_BYTES,
                 count(fsg.EDR_COUNT) EDR_COUNT_COUNT,
                 count(fsg.EDR_DURATION) EDR_DURATION_COUNT,
                 count(fsg.EDR_VALUE) EDR_VALUE_COUNT,
                 count(fsg.EDR_BYTES) EDR_BYTES_COUNT,
                 count(*) f_file_count,
                 DBMS_MVIEW.PMARKER(fsg.ROWID) f_file_pmarker
           from F_FILE_STAGING fsg
           where
           fsg.job_id = p_job_id
           and BATCH_ID = p_batch_id
           and
           not exists (select log_record_id
                        from F_FILE_STAGING fsg2
                        where fsg2.log_record_id = fsg.log_record_id
                          and fsg2.d_measure_type_id = fsg.d_measure_type_id
                          and fsg2.batch_id > fsg.batch_id
                        )
           group by trunc(SAMPLE_DATE),
                    D_EDR_TYPE_ID,
                    D_NODE_ID,
                    D_MEASURE_TYPE_ID,
                    D_SOURCE_ID,
                    DBMS_MVIEW.PMARKER(fsg.ROWID) ) m
            ON (a.d_day_id = m.d_day_id
                AND a.d_edr_type_id = m.d_edr_type_id
                AND a.d_node_id = m.d_node_id
                AND a.d_measure_type_id = m.d_measure_type_id
                AND a.d_source_id = m.d_source_id )
            WHEN MATCHED THEN UPDATE
                 SET a.edr_count = a.edr_count + m.edr_count,
                     a.edr_duration = a.edr_duration + m.edr_duration,
                     a.edr_value = a.edr_value + m.edr_value,
                     a.edr_bytes = a.edr_bytes + m.edr_bytes,
                     a.edr_count_count = a.edr_count_count + m.edr_count_count,
                     a.edr_duration_count = a.edr_duration_count + m.edr_duration_count,
                     a.edr_value_count = a.edr_value_count + m.edr_value_count,
                     a.edr_bytes_count = a.edr_bytes_count + m.edr_bytes_count
            WHEN NOT MATCHED THEN INSERT
                ( d_day_id,
                  d_edr_type_id,
                  d_node_id,
                  d_measure_type_id,
                  d_source_id,
                  edr_count,
                  edr_duration,
                  edr_value,
                  edr_bytes,
                  edr_count_count,
                  edr_duration_count,
                  edr_value_count,
                  edr_bytes_count,
                  f_file_count,
                  f_file_pmarker )
              VALUES
                ( m.d_day_id,
                  m.d_edr_type_id,
                  m.d_node_id,
                  m.d_measure_type_id,
                  m.d_source_id,
                  m.edr_count,
                  m.edr_duration,
                  m.edr_value,
                  m.edr_bytes,
                  m.edr_count_count,
                  m.edr_duration_count,
                  m.edr_value_count,
                  m.edr_bytes_count,
                  m.f_file_count,
                  m.f_file_pmarker );


    end;


  /*******
  *  update the LATE_FILE_MATCH_QUEUE table
  *  set status = 'L' for loaded late files
  *********/
  procedure updateLateFileMatchQueue is
  begin
    -- update the LATE_FILE_MATCH_QUEUE table
    -- set status = 'L' for loaded late files
    update late_file_match_queue lfq
    set lfq.status = 'L'
    where exists
    (
       select null
       from log_record lr
       where lr.d_period_id = get_d_period(lfq.sample_date)
       and lr.log_record_id = lfq.log_record_id
    )
    and
      lfq.status = 'S';
  end updateLateFileMatchQueue;


  /***
  * wait for n seconds
  ****/
  procedure sleep(n integer) is
  begin
    dbms_lock.sleep(n);
  end;

  /**************
  * Return the d_period resolution for a particular day in minutes
  **************/
  function getDPeriodResolutionMinutes(a_day date) return integer is

    d_period_res integer;
  begin

    -- get the d_period resolution in minutes
    select trunc(1440 / count(*))
      into d_period_res
      from d_period
     where trunc(d_period_id) = trunc(a_day);

    return d_period_res;
  end;


  ------------------------------------------------------------
  -- Split strings into tokens

  -- Example:
  -- select
  --   get_token('foo,bar,baz',1), -- 'foo'
  --   get_token('foo,bar,baz',3), -- 'baz'
  --   get_token('a,,b',2),        -- '' (null)
  --   get_token('a,,b',3),        -- 'b'
  --   get_token('a|b|c',2,'|'),   -- 'b'
  --   get_token('a|b|c',4,'|')    -- '' (null)
  -- from
  --   dual
  ------------------------------------------------------------
  function get_token(
    the_list  varchar2,
    the_index number,
    delim     varchar2 := ','
  )
    return   varchar2
  is
    start_pos number;
    end_pos   number;
  begin
    if the_index = 1 then
        start_pos := 1;
    else
        start_pos := instr(the_list, delim, 1, the_index - 1);
        if start_pos = 0 then
            return null;
        else
            start_pos := start_pos + length(delim);
        end if;
    end if;

    end_pos := instr(the_list, delim, start_pos, 1);

    if end_pos = 0 then
        return substr(the_list, start_pos);
    else
        return substr(the_list, start_pos, end_pos - start_pos);
    end if;

  end get_token;

  /*******************************************************************
  * Returns the value of the parameter in p_str                      *
  * e.g.   p_str = "-node 71 -match 6 -load_type 1 -threads 1 -offset 2 -weekday 1"
  *        get_parameter(p_str, '-match') returns 6
  *******************************************************************/
  FUNCTION get_parameter (p_str IN VARCHAR2,
                          p_parameter IN VARCHAR2)
  RETURN VARCHAR2 
  DETERMINISTIC IS
    begin_idx INTEGER := 0;
    end_idx INTEGER := 0;
  BEGIN
    begin_idx := INSTR(p_str, p_parameter);

    -- eat leading whitespace
    IF begin_idx > 0 THEN
      begin_idx := begin_idx + LENGTH(p_parameter);
      WHILE SUBSTR(p_str, begin_idx, 1) = ' ' LOOP
        begin_idx := begin_idx + 1;
      END LOOP;
    END IF;

    end_idx := INSTR(p_str, ' ', begin_idx);

    IF begin_idx > 0 THEN

      -- parameter value goes to end-of-line
      IF end_idx = 0 THEN
          end_idx := LENGTH(p_str) + 1;
      END IF;

      RETURN SUBSTR(p_str, begin_idx, end_idx - begin_idx);

    END IF;

    RETURN NULL;
  END;

  procedure insertIntoFmo_Match_Queue (p_batch_id number)
  is
  begin
  insert into um.fmo_match_queue
    (d_period_id,
     log_record_id,
     node_id,
     file_name,
     out_file_name,
     file_type,
     sample_date,
     creation_date,
     i_checksum,
     j_checksum,
     operator_id,
     thread_id,
     source_id,
     batch_id)
     SELECT
     d_period_id,
     log_record_id,
     node_id,
     file_name,
     out_file_name,
     file_type,
     sample_date,
     creation_date,
     i_checksum,
     j_checksum,
     operator_id,
     thread_id,
     source_id,
     batch_id
     FROM um.fmo_match_queue_staging stg
     WHERE stg.batch_id = p_batch_id;

  end insertIntoFmo_Match_Queue;


  procedure insertIntoFmo_Match_Count(p_batch_id number) is
  begin
      insert into um.fmo_match_count
      (log_record_id, node_id, edge_id, match_count, match_direction)
      select mq.log_record_id,
           mq.node_id,
           EMR.EDGE_ID AS EDGE_ID,
           EMR.Expected_Match_Count as MATCH_COUNT,
           (select (decode((select edge_id
                             from dgf.edge_ref
                            where edge_id = EMR.EDGE_ID
                              and I_node_id = mq.node_id),
                           EMR.EDGE_ID,
                           'S',
                           'P'))
              from dual) as MATCH_DIRECTION

      from um.expected_matches_ref EMR, um.fmo_match_queue_staging mq

      where mq.source_id = emr.source_id
        AND mq.log_record_id = mq.log_record_id
        AND mq.node_id = EMR.NODE_ID
        AND mq.batch_id = p_batch_id;

  end insertIntoFmo_Match_Count;

  procedure writeDebug(tmpStatusTble varchar2,
                       p_batch_id    varchar2,
                       p_status      varchar2,
                       p_msg         varchar2) is
    --PRAGMA AUTONOMOUS_TRANSACTION;
    v_sql varchar2(2000);
    v_msg varchar2(2000);
  begin
  
    v_msg := to_char(sysdate, 'dd-mm-yyyy hh24:mi:ss') || ' ' || p_msg;
  
    -- log/status message to tmpStatusTble
    v_sql := 'insert into ' || tmpStatusTble ||
             ' (gdlJobId, status, msg) values (';
    v_sql := v_sql || p_batch_id || ', ' || p_status || ', ''' || v_msg ||
             ''')';
  
    execute immediate v_sql;
  
  end;

end etl;
/
exit;
