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

grant connect, create table, create procedure, create sequence, create trigger, create view, create role to ble;

grant select on sys.v_$sql to ble;
grant select on v$session to ble;
grant debug connect session to ble;

exit;
