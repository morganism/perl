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

grant create session to cwe;
grant create table to cwe;
grant create view to cwe;
grant create procedure to cwe;
grant create trigger to cwe;
grant create sequence to cwe;
grant create type to cwe;
grant create role to cwe;
grant create dimension to cwe; 
grant create materialized view to cwe;

exit;
