REM * Create the olap user
REM * Run this as 'system'

drop user olap cascade;

begin
 execute immediate 'purge recyclebin';
exception
when others then null;
end;
/

create user olap
  identified by ascertain
  default tablespace ascertain_data
  temporary tablespace temp
  quota unlimited on ascertain_data
  quota unlimited on ascertain_idx;

grant create session to olap;
grant create table to olap;
grant create view to olap;
grant create procedure to olap;
grant create trigger to olap;
grant create sequence to olap;
grant create type to olap;
grant create role to olap;
grant create dimension to olap; 
grant create materialized view to olap;

exit;
