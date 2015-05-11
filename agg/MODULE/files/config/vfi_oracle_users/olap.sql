REM * Create the web user
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

grant connect,  create table, create sequence, create procedure, create role, create trigger, create dimension, create view, create materialized view to olap;

grant select on sys.dba_free_space to olap;
grant select on sys.dba_data_files to olap;
grant select on sys.dba_objects to olap;
grant select on sys.dba_indexes to olap;
grant select on sys.dba_segments to olap;
grant debug connect session to olap;

exit;
