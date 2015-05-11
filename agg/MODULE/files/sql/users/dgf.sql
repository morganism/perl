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

grant create session to dgf;
grant create table to dgf;
grant create view to dgf;
grant create procedure to dgf;
grant create trigger to dgf;
grant create sequence to dgf;
grant create type to dgf;
grant create role to dgf;
grant create dimension to dgf; 
grant create materialized view to dgf;

exit;
