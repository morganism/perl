--------------------------------------------------
--
-- A basic view intended for release to VFI
--
--------------------------------------------------
create or replace view v_base_data
as
select lr.d_period_id
     , lr.log_record_id
--id--     , lr.node_id
     , nr.description      node
--id--     , lr.source_id
     , src.name            source
     , lr.file_name
--n/a--     , ff.f_attribute_id
     , st.custom_type      service_type
     , ff.edr_count
     , ff.edr_value
     , ff.edr_duration
     , ff.edr_bytes
      from um.log_record  lr
inner join um.f_file      ff
        on lr.d_period_id    = ff.d_period_id
       and lr.log_record_id  = ff.log_record_id
inner join um.f_attribute fa       
        on ff.f_attribute_id = fa.f_attribute_id
inner join um.d_custom_01 st
        on st.d_custom_01_id = fa.d_custom_01_id        
inner join um.source_ref  src
        on src.source_id     = fa.d_source_id        
inner join dgf.node_ref   nr
        on nr.node_id        = fa.d_node_id
/

exit
