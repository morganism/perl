REM * Create the customer user for the VFI-UM database
REM * Run this as 'system'

drop user customer cascade;

create user customer
  identified by ascertain
  default tablespace customer_data
  temporary tablespace temp
  quota unlimited on customer_data
  quota unlimited on customer_idx;

grant create session to customer;
grant create table to customer;
grant create view to customer;
grant create procedure to customer;
grant create trigger to customer;
grant create sequence to customer;
grant create type to customer;
grant create role to customer;
grant create dimension to customer; 
grant create materialized view to customer;

-- Used in create partition procedure
grant execute on sys.dbms_lock to customer;

exit;
