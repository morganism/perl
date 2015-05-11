grant references, select on jobs.job to customer; 
grant             select on jobs.action to customer;
grant             select on jobs.multi_job_component to customer;
grant             select on jobs.multi_job to customer;
grant             select on jobs.job_code_ref to customer;
grant             select, insert, update  on jobs.multi_job_ref to customer;
grant             select, insert, update  on jobs.multi_job_comp_ref to customer;
grant             select, insert, update  on jobs.job_comp_dep_ref to customer;

exit
