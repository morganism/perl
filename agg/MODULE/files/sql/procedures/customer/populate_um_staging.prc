create or replace procedure populate_um_staging ( p_job_id in  NUMBER
                                                , p_batch_id   NUMBER
                                                , p_table_name VARCHAR2
                                                , p_partition  VARCHAR2 default 'Y'
                                                , p_debug      VARCHAR2 default 'Y'
                                                ) IS
/*****************************************************************************************
** Procedure populate_um_staging.prc
**
** This procedure moves data from the CUSTOMER staging tables to the UM staging tables.
** Called from a GDL POST action.
**
** Author: Steve Makinson, Cartesian Jan 2011
**
*****************************************************************************************/

-- Variables for message logging
v_ModuleName varchar2(50) := 'customer.populate_um_staging';
v_Message    varchar2(500);
v_Recs       number;
v_start      timestamp;
v_end        timestamp;
v_interval   interval day(9) to second(6);
v_elapsed    number;

v_sql varchar2(8000);

v_DS          varchar2(10);
v_cap         integer;
v_cap_default integer;
v_sysdate     date;
v_offset_date date;
v_cap_date    date;
v_max_age     date;

v_node_id     number;

v_default_edr_type number;

begin

--------------------------------------------------
-- Gather some parameters
--------------------------------------------------
-- fix the processing date to the start of the multi-job
select nvl(m.requested_start_time,j.actual_start_time)
--      ,j.job_id
--      ,c.parent_job_id
into v_sysdate
from jobs.job                  j
left join
      jobs.multi_job_component c
on j.job_id = c.job_id
left join
      jobs.multi_job           m
on m.multi_job_id = c.parent_job_id
where j.job_id = p_job_id;

-- the cap parameter - the number of days after which we give up recalculating
select pv.value
into v_cap_default
from       utils.parameter_values pv
inner join utils.parameter_set_ref psr
   on psr.parameter_set_id = pv.parameter_set_id
where pv.name = 'CAP_WINDOW'
  and psr.description = 'UM ETL';
-- What happens if no record found? Should stop / error.

-- get the feed name from the staging table
select substr(upper(p_table_name)
        ,instr(upper(p_table_name),'DS',-1)) -- It is fair to assume the staging tables will not change name
into v_DS
from dual;
v_Message := 'DS is '||v_DS;
utils.putmessage(v_ModuleName, v_Message, p_job_id, p_debug);

-- Now work out the cut-off dates used below
select trunc(v_sysdate - dff.latency)
      ,trunc(v_sysdate - dff.latency - nvl(dff.cap,v_cap_default))
into  v_offset_date
     ,v_cap_date
from customer.data_feed_frequency_ref dff
where dff.node = v_DS;

-- get node_id

begin
  select node_id
  into   v_node_id
  from   dgf.node_ref
  where  description = v_DS;
exception
    when others then
      
         begin            
           select node_id
	   into   v_node_id
           from   customer.data_feed_frequency_ref f
           where  f.node = v_DS;         
         exception
            when others then
    
                 v_node_id := -1;
         end;
end;

-- Load Staged Data can't handle records which don't have a matching d_period date
select min(d_period_id) into v_max_age from um.d_period;

--gather stats so things don't take forever
dbms_stats.gather_table_stats('customer',replace(p_table_name,'customer.'));

--------------------------------------------------
-- Start by creating the partitions to load data
--------------------------------------------------
if p_partition = 'Y' then
  createStagingPartitions(p_job_id);
end if;

--------------------------------------------------
-- Now go on to move data into UM Staging tables
--------------------------------------------------
----------- message -------------
v_sql := 'select count(*) from '||p_table_name;
execute immediate v_sql into v_Recs;
select current_timestamp into v_start from dual;
v_Message := 'Processing '||v_Recs||' records from '||upper(p_table_name);
utils.putmessage(v_ModuleName, v_Message, p_job_id, p_debug);
----------- message -------------

-----------------------------------------------------------------------------------
-- Populate the log_record_id for STAGING records having FILENAME that already
-- exists in um.log_record. From this point on, the presence of a non-null value
-- in log_record_id indicates that the STAGING record has been represented.
-----------------------------------------------------------------------------------

