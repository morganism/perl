update jobs.option_sql_ref 
set sql = 'select  to_char((sysdate -(level-1)), ''DD-MON-YYYY''), to_char((sysdate -(level-1)), ''YYYYMMDD'')  from dual connect by level < 22
order by sysdate -(level-1) desc' 
where option_sql_id = 36002;
update jobs.option_sql_ref 
set sql = 'select  to_char(level-1,''00''),to_char(level-1,''00'')  from dual connect by level < 25
order by level asc' 
where option_sql_id = 36003;
update jobs.option_sql_ref 
set sql = 'select  to_char((sysdate -(level-1)), ''DD-MON-YYYY''), to_char((sysdate -(level-1)), ''YYYYMMDD'')  from dual connect by level < 22
order by sysdate -(level-1) desc' 
where option_sql_id = 36004;
update jobs.option_sql_ref 
set sql = 'select  to_char(level-1,''00''),to_char(level-1,''00'')  from dual connect by level < 25
order by level asc' 
where option_sql_id = 36005;
update jobs.option_sql_ref 
set sql = 'select  power(10,level+1),power(10,level+1)  from dual connect by level < 8
order by level asc' 
where option_sql_id = 36006;

commit;
exit;
