REM * Create the SOA users for the SOA database
REM * Run this as 'system'

drop user soa cascade;

create user soa
  identified by ascertain
  default tablespace ascertain_data
  temporary tablespace temp
  quota unlimited on ascertain_data
  quota unlimited on ascertain_idx;

grant create session to soa;
grant create table to soa;
grant create view to soa;
grant create procedure to soa;
grant create trigger to soa;
grant create sequence to soa;
grant create type to soa;
grant create role to soa;
grant create dimension to soa; 
grant create materialized view to soa;

exit;
