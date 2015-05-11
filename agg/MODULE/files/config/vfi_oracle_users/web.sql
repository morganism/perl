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

grant connect,  create table, create sequence, create procedure, create role, create trigger, create view to web;

grant select on sys.dba_free_space to web;
grant select on sys.dba_data_files to web;
grant select on sys.dba_objects to web;
grant select on sys.dba_indexes to web;
grant select on sys.dba_segments to web with grant option;
grant select on sys.all_tab_cols to web;
GRANT SELECT ON sys.all_constraints TO WEB;
GRANT SELECT ON sys.all_cons_columns TO  WEB;
GRANT SELECT ON sys.all_tables TO WEB;
grant debug connect session to web;

exit;
