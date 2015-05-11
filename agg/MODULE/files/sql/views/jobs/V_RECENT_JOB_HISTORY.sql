create or replace view jobs.v_recent_job_history as 
select trunc(execute_date) as run_date,
count(*) as total,
sum(case when status_group = 'Failed' then 1 else 0 end) as failed,
sum(case when status_group = 'Cancelled' then 1 else 0 end) as cancelled,
sum(case when status_group = 'Complete' then 1 else 0 end) as Completed,
sum(case when status_group = 'Warning' then 1 else 0 end) as Warning,
sum(case when status_group != 'Complete' and status_group != 'Failed' and status_group != 'Cancelled' and status_group != 'Warning' then 1 else 0 end) as Other
from jobs.v_job_history where trunc(execute_date) > trunc(sysdate) -4 
 group by trunc(execute_date)
order by trunc(execute_date) desc;

exit

