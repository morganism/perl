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

grant connect,  create table, create sequence, create procedure, create session, create role, create trigger, create view, create synonym, create public synonym to imm;
grant create dimension, create procedure to imm;
grant create type to imm;

grant execute on SYS.DBMS_SYS_ERROR to imm;
grant execute on sys.dbms_refresh to imm;
grant execute on sys.dbms_utility to imm;

grant CREATE ANY DIRECTORY to imm;
grant exp_full_database to imm;
grant imp_full_database to imm;

grant create table to imm;
grant debug connect session to imm;

grant create materialized view to imm;

exit;
