REM * Create the ble users
REM * Run this as 'system'

drop user ble cascade;

begin
 execute immediate 'purge recyclebin';
exception
when others then null;
end;
/

create user ble
  identified by ascertain
  default tablespace ascertain_data
  temporary tablespace temp
  quota unlimited on ascertain_data
  quota unlimited on ascertain_idx;

grant create session to ble;
grant create table to ble;
grant create view to ble;
grant create procedure to ble;
grant create trigger to ble;
grant create sequence to ble;
grant create type to ble;
grant create role to ble;
grant create dimension to ble; 
grant create materialized view to ble;

exit;
