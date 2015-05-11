PROMPT Updating threshold percentages

update imm.threshold_severity_ref s
set    s.value =  s.value / 100
where  ( s.value >= 1  or s.value <= -1 )
and    exists ( select 1
                from   imm.threshold_version_ref  v,
                       imm.threshold_definition_ref d
                where  s.threshold_version_id = v.threshold_version_id
                and    d.threshold_definition_id = v.threshold_definition_id
                and    d.type = 'Percentage'
              );

commit;

exit

