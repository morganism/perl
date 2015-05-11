create or replace view CUSTOMER.V_METRIC_ISSUES_BY_SEVERITY as
select /*+ RESULT_CACHE */ "METRIC_NAME","METRIC_DEFINITION_ID","CRITICAL","HIGH","MEDIUM","LOW","INFORMATION"
  from (
    select name as metric_name,
           metric_definition_id,
           sum(critical) critical,
           sum(high) high,
           sum(medium) medium,
           sum(low) low,
           sum(information) information
      from (
        select d.name,
               d.metric_definition_id,
               sum(case when sv.name = 'Critical' then 1 else 0 end) critical,
               sum(case when sv.name = 'High' then 1 else 0 end) high,
               sum(case when sv.name = 'Medium' then 1 else 0 end) medium,
               sum(case when sv.name = 'Low' then 1 else 0 end) low,
               sum(case when sv.name = 'Information' then 1 else 0 end) information
          from imm.issue i
         inner join imm.state_ref sr
            on i.state_id = sr.state_id
         inner join imm.issue_attribute ia
            on ia.issue_id = i.issue_id
         inner join imm.severity_ref sv
            on sv.severity_id = i.severity_id
         inner join um.metric_definition_ref d
            on ia.value = d.metric_definition_id
         where i.issue_type_id = 35200 /*35200 - metric issue*/
           and ia.attribute_id = 35000 /*metric definition*/
           and sr.state_type in ('S', 'I')
         group by d.name, d.metric_definition_id, sv.name, sv.importance
            ) pivot_1
    group by name, metric_definition_id
      ) pivot_2
order by critical desc, high desc, medium desc, low desc, information desc;

exit;
