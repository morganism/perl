REM * Create the um user for the UM database on Oracle Standard Edition
REM * Run this as 'system'

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
grant create procedure to um;
grant select_catalog_role to um;
grant debug connect session to um;
grant create type to um;

grant execute on sys.dbms_utility to um;
grant execute on sys.dbms_stats to um;
grant execute on sys.dbms_lock to um;
grant select_catalog_role to um;

grant CREATE ANY DIRECTORY to um;
grant exp_full_database to um;
grant imp_full_database to um;

grant create table to UM;
grant create materialized view to um;

alter user um quota 5G on um_mvl_data;
alter user um quota 5G on um_mv_data;
alter user um quota 5G on um_mv_idx;
alter user um quota 5G on ascertain_data;
alter user um quota 5G on ascertain_idx;

exit;
