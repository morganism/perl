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
  quota unlimited on imm_idx
  quota unlimited on um_mv_data
  quota unlimited on um_mv_idx
  quota unlimited on um_mvl_data
  quota unlimited on um_dwh_mtr_data
  quota unlimited on um_dwh_mtr_idx;

grant create session to um;
grant create table to um;
grant create view to um;
grant create procedure to um;
grant create trigger to um;
grant create sequence to um;
grant create type to um;
grant create role to um;
grant create dimension to um; 
grant create materialized view to um;
grant create synonym to um;

grant execute on sys.dbms_utility to um;
grant execute on sys.dbms_stats to um;
grant execute on sys.dbms_lock to um;

exit;
