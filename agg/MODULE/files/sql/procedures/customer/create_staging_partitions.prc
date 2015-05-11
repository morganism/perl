create or replace procedure createStagingPartitions(p_job_id integer)
is
/*
This code was lifted from the VM UM.ETL package

http://cvs.cartesian.co.uk/viewvc/Ascertain/Ascertain/project/VM/UM/sql/packages/um/etl.partition.pck?view=log
*/
-----------------------------------------------------------------------
-- Create partitons on tables F_FILE_STAGING and LOG_RECORD_STAGING
-- this is a LIST partition that contains the single value $JOB_ID
-----------------------------------------------------------------------
   v_ff_part_sql varchar(100);
   v_lr_part_sql varchar(100);
   v_job_id_pad varchar(9);
   v_partcount integer := 0;

   resource_busy exception;
   pragma exception_init (resource_busy,-54);
   v_max_wait integer; -- max number of wait cycles

begin
   select lpad(p_job_id,9,'0')
   into v_job_id_pad
   from dual;

   -- check if partition already exists
   select count(*)
   into v_partcount
   from all_tab_partitions t
   where t.table_owner = 'UM' and t.table_name = 'F_FILE_STAGING'
   and t.partition_name= 'F_FILE_STAGING_P' || v_job_id_pad;

   -- create if partition doesn't exist
   if v_partcount = 0 then
     v_ff_part_sql := 'alter table um.F_FILE_STAGING add partition F_FILE_STAGING_P' || v_job_id_pad ||
                         ' VALUES (' || p_job_id || ')';

     -- this loop will avoid "resource_busy" ORA-00054 errors
     -- that may occur when createStagingPartitions is called in parallel
     v_max_wait := 1000;
     loop
       v_max_wait := v_max_wait - 1;
       if v_max_wait <= 0 then
          raise resource_busy;
       end if;

       begin
            execute immediate v_ff_part_sql;
            exit; -- break out of the loop on success
       exception
         when resource_busy then
            dbms_lock.sleep(1);
       end;
     end loop;
   end if;

   -- check if partition already exists
   select count(*)
   into v_partcount
   from all_tab_partitions t
   where t.table_owner = 'UM' and t.table_name = 'LOG_RECORD_STAGING'
   and t.partition_name= 'LOG_RECORD_STAGING_P' || v_job_id_pad;

   -- create if partition doesn't exist
   if v_partcount = 0 then
     v_lr_part_sql := 'alter table um.LOG_RECORD_STAGING add partition LOG_RECORD_STAGING_P' || v_job_id_pad ||
                         ' VALUES (' || p_job_id || ')';


     -- this loop will avoid "resource_busy" ORA-00054 errors
     -- that may occur when createStagingPartitions is called in parallel
     v_max_wait := 1000;
     loop
       v_max_wait := v_max_wait - 1;
       if v_max_wait <= 0 then
          raise resource_busy;
       end if;

       begin
            execute immediate v_lr_part_sql;
            exit; -- break out of the loop on success
       exception
         when resource_busy then
            dbms_lock.sleep(1);
       end;
     end loop;
   end if;
exception
  when resource_busy then
             RAISE_APPLICATION_ERROR(-20001,
                            'Exception: MAX WAIT exceeded while waiting for staging table resource.');

  
end createStagingPartitions;
/

exit
