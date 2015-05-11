

insert into jobs.job_code_ref (JOB_CODE_ID, WEIGHT, PARAMETERS, CLASS_NAME, BLOCKING_STATUS, DESCRIPTION, JOB_CATEGORY_ID, COMPRESSED_LOGS, PARAMETERS_URL)
values (3000, 5, '-node_id 3000 -node_instance 3000i1', 'uk.co.cartesian.ascertain.imm.jms.SQLIssueActionMessageConsumerJob', '', 'Process IM SQL Action Queue', 3000, 'N', '');

commit;
exit;