v_sql := 'update '||p_table_name||' stg'||
'         set    log_record_id = (select max(lr.log_record_id) '||
'                                 from   um.log_record lr,     '||
'                                        dgf.node_ref nr,      '||
'                               (                              '||
'                                select *                      '||
'                                from   um.source_desc_ref     '||
'                                union                         '||
'                                select ' || v_node_id || ', ''UNKNOWN'', -1 '||
'                                from   dual                                '||
'                               ) sd                                        '||
'                        where lr.node_id = nr.node_id                      '||
'                        and   lr.source_id = sd.source_id                  '||
'                        and   nr.description = substr(stg.umidentifier,1,instr(stg.umidentifier,''.'') -1)   '||
'                        and  (    sd.source_description = stg.neid  '||
'                               or ( not exists ( '||
'                                                select 1 '||
'                                                from   um.source_desc_ref sd '||
'                                                where  sd.node_id = nr.node_id '||
'                                                and    sd.source_description = stg.neid  '||
'                                               ) '||
'                                    and lr.source_id = -1  '||
'                                  ) '||
'                              ) '||
'                        and lr.file_name = stg.currentdir '|| -- note that currentdir also contains the filename in edr_filename
'                        and stg.timeslot = lr.d_period_id '||
'                        and lr.d_period_id > '''||v_cap_date||''''||
'                      ) '||
'where exists (  select 1 '||
'                from   um.log_record lr,                   '||
'                       dgf.node_ref nr,                    '||
'                       (                                   '||
'                        select *                           '||
'                        from   um.source_desc_ref          '||
'                        union                              '||
'                        select ' || v_node_id || ', ''UNKNOWN'', -1        '||
'                        from   dual '||
'                       ) sd  '||
'                where lr.node_id = nr.node_id '||
'                and   lr.source_id = sd.source_id '||
'                and   nr.description = substr(stg.umidentifier,1,instr(stg.umidentifier,''.'') -1)  '||
'                and  (    sd.source_description = stg.neid   '||
'                       or ( not exists ( '||
'                                        select 1 '||
'                                        from   um.source_desc_ref sd '||
'                                        where  sd.node_id = nr.node_id '||
'                                        and    sd.source_description = stg.neid  '||
'                                       ) '||
'                            and lr.source_id = -1  '||
'                          ) '||
'                      ) '||
'                and lr.file_name = stg.currentdir  '||-- note that currentdir also contains the filename in edr_filename
'                and stg.timeslot = lr.d_period_id   '||
'                and lr.d_period_id > '''||v_cap_date||''''||
'              ) ';

execute immediate v_sql;

----------- message -------------
select current_timestamp into v_end from dual;
v_interval := v_end - v_start;
v_elapsed  := abs(extract(second from v_interval)
                + extract(minute from v_interval)*60
                + extract(hour from v_interval)*60*60
                + extract(day from v_interval)*24*60*60);
v_Message := to_char(v_elapsed,'900000000000.000')||' seconds to update LOG_RECORD_ID on STAGING table'||p_table_name;
utils.putmessage(v_ModuleName, v_Message, p_job_id, p_debug);
v_start := v_end;
----------- message -------------

--
-- Need to check LOG_RECORD_STAGING as well, for recently loaded records
--
-- Is there a faster way to do this reliably?
--


v_sql := 'update '||p_table_name||' stg'||
'         set    log_record_id = (select max(lrs.log_record_id) '||
'                                 from   um.log_record_STAGING lrs,     '||
'                                        dgf.node_ref nr,      '||
'                               (                              '||
'                                select *                      '||
'                                from   um.source_desc_ref     '||
'                                union                         '||
'                                select ' || v_node_id || ', ''UNKNOWN'', -1 '||
'                                from   dual                                '||
'                               ) sd                                        '||
'                        where lrs.node_id = nr.node_id                      '||
'                        and   lrs.source_id = sd.source_id                  '||
'                        and   nr.description = substr(stg.umidentifier,1,instr(stg.umidentifier,''.'') -1)   '||
'                        and  (    sd.source_description = stg.neid  '||
'                               or ( not exists ( '||
'                                                select 1 '||
'                                                from   um.source_desc_ref sd '||
'                                                where  sd.node_id = nr.node_id '||
'                                                and    sd.source_description = stg.neid  '||
'                                               ) '||
'                                    and lrs.source_id = -1  '||
'                                  ) '||
'                              ) '||
'                        and lrs.file_name = stg.currentdir '|| -- note that currentdir also contains the filename in edr_filename
'                        and stg.timeslot = lrs.sample_date '||
'                      ) '||
'where exists (  select 1 '||
'                from   um.log_record_STAGING lrs,          '||
'                       dgf.node_ref nr,                    '||
'                       (                                   '||
'                        select *                           '||
'                        from   um.source_desc_ref          '||
'                        union                              '||
'                        select ' || v_node_id || ', ''UNKNOWN'', -1        '||
'                        from   dual '||
'                       ) sd  '||
'                where lrs.node_id = nr.node_id '||
'                and   lrs.source_id = sd.source_id '||
'                and   nr.description = substr(stg.umidentifier,1,instr(stg.umidentifier,''.'') -1)  '||
'                and  (    sd.source_description = stg.neid   '||
'                       or ( not exists ( '||
'                                        select 1 '||
'                                        from   um.source_desc_ref sd '||
'                                        where  sd.node_id = nr.node_id '||
'                                        and    sd.source_description = stg.neid  '||
'                                       ) '||
'                            and lrs.source_id = -1  '||
'                          ) '||
'                      ) '||
'                and lrs.file_name = stg.currentdir  '||-- note that currentdir also contains the filename in edr_filename
'                and stg.timeslot = lrs.sample_date         '||
'                and stg.timeslot > '''||v_cap_date||''''||
'              ) ';

execute immediate v_sql;

----------- message -------------
select current_timestamp into v_end from dual;
v_interval := v_end - v_start;
v_elapsed  := abs(extract(second from v_interval)
                + extract(minute from v_interval)*60
                + extract(hour from v_interval)*60*60
                + extract(day from v_interval)*24*60*60);
v_Message := to_char(v_elapsed,'900000000000.000')||' seconds for 2nd update LOG_RECORD_ID on STAGING table'||p_table_name;
utils.putmessage(v_ModuleName, v_Message, p_job_id, p_debug);
v_start := v_end;
----------- message -------------

-----------------------------------------------------------------------------------
-- Promote records from CUSTOMER STAGING table to LOG_RECORD_STAGING, looking up
-- source and node ids etc., on the way...
-----------------------------------------------------------------------------------
v_sql := 'insert into um.log_record_staging'||
'  (JOB_ID,'||
'   BATCH_ID,'||
'   SAMPLE_DATE,'||
'   LOG_RECORD_ID,'||
'   NODE_ID,'||
'   SOURCE_ID,'||
'   FILE_TYPE,'||
'   PROCESS_DATE,'||
'   CREATION_DATE,'||
'   RECORD_NO,'||
'   RECORD_CHECKSUM,'||
'   IS_MISSING_PREDECESSOR,'||
'   IS_MISSING_SUCCESSOR,'||
'   FILE_NAME,'||
'   OUT_FILE_NAME,'||
'   IS_RELOAD,'||
'   IS_DELTA)'||
'  select JOB_ID,'||
'         BATCH_ID,'||
'         SAMPLE_DATE,'||
'         nvl(LOG_RECORD_ID, um.seq_log_record_id.nextval) LOG_RECORD_ID,'||
'         NODE_ID,'||
'         SOURCE_ID,'||
'         FILE_TYPE,'||
'         PROCESS_DATE,'||
'         CREATION_DATE,'||
'         RECORD_NO,'||
'         RECORD_CHECKSUM,'||
'         IS_MISSING_PREDECESSOR,'||
'         IS_MISSING_SUCCESSOR,'||
'         FILE_NAME,'||
'         OUT_FILE_NAME,'||
'         IS_RELOAD,'||
'         IS_DELTA'||
'    from (select '||
'         '||p_job_id||' JOB_ID,'||
'         '||p_batch_id||' BATCH_ID,'||
'          q1.stg_timeslot SAMPLE_DATE,'||
'          q1.stg_log_record_id         LOG_RECORD_ID,'||
'          nvl(q1.node_node_id, -1) NODE_ID,'||    -- not really substituting a default as -1 is not a valid node_id
'          nvl(sd.source_id, -1)    SOURCE_ID,'||  -- not really substituting a default as -1 is not a valid source_id
'          ''L''                    FILE_TYPE,'||
'          max(q1.stg_processdate)  PROCESS_DATE,'||
'        '''||v_sysdate||'''     CREATION_DATE,'||
'          null          RECORD_NO,'||
'          null          RECORD_CHECKSUM,'||
'          ''N''         IS_MISSING_PREDECESSOR,'||
'          ''N''         IS_MISSING_SUCCESSOR,'||
'          q1.stg_fileandpath FILE_NAME,'||
'          null               OUT_FILE_NAME,'||
--reload:
'case '||
     /* 1) b) file HAS been seen before and match NOT YET run*/
'     when q1.stg_log_record_id is NOT null '||
'      AND q1.stg_timeslot > '''||v_offset_date||''' '||
'       then ''Y'' '||
     /* 2) b) file HAS been seen before and match HAS run AND is within processing window*/
'     when q1.stg_log_record_id is NOT null '||
'      AND q1.stg_timeslot between '''||v_cap_date||''' and '''||v_offset_date||'''  '||
'       then ''Y'' '||
     /* 1) a) file HAS NOT seen and match NOT YET run*/
'     when q1.stg_log_record_id is null '||
'      AND q1.stg_timeslot > '''||v_offset_date||''' '||
'       then ''N'' '||
     /* 2) a) file HAS NOT seen and match HAS run AND is within processing window*/
'     when q1.stg_log_record_id is null '||
'      AND q1.stg_timeslot between '''||v_cap_date||''' and '''||v_offset_date||'''  '||
'       then ''Y''  '||
     /* 3) a) and 3) b) File is really old and will only be used for mrecs*/
'     when q1.stg_timeslot < '''||v_cap_date||''' '||
'       then ''N'' '||
'     else ''N'''|| -- NEEDS AN ELSE CLAUSE
'     end  IS_RELOAD,  '||
--delta:
'case '||
     /* 1) b) file HAS been seen before and match NOT YET run*/
