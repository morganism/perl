create or replace view temp_sm_check_loaded_data as
select
       n.description node
       ,service_type
       ,max(day) max_day
       ,min(day) min_day
       ,sum(record_count) no_recs
 from V_UTILITY_LOADED_DATA t
 right join dgf.node_ref n
 on n.description = t.node
 where n.description like 'DS%'
 group by n.description, service_type
 order by n.description, service_type;
/

exit
