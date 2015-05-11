REM * Create the utils user
REM * Run this as 'system'

drop user utils cascade;

begin
 execute immediate 'purge recyclebin';
exception
when others then null;
end;
/

create user utils
  identified by ascertain
  default tablespace ascertain_data
  temporary tablespace temp
  quota unlimited on ascertain_data
  quota unlimited on ascertain_idx;

grant create session to utils;
grant create table to utils;
grant create view to utils;
grant create procedure to utils;
grant create trigger to utils;
grant create sequence to utils;
grant create type to utils;
grant create role to utils;
grant create dimension to utils; 
grant create materialized view to utils;

exit;
