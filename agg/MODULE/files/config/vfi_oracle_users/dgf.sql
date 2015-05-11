REM * Create the dgf user
REM * Run this as 'system'

drop user dgf cascade;

begin
 execute immediate 'purge recyclebin';
exception
when others then null;
end;
/

create user dgf
  identified by ascertain
  default tablespace ascertain_data
  temporary tablespace temp
  quota unlimited on ascertain_data
  quota unlimited on ascertain_idx;

grant connect,  create table, create sequence, create procedure, create role, create trigger, create view to dgf;
grant debug connect session to dgf;
grant create type to dgf;
grant select on sys.v_$sql to dgf;
grant select on v$session to dgf;

grant select, references on web.graph_edge_style_ref to dgf;

alter user dgf quota 5G on um_mvl_data;

exit;
