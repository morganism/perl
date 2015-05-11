----------------------------------------------------------------------------------
--
-- V_UTILITY_UNMAPPED_DATA
--
-- A view to select data loaded with default values - failed to find correct value
--  in ETL phase.
--
----------------------------------------------------------------------------------

create or replace view customer.v_utility_unmapped_lr_data 
as
select count(*)            lr_record_records,
       decode(lr.log_record_id,null,null,'not null') log_record_id,
       lr.node_id,
       n.name              node_name,
       lr.source_id,
       s.name              source_name
 from  UM.LOG_RECORD          LR
  left join DGF.NODE_REF      N
    on lr.node_id         = n.node_id
  left join um.source_ref     S
    on lr.source_id       = s.source_id
where
       lr.source_id           = -1
    or lr.node_id             = -1
    or lr.log_record_id       is null
 group by
       decode(lr.log_record_id,null,null,'not null') 
      ,lr.node_id
      ,n.name
      ,lr.source_id
      ,s.name
/

exit
