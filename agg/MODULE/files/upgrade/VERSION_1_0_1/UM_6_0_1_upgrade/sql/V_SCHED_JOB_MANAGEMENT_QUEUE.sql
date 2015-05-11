---------------------------------------
-- IBM LMD2
-- Cartesian Limited
-- Ramona Solomon
-- Kazan Glenn
--
-- this view is flawed with regard to multi-jobs of multi-jobs
-- and will need to be revisited to cover this better, but
-- this solution answers concerns with regard to performance
--
-- also introduced is a type column, allowing filtering by type
-- type will be one of;
--   o Ascertain
--   o Multi
---------------------------------------

create or replace view jobs.v_sched_job_management_queue as
select "ID",
       "SUBMISSION_DATE",
       "NEXT_RUN_TIME",
       "TERMINATION_TIME",
       "DESCRIPTION",
       "TYPE",
       "PRIORITY",
       "REPEAT",
       "RETRY",
       "ALIAS",
       "SUSPENDED",
       "DELETE_ID" 
from(
    select distinct jobs.automated_run.automation_id as id,
                    jobs.automated_run.requested_start_time as submission_date,
                    jobs.automated_run.next_run_time as next_run_time,
                    substr(regexp_substr(jobs.job.opt_parameters, '--terminatetime [0-9]+:[0-9]+:[0-9]+'), 17) as termination_time,
                    nvl(job.description, job_code_ref.description) as description,
                    'Ascertain' as type,
                    decode(jobs.job.job_priority,'S','Standard','H','High','U','Urgent') as priority,
                    decode(jobs.automated_run.repeat_interval,'H','Hourly','D','Daily','W','Weekly','M','Monthly',jobs.automated_run.repeat_interval) as repeat,
                    jobs.job.retry_count as retry,
                    utils.ascertain_user.alias as alias,
                    jobs.automated_run.suspended,
                    jobs.automated_run.automation_id  as delete_id
    from jobs.job,
         jobs.job_code_ref,
         jobs.automated_run,
         utils.ascertain_user
    where 1=1
    and job.job_id < 0
    and automated_run.automation_id = job.automation_id
    and job.job_code_id = job_code_ref.job_code_id
    and not exists (select job_id from multi_job_component where job_id = job.job_id)
    and ascertain_user.user_id = job.user_id
    union
    select distinct jobs.automated_run.automation_id as id,
                    jobs.automated_run.requested_start_time as submisssion_date,
                    jobs.automated_run.next_run_time as next_run_time,
                    null as termination_time,
                    multi_job_ref.description as description,
                    'Multi' as type,
                    decode(jobs.getmultijobpriority(multi_job.multi_job_id),'S','Standard','H','High','U','Urgent') as priority,
                    decode(jobs.automated_run.repeat_interval,'H','Hourly','D','Daily','W','Weekly','M','Monthly',jobs.automated_run.repeat_interval) as repeat,
                    0 as retry,
                    jobs.getmultijobuser(multi_job.multi_job_id) as alias,
                    jobs.automated_run.suspended,
                    jobs.automated_run.automation_id  as delete_id
    from jobs.automated_run,
         jobs.multi_job,
         jobs.multi_job_ref,
         jobs.multi_job_component
    where 1=1
    and multi_job.multi_job_id < 0
    and automated_run.automation_id = multi_job.automation_id
    and multi_job_component.parent_job_id = multi_job.multi_job_id
    and multi_job.multi_job_ref_id = multi_job_ref.multi_job_ref_id
    and multi_job.multi_job_id not in (select multi_job_id from jobs.multi_job_component where multi_job_id is not null)
)
order by id desc;

exit;
