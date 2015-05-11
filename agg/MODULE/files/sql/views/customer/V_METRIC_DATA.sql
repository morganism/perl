--------------------------------------------------
--
-- A basic view intended for release to VFI
--
--------------------------------------------------
create or replace view v_metric_data as
select  fm.d_period_id
      , fm.f_metric_id
      , fm.d_source_id
      , fm.creation_date
--      , fm.i_value
--      , fm.raw_value
      , fm.metric       metric_value
      , nr.description  node
      , fm.d_node_id
      , md.metric_definition_id
      , md.name         metric_definition
      , mv.metric_version_id
      , src.name        source
--      , st.custom_type  service_type
      , st.d_custom_01_id
      , et.edr_type
      , et.edr_type_id
      , fmoe.field_type
      from um.f_metric                    fm
inner join um.metric_definition_ref       md
        on md.metric_definition_id = fm.metric_definition_id
inner join um.metric_version_ref          mv
        on mv.metric_definition_id = md.metric_definition_id
inner join um.metric_operator_ref         mo
        on mo.metric_version_id    = mv.metric_version_id
inner join um.fmo_equation                fmoe
        on fmoe.metric_operator_id = mo.metric_operator_id
inner join um.d_custom_01                 st
        on st.d_custom_01_id       = fm.d_custom_01_list
inner join um.source_ref                  src
        on src.source_id           = fm.d_source_id
inner join dgf.node_ref                   nr
        on nr.node_id              = fm.d_node_id
inner join um.edr_type_ref                et
        on et.edr_type_id          = fm.edr_type_id
/

exit
