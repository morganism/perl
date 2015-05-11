REM * Create the IMM user
REM * Run this as 'system'

drop user imm cascade;

begin
 execute immediate 'purge recyclebin';
exception
when others then null;
end;
/

create user imm
  identified by ascertain
  default tablespace ascertain_data
  temporary tablespace temp
  quota unlimited on ascertain_data
  quota unlimited on ascertain_idx
  quota unlimited on imm_data
  quota unlimited on imm_idx;

grant create session to imm;
grant create table to imm;
grant create view to imm;
grant create procedure to imm;
grant create trigger to imm;
grant create sequence to imm;
grant create type to imm;
grant create role to imm;
grant create dimension to imm; 
grant create materialized view to imm;
grant create synonym to imm; 

grant create ANY directory to imm;

grant execute on sys.dbms_sys_error to imm;
grant execute on sys.dbms_refresh to imm;
grant execute on sys.dbms_utility to imm;

exit;
