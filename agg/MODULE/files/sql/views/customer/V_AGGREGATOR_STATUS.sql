----------------------------------------------------------------------------
-- View that summarises file processing and timeliness
----------------------------------------------------------------------------
create or replace view v_aggregator_status as
with max_file
as
(
select n.description node
      ,lr.process_date
      ,max(lr.file_name) file_name /* need to pick one, so use max */
 from um.log_record     lr
   inner join
      (
       select lr1.node_id
              ,max(lr1.process_date) max_process_date
       from um.log_record  lr1
        group by lr1.node_id
       ) latest
   on  lr.node_id = latest.node_id
   and lr.process_date = latest.max_process_date
 inner join dgf.node_ref n
    on n.node_id = lr.node_id
 group by n.description, lr.process_date
 ),
 hourly_summary
 as
 (
 select dff.node
       ,decode(dff.alarm_period_type,'hour',to_date(to_char(recent_files.process_date,'YYYYMMDDHH24'),'YYYYMMDDHH24')
                                           ,to_date(to_char(recent_files.process_date,'YYYYMMDD'),'YYYYMMDD')
              )                  ts
      ,count(*)                 file_count
from
     (
       select  n.description     node
              ,max(lr1.process_date) process_date  /* max/min it should be the same */
             ,lr1.file_name
       from um.log_record  lr1
      inner join dgf.node_ref   n
      on      lr1.node_id = n.node_id
      where   lr1.process_date > trunc(sysdate) - 4
      group by n.description
              ,lr1.file_name
      )   recent_files
      right join
      customer.data_feed_frequency_ref dff
on    recent_files.node = dff.node
group by dff.node
        ,decode(dff.alarm_period_type,'hour',to_date(to_char(recent_files.process_date,'YYYYMMDDHH24'),'YYYYMMDDHH24')
                                            ,to_date(to_char(recent_files.process_date,'YYYYMMDD'),'YYYYMMDD')
               )
 )
 --------------------
 -- Main query
 --------------------
 select dataset.NODE||' ('||dnr.name||')' node
   ,ALARM_PERIOD_TYPE                  TYPE
   ,nvl(to_char(PROCESS_DATE,          'DD-Mon-YYYY HH24:MI:SS')
        ,'<span class="status-red bold italic ">***********</span>'
       ) PROCESS_DATE
   ,nvl(FILE_NAME
       ,'<span class="status-red bold italic ">No files loaded in last 4 days</span>'
        ) FILE_NAME
   ,lpad(round(EXPECTED_FILES_PER_PERIOD,0)||' '|| chr(177) || ALARM_THRESHOLD * 100 || '%',15) EXPECTED_FILES_PER_PERIOD
   ,ALARM_THRESHOLD
   ,PERIOD0
   ,PERIOD1
   ,PERIOD2
   ,PERIOD3
   ,'OK' /* don't colour code current day */
           period0_status
   ,case
         when period1 between expected_files_per_period - allowed_margin
                      and     expected_files_per_period + allowed_margin
           then 'OK'
         when period1 < expected_files_per_period - allowed_margin  then 'less'
         when period1 > expected_files_per_period + allowed_margin  then 'more'
     end    period1_status
    ,case
         when period2 between expected_files_per_period - allowed_margin
                       and     expected_files_per_period + allowed_margin
            then 'OK'
         when period2 < expected_files_per_period - allowed_margin  then 'less'
         when period2 > expected_files_per_period + allowed_margin  then 'more'
    end    period2_status
   ,case
         when period3 between expected_files_per_period - allowed_margin
                      and     expected_files_per_period + allowed_margin
           then 'OK'
         when period3 < expected_files_per_period - allowed_margin  then 'less'
         when period3 > expected_files_per_period + allowed_margin  then 'more'
     end    period3_status
 from (
       select hs.node
             ,cfg.alarm_period_type
             ,mf.process_date
             ,mf.file_name
             ,cfg.expected_files_per_period
             ,cfg.alarm_threshold
             ,abs(cfg.expected_files_per_period * alarm_threshold)        allowed_margin
             ,sum(decode(cfg.alarm_period_type,'hour',decode(hs.ts,t.hour0,file_count,0)
                                              ,'day' ,decode(hs.ts,t.day0 ,file_count,0)
                       ) ) period0
             ,sum(decode(cfg.alarm_period_type,'hour',decode(hs.ts,t.hour1,file_count,0)
                                              ,'day' ,decode(hs.ts,t.day1 ,file_count,0)
                       ) ) period1
             ,sum(decode(cfg.alarm_period_type,'hour',decode(hs.ts,t.hour2,file_count,0)
                                              ,'day' ,decode(hs.ts,t.day2 ,file_count,0)
                       ) ) period2
             ,sum(decode(cfg.alarm_period_type,'hour',decode(hs.ts,t.hour3,file_count,0)
                                              ,'day' ,decode(hs.ts,t.day3 ,file_count,0)
                       ) ) period3
       from customer.data_feed_frequency_ref              cfg
            left join hourly_summary                       hs
             on cfg.node = hs.node
            left join max_file                             mf
             on hs.node  = mf.node
           cross join customer.v_aggregator_timeslots_ref   t
       group by hs.node
               ,cfg.alarm_period_type
               ,mf.process_date
               ,mf.file_name
               ,cfg.expected_files_per_period
               ,cfg.alarm_threshold
       order by to_number(substr(hs.node,3))
      )   dataset
     inner join dgf.node_ref dnr
      on dnr.description = dataset.node;
/

exit
