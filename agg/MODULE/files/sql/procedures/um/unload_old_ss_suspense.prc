create or replace procedure um.unload_old_ss_suspense IS

       cursor c_batches is 
       with ff_data as ( select batch_id, sum(edr_count) sumcount
                         from   um.log_record lr, um.f_file ff
                         where  lr.log_record_id = ff.log_record_id
                         and    lr.d_period_id = ff.d_period_id
                         and    lr.node_id = 100177
                         and    lr.d_period_id > sysdate - 92 
                         group by batch_id) 
       select b.batch_id
       from   jobs.batch b, ff_data f
       where  batch_name like '%DS98%'
       and    b.batch_status_id = 4
       and    f.batch_id = b.batch_id
       and    f.sumcount != 0 
       and    b.batch_id != (select max(b2.batch_id)
                             from   jobs.batch  b2
                             where  b2.batch_name like '%DS98%'
                             and    b2.batch_status_id = 4 );


       cursor c_staging_batches is 
       with ff_data as ( select lr.batch_id, sum(edr_count) sumcount
                         from   um.log_record_staging lr, um.f_file_staging ff
                         where  lr.log_record_id = ff.log_record_id
                         and    lr.sample_date = ff.sample_date
                         and    lr.node_id = 100177
                         and    lr.sample_date > sysdate - 92 
                         group by lr.batch_id) 
       select b.batch_id
       from   jobs.batch b, ff_data f
       where  batch_name like '%DS98%'
       and    b.batch_status_id = 4
       and    f.batch_id = b.batch_id
       and    f.sumcount != 0
       and    b.batch_id != (select max(b2.batch_id)
                             from   jobs.batch  b2
                             where  b2.batch_name like '%DS98%'
                             and    b2.batch_status_id = 4 );
begin

    FOR v_batches IN c_batches LOOP
      
        INSERT INTO um.F_FILE
               ( D_PERIOD_ID,
                 F_FILE_ID,
                 SAMPLE_DATE,
                 F_ATTRIBUTE_ID,
                 LOG_RECORD_ID,
                 EDR_COUNT,
                 EDR_VALUE,
                 EDR_DURATION,
                 EDR_BYTES
                )
          SELECT FF.D_PERIOD_ID, 
                 UM.SEQ_F_FILE_ID.NEXTVAL, 
                 FF.SAMPLE_DATE, 
                 FF.F_ATTRIBUTE_ID, 
                 FF.LOG_RECORD_ID, 
                 FF.EDR_COUNT * -1, 
                 FF.EDR_VALUE * -1, 
                 FF.EDR_DURATION * -1, 
                 FF.EDR_BYTES * -1 
            FROM um.F_FILE FF
           WHERE 1 = 1 
             AND FF.EDR_COUNT != 0
             AND exists (select 1
                         from   um.LOG_RECORD LR 
                         where  LR.LOG_RECORD_ID = FF.LOG_RECORD_ID 
                         AND    LR.D_PERIOD_ID = FF.D_PERIOD_ID 
                         ANd    LR.BATCH_ID = v_batches.batch_id);
     END LOOP;        
             
     FOR v_staging_batches IN c_staging_batches LOOP        
         INSERT INTO um.F_FILE_STAGING
                  (  JOB_ID,
                     BATCH_ID,
                     SAMPLE_DATE,
                     F_FILE_ID,
                     D_NODE_ID,
                     D_SOURCE_ID,
                     D_EDR_TYPE_ID,
                     D_MEASURE_TYPE_ID,
                     D_BILLING_TYPE_ID,
                     D_PAYMENT_TYPE_ID,
                     D_CALL_TYPE_ID,
                     D_CUSTOMER_TYPE_ID,
                     D_SERVICE_PROVIDER_ID,
                     LOG_RECORD_ID,
                     EDR_COUNT,
                     EDR_VALUE,
                     EDR_DURATION,
                     EDR_BYTES,
                     D_CUSTOM_01_ID,
                     D_CUSTOM_02_ID,
                     D_CUSTOM_03_ID,
                     D_CUSTOM_04_ID,
                     D_CUSTOM_05_ID,
                     D_CUSTOM_06_ID,
                     D_CUSTOM_07_ID,
                     D_CUSTOM_08_ID,
                     D_CUSTOM_09_ID,
                     D_CUSTOM_10_ID,
                     D_CUSTOM_11_ID,
                     D_CUSTOM_12_ID,
                     D_CUSTOM_13_ID,
                     D_CUSTOM_14_ID,
                     D_CUSTOM_15_ID,
                     D_CUSTOM_16_ID,
                     D_CUSTOM_17_ID,
                     D_CUSTOM_18_ID,
                     D_CUSTOM_19_ID,
                     D_CUSTOM_20_ID )
              SELECT FFS.JOB_ID,
                     FFS.BATCH_ID,
                     FFS.SAMPLE_DATE, 
                     UM.SEQ_F_FILE_ID.NEXTVAL, 
                     FFS.D_NODE_ID, 
                     FFS.D_SOURCE_ID, 
                     FFS.D_EDR_TYPE_ID, 
                     FFS.D_MEASURE_TYPE_ID, 
                     FFS.D_BILLING_TYPE_ID, 
                     FFS.D_PAYMENT_TYPE_ID, 
                     FFS.D_CALL_TYPE_ID, 
                     FFS.D_CUSTOMER_TYPE_ID, 
                     FFS.D_SERVICE_PROVIDER_ID, 
                     FFS.LOG_RECORD_ID, 
                     FFS.EDR_COUNT * -1, 
                     FFS.EDR_VALUE * -1, 
                     FFS.EDR_DURATION * -1, 
                     FFS.EDR_BYTES * -1, 
                     FFS.D_CUSTOM_01_ID, 
                     FFS.D_CUSTOM_02_ID, 
                     FFS.D_CUSTOM_03_ID, 
                     FFS.D_CUSTOM_04_ID, 
                     FFS.D_CUSTOM_05_ID, 
                     FFS.D_CUSTOM_06_ID, 
                     FFS.D_CUSTOM_07_ID, 
                     FFS.D_CUSTOM_08_ID, 
                     FFS.D_CUSTOM_09_ID, 
                     FFS.D_CUSTOM_10_ID, 
                     FFS.D_CUSTOM_11_ID, 
                     FFS.D_CUSTOM_12_ID, 
                     FFS.D_CUSTOM_13_ID, 
                     FFS.D_CUSTOM_14_ID, 
                     FFS.D_CUSTOM_15_ID, 
                     FFS.D_CUSTOM_16_ID, 
                     FFS.D_CUSTOM_17_ID, 
                     FFS.D_CUSTOM_18_ID, 
                     FFS.D_CUSTOM_19_ID, 
                     FFS.D_CUSTOM_20_ID 
                FROM um.F_FILE_STAGING FFS
               WHERE 1 = 1 
                 AND FFS.EDR_COUNT  != 0
                 AND exists (select 1
                             from   um.LOG_RECORD_STAGING LRS 
                             where  LRS.LOG_RECORD_ID = FFS.LOG_RECORD_ID 
                             AND    LRS.SAMPLE_DATE = FFS.SAMPLE_DATE 
                             AND    LRS.BATCH_ID = v_staging_batches.batch_id);
      END LOOP;
      
      commit;           

end unload_old_ss_suspense;
/
exit;
