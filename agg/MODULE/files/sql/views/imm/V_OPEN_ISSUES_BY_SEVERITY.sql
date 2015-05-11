create or replace view v_open_issues_by_severity as         
select severity, count, issue_severity_id
  from (select sr.name as severity,
               count(*) as count,
               sr.severity_id as issue_severity_id
          from imm.issue i
          join imm.severity_ref sr
            on sr.severity_id = i.severity_id
         where i.date_closed is null
         group by sr.severity_id, sr.name
        union
        select name, 0 as count, severity_id
          from imm.severity_ref
         group by name, severity_id);
exit;
