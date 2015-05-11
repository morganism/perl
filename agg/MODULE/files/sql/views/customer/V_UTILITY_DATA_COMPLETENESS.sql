create or replace view v_utility_data_completeness as
with
list_of_metrics
as
(
 select n.name || ' (' || n.description || ')'   node
      , md.name                 metric_name
      , md.metric_definition_id metric_id
      , j.node_id
      , n.description           node_desc
  from um.metric_definition_ref md
 inner join um.node_metric_jn j
    on md.metric_definition_id = j.metric_definition_id
 inner join dgf.node_ref n
    on n.node_id = j.node_id
),
f_metric_data
as
(
 select md.name         metric_name
      , n.name || ' (' || n.description || ')'          node
      , count(*)        recs
      , sum(fm.metric)  sum_value
 from um.f_metric  fm
 inner join um.metric_definition_ref md
 on fm.metric_definition_id = md.metric_definition_id
 inner join dgf.node_ref n
 on n.node_id = fm.d_node_id
 group by md.name
        , n.name || ' (' || n.description || ')'
),
f_file_data
as
(
 select n.name || ' (' || n.description || ')'               node
       ,c.custom_type        service_type
       ,sum(ff.edr_count)    edr_count
       ,sum(ff.edr_value)    edr_value
       ,sum(ff.edr_duration) edr_duration
       ,sum(ff.edr_bytes)    edr_bytes
 from um.log_record   lr
 inner join um.f_file ff
 on  lr.log_record_id = ff.log_record_id
 and lr.d_period_id   = ff.d_period_id
 inner join um.f_attribute  fa
 on fa.f_attribute_id = ff.f_attribute_id
 inner join um.d_custom_01 c
 on fa.d_custom_01_id = c.d_custom_01_id
 inner join dgf.node_ref n
 on n.node_id = lr.node_id
 group by
        n.name || ' (' || n.description || ')'
       ,c.custom_type
)
select node -- This outer query wraps the inner one, and makes the metric data comparable to the log_record totals
      ,metric_name
      ,metric_data
      ,log_record_data
      ,decode(substr(metric_name,instr(metric_name,' - EDR') + 3)
             ,'EDR Count',    loaded_edr_count
             ,'EDR Duration', loaded_edr_duration
             ,'EDR Value',    loaded_edr_value
             ,'EDR Bytes',    loaded_edr_bytes
             ,null
             ) log_record_quantity -- This logic is slightly flaky as it relies on a metric naming convention
      ,metric_quantity
from     (select l.node
                ,l.metric_name
                ,m.metric_name metric_data    -- This column left to show gaps where left join finds nothing
                ,f.node        log_record_data-- This column left to show gaps where left join finds nothing
                ,nvl(to_char(m.sum_value),'--No f_metric data--')        metric_quantity
    --            ,nvl(to_char(m.recs     ),'--No f_metric data--')        metric_recs
                ,nvl(to_char(f.edr_count),'--No usage data loaded--')    loaded_edr_count
                ,nvl(to_char(f.edr_value),'--No usage data loaded--')    loaded_edr_value
                ,nvl(to_char(f.edr_duration),'--No usage data loaded--') loaded_edr_duration
                ,nvl(to_char(f.edr_bytes),'--No usage data loaded--')    loaded_edr_bytes
          from
                list_of_metrics  l
                left join f_metric_data    m
                on  l.node         = m.node
                and l.metric_name  = m.metric_name
                left join f_file_data      f
                on  l.node        = f.node
                and substr(l.metric_name,1,instr(l.metric_name,' -') -1) = f.service_type
          order by to_number(replace(l.node_desc,'DS'))
          )
/

exit
