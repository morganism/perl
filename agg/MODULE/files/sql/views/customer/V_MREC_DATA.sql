--------------------------------------------------
--
-- A basic view intended for release to VFI
--
--------------------------------------------------
create or replace view v_mrec_data as
select  nr.description  node
      , fa.d_node_id
      , src.name        source
      , fa.d_source_id
      , st.d_custom_01_id
--      , st.custom_type    service_type
      , et.edr_type
      , fm.d_period_id
      , mr.mrec_definition_id
      , mvr.mrec_version_id
      , fm.measure_type
      , decode(fm.measure_type
              ,'C','EDR Count'
              ,'V','EDR Value'
              ,'D','EDR Duration'
              ,'B','EDR Bytes'
              ,'Unknown'
              )         measure
      , sum(decode(fm.mrec_set
                  ,-1,fm.mrec
                  ,0
                  )
           )            mrec_value_i
      , sum(decode(fm.mrec_set
                  ,+1,fm.mrec
                  ,0
                  )
           )            mrec_value_j
--n/a--      , et.edr_direction
      from um.f_mrec      fm
inner join um.mrec        mr
        on mr.mrec_id        = fm.mrec_id
inner join um.mrec_version_ref mvr
        on mvr.mrec_version_id = mr.mrec_version_id
inner join um.f_attribute fa
        on fa.f_attribute_id = fm.f_attribute_id
inner join um.d_custom_01 st
        on st.d_custom_01_id = fa.d_custom_01_id
inner join um.source_ref  src
        on src.source_id     = fa.d_source_id
inner join dgf.node_ref   nr
        on nr.node_id        = fa.d_node_id
inner join um.d_edr_type_mv et
        on et.d_edr_type_id  = fa.d_edr_type_id
where 1 = 1
and   fm.mrec_set <> 0  -- exclude the reconciliation diff line
group by 
        nr.description  
      , fa.d_node_id
      , src.name        
      , fa.d_source_id
      , st.d_custom_01_id
      , st.custom_type    
      , et.edr_type
      , fm.d_period_id
      , mr.mrec_definition_id
      , mvr.mrec_version_id
      , fm.measure_type
/

exit
