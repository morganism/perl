
insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (100289, '(M) Import PGW', '-daemon no -load_type 1 -mapping 100079', 5000);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (100290, '(M) Import SGW', '-daemon no -load_type 1 -mapping 100080', 5000);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (100291, '(M) Import SGSN', '-daemon no -load_type 1 -mapping 100081', 5000);



insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (100558, '(M) Node DS70', '-node 100150 -match 100000 -daemon no -offset 1 --terminatetime 23:59:59', 1);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (100559, '(M) Node DS71', '-node 100151 -match 100000 -daemon no -offset 1 --terminatetime 23:59:59', 1);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (100560, '(M) Node DS72', '-node 100152 -match 100000 -daemon no -offset 1 --terminatetime 23:59:59', 1);



insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (100758, '(M) Forecasts multi-job for node 100150', '-node_id 100150 -offset 1', 35004);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (100759, '(M) Forecasts multi-job for node 100151', '-node_id 100151 -offset 1', 35004);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (100760, '(M) Forecasts multi-job for node 100152', '-node_id 100152 -offset 1', 35004);



insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (100289, 102000, 100289, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (100290, 102000, 100290, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (100291, 102000, 100291, null);



insert into jobs.job_comp_dep_ref (PARENT_COMP_ID, DEPENDENT_COMP_ID)
values (100289, 100288);

insert into jobs.job_comp_dep_ref (PARENT_COMP_ID, DEPENDENT_COMP_ID)
values (100290, 100289);

insert into jobs.job_comp_dep_ref (PARENT_COMP_ID, DEPENDENT_COMP_ID)
values (100291, 100290);


insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (102124, 100289, null, 5000);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (102125, 100290, null, 5000);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (102126, 100291, null, 5000);

---

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (100558, 104000, 100558, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (100559, 104000, 100559, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (100560, 104000, 100560, null);


insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (104205, 100558, null, 35105);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (104204, 100558, null, 35110);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (100758, 100558, 100758, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (104206, 100559, null, 35110);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (104207, 100559, null, 35105);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (100759, 100559, 100759, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (104209, 100560, null, 35105);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (104208, 100560, null, 35110);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (100760, 100560, 100760, null);




insert into jobs.job_comp_dep_ref (PARENT_COMP_ID, DEPENDENT_COMP_ID)
values (104205, 104204);

insert into jobs.job_comp_dep_ref (PARENT_COMP_ID, DEPENDENT_COMP_ID)
values (100758, 104205);

insert into jobs.job_comp_dep_ref (PARENT_COMP_ID, DEPENDENT_COMP_ID)
values (104207, 104206);

insert into jobs.job_comp_dep_ref (PARENT_COMP_ID, DEPENDENT_COMP_ID)
values (100759, 104207);

insert into jobs.job_comp_dep_ref (PARENT_COMP_ID, DEPENDENT_COMP_ID)
values (104209, 104208);

insert into jobs.job_comp_dep_ref (PARENT_COMP_ID, DEPENDENT_COMP_ID)
values (100760, 104209);



insert into jobs.job_code_ref (JOB_CODE_ID, WEIGHT, PARAMETERS, CLASS_NAME, BLOCKING_STATUS, DESCRIPTION, JOB_CATEGORY_ID, COMPRESSED_LOGS, PARAMETERS_URL)
values (100115, 1, '-source 100023 -daemon no -sample_size 4 -threads 1 -forecast_type METRIC -date_type rolling -offset 1 -metric "0" -duration 1', 'uk.co.cartesian.ascertain.um.job.ForecastsAndTrendsJob', 'source_100023', 'Forecast (all metrics) for source PGW', 35004, 'N', '');

insert into jobs.job_code_ref (JOB_CODE_ID, WEIGHT, PARAMETERS, CLASS_NAME, BLOCKING_STATUS, DESCRIPTION, JOB_CATEGORY_ID, COMPRESSED_LOGS, PARAMETERS_URL)
values (100116, 1, '-source 100024 -daemon no -sample_size 4 -threads 1 -forecast_type METRIC -date_type rolling -offset 1 -metric "0" -duration 1', 'uk.co.cartesian.ascertain.um.job.ForecastsAndTrendsJob', 'source_100024', 'Forecast (all metrics) for source SGW', 35004, 'N', '');

insert into jobs.job_code_ref (JOB_CODE_ID, WEIGHT, PARAMETERS, CLASS_NAME, BLOCKING_STATUS, DESCRIPTION, JOB_CATEGORY_ID, COMPRESSED_LOGS, PARAMETERS_URL)
values (100117, 1, '-source 100025 -daemon no -sample_size 4 -threads 1 -forecast_type METRIC -date_type rolling -offset 1 -metric "0" -duration 1', 'uk.co.cartesian.ascertain.um.job.ForecastsAndTrendsJob', 'source_100025', 'Forecast (all metrics) for source SGSN', 35004, 'N', '');


insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (104210, 100758, null, 100115);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (104211, 100759, null, 100116);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (104212, 100760, null, 100117);




insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (105160, '(M) PGW vs SGSN (bytes) - ST_DATA_2G - EDR Bytes', '-mrec_id 100060 -num_days 7 -offset 8', 35005);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (105161, '(M) PGW vs SGSN (bytes) - ST_DATA_3G - EDR Bytes', '-mrec_id 100061 -num_days 7 -offset 8', 35005);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (105162, '(M) PGW vs SGW (bytes) - ST_DATA_4G - EDR Bytes', '-mrec_id 100062 -num_days 7 -offset 8', 35005);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (105163, '(M) PGW vs SGW (bytes) - ST_DATA_WAP - EDR Bytes', '-mrec_id 100063 -num_days 7 -offset 8', 35005);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (105164, '(M) PGW vs SGSN (bytes) - ST_DATA_WAP - EDR Bytes', '-mrec_id 100064 -num_days 7 -offset 8', 35005);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (105165, '(M) SGSN vs SGW (bytes) - ST_DATA_WAP - EDR Bytes', '-mrec_id 100065 -num_days 7 -offset 8', 35005);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (105166, '(M) PGW vs SGW (bytes) - ST_DATA_GPRS - EDR Bytes', '-mrec_id 100066 -num_days 7 -offset 8', 35005);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (105167, '(M) PGW vs SGSN (bytes) - ST_DATA_GPRS - EDR Bytes', '-mrec_id 100067 -num_days 7 -offset 8', 35005);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (105168, '(M) SGSN vs SGW (bytes) - ST_DATA_GPRS - EDR Bytes', '-mrec_id 100068 -num_days 7 -offset 8', 35005);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (105169, '(M) PGW vs EMM Data (bytes) - ST_DATA_GPRS - EDR Bytes', '-mrec_id 100069 -num_days 7 -offset 8', 35005);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (105170, '(M) PGW vs EMM Data (bytes) - ST_DATA_WAP - EDR Bytes', '-mrec_id 100070 -num_days 7 -offset 8', 35005);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (105171, '(M) PGW vs EMM Data (bytes) - ST_DATA_2G - EDR Bytes', '-mrec_id 100071 -num_days 7 -offset 8', 35005);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (105172, '(M) PGW vs EMM Data (bytes) - ST_DATA_3G - EDR Bytes', '-mrec_id 100072 -num_days 7 -offset 8', 35005);

insert into jobs.multi_job_ref (MULTI_JOB_REF_ID, DESCRIPTION, PARAMETERS, JOB_CATEGORY_ID)
values (105173, '(M) PGW vs EMM Data (bytes) - ST_DATA_4G - EDR Bytes', '-mrec_id 100073 -num_days 7 -offset 8', 35005);




insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105260, 105000, 105160, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105261, 105000, 105161, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105262, 105000, 105162, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105263, 105000, 105163, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105264, 105000, 105164, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105265, 105000, 105165, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105266, 105000, 105166, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105267, 105000, 105167, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105268, 105000, 105168, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105269, 105000, 105169, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105270, 105000, 105170, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105271, 105000, 105171, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105272, 105000, 105172, null);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105273, 105000, 105173, null);









insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105160, 105160, null, 35501);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105161, 105161, null, 35501);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105162, 105162, null, 35501);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105163, 105163, null, 35501);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105164, 105164, null, 35501);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105165, 105165, null, 35501);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105166, 105166, null, 35501);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105167, 105167, null, 35501);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105168, 105168, null, 35501);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105169, 105169, null, 35501);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105170, 105170, null, 35501);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105171, 105171, null, 35501);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105172, 105172, null, 35501);

insert into jobs.multi_job_comp_ref (COMP_REF_ID, PARENT_JOB_REF_ID, MULTI_JOB_REF_ID, JOB_CODE_ID)
values (105173, 105173, null, 35501);









commit;

exit