'     when q1.stg_log_record_id is NOT null '||
'      AND q1.stg_timeslot > '''||v_offset_date||''' '||
'       then ''N'' '||
     /* 2) b) file HAS been seen before and match HAS run AND is within processing window*/
'     when q1.stg_log_record_id is NOT null '||
'      AND q1.stg_timeslot between '''||v_cap_date||''' and '''||v_offset_date||'''  '||
'       then ''N'' '||
     /* 1) a) file HAS NOT seen and match NOT YET run*/
'     when q1.stg_log_record_id is null '||
'      AND q1.stg_timeslot > '''||v_offset_date||''' '||
'       then ''N'' '||
     /* 2) a) file HAS NOT seen and match HAS run AND is within processing window*/
'     when q1.stg_log_record_id is null'||
'      AND q1.stg_timeslot between '''||v_cap_date||''' and '''||v_offset_date||'''  '||
'       then ''Y'' '||
     /* 3) a) and 3) b) File is really old and will only be used for mrecs*/
'     when q1.stg_timeslot < '''||v_cap_date||''' '||
'       then ''N'''||
'     else ''N'''|| -- NEEDS AN ELSE CLAUSE
'     end IS_DELTA'||
'          from (select ds.currentdir  stg_fileandpath'|| -- combine them here [once] for efficiency
'                      ,ds.neid          stg_source_description'||
'                      ,ds.log_record_id stg_log_record_id'||
'                      ,ds.processdate   stg_processdate'||
'                      ,ds.timeslot      stg_timeslot'||
'                      ,nr.node_id       node_node_id'||
'                 from '||p_table_name||' ds '||
'                  left join dgf.node_ref nr '||
'                  on nr.description = substr(ds.umidentifier,1,instr(ds.umidentifier,''.'') -1)'||
'               ) q1'||
'           left join um.source_desc_ref sd'||
'             on sd.source_description = q1.stg_source_description'||
'            and sd.node_id            = q1.node_node_id'||
'          where q1.stg_timeslot >= '''||v_max_age||''' '||
'         group by q1.stg_fileandpath'||
'                 ,q1.node_node_id'||
'                 ,sd.source_id'||
'                 ,q1.stg_timeslot'||
'                 ,q1.stg_log_record_id'||  -- NOT SURE ABOUT THIS! Think it's OK.
'         )';                               -- Added to GROUP BY after the UPDATE(s) added
                                            -- at the top of the procedure.
/*
dbms_output.put_line('--length of SQL = '||length(v_sql));
dbms_output.put_line(substr(v_sql,0001,1000));
dbms_output.put_line(substr(v_sql,1001,1000));
dbms_output.put_line(substr(v_sql,2001,1000));
dbms_output.put_line(substr(v_sql,3001,1000));
dbms_output.put_line(substr(v_sql,4001,1000));
*/

execute immediate v_sql;

----------- message -------------
select current_timestamp into v_end from dual;
v_interval := v_end - v_start;
v_elapsed  := abs(extract(second from v_interval)
                + extract(minute from v_interval)*60
                + extract(hour from v_interval)*60*60
                + extract(day from v_interval)*24*60*60);
v_Message := to_char(v_elapsed,'900000000000.000')||' seconds to load LOG_RECORD_STAGING';
utils.putmessage(v_ModuleName, v_Message, p_job_id, p_debug);
v_start := v_end;
----------- message -------------

-----------------------------------------------------------------------------------
-- Promote records from CUSTOMER STAGING table to F_FILE_STAGING - needs to
-- reference records just added to LOG_RECORD_STAGING to get the IDs
-----------------------------------------------------------------------------------
-- First look up the default EDR_TYPE value for use later
v_default_edr_type := -1; -- a default

select detm.d_edr_type_id
into v_default_edr_type
from um.d_edr_type_mv detm
where detm.edr_type_uid = -1;

v_sql := 'insert into um.f_file_staging'||
'      (JOB_ID,'||
'       BATCH_ID,'||
'       SAMPLE_DATE,'||
'       F_FILE_ID,'||
'       D_NODE_ID,'||
'       D_SOURCE_ID,'||
'       D_EDR_TYPE_ID,'||
'       D_MEASURE_TYPE_ID,'||
'       D_BILLING_TYPE_ID,'||
'       D_PAYMENT_TYPE_ID,'||
'       D_CALL_TYPE_ID,'||
'       D_CUSTOMER_TYPE_ID,'||
'       D_SERVICE_PROVIDER_ID,'||
'       LOG_RECORD_ID,  '||
'       EDR_COUNT,'||
'       EDR_VALUE,'||
'       EDR_DURATION,'||
'       EDR_BYTES,'||
'       D_CUSTOM_01_ID)'||
'            Select'||
'          '||p_job_id||' JOB_ID,'||
'          '||p_batch_id||' BATCH_ID,'||
'             stg.sample_date,'||
'             um.seq_f_file_id.nextval              F_FILE_ID,'||
'             stg.node_id                           D_NODE_ID,'||
'             stg.source_id                         D_SOURCE_ID,'||
'             nvl(detm.d_edr_type_id,'||v_default_edr_type||') D_EDR_TYPE_ID,'||
'             100                                   D_MEASURE_TYPE_ID,'||
'             null                                  D_BILLING_TYPE_ID,'||
'             -1                                    D_PAYMENT_TYPE_ID,'||
'             -1                                    D_CALL_TYPE_ID,'||
'             -1                                    D_CUSTOMER_TYPE_ID,'||
'             -1                                    D_SERVICE_PROVIDER_ID,'||
'             lr.log_record_id                      LOG_RECORD_ID,'||
'             stg.eventcount                        EDR_COUNT,'||
'             stg.sumvalue                          EDR_VALUE,'||
'             stg.sumduration                       EDR_DURATION,'||
'             stg.sumbytes                          EDR_BYTES,'||
'             nvl(c1.d_custom_01_id, -1)            D_CUSTOM_01_ID'||
'         from (select '||
'                      currentdir    fileandpath'||
'                     ,neid  source_description'||
'                     ,umidentifier'||
'                     ,usagetype'||
'                     ,timeslot sample_date'||
'                     ,servicetype'||
'                     ,eventcount'||        -- picking just the columns needed from staging
'                     ,sumduration'||       -- and deriving the columns that need processing
'                     ,sumbytes'||
'                     ,sumvalue'||
'                     ,nvl(nr.node_id, -1) node_id ' ||
'                     ,nvl(sd.source_id, -1) source_id ' ||
'                 from '||p_table_name ||  ' s '||
'                 left join dgf.node_ref nr ' ||
'                      on nr.description = substr(s.umidentifier,1,instr(s.umidentifier,''.'') -1)'||
'                 left join um.source_desc_ref sd ' ||
'                      on  sd.source_description = s.neid'||
'                      and sd.node_id = nr.node_id '||
'             ) stg'||
'        inner join um.log_record_staging   lr'||
'           on lr.file_name          = stg.fileandpath'||
'          and lr.sample_date        = stg.sample_date'||
'          and lr.node_id            = stg.node_id '||
'          and lr.source_id          = stg.source_id '||
-- LR insert above creates 1 rec per combination of
-- stg_fileandpath, node_id, source_id and stg_timeslot
-- but we don't need to join back to it using all these keys
'         left join um.d_custom_01                   c1'||
'           on c1.custom_type = stg.servicetype'||
'          left join um.d_edr_type_mv detm'||
'           on upper(detm.edr_type) = upper(stg.usagetype)'||
'          and detm.edr_direction = ''Other'''||
'       where  lr.job_id    = '||p_job_id||
'       and    lr.batch_id  = '||p_batch_id;

