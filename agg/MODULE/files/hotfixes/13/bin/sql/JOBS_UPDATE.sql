insert into jobs.job_code_ref (JOB_CODE_ID, WEIGHT, PARAMETERS, CLASS_NAME, BLOCKING_STATUS, DESCRIPTION, JOB_CATEGORY_ID, COMPRESSED_LOGS, PARAMETERS_URL)
values (100200, 2, '-script run_missing_node_matches.pl', 'uk.co.cartesian.ascertain.jobs.extensions.server.ExtendedExternalJob', '', 'Run Missing Node Matches', 35003, 'N', '');

insert into jobs.option_ref (OPTION_ID, LABEL, IS_MULTISELECT, DESCRIPTION, DEFAULT_VALUE)
values (100200, 'Look days back', '', '', '14');

insert into jobs.option_job_jn (OPTION_ID, JOB_CODE_ID)
values (100200, 100200);

insert into jobs.option_value_ref (OPTION_ID, FLAG, VALUE, DESCRIPTION, DISPLAY_ORDER)
values (100200, '-lookbackdays', '70', '10 Weeks', null);

insert into jobs.option_value_ref (OPTION_ID, FLAG, VALUE, DESCRIPTION, DISPLAY_ORDER)
values (100200, '-lookbackdays', '63', '9 Weeks', null);

insert into jobs.option_value_ref (OPTION_ID, FLAG, VALUE, DESCRIPTION, DISPLAY_ORDER)
values (100200, '-lookbackdays', '84', '12 Weeks', null);

insert into jobs.option_value_ref (OPTION_ID, FLAG, VALUE, DESCRIPTION, DISPLAY_ORDER)
values (100200, '-lookbackdays', '77', '11 Weeks', null);

insert into jobs.option_value_ref (OPTION_ID, FLAG, VALUE, DESCRIPTION, DISPLAY_ORDER)
values (100200, '-lookbackdays', '56', '8 Weeks', null);

insert into jobs.option_value_ref (OPTION_ID, FLAG, VALUE, DESCRIPTION, DISPLAY_ORDER)
values (100200, '-lookbackdays', '7', '1 Week', null);

insert into jobs.option_value_ref (OPTION_ID, FLAG, VALUE, DESCRIPTION, DISPLAY_ORDER)
values (100200, '-lookbackdays', '14', '2 Weeks', null);

insert into jobs.option_value_ref (OPTION_ID, FLAG, VALUE, DESCRIPTION, DISPLAY_ORDER)
values (100200, '-lookbackdays', '21', '3 Weeks', null);

insert into jobs.option_value_ref (OPTION_ID, FLAG, VALUE, DESCRIPTION, DISPLAY_ORDER)
values (100200, '-lookbackdays', '28', '4 Weeks', null);

insert into jobs.option_value_ref (OPTION_ID, FLAG, VALUE, DESCRIPTION, DISPLAY_ORDER)
values (100200, '-lookbackdays', '49', '7 Weeks', null);

insert into jobs.option_value_ref (OPTION_ID, FLAG, VALUE, DESCRIPTION, DISPLAY_ORDER)
values (100200, '-lookbackdays', '42', '6 Weeks', null);

insert into jobs.option_value_ref (OPTION_ID, FLAG, VALUE, DESCRIPTION, DISPLAY_ORDER)
values (100200, '-lookbackdays', '35', '5 Weeks', null);

commit;
exit;
