alter table jobs.option_sql_ref modify sql varchar2(4000);

update jobs.job_code_ref jc
set    jc.weight = 7
where  job_code_id in (35450,35455,5000,5010);

update jobs.job_code_ref jc
set    jc.weight = 5
where  job_code_id in (100200);


insert into jobs.job_code_ref (JOB_CODE_ID, WEIGHT, PARAMETERS, CLASS_NAME, BLOCKING_STATUS, DESCRIPTION, JOB_CATEGORY_ID, COMPRESSED_LOGS, PARAMETERS_URL)
values (140000, 1, '-script writeTaskFile', 'uk.co.cartesian.ascertain.jobs.extensions.server.ExtendedExternalJob', 'writeTask', 'Extract Event Detail Records', 35001, 'N', '');


insert into jobs.option_ref (OPTION_ID, LABEL, IS_MULTISELECT, DESCRIPTION, DEFAULT_VALUE)
values (36000, 'Datasource', '', 'Aggregator Datasource', '');

insert into jobs.option_ref (OPTION_ID, LABEL, IS_MULTISELECT, DESCRIPTION, DEFAULT_VALUE)
values (36001, 'Service Type', '', 'Aggregator Service Type', '');

insert into jobs.option_ref (OPTION_ID, LABEL, IS_MULTISELECT, DESCRIPTION, DEFAULT_VALUE)
values (36002, 'Start Date', '', 'Aggregator Start Date', '');

insert into jobs.option_ref (OPTION_ID, LABEL, IS_MULTISELECT, DESCRIPTION, DEFAULT_VALUE)
values (36003, 'Start Hour', '', 'Aggregator Start Hour', '');

insert into jobs.option_ref (OPTION_ID, LABEL, IS_MULTISELECT, DESCRIPTION, DEFAULT_VALUE)
values (36004, 'End Date', '', 'Aggregator Start Date', '');

insert into jobs.option_ref (OPTION_ID, LABEL, IS_MULTISELECT, DESCRIPTION, DEFAULT_VALUE)
values (36005, 'End Hour', '', 'Aggregator End Hour', '');

insert into jobs.option_ref (OPTION_ID, LABEL, IS_MULTISELECT, DESCRIPTION, DEFAULT_VALUE)
values (36006, 'Max Records', '', 'Aggregator Max Records to dump', '10000000');


insert into jobs.option_sql_ref (OPTION_SQL_ID, OPTION_ID, FLAG, SQL)
values (36000, 36000, '-ds', 'select n.description || '' ('' || n.name || '')'', n.description from dgf.node_ref n, dgf.node_type_ref t where t.node_type_id = n.node_type_id and t.node_type = ''Data Source'' order by n.description');

insert into jobs.option_sql_ref (OPTION_SQL_ID, OPTION_ID, FLAG, SQL)
values (36001, 36001, '-st', 'select regexp_replace(t.name, '' - EDR Count'', ''''), regexp_replace(t.name, '' - EDR Count'', '''') from um.metric_definition_ref t where t.name like ''%EDR Count''');

