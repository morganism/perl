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

grant create session to ikm;
grant create table to ikm;
grant create view to ikm;
grant create procedure to ikm;
grant create trigger to ikm;
grant create sequence to ikm;
grant create type to ikm;
grant create role to ikm;
grant create dimension to ikm; 
grant create materialized view to ikm;

exit;
