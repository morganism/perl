REM * Create the web user
REM * Run this as 'system'

drop user web cascade;

begin
 execute immediate 'purge recyclebin';
exception
when others then null;
end;
/

create user web
  identified by ascertain
  default tablespace ascertain_data
  temporary tablespace temp
  quota unlimited on ascertain_data
  quota unlimited on ascertain_idx;

grant create session to web;
grant create table to web;
grant create view to web;
grant create procedure to web;
grant create trigger to web;
grant create sequence to web;
grant create type to web;
grant create role to web;
grant create dimension to web;
grant create materialized view to web;

exit;
