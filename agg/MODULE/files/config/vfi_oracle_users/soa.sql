REM * Create the SOA users for the SOA database
REM * Run this as 'system'

drop user soa cascade;

create user soa
  identified by ascertain
  default tablespace ascertain_data
  temporary tablespace temp
  quota unlimited on ascertain_data
  quota unlimited on ascertain_idx;

grant connect,  create table, create sequence, create procedure, create view, create session, create role, create trigger to soa with admin option;

exit;
