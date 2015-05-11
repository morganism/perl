----------------------------------------------------------------------------------
--
-- V_UTILITY_UNMAPPED_DATA
--
-- A view to select data loaded with default values - failed to find correct value
--  in ETL phase.
--
----------------------------------------------------------------------------------

create or replace view customer.v_utility_unmapped_FF_data as
select count(*)             f_file_records,
       sum(ff.edr_count)    sum_count,
       sum(ff.edr_value)    sum_value,
       sum(ff.edr_duration) sum_duration,
       sum(ff.edr_bytes)    sum_bytes,
       decode(ff.log_record_id,null,null,'not null') log_record_id,
       fa.d_node_id,
       n.name              node_name,
       fa.d_source_id,
       s.name              source_name,
       fa.d_edr_type_id,
       e.edr_type,
       fa.d_measure_type_id,
       m.measure_type,
       fa.d_custom_01_id   service_type_id,
       c1.custom_type      service_type
 from UM.F_ATTRIBUTE         FA
 inner join UM.F_FILE        FF
    on FA.F_ATTRIBUTE_ID    = FF.F_ATTRIBUTE_ID
 left join DGF.NODE_REF      N
    on fa.d_node_id         = n.node_id
 left join um.source_ref     S
   on fa.d_source_id       = s.source_id
 left join um.edr_type_ref   E
   on fa.d_edr_type_id     = e.edr_type_id
 left join um.d_measure_type M
    on fa.d_measure_type_id = m.d_measure_type_id
 left join um.d_custom_01    C1
    on fa.d_custom_01_id    = c1.d_custom_01_id
where
      fa.d_source_id           = -1
   or fa.d_edr_type_id         = -1
   or fa.d_measure_type_id     = -1
   or fa.d_custom_01_id        = -1
   or ff.log_record_id         is null
 --   or fa.d_billing_type_id     = -1 /* -1 is the expected value for all records */
 --   or fa.d_payment_type_id     = -1 /* -1 is the expected value for all records */
 --   or fa.d_call_type_id        = -1 /* -1 is the expected value for all records */
 --   or fa.d_customer_type_id    = -1 /* -1 is the expected value for all records */
 --   or fa.d_service_provider_id = -1 /* -1 is the expected value for all records */
  group by
        decode(ff.log_record_id,null,null,'not null') 
       ,fa.d_node_id
       ,n.name
       ,fa.d_source_id
       ,s.name
       ,fa.d_edr_type_id
       ,e.edr_type
       ,fa.d_measure_type_id
       ,m.measure_type
       ,fa.d_custom_01_id
       ,c1.custom_type
/

exit
