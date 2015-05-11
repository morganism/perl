REM * Create the ikm user
REM * Run this as 'system'

drop user ikm cascade;

begin
 execute immediate 'purge recyclebin';
exception
when others then null;
end;
/

create user ikm
  identified by ascertain
  default tablespace ascertain_data
  temporary tablespace temp
  quota unlimited on ascertain_data
  quota unlimited on ascertain_idx;

grant connect,  create table, create sequence, create procedure, create role, create trigger, create view to ikm;

exit;
