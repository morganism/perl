REM * Create the cwe user
REM * Run this as 'system'

drop user cwe cascade;

begin
 execute immediate 'purge recyclebin';
exception
when others then null;
end;
/

create user cwe
  identified by ascertain
  default tablespace ascertain_data
  temporary tablespace temp
  quota unlimited on ascertain_data
  quota unlimited on ascertain_idx;

grant connect, create role, create table, create sequence, create procedure, create trigger, create view to cwe;

exit;