insert into jobs.option_sql_ref (OPTION_SQL_ID, OPTION_ID, FLAG, SQL)
values (36002, 36002, '-start_date', 'select to_char((sysdate -1), ''DD-MON-YYYY''), to_char((sysdate -1), ''YYYYMMDD'')  from dual  union select to_char((sysdate -2), ''DD-MON-YYYY''), to_char((sysdate -2), ''YYYYMMDD'')  from dual  union select to_char((sysdate -3), ''DD-MON-YYYY''), to_char((sysdate -3), ''YYYYMMDD'')  from dual  union select to_char((sysdate -4), ''DD-MON-YYYY''), to_char((sysdate -4), ''YYYYMMDD'')  from dual  union select to_char((sysdate -5), ''DD-MON-YYYY''), to_char((sysdate -5), ''YYYYMMDD'')  from dual  union select to_char((sysdate -6), ''DD-MON-YYYY''), to_char((sysdate -6), ''YYYYMMDD'')  from dual union select to_char((sysdate -7), ''DD-MON-YYYY''), to_char((sysdate -7), ''YYYYMMDD'')  from dual union select to_char((sysdate -8), ''DD-MON-YYYY''), to_char((sysdate -8), ''YYYYMMDD'')  from dual union select to_char((sysdate -9), ''DD-MON-YYYY''), to_char((sysdate -9), ''YYYYMMDD'')  from dual union select to_char((sysdate -10), ''DD-MON-YYYY''), to_char((sysdate -10), ''YYYYMMDD'')  from dual union select to_char((sysdate -11), ''DD-MON-YYYY''), to_char((sysdate -11), ''YYYYMMDD'')  from dual union select to_char((sysdate -12), ''DD-MON-YYYY''), to_char((sysdate -12), ''YYYYMMDD'')  from dual union select to_char((sysdate -13), ''DD-MON-YYYY''), to_char((sysdate -13), ''YYYYMMDD'')  from dual union select to_char((sysdate -14), ''DD-MON-YYYY''), to_char((sysdate -14), ''YYYYMMDD'')  from dual union select to_char((sysdate -15), ''DD-MON-YYYY''), to_char((sysdate -15), ''YYYYMMDD'')  from dual union select to_char((sysdate -16), ''DD-MON-YYYY''), to_char((sysdate -16), ''YYYYMMDD'')  from dual union select to_char((sysdate -17), ''DD-MON-YYYY''), to_char((sysdate -17), ''YYYYMMDD'')  from dual union select to_char((sysdate -18), ''DD-MON-YYYY''), to_char((sysdate -18), ''YYYYMMDD'')  from dual union select to_char((sysdate -19), ''DD-MON-YYYY''), to_char((sysdate -19), ''YYYYMMDD'')  from dual union select to_char((sysdate -20), ''DD-MON-YYYY''), to_char((sysdate -20), ''YYYYMMDD'')  from dual union select to_char((sysdate -21), ''DD-MON-YYYY''), to_char((sysdate -21), ''YYYYMMDD'')  from dual ');

insert into jobs.option_sql_ref (OPTION_SQL_ID, OPTION_ID, FLAG, SQL)
values (36003, 36003, '-start_hour', 'select ''00'', ''00''  from dual  union select ''01'', ''01''  from dual union select ''02'', ''02''  from dual union select ''03'', ''03''  from dual union select ''04'', ''04''  from dual union select ''05'', ''05''  from dual union select ''06'', ''06''  from dual union select ''07'', ''07''  from dual union select ''08'', ''08''  from dual union select ''09'', ''09''  from dual union select ''10'', ''10''  from dual union select ''11'', ''11''  from dual union select ''12'', ''12''  from dual union select ''13'', ''13''  from dual union select ''14'', ''14''  from dual union select ''15'', ''15''  from dual union select ''16'', ''16''  from dual union select ''17'', ''17''  from dual union select ''18'', ''18''  from dual union select ''19'', ''19''  from dual union select ''20'', ''20''  from dual union select ''21'', ''21''  from dual union select ''22'', ''22''  from dual union select ''23'', ''23''  from dual');

