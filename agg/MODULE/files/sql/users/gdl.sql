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

grant create session to gdl;
grant create table to gdl;
grant create view to gdl;
grant create procedure to gdl;
grant create trigger to gdl;
grant create sequence to gdl;
grant create type to gdl;
grant create role to gdl;
grant create dimension to gdl; 
grant create materialized view to gdl;

grant execute on SYS.DBMS_STATS to gdl;

exit;
