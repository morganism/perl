REM * Create the jobs users
REM * Run this as 'system'

drop user jobs cascade;

begin
 execute immediate 'purge recyclebin';
exception
when others then null;
end;
/

create user jobs
  identified by ascertain
  default tablespace ascertain_data
  temporary tablespace temp
  quota unlimited on ascertain_data
  quota unlimited on ascertain_idx;

grant connect,  create table, create sequence, create procedure, create role, create trigger, create view to jobs;
grant debug connect session to jobs;

grant create materialized view to JOBS;
grant create table to JOBS;
grant execute on SYS.DBMS_STATS to JOBS;

exit;
