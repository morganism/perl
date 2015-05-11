REM * Create the gdl user
REM * Run this as 'system'

drop user gdl cascade;

begin
 execute immediate 'purge recyclebin';
exception
when others then null;
end;
/

create user gdl
  identified by ascertain
  default tablespace ascertain_data
  temporary tablespace temp
  quota unlimited on ascertain_data
  quota unlimited on ascertain_idx;

grant connect,  create table, create sequence, create procedure, create trigger, create view, create role to gdl;
grant debug connect session to gdl;
grant execute on SYS.DBMS_STATS to gdl;

exit;
