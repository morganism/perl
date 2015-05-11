PROMPT Adding JOBS.MULTI_JOB_REF
insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (105154, '(M) MSS vs GSM (count) - ST_ONXP_VOICE_POSTPAID_HOME_MO - EDR Count', '-mrec_id 100054 -num_days 21 -offset 28', 35005);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (105155, '(M) MSS vs GSM (duration) - ST_ONXP_VOICE_POSTPAID_HOME_MO - EDR Duration', '-mrec_id 100055 -num_days 21 -offset 28', 35005);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (105156, '(M) GSM vs ICCS Unbilled (count) - ST_ONXP_VOICE_POSTPAID_HOME_MO - EDR Count', '-mrec_id 100056 -num_days 21 -offset 28', 35005);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (105157, '(M) GSM vs ICCS Unbilled (duration) - ST_ONXP_VOICE_POSTPAID_HOME_MO - EDR Duration', '-mrec_id 100057 -num_days 21 -offset 28', 35005);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (105158, '(M) GSM vs ICCS Unbilled (count) - ST_ONXP_VOICE_POSTPAID_HOME_CALL_FWD - EDR Count', '-mrec_id 100058 -num_days 21 -offset 28', 35005);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (105159, '(M) GSM vs ICCS Unbilled (duration) - ST_ONXP_VOICE_POSTPAID_HOME_CALL_FWD - EDR Duration', '-mrec_id 100059 -num_days 21 -offset 28', 35005);

PROMPT Adding JOBS.MULTI_JOB_COMP_REF
insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105154, 105154, null, 35501);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105155, 105155, null, 35501);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105156, 105156, null, 35501);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105157, 105157, null, 35501);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105158, 105158, null, 35501);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105159, 105159, null, 35501);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105254, 105000, 105154, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105255, 105000, 105155, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105256, 105000, 105156, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105257, 105000, 105157, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105258, 105000, 105158, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105259, 105000, 105159, null);

PROMPT Adding ONXP jobs

insert into jobs.job_code_ref
  (job_code_id,
   weight,
   parameters,
   class_name,
   blocking_status,
   description,
   job_category_id,
   compressed_logs,
   parameters_url)
values
  (140001,
   1,
   '-script writeOnxpDataFile',
   'uk.co.cartesian.ascertain.jobs.extensions.server.ExtendedExternalJob',
   'writeOnxp',
   'Write ONXP Data File',
   35001,
   'N',
   null
);


exit;
