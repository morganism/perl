create or replace procedure imm.p_open_issues_by_type as 
PRAGMA AUTONOMOUS_TRANSACTION;

v_first_sql varchar2(800) := 'create or replace view imm.v_open_issues_by_type_temp as
              select to_char(to_char(i.date_raised,''YYYY/MM/DD'')) as date_raised,
                     to_char(count(*)) as count,
                     to_char(itr.issue_type_id) as issue_type_id
              from imm.issue i, imm.state_ref sr, imm.issue_type_ref itr
              where (i.state_id = sr.state_id and sr.state_type != ''E'') and i.issue_type_id = itr.issue_type_id and itr.issue_type_id != ''3000'' and date_raised >= sysdate - 31
              group by to_char(i.date_raised,''YYYY/MM/DD''),
                       to_char(i.date_raised,''DD-MM-YYYY,DD-MM-YYYY''),
                       itr.issue_type_id';

v_sql_grant varchar2 (100) := 'grant select on imm.v_open_issues_by_type_summary to web';

v_start_sql varchar2(100) := 'create or replace view imm.v_open_issues_by_type_summary as
select date_raised, date_raised_flt,';

--v_sql_body_A looks something like
/*
 sum(open_case)    open_case,
 sum(open_alert)   open_alert,
*/
v_sql_body_2 varchar2(200):= ' from (select trim(it.date_raised) as date_raised,
 to_char(to_date(trim(it.date_raised),''YYYY/MM/DD''),''DD-MM-YYYY,DD-MM-YYYY'') as date_raised_flt,' ;
/*
v_sql_body_B looks something like
 (case when it.issue_type_id = '3001' then count else '0' end) open_case,
 (case when it.issue_type_id = '3002' then count else '0' end) open_alert,
*/

v_sql_body_4  varchar2(400):= ' from imm.v_open_issues_by_type_temp it
  where to_date(date_raised,''YYYY/MM/DD'') >= sysdate - 31
  group by trim(it.date_raised) ,
  to_char(to_date(trim(it.date_raised),''YYYY/MM/DD''),''DD-MM-YYYY,DD-MM-YYYY''),it.issue_type_id,it.count
  union all (select trim(to_char(sysdate-rownum+1,''YYYY/MM/DD'')) as date_raised,
  to_char(sysdate-rownum+1,''DD-MM-YYYY,DD-MM-YYYY'') as date_raised_flt,';

/*
v_sql_body_C -- looks something like
 '0',
 '0'
*/

v_sql_body_6 varchar2 (200) := ' from all_tables where rownum <= 31)  )
 group by date_raised,date_raised_flt
 order by date_raised';

vSql varchar2(12000) ;
vSql1 varchar2(4000) ;
vSql2 varchar2(4000) ;
vSql3 varchar2(4000) ;

type tsqlBodyLine is table of varchar2(100) ;
vTsqlBodyA tsqlBodyLine ;
vTsqlBodyB tsqlBodyLine ;
vTsqlBodyC tsqlBodyLine ;

begin

vTsqlBodyA := tsqlBodyLine();
vTsqlBodyB := tsqlBodyLine();
vTsqlBodyC := tsqlBodyLine();

select
 'sum ("'||t.issue_type_id||'") as '||replace(t.name,' ','_')||',' sql_body_1_line
,'(case when it.issue_type_id = '|| t.issue_type_id|| ' then it.count else ''0'' end) "'||t.issue_type_id||'",' sql_body_3_line
,'''0'',' sql_body_5_line
bulk collect into vTsqlBodyA , vTsqlBodyB ,vTsqlBodyC
from imm.issue_type_ref t
order by t.name ;

vSql:= v_start_sql ;

for i in vTsqlBodyA.first..vTsqlBodyA.last
  loop
    vSql1 := vSql1 || chr(10) ||vTsqlBodyA(i) ;
  end loop ;
vsql:= vsql||rtrim(vsql1,',');

vSql:= vSql || chr(10) || v_Sql_body_2 ;

for i in vTsqlBodyB.first..vTsqlBodyB.last
 loop
   vSql2 := vSql2 || chr(10) ||vTsqlBodyB(i) ;
 end loop;

vsql:= vsql || rtrim(vsql2,',');

vSql:= vSql || chr(10) || v_Sql_body_4 ;

for i in vTsqlBodyC.first..vTsqlBodyC.last
  loop
    vSql3 := vSql3 || chr(10) ||vTsqlBodyC(i) ;
  end loop ;

vsql:= vsql || rtrim(vsql3,',');

vSql:= vSql || chr(10) || v_Sql_body_6 ;

execute immediate v_first_sql;
execute immediate vSql;
execute immediate v_sql_grant;

end;

/
exit;
