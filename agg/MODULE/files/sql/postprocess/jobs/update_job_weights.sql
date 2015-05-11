update jobs.job_code_ref 
set weight = 10      /* nothing else will run */
where weight = 1 
and trim(description) in ('Import', 'Import (Daemon)');

grant select on JOBS.V_JOB_QUEUE to utils;
grant select on JOBS.V_JOB_HAS_BATCHES to utils;
grant select on JOBS.V_JOB_HISTORY to utils;
grant select on JOBS.V_JOB_STATE_SUMMARY to utils;
grant select on JOBS.V_JOB_SUMMARY_MATRIX_GRAPH to utils;
grant select on JOBS.V_JOB_SUMMARY_MATRIX to utils;
grant select on JOBS.V_BATCH_ACTION_TOTALS to utils;
grant select on JOBS.V_ACTION_MANAGEMENT_QUEUE to utils;
grant select on JOBS.V_AVERAGE_JOB_DURATIONS to utils;
grant select on JOBS.V_SCHED_JOB_MANAGEMENT_QUEUE to utils;
grant select on JOBS.V_BATCH_MANAGEMENT_QUEUE to utils;
grant select on JOBS.V_MJ_HAS_PARENT to utils;
grant select on JOBS.V_MJ_HAS_INSTANCES to utils;
grant select on JOBS.V_MULTIJOB_REF to utils;
grant select on JOBS.V_JOB_DURATION to utils;
grant select on JOBS.V_JOB_DURATION_TABLE to utils;
grant select on JOBS.V_NEXT_RETURN_CODE to utils;
grant select on JOBS.V_EM_20 to utils;
grant select on JOBS.V_ALARM_CHART to utils;
grant select on JOBS.V_ALARM_DATA to utils;

exit
