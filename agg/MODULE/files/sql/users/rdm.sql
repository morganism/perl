REM * Create the rdm user
REM * Run this as 'system'

drop user rdm cascade;

begin
 execute immediate 'purge recyclebin';
exception
when others then null;
end;
/

create user rdm
  identified by ascertain
  default tablespace ascertain_data
  temporary tablespace temp
  quota unlimited on ascertain_data
  quota unlimited on ascertain_idx;

grant create session to rdm;
grant create table to rdm;
grant create view to rdm;
grant create procedure to rdm;
grant create trigger to rdm;
grant create sequence to rdm;
grant create type to rdm;
grant create role to rdm;
grant create dimension to rdm; 
grant create materialized view to rdm;

exit;