insert into jobs.option_sql_ref (OPTION_SQL_ID, OPTION_ID, FLAG, SQL)
values (36004, 36004, '-end_date', 'select to_char((sysdate -1), ''DD-MON-YYYY''), to_char((sysdate -1), ''YYYYMMDD'')  from dual  union select to_char((sysdate -2), ''DD-MON-YYYY''), to_char((sysdate -2), ''YYYYMMDD'')  from dual  union select to_char((sysdate -3), ''DD-MON-YYYY''), to_char((sysdate -3), ''YYYYMMDD'')  from dual  union select to_char((sysdate -4), ''DD-MON-YYYY''), to_char((sysdate -4), ''YYYYMMDD'')  from dual  union select to_char((sysdate -5), ''DD-MON-YYYY''), to_char((sysdate -5), ''YYYYMMDD'')  from dual  union select to_char((sysdate -6), ''DD-MON-YYYY''), to_char((sysdate -6), ''YYYYMMDD'')  from dual union select to_char((sysdate -7), ''DD-MON-YYYY''), to_char((sysdate -7), ''YYYYMMDD'')  from dual union select to_char((sysdate -8), ''DD-MON-YYYY''), to_char((sysdate -8), ''YYYYMMDD'')  from dual union select to_char((sysdate -9), ''DD-MON-YYYY''), to_char((sysdate -9), ''YYYYMMDD'')  from dual union select to_char((sysdate -10), ''DD-MON-YYYY''), to_char((sysdate -10), ''YYYYMMDD'')  from dual union select to_char((sysdate -11), ''DD-MON-YYYY''), to_char((sysdate -11), ''YYYYMMDD'')  from dual union select to_char((sysdate -12), ''DD-MON-YYYY''), to_char((sysdate -12), ''YYYYMMDD'')  from dual union select to_char((sysdate -13), ''DD-MON-YYYY''), to_char((sysdate -13), ''YYYYMMDD'')  from dual union select to_char((sysdate -14), ''DD-MON-YYYY''), to_char((sysdate -14), ''YYYYMMDD'')  from dual union select to_char((sysdate -15), ''DD-MON-YYYY''), to_char((sysdate -15), ''YYYYMMDD'')  from dual union select to_char((sysdate -16), ''DD-MON-YYYY''), to_char((sysdate -16), ''YYYYMMDD'')  from dual union select to_char((sysdate -17), ''DD-MON-YYYY''), to_char((sysdate -17), ''YYYYMMDD'')  from dual union select to_char((sysdate -18), ''DD-MON-YYYY''), to_char((sysdate -18), ''YYYYMMDD'')  from dual union select to_char((sysdate -19), ''DD-MON-YYYY''), to_char((sysdate -19), ''YYYYMMDD'')  from dual union select to_char((sysdate -20), ''DD-MON-YYYY''), to_char((sysdate -20), ''YYYYMMDD'')  from dual union select to_char((sysdate -21), ''DD-MON-YYYY''), to_char((sysdate -21), ''YYYYMMDD'')  from dual ');

insert into jobs.option_sql_ref (OPTION_SQL_ID, OPTION_ID, FLAG, SQL)
values (36005, 36005, '-end_hour', 'select ''00'', ''00''  from dual  union select ''01'', ''01''  from dual union select ''02'', ''02''  from dual union select ''03'', ''03''  from dual union select ''04'', ''04''  from dual union select ''05'', ''05''  from dual union select ''06'', ''06''  from dual union select ''07'', ''07''  from dual union select ''08'', ''08''  from dual union select ''09'', ''09''  from dual union select ''10'', ''10''  from dual union select ''11'', ''11''  from dual union select ''12'', ''12''  from dual union select ''13'', ''13''  from dual union select ''14'', ''14''  from dual union select ''15'', ''15''  from dual union select ''16'', ''16''  from dual union select ''17'', ''17''  from dual union select ''18'', ''18''  from dual union select ''19'', ''19''  from dual union select ''20'', ''20''  from dual union select ''21'', ''21''  from dual union select ''22'', ''22''  from dual union select ''23'', ''23''  from dual');

insert into jobs.option_sql_ref (OPTION_SQL_ID, OPTION_ID, FLAG, SQL)
values (36006, 36006, '-max_records', 'select ''10'', ''10''  from dual  union select ''100'', ''100''  from dual union select ''1000'', ''1000''  from dual union select ''10000'', ''10000''  from dual union select ''100000'', ''100000''  from dual union select ''1000000'', ''1000000''  from dual union select ''10000000'', ''10000000''  from dual ');


insert into jobs.option_job_jn (OPTION_ID, JOB_CODE_ID)
values (36000, 140000);

insert into jobs.option_job_jn (OPTION_ID, JOB_CODE_ID)
values (36001, 140000);

insert into jobs.option_job_jn (OPTION_ID, JOB_CODE_ID)
values (36002, 140000);

insert into jobs.option_job_jn (OPTION_ID, JOB_CODE_ID)
values (36003, 140000);

insert into jobs.option_job_jn (OPTION_ID, JOB_CODE_ID)
values (36004, 140000);

insert into jobs.option_job_jn (OPTION_ID, JOB_CODE_ID)
values (36005, 140000);

insert into jobs.option_job_jn (OPTION_ID, JOB_CODE_ID)
values (36006, 140000);



commit;

exit
