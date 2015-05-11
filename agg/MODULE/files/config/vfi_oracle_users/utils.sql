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

grant connect,  create table, create sequence, create procedure, create role, create trigger, create view, create public synonym, exp_full_database to utils;
grant debug connect session to utils;
grant select on sys.v_$mystat to utils with grant option;
grant select on sys.v_$latch to utils with grant option;
grant select on sys.v_$sysstat to utils with grant option;
grant select on sys.v_$session to utils with grant option;
grant select on sys.v_$parameter to utils with grant option;
grant select on sys.v_$sgastat to utils with grant option;
grant select on sys.v_$lock to utils with grant option;
grant select on sys.v_$locked_object to utils with grant option;
grant select on sys.v_$sqlarea to utils with grant option;
grant select on sys.v_$open_cursor to utils with grant option;
grant select on sys.v_$rollstat to utils with grant option;
grant select on sys.v_$rollname to utils with grant option;
grant select on sys.v_$sesstat to utils with grant option;
grant select on sys.v_$statname to utils with grant option;
grant select on sys.v_$sess_io to utils with grant option;
grant select on sys.v_$session_wait to utils with grant option;
grant select on sys.v_$sql to utils with grant option;
grant select on sys.v_$sort_usage to utils with grant option;
grant select on sys.dba_free_space to utils with grant option;
grant select on sys.dba_data_files to utils with grant option;
grant select on sys.dba_objects to utils with grant option;
grant select on sys.dba_indexes to utils with grant option;
grant select on sys.dba_segments to utils with grant option;
grant select on sys.dba_ind_columns to utils with grant option;
grant select on sys.dba_tab_columns to utils with grant option;
grant select on sys.dba_tab_partitions to utils with grant option;
grant select on sys.dba_ind_partitions to utils with grant option;
grant select on sys.dba_tables to utils with grant option;
grant select on sys.all_tables to utils with grant option;
grant select on sys.all_indexes to utils with grant option;
grant select on sys.dba_tablespaces to utils with grant option;
grant select on sys.all_tab_partitions to utils with grant option;
grant select on sys.all_ind_partitions to utils with grant option;
grant select on sys.all_ind_columns to utils with grant option;
grant execute on sys.dbms_stats to utils with grant option;
create synonym utils.v_$sysstat for sys.v_$sysstat;
create synonym utils.v_$session for sys.v_$session;
create synonym utils.v_$parameter for sys.v_$parameter;
create synonym utils.v_$sgastat for sys.v_$sgastat;
create synonym utils.v_$lock for sys.v_$lock;
create synonym utils.v_$locked_object for sys.v_$locked_object;
create synonym utils.v_$sqlarea for sys.v_$sqlarea;
create synonym utils.v_$open_cursor for sys.v_$open_cursor;
create synonym utils.v_$rollstat for sys.v_$rollstat;
create synonym utils.v_$rollname for sys.v_$rollname;
create synonym utils.v_$sesstat for sys.v_$sesstat;
create synonym utils.v_$statname for sys.v_$statname;
create synonym utils.v_$sess_io for sys.v_$sess_io;
create synonym utils.v_$session_wait for sys.v_$session_wait;
create synonym utils.v_$sql for sys.v_$sql;
create synonym utils.v_$sort_usage for sys.v_$sort_usage;
create synonym utils.dba_free_space for sys.dba_free_space;
create synonym utils.dba_data_files for sys.dba_data_files;
create synonym utils.dba_objects for sys.dba_objects;
create synonym utils.dba_indexes for sys.dba_indexes;
create synonym utils.dba_segments for sys.dba_segments;

exit;
