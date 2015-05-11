create table customer.partners (
       
      partner_id               integer,
      partner_name             varchar2(50),
      type                     varchar2(50),                                    
      description              varchar2(200),
      prefix                   varchar2(10),
      imsi_start_range         varchar2(20),
      imsi_end_range           varchar2(20),
      source_id                integer

);

alter table customer.partners add constraint partners_pk primary key (partner_id) ;
alter table customer.partners add constraint partners_fk_1 foreign key (source_id) references um.source_ref (source_id);
     
grant select, insert, delete, update on customer.partners to um;

exit