/*
dbms_output.put_line('--length of SQL = '||length(v_sql));
dbms_output.put_line(substr(v_sql,0001,1000));
dbms_output.put_line(substr(v_sql,1001,1000));
dbms_output.put_line(substr(v_sql,2001,1000));
dbms_output.put_line(substr(v_sql,3001,1000));
dbms_output.put_line(substr(v_sql,4001,1000));
*/
execute immediate v_sql;

----------- message -------------
select current_timestamp into v_end from dual;
v_interval := v_end - v_start;
v_elapsed  := abs(extract(second from v_interval)
                + extract(minute from v_interval)*60
                + extract(hour from v_interval)*60*60
                + extract(day from v_interval)*24*60*60);
v_Message := to_char(v_elapsed,'900000000000.000')||' seconds to load F_FILE_STAGING';
utils.putmessage(v_ModuleName, v_Message, p_job_id, p_debug);
----------- message -------------

-- add any log records which fall outside the scheduled match window to late processing queue
v_sql := 'insert into um.late_file_match_queue '||
'select lrs.log_record_id, lrs.sample_date, lrs.node_id, null, ''L'' '||
'      from um.log_record_staging lrs '||
'     where not exists (select 1  '|| --only new records
'              from um.log_record lr  '||
'             where lr.log_record_id = lrs.log_record_id  '||
'               and um.etl.get_d_period(lrs.sample_date) != lr.d_period_id) '||
'       and lrs.sample_date between '''||v_cap_date||''' and '''||v_offset_date||'''  '|| --where match and metrics have already run but is within processing window
'       and lrs.is_reload = ''Y'' ' || --and metrics due to be regenerated
'       and lrs.job_id = '|| p_job_id;


execute immediate v_sql;

----------- message -------------
select current_timestamp into v_end from dual;
v_interval := v_end - v_start;
v_elapsed  := abs(extract(second from v_interval)
                + extract(minute from v_interval)*60
                + extract(hour from v_interval)*60*60
                + extract(day from v_interval)*24*60*60);
v_Message := to_char(v_elapsed,'900000000000.000')||' seconds to insert into LATE_FILE_MATCH_QUEUE';
utils.putmessage(v_ModuleName, v_Message, p_job_id, p_debug);
v_start := v_end;
----------- message -------------

-- remove reload flag from these records otherwise the metrics will be regenerated twice (once by regen job, once by filter late filesets)
v_sql := 'update um.log_record_staging lrs '||
'   set lrs.is_reload = ''N'' '||
' where not exists (select 1 '||
'          from um.log_record lr '||
'         where lr.log_record_id = lrs.log_record_id '||
'           and um.etl.get_d_period(lrs.sample_date) != lr.d_period_id) '||
'   and lrs.sample_date between '''||v_cap_date||''' and '''||v_offset_date||'''  '||
'   and lrs.is_reload = ''Y'' ' ||
'   and lrs.job_id = '|| p_job_id;

execute immediate v_sql;

----------- message -------------
select current_timestamp into v_end from dual;
v_interval := v_end - v_start;
v_elapsed  := abs(extract(second from v_interval)
                + extract(minute from v_interval)*60
                + extract(hour from v_interval)*60*60
                + extract(day from v_interval)*24*60*60);
v_Message := to_char(v_elapsed,'900000000000.000')||' seconds for final update to LOG_RECORD_STAGING';
utils.putmessage(v_ModuleName, v_Message, p_job_id, p_debug);
v_start := v_end;
----------- message -------------

-----------------------------------------------------------------------------------
-- Empty the CUSTOMER STAGING table so that the contents can't be reloaded if the
-- GDL load stage is skipped for any reason - duplicate input file for instance.
-----------------------------------------------------------------------------------
v_sql := 'truncate table '||p_table_name;
execute immediate v_sql;

end populate_um_staging;
/
exit
