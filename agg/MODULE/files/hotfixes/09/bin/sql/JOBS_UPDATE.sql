
update jobs.multi_job_ref m
set    m.parameters = replace(m.parameters,'-num_days 21 -offset 28','-num_days 70 -offset 79')
where  m.multi_job_ref_id in (105137,105138,105140,105141,105143,105146);

commit:

exit
