-------------------------------------------------------------------
-- Intended to be the base of queries over LOG_RECORD and F_FILE
-- 
-- Use a where clause to filter on NODE or SERVICE_TYPE
-- Use a further group by to sum across time if necessary
-------------------------------------------------------------------
create or replace view v_utility_loaded_data
as
select count(*)              record_count
      ,nr.description        node 
      ,trunc(lr.d_period_id) day
      ,c1.custom_type        service_type
  from um.log_record lr
 inner join um.f_file ff
     on lr.log_record_id = ff.log_record_id
  inner join dgf.node_ref nr
    on lr.node_id = nr.node_id 
 inner join um.f_attribute fa
     on fa.f_attribute_id = ff.f_attribute_id
  inner join um.d_custom_01 c1
    on fa.d_custom_01_id = c1.d_custom_01_id
  where fa.d_custom_01_id = c1.d_custom_01_id
--    and c1.custom_type    = 'ST_ALL'
--    and nr.description    = 'DS44'
 group by nr.description
          ,trunc(lr.d_period_id)
         ,c1.custom_type
/   

exit
