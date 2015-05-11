create or replace view v_file_metric_issues as
select n.node_id,
       n.name node,
       d.description metric_name,
       mij.d_period_id filedate,
       i.issue_id,
       s.name state,
       d.metric_definition_id
from   um.metric_issue_jn mij,
       dgf.node_ref n,
       um.metric_definition_ref d,
       imm.issue i,
       imm.state_ref s
where  mij.d_period_id > sysdate - 14
and    mij.metric_definition_id = d.metric_definition_id
and    d.name like '%ST_AGG%'
and    n.node_id = mij.node_id
and    i.issue_id = mij.issue_id
and    i.date_raised = mij.date_raised
and    i.date_raised > sysdate - 14
and    i.state_id = s.state_id
and    i.date_closed is null;

exit;
