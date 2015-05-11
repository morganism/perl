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

grant create session to JOBS;
grant create table to JOBS;
grant create view to JOBS;
grant create procedure to JOBS;
grant create trigger to JOBS;
grant create sequence to JOBS;
grant create type to JOBS;
grant create role to JOBS;
grant create dimension to JOBS; 
grant create materialized view to JOBS;

grant execute on SYS.DBMS_STATS to JOBS;

exit;
