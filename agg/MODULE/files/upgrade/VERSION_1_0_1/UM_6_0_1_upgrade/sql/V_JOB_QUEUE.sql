create or replace view jobs.v_job_queue as
select
     j_j.job_id as job,
     parent_job_id as multi_job,
     nvl(actual_start_time, REQUESTED_START_TIME) as execute_date,
     decode(j_j.job_status,
     'R',
     substr('00'||trunc((sysdate - j_j.actual_start_time)*24),-2) ||':'||
     substr('00'||trunc((sysdate - j_j.actual_start_time)*24*60 - 60*trunc((sysdate - j_j.actual_start_time)*24)),-2) ||':'||
     substr('00'||trunc((sysdate - j_j.actual_start_time)*24*60*60 - 60*trunc((sysdate - j_j.actual_start_time)*24*60)),-2),
     null
     ) as duration,
     nvl(j_j.description,j_jcr.description) as description,
     u_au.forename || ' ' || u_au.surname as owner,
     j_jcatr.description as type,
     decode(j_j.job_status,'P','Pending','R','Running') as status,
     substr( j_j.log_file_reference , instr( j_j.log_file_reference , '/' , -1 ) + 1 ) as log_file,
     j_j.job_status as cancel_job
from
     jobs.job j_j,
     jobs.job_category_ref j_jcatr,
     jobs.job_code_ref j_jcr,
     jobs.multi_job_component j_mjc,
     utils.ascertain_user u_au
where 1=1
and j_j.job_status in ('P','R')
and j_j.job_id = j_mjc.job_id (+)
and j_j.user_id = u_au.user_id (+)
and j_j.job_code_id = j_jcr.job_code_id
and j_jcr.job_category_id = j_jcatr.job_category_id
;

exit;
