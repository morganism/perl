create table customer.postpaid_voice_free_of_charge 
(
    dialled_digits VARCHAR2(20),
    description    varchar2(100)
)
tablespace CUSTOMER_DATA;


-- add/modify columns 
alter table customer.postpaid_voice_free_of_charge modify dialled_digits not null;

-- Create/Recreate primary, unique and foreign key constraints 
alter table customer.postpaid_voice_free_of_charge
  add constraint postpaid_voice_foc_PK primary key (dialled_digits);

exit;
