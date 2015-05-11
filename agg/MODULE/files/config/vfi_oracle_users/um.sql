REM * Create the um user for the UM database
REM * Run this as 'system'

set serveroutput on
set verify on

drop user um cascade;

begin
 execute immediate 'purge recyclebin';
exception
when others then null;
end;
/

create user um
  identified by ascertain
  default tablespace um_dwh_usg_data
  temporary tablespace temp
  quota unlimited on um_dwh_usg_data
  quota unlimited on um_dwh_usg_idx
  quota unlimited on imm_data
  quota unlimited on imm_idx;

grant connect,  create table, create sequence, create procedure, create role, create view, create trigger to um;
grant create dimension, create procedure to um;

grant create materialized view to um;
grant debug connect session to um;
grant global query rewrite to um;
grant on commit refresh to um;
grant create type to um;

grant execute on sys.dbms_irefresh to um;
grant execute on sys.dbms_repcat_sna to um;
grant execute on sys.dbms_sys_error to um;
grant execute on sys.dbms_isnapshot to um;
grant execute on sys.dbms_refresh to um;
grant execute on sys.dbms_snapshot to um;
grant execute on sys.dbms_utility to um;
grant execute on sys.dbms_stats to um;
grant execute on sys.dbms_lock to um;

grant CREATE ANY DIRECTORY to um;
grant exp_full_database to um;
grant imp_full_database to um;

alter user um quota 5G on um_mvl_data;
alter user um quota 5G on um_mv_data;
alter user um quota 5G on um_mv_idx;
alter user um quota 5G on ascertain_data;
alter user um quota 5G on ascertain_idx;
alter user um quota 5G on UM_DWH_USG_DATA;
alter user um quota 5G on UM_DWH_USG_IDX;
alter user um quota 5G on UM_DWH_MTR_DATA;
alter user um quota 5G on UM_DWH_MTR_IDX;

exit;
