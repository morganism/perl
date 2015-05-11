----------------------------------------------
-- Kazan Glenn
-- Cartesian
--
-- Trigger for auditing table changes.
----------------------------------------------

create or replace trigger T_AU_EX_TRANSFORM_VERSION_REF
 before insert or delete or update on EX_TRANSFORM_VERSION_REF
 for each row
declare

 v_change_id number; 
 v_change_type varchar2(1);
 v_user_id number;

begin

 -- set the change type

 if inserting then
  v_change_type := 'I';
 elsif updating then
  v_change_type := 'U';
 else
  v_change_type := 'D';
 end if;

 -- get user id first to test whether lock applied
 -- exit if not found; no lock = no auditing required
 -- if table edited through configurator, standard auditing can be used with trigger in place
 -- as no lock record will be generated. If edited through bespoke screens and DAO's then
 -- lock record generated and triggers will run. This allows a table to be audited by both
 -- bespoke DAO's and configurator, giving maximum flexibility for GUI development.
 
 begin
  select user_id into v_user_id from utils.ascertain_user au, utils.audit_lock al where al.alias = au.alias and al.table_name = 'GDL.EX_TRANSFORM_VERSION_REF';
 exception
  when no_data_found then return;
 end;

 -- get the change id

 select utils.seq_change_id.nextval into v_change_id from dual;
 
 -- record standard audit information

 insert into utils.audit_log
  (change_id, audit_group_id, schema, table_name, change_user_id, change_date, change_type)
 values
  (v_change_id,
   (select audit_group_id from utils.audit_table_group_ref where schema = 'GDL' and table_name = 'EX_TRANSFORM_VERSION_REF'),
   'GDL',
   'EX_TRANSFORM_VERSION_REF',
   v_user_id,
   sysdate,
   v_change_type);

 -- record column level changes

 insert into utils.audit_column_log
  (change_id, column_name, data_type, value_from, value_to)
 values
  (v_change_id,
   'TRANSFORM_VERSION_ID',
   'NUMBER',
   :old.TRANSFORM_VERSION_ID,
   :new.TRANSFORM_VERSION_ID);

 insert into utils.audit_column_log
  (change_id, column_name, data_type, value_from, value_to)
 values
  (v_change_id,
   'TRANSFORM_ID',
   'NUMBER',
   :old.TRANSFORM_ID,
   :new.TRANSFORM_ID);

 insert into utils.audit_column_log
  (change_id, column_name, data_type, value_from, value_to)
 values
  (v_change_id,
   'VALID_FROM',
   'DATE',
   :old.VALID_FROM,
   :new.VALID_FROM);

 insert into utils.audit_column_log
  (change_id, column_name, data_type, value_from, value_to)
 values
  (v_change_id,
   'VALID_TO',
   'DATE',
   :old.VALID_TO,
   :new.VALID_TO);

 insert into utils.audit_column_log
  (change_id, column_name, data_type, value_from, value_to)
 values
  (v_change_id,
   'STATUS',
   'VARCHAR2',
   :old.STATUS,
   :new.STATUS);

 insert into utils.audit_column_log
  (change_id, column_name, data_type, value_from, value_to)
 values
  (v_change_id,
   'NAME',
   'VARCHAR2',
   :old.NAME,
   :new.NAME);

 insert into utils.audit_column_log
  (change_id, column_name, data_type, value_from, value_to)
 values
  (v_change_id,
   'DESCRIPTION',
   'VARCHAR2',
   :old.DESCRIPTION,
   :new.DESCRIPTION);

 insert into utils.audit_column_log
  (change_id, column_name, data_type, value_from, value_to)
 values
  (v_change_id,
   'TRANSFORM_DEFINITION',
   'CLOB',
   :old.TRANSFORM_DEFINITION,
   :new.TRANSFORM_DEFINITION);

 insert into utils.audit_column_log
  (change_id, column_name, data_type, value_from, value_to)
 values
  (v_change_id,
   'AUTHOR_ID',
   'VARCHAR2',
   :old.AUTHOR_ID,
   :new.AUTHOR_ID);

 insert into utils.audit_column_log
  (change_id, column_name, data_type, value_from, value_to)
 values
  (v_change_id,
   'CREATION_DATE',
   'DATE',
   :old.CREATION_DATE,
   :new.CREATION_DATE);

 -- can't audit BLOBs currently
 --insert into utils.audit_column_log
 -- (change_id, column_name, data_type, value_from, value_to)
 --values
 -- (v_change_id,
 --  'XSD_DEFINITION',
 --  'BLOB',
 --  :old.XSD_DEFINITION,
 --  :new.XSD_DEFINITION);

end T_AU_EX_TRANSFORM_VERSION_REF;
/
show errors
exit;
