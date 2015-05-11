create table customer.itc_excl_service_centre  
(
  called_subscriber_imsi VARCHAR2(20),
  service_centre_address VARCHAR2(20),
  exclude varchar2(1)
)
tablespace CUSTOMER_DATA;


ALTER TABLE customer.itc_excl_service_centre 
add CONSTRAINT itc_excl_service_centre_ck_1
  CHECK (exclude IN ('Y', 'N'));

-- Add/modify columns 
alter table customer.itc_excl_service_centre modify service_centre_address not null;
alter table customer.itc_excl_service_centre modify called_subscriber_imsi not null;

-- Create/Recreate primary, unique and foreign key constraints 
alter table customer.itc_excl_service_centre
  add constraint itc_excl_service_centre_PK primary key (called_subscriber_imsi,service_centre_address);

exit;
