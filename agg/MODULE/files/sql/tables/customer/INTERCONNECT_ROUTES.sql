create table interconnect_routes 
(
  incomingroute VARCHAR2(20),
  outgoingroute VARCHAR2(20),
  interconnect  CHAR(1),
  description   varchar2(100)
)
tablespace CUSTOMER_DATA;


ALTER TABLE customer.interconnect_routes 
add CONSTRAINT interconnect_routes_ck_1
  CHECK (interconnect IN ('Y', 'N'));

-- Add/modify columns 
alter table customer.INTERCONNECT_ROUTES modify outgoingroute not null;
alter table customer.INTERCONNECT_ROUTES modify interconnect not null;

-- Create/Recreate primary, unique and foreign key constraints 
alter table customer.INTERCONNECT_ROUTES
  add constraint INTERCONNECT_ROUTES_PK primary key (INCOMINGROUTE, OUTGOINGROUTE);

exit;
