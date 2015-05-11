create or replace view customer.v_utility_recent_data 
as
select count(*)            f_file_records
       ,min(fm.d_period_id) min_period_id
       ,max(fm.d_period_id) max_period_id
       ,fm.d_node_id
       ,n.name              node_name
--       ,fm.d_source_id
--       ,s.name              source_name
       ,fm.edr_type_id
       ,e.edr_type
--       ,fm.d_custom_01_list   service_type_id
--       ,c1.custom_type      service_type
from um.f_metric             FM
 left join DGF.NODE_REF       N
   on fm.d_node_id         = n.node_id
left join um.source_ref       S
   on fm.d_source_id       = s.source_id
 left join um.edr_type_ref    E
   on fm.edr_type_id     = e.edr_type_id
 left join um.d_custom_01    C1
   on fm.d_custom_01_list /*assumes only one value*/   = c1.d_custom_01_id
where
      fm.d_period_id > trunc(sysdate) - ((4 * 7) + 7)
 group by
       fm.d_node_id
      ,n.name
--      ,fm.d_source_id
--      ,s.name
      ,fm.edr_type_id
      ,e.edr_type
--      ,fm.d_custom_01_list
--      ,c1.custom_type
 order by
       to_number(replace(n.name,'DS'))
--     ,s.name
      ,e.edr_type
--      ,c1.custom_type
/

exit
