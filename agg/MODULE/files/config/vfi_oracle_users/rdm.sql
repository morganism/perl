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

grant connect,  create table, create sequence, create procedure, create role, create trigger, create view to rdm;

grant select on sys.dba_free_space to rdm;
grant select on sys.dba_data_files to rdm;
grant select on sys.dba_objects to rdm;
grant select on sys.dba_indexes to rdm;
grant select on sys.dba_segments to rdm;
grant debug connect session to rdm;

exit;
