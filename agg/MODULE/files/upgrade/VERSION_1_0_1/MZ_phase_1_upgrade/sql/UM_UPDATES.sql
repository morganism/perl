set define off

insert into um.source_type_ref (SOURCE_TYPE_ID, SOURCE_TYPE, DESCRIPTION)
values (100023, 'PGW', 'PGW');

insert into um.source_type_ref (SOURCE_TYPE_ID, SOURCE_TYPE, DESCRIPTION)
values (100024, 'SGW', 'SGW');

insert into um.source_type_ref (SOURCE_TYPE_ID, SOURCE_TYPE, DESCRIPTION)
values (100025, 'SGSN', 'SGSN');

insert into um.source_ref (SOURCE_ID, SOURCE_TYPE_ID, REGION_ID, SYSTEM_ID, COUNTRY_ID, NAME, IDENTIFIER)
values (100023, 100023, -1, -1, -1, 'PGW', 'PGW');

insert into um.source_ref (SOURCE_ID, SOURCE_TYPE_ID, REGION_ID, SYSTEM_ID, COUNTRY_ID, NAME, IDENTIFIER)
values (100024, 100024, -1, -1, -1, 'SGW', 'SGW');

insert into um.source_ref (SOURCE_ID, SOURCE_TYPE_ID, REGION_ID, SYSTEM_ID, COUNTRY_ID, NAME, IDENTIFIER)
values (100025, 100025, -1, -1, -1, 'SGSN', 'SGSN');


insert into um.d_custom_01 (D_CUSTOM_01_ID, CUSTOM_TYPE, DESCRIPTION)
values (100076, 'ST_DATA_2G', 'Data 2G');

insert into um.d_custom_01 (D_CUSTOM_01_ID, CUSTOM_TYPE, DESCRIPTION)
values (100077, 'ST_DATA_3G', 'Data 3G');

insert into um.d_custom_01 (D_CUSTOM_01_ID, CUSTOM_TYPE, DESCRIPTION)
values (100078, 'ST_DATA_4G', 'Data 4G');

insert into um.d_custom_01 (D_CUSTOM_01_ID, CUSTOM_TYPE, DESCRIPTION)
values (100079, 'ST_DATA_2G_PREPAID', 'Data 2G Prepaid');

insert into um.d_custom_01 (D_CUSTOM_01_ID, CUSTOM_TYPE, DESCRIPTION)
values (100080, 'ST_DATA_2G_POSTPAID', 'Data 2G Postpaid');

insert into um.d_custom_01 (D_CUSTOM_01_ID, CUSTOM_TYPE, DESCRIPTION)
values (100081, 'ST_DATA_3G_PREPAID', 'Data 3G Prepaid');

insert into um.d_custom_01 (D_CUSTOM_01_ID, CUSTOM_TYPE, DESCRIPTION)
values (100082, 'ST_DATA_3G_POSTPAID', 'Data 3G Postpaid');

insert into um.d_custom_01 (D_CUSTOM_01_ID, CUSTOM_TYPE, DESCRIPTION)
values (100083, 'ST_DATA_4G_PREPAID', 'Data 4G Prepaid');

insert into um.d_custom_01 (D_CUSTOM_01_ID, CUSTOM_TYPE, DESCRIPTION)
values (100084, 'ST_DATA_4G_POSTPAID', 'Data 4G Postpaid');




insert into um.source_desc_ref (NODE_ID, SOURCE_DESCRIPTION, SOURCE_ID)
values (100150, 'DS70', 100023);

insert into um.source_desc_ref (NODE_ID, SOURCE_DESCRIPTION, SOURCE_ID)
values (100151, 'DS71', 100024);

insert into um.source_desc_ref (NODE_ID, SOURCE_DESCRIPTION, SOURCE_ID)
values (100152, 'DS72', 100025);


insert into um.node_match_jn (NODE_ID, FILE_MATCH_DEFINITION_ID)
values (100150, 100000);

insert into um.node_match_jn (NODE_ID, FILE_MATCH_DEFINITION_ID)
values (100151, 100000);

insert into um.node_match_jn (NODE_ID, FILE_MATCH_DEFINITION_ID)
values (100152, 100000);




----


insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100441, 'ST_DATA_2G - EDR Count', 'ST_DATA_2G - EDR Count', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100442, 'ST_DATA_2G - EDR Bytes', 'ST_DATA_2G - EDR Bytes', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100443, 'ST_DATA_2G - EDR Duration', 'ST_DATA_2G - EDR Duration', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100444, 'ST_DATA_2G - EDR Value', 'ST_DATA_2G - EDR Value', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100445, 'ST_DATA_3G - EDR Count', 'ST_DATA_3G - EDR Count', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100446, 'ST_DATA_3G - EDR Bytes', 'ST_DATA_3G - EDR Bytes', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100447, 'ST_DATA_3G - EDR Duration', 'ST_DATA_3G - EDR Duration', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100448, 'ST_DATA_3G - EDR Value', 'ST_DATA_3G - EDR Value', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100449, 'ST_DATA_4G - EDR Count', 'ST_DATA_4G - EDR Count', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100450, 'ST_DATA_4G - EDR Bytes', 'ST_DATA_4G - EDR Bytes', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100451, 'ST_DATA_4G - EDR Duration', 'ST_DATA_4G - EDR Duration', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100452, 'ST_DATA_4G - EDR Value', 'ST_DATA_4G - EDR Value', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100453, 'ST_DATA_2G_PREPAID - EDR Count', 'ST_DATA_2G_PREPAID - EDR Count', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100454, 'ST_DATA_2G_PREPAID - EDR Bytes', 'ST_DATA_2G_PREPAID - EDR Bytes', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100455, 'ST_DATA_2G_PREPAID - EDR Duration', 'ST_DATA_2G_PREPAID - EDR Duration', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100456, 'ST_DATA_2G_PREPAID - EDR Value', 'ST_DATA_2G_PREPAID - EDR Value', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100457, 'ST_DATA_2G_POSTPAID - EDR Count', 'ST_DATA_2G_POSTPAID - EDR Count', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100458, 'ST_DATA_2G_POSTPAID - EDR Bytes', 'ST_DATA_2G_POSTPAID - EDR Bytes', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100459, 'ST_DATA_2G_POSTPAID - EDR Duration', 'ST_DATA_2G_POSTPAID - EDR Duration', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100460, 'ST_DATA_2G_POSTPAID - EDR Value', 'ST_DATA_2G_POSTPAID - EDR Value', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100461, 'ST_DATA_3G_PREPAID - EDR Count', 'ST_DATA_3G_PREPAID - EDR Count', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100462, 'ST_DATA_3G_PREPAID - EDR Bytes', 'ST_DATA_3G_PREPAID - EDR Bytes', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100463, 'ST_DATA_3G_PREPAID - EDR Duration', 'ST_DATA_3G_PREPAID - EDR Duration', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100464, 'ST_DATA_3G_PREPAID - EDR Value', 'ST_DATA_3G_PREPAID - EDR Value', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100465, 'ST_DATA_3G_POSTPAID - EDR Count', 'ST_DATA_3G_POSTPAID - EDR Count', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100466, 'ST_DATA_3G_POSTPAID - EDR Bytes', 'ST_DATA_3G_POSTPAID - EDR Bytes', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100467, 'ST_DATA_3G_POSTPAID - EDR Duration', 'ST_DATA_3G_POSTPAID - EDR Duration', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100468, 'ST_DATA_3G_POSTPAID - EDR Value', 'ST_DATA_3G_POSTPAID - EDR Value', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100469, 'ST_DATA_4G_PREPAID - EDR Count', 'ST_DATA_4G_PREPAID - EDR Count', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100470, 'ST_DATA_4G_PREPAID - EDR Bytes', 'ST_DATA_4G_PREPAID - EDR Bytes', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100471, 'ST_DATA_4G_PREPAID - EDR Duration', 'ST_DATA_4G_PREPAID - EDR Duration', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100472, 'ST_DATA_4G_PREPAID - EDR Value', 'ST_DATA_4G_PREPAID - EDR Value', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100473, 'ST_DATA_4G_POSTPAID - EDR Count', 'ST_DATA_4G_POSTPAID - EDR Count', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100474, 'ST_DATA_4G_POSTPAID - EDR Bytes', 'ST_DATA_4G_POSTPAID - EDR Bytes', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100475, 'ST_DATA_4G_POSTPAID - EDR Duration', 'ST_DATA_4G_POSTPAID - EDR Duration', 7, 100000, 100000);

insert into um.metric_definition_ref (METRIC_DEFINITION_ID, NAME, DESCRIPTION, THRESHOLD_REAPPLY_PERIOD, METRIC_TYPE_ID, METRIC_CATEGORY_ID)
values (100476, 'ST_DATA_4G_POSTPAID - EDR Value', 'ST_DATA_4G_POSTPAID - EDR Value', 7, 100000, 100000);




insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100441, 100441, null, 'ST_DATA_2G - EDR Count - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100442, 100442, null, 'ST_DATA_2G - EDR Bytes - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100443, 100443, null, 'ST_DATA_2G - EDR Duration - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100444, 100444, null, 'ST_DATA_2G - EDR Value - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100445, 100445, null, 'ST_DATA_3G - EDR Count - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100446, 100446, null, 'ST_DATA_3G - EDR Bytes - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100447, 100447, null, 'ST_DATA_3G - EDR Duration - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100448, 100448, null, 'ST_DATA_3G - EDR Value - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100449, 100449, null, 'ST_DATA_4G - EDR Count - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100450, 100450, null, 'ST_DATA_4G - EDR Bytes - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100451, 100451, null, 'ST_DATA_4G - EDR Duration - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100452, 100452, null, 'ST_DATA_4G - EDR Value - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100453, 100453, null, 'ST_DATA_2G_PREPAID - EDR Count - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100454, 100454, null, 'ST_DATA_2G_PREPAID - EDR Bytes - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100455, 100455, null, 'ST_DATA_2G_PREPAID - EDR Duration - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100456, 100456, null, 'ST_DATA_2G_PREPAID - EDR Value - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100457, 100457, null, 'ST_DATA_2G_POSTPAID - EDR Count - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100458, 100458, null, 'ST_DATA_2G_POSTPAID - EDR Bytes - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100459, 100459, null, 'ST_DATA_2G_POSTPAID - EDR Duration - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100460, 100460, null, 'ST_DATA_2G_POSTPAID - EDR Value - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100461, 100461, null, 'ST_DATA_3G_PREPAID - EDR Count - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100462, 100462, null, 'ST_DATA_3G_PREPAID - EDR Bytes - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100463, 100463, null, 'ST_DATA_3G_PREPAID - EDR Duration - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100464, 100464, null, 'ST_DATA_3G_PREPAID - EDR Value - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100465, 100465, null, 'ST_DATA_3G_POSTPAID - EDR Count - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100466, 100466, null, 'ST_DATA_3G_POSTPAID - EDR Bytes - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100467, 100467, null, 'ST_DATA_3G_POSTPAID - EDR Duration - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100468, 100468, null, 'ST_DATA_3G_POSTPAID - EDR Value - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100469, 100469, null, 'ST_DATA_4G_PREPAID - EDR Count - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100470, 100470, null, 'ST_DATA_4G_PREPAID - EDR Bytes - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100471, 100471, null, 'ST_DATA_4G_PREPAID - EDR Duration - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100472, 100472, null, 'ST_DATA_4G_PREPAID - EDR Value - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100473, 100473, null, 'ST_DATA_4G_POSTPAID - EDR Count - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100474, 100474, null, 'ST_DATA_4G_POSTPAID - EDR Bytes - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100475, 100475, null, 'ST_DATA_4G_POSTPAID - EDR Duration - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');

insert into um.metric_version_ref (METRIC_VERSION_ID, METRIC_DEFINITION_ID, PARENT_VERSION_ID, DESCRIPTION, VALID_FROM, VALID_TO, STATUS)
values (100476, 100476, null, 'ST_DATA_4G_POSTPAID - EDR Value - Version 1', to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'A');



insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100441, 100001, 100441);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100442, 100001, 100442);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100443, 100001, 100443);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100444, 100001, 100444);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100445, 100001, 100445);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100446, 100001, 100446);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100447, 100001, 100447);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100448, 100001, 100448);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100449, 100001, 100449);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100450, 100001, 100450);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100451, 100001, 100451);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100452, 100001, 100452);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100453, 100001, 100453);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100454, 100001, 100454);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100455, 100001, 100455);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100456, 100001, 100456);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100457, 100001, 100457);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100458, 100001, 100458);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100459, 100001, 100459);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100460, 100001, 100460);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100461, 100001, 100461);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100462, 100001, 100462);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100463, 100001, 100463);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100464, 100001, 100464);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100465, 100001, 100465);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100466, 100001, 100466);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100467, 100001, 100467);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100468, 100001, 100468);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100469, 100001, 100469);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100470, 100001, 100470);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100471, 100001, 100471);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100472, 100001, 100472);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100473, 100001, 100473);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100474, 100001, 100474);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100475, 100001, 100475);

insert into um.forecast_metric_jn (FORECAST_METRIC_ID, FORECAST_DEFINITION_ID, METRIC_DEFINITION_ID)
values (100476, 100001, 100476);





insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100441, 100441, 13, 35127, 100441, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_2G - EDR Count');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100442, 100442, 10, 35127, 100442, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_2G - EDR Bytes');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100443, 100443, 4, 35127, 100443, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_2G - EDR Duration');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100444, 100444, 3, 35127, 100444, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_2G - EDR Value');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100445, 100445, 13, 35127, 100445, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_3G - EDR Count');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100446, 100446, 10, 35127, 100446, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_3G - EDR Bytes');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100447, 100447, 4, 35127, 100447, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_3G - EDR Duration');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100448, 100448, 3, 35127, 100448, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_3G - EDR Value');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100449, 100449, 13, 35127, 100449, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_4G - EDR Count');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100450, 100450, 10, 35127, 100450, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_4G - EDR Bytes');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100451, 100451, 4, 35127, 100451, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_4G - EDR Duration');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100452, 100452, 3, 35127, 100452, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_4G - EDR Value');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100453, 100453, 13, 35127, 100453, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_2G_PREPAID - EDR Count');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100454, 100454, 10, 35127, 100454, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_2G_PREPAID - EDR Bytes');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100455, 100455, 4, 35127, 100455, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_2G_PREPAID - EDR Duration');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100456, 100456, 3, 35127, 100456, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_2G_PREPAID - EDR Value');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100457, 100457, 13, 35127, 100457, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_2G_POSTPAID - EDR Count');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100458, 100458, 10, 35127, 100458, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_2G_POSTPAID - EDR Bytes');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100459, 100459, 4, 35127, 100459, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_2G_POSTPAID - EDR Duration');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100460, 100460, 3, 35127, 100460, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_2G_POSTPAID - EDR Value');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100461, 100461, 13, 35127, 100461, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_3G_PREPAID - EDR Count');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100462, 100462, 10, 35127, 100462, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_3G_PREPAID - EDR Bytes');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100463, 100463, 4, 35127, 100463, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_3G_PREPAID - EDR Duration');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100464, 100464, 3, 35127, 100464, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_3G_PREPAID - EDR Value');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100465, 100465, 13, 35127, 100465, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_3G_POSTPAID - EDR Count');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100466, 100466, 10, 35127, 100466, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_3G_POSTPAID - EDR Bytes');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100467, 100467, 4, 35127, 100467, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_3G_POSTPAID - EDR Duration');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100468, 100468, 3, 35127, 100468, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_3G_POSTPAID - EDR Value');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100469, 100469, 13, 35127, 100469, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_4G_PREPAID - EDR Count');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100470, 100470, 10, 35127, 100470, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_4G_PREPAID - EDR Bytes');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100471, 100471, 4, 35127, 100471, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_4G_PREPAID - EDR Duration');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100472, 100472, 3, 35127, 100472, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_4G_PREPAID - EDR Value');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100473, 100473, 13, 35127, 100473, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_4G_POSTPAID - EDR Count');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100474, 100474, 10, 35127, 100474, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_4G_POSTPAID - EDR Bytes');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100475, 100475, 4, 35127, 100475, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_4G_POSTPAID - EDR Duration');

insert into um.metric_operator_ref (METRIC_OPERATOR_ID, METRIC_VERSION_ID, UNIT_ID, OPERATOR_DEFINITION_ID, FORECAST_METRIC_ID, OPERATOR_ORDER, PARAMETERS, DESCRIPTION)
values (100476, 100476, 3, 35127, 100476, 1, '-syncOnMerge no -function sum -debug no -switch_to_raw no -threads 1 -distinct_filenames no', 'ST_DATA_4G_POSTPAID - EDR Value');




insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100441, 'C', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100076', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100442, 'B', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100076', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100443, 'D', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100076', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100444, 'V', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100076', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100445, 'C', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100077', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100446, 'B', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100077', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100447, 'D', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100077', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100448, 'V', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100077', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100449, 'C', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100078', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100450, 'B', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100078', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100451, 'D', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100078', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100452, 'V', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100078', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100453, 'C', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100079', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100454, 'B', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100079', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100455, 'D', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100079', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100456, 'V', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100079', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100457, 'C', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100080', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100458, 'B', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100080', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100459, 'D', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100080', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100460, 'V', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100080', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100461, 'C', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100081', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100462, 'B', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100081', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100463, 'D', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100081', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100464, 'V', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100081', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100465, 'C', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100082', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100466, 'B', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100082', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100467, 'D', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100082', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100468, 'V', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100082', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100469, 'C', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100083', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100470, 'B', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100083', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100471, 'D', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100083', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100472, 'V', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100083', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100473, 'C', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100084', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100474, 'B', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100084', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100475, 'D', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100084', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

insert into um.fmo_equation (METRIC_OPERATOR_ID, FIELD_TYPE, OPERATOR, ADJUSTER, SOURCE_ID, SOURCE_TYPE_ID, I_D_MEASURE_TYPE_ID, J_D_MEASURE_TYPE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, D_PAYMENT_TYPE_ID, D_CALL_TYPE_ID, D_CUSTOMER_TYPE_ID, D_SERVICE_PROVIDER_ID, D_CUSTOM_01_LIST, D_CUSTOM_02_LIST, D_CUSTOM_03_LIST, D_CUSTOM_04_LIST, D_CUSTOM_05_LIST, D_CUSTOM_06_LIST, D_CUSTOM_07_LIST, D_CUSTOM_08_LIST, D_CUSTOM_09_LIST, D_CUSTOM_10_LIST, D_CUSTOM_11_LIST, D_CUSTOM_12_LIST, D_CUSTOM_13_LIST, D_CUSTOM_14_LIST, D_CUSTOM_15_LIST, D_CUSTOM_16_LIST, D_CUSTOM_17_LIST, D_CUSTOM_18_LIST, D_CUSTOM_19_LIST, D_CUSTOM_20_LIST)
values (100476, 'V', 'Sum', null, null, null, 100, null, null, null, null, null, null, null, '100084', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');





insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100442, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100442, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100150, 100442, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100152, 100442, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100441, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100441, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100150, 100441, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100152, 100441, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100443, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100443, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100150, 100443, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100152, 100443, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100444, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100458, null, null, null, null, 100000, 'Y', 'Y');


insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100141, 100458, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100458, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100457, null, null, null, null, 100000, 'Y', 'Y');


insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100141, 100457, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100457, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100459, null, null, null, null, 100000, 'Y', 'Y');


insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100141, 100459, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100459, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100460, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100454, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100453, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100455, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100446, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100446, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100150, 100446, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100152, 100446, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100445, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100445, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100150, 100445, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100152, 100445, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100447, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100447, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100150, 100447, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100152, 100447, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100448, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100466, null, null, null, null, 100000, 'Y', 'Y');


insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100141, 100466, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100466, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100465, null, null, null, null, 100000, 'Y', 'Y');


insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100141, 100465, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100465, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100467, null, null, null, null, 100000, 'Y', 'Y');


insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100141, 100467, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100467, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100468, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100462, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100461, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100463, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100450, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100450, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100150, 100450, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100151, 100450, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100449, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100449, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100150, 100449, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100151, 100449, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100451, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100451, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100150, 100451, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100151, 100451, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100452, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100474, null, null, null, null, 100000, 'Y', 'Y');


insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100141, 100474, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100474, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100473, null, null, null, null, 100000, 'Y', 'Y');


insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100141, 100473, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100473, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100475, null, null, null, null, 100000, 'Y', 'Y');


insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100141, 100475, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100475, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100120, 100476, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100470, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100469, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100107, 100471, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100150, 100271, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100151, 100271, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100152, 100271, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100150, 100025, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100151, 100025, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100152, 100025, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100150, 100033, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100151, 100033, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100152, 100033, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100150, 100274, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100151, 100274, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100152, 100274, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100150, 100042, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100151, 100042, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100152, 100042, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100150, 100051, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100151, 100051, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100152, 100051, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100150, 100032, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100150, 100000, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100150, 100181, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100151, 100032, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100151, 100000, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100151, 100181, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100152, 100181, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100152, 100000, null, null, null, null, 100000, 'Y', 'Y');

insert into um.node_metric_jn (NODE_ID, METRIC_DEFINITION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, SOURCE_ID, SOURCE_TYPE_ID, FILE_MATCH_DEFINITION_ID, IS_REGENERATE, IS_ACTIVE)
values (100152, 100032, null, null, null, null, 100000, 'Y', 'Y');






insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100045, 'ICCS Unbilled: ST_DATA_2G - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100442, 100120, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100046, 'EMM data: ST_DATA_2G - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100442, 100107, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100047, 'PGW: ST_DATA_2G - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100442, 100150, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100048, 'SGSN: ST_DATA_2G - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100442, 100152, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100049, 'ICCS Unbilled: ST_DATA_2G - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100441, 100120, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100050, 'EMM data: ST_DATA_2G - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100441, 100107, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100051, 'PGW: ST_DATA_2G - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100441, 100150, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100052, 'SGSN: ST_DATA_2G - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100441, 100152, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100053, 'ICCS Unbilled: ST_DATA_2G_POSTPAID - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100458, 100120, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100054, 'GPRS ICCS: ST_DATA_2G_POSTPAID - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100458, 100141, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');


insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100056, 'EMM data: ST_DATA_2G_POSTPAID - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100458, 100107, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100057, 'ICCS Unbilled: ST_DATA_2G_POSTPAID - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100457, 100120, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100058, 'GPRS ICCS: ST_DATA_2G_POSTPAID - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100457, 100141, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');


insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100060, 'EMM data: ST_DATA_2G_POSTPAID - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100457, 100107, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100061, 'EMM data: ST_DATA_2G_PREPAID - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100454, 100107, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100062, 'EMM data: ST_DATA_2G_PREPAID - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100453, 100107, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100063, 'ICCS Unbilled: ST_DATA_3G - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100446, 100120, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100064, 'EMM data: ST_DATA_3G - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100446, 100107, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100065, 'PGW: ST_DATA_3G - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100446, 100150, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100066, 'SGSN: ST_DATA_3G - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100446, 100152, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100067, 'ICCS Unbilled: ST_DATA_3G - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100445, 100120, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100068, 'EMM data: ST_DATA_3G - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100445, 100107, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100069, 'PGW: ST_DATA_3G - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100445, 100150, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100070, 'SGSN: ST_DATA_3G - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100445, 100152, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100071, 'ICCS Unbilled: ST_DATA_3G_POSTPAID - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100466, 100120, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100072, 'GPRS ICCS: ST_DATA_3G_POSTPAID - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100466, 100141, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');


insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100074, 'EMM data: ST_DATA_3G_POSTPAID - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100466, 100107, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100075, 'ICCS Unbilled: ST_DATA_3G_POSTPAID - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100465, 100120, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100076, 'GPRS ICCS: ST_DATA_3G_POSTPAID - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100465, 100141, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');


insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100078, 'EMM data: ST_DATA_3G_POSTPAID - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100465, 100107, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100079, 'EMM data: ST_DATA_3G_PREPAID - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100462, 100107, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100080, 'EMM data: ST_DATA_3G_PREPAID - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100461, 100107, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100081, 'ICCS Unbilled: ST_DATA_4G - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100450, 100120, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100082, 'EMM data: ST_DATA_4G - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100450, 100107, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100083, 'PGW: ST_DATA_4G - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100450, 100150, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100084, 'SGW: ST_DATA_4G - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100450, 100151, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100085, 'ICCS Unbilled: ST_DATA_4G - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100449, 100120, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100086, 'EMM data: ST_DATA_4G - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100449, 100107, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100087, 'PGW: ST_DATA_4G - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100449, 100150, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100088, 'SGW: ST_DATA_4G - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100449, 100151, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100089, 'ICCS Unbilled: ST_DATA_4G_POSTPAID - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100474, 100120, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100090, 'GPRS ICCS: ST_DATA_4G_POSTPAID - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100474, 100141, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');


insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100092, 'EMM data: ST_DATA_4G_POSTPAID - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100474, 100107, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100093, 'ICCS Unbilled: ST_DATA_4G_POSTPAID - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100473, 100120, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100094, 'GPRS ICCS: ST_DATA_4G_POSTPAID - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100473, 100141, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');


insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100096, 'EMM data: ST_DATA_4G_POSTPAID - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100473, 100107, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100097, 'EMM data: ST_DATA_4G_PREPAID - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100470, 100107, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100098, 'EMM data: ST_DATA_4G_PREPAID - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100469, 100107, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100099, 'PGW: ST_DATA_GPRS - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100271, 100150, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100100, 'SGW: ST_DATA_GPRS - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100271, 100151, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100101, 'SGSN: ST_DATA_GPRS - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100271, 100152, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100102, 'PGW: ST_DATA_GPRS - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100025, 100150, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100103, 'SGW: ST_DATA_GPRS - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100025, 100151, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100104, 'SGSN: ST_DATA_GPRS - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100025, 100152, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100105, 'PGW: ST_DATA_WAP - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100274, 100150, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100106, 'SGW: ST_DATA_WAP - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100274, 100151, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100107, 'SGSN: ST_DATA_WAP - EDR Bytes Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100274, 100152, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100108, 'PGW: ST_DATA_WAP - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100042, 100150, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100109, 'SGW: ST_DATA_WAP - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100042, 100151, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');

insert into um.CD_METRIC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, SAMPLE_FROM, SAMPLE_TO, METRIC_DEFINITION_ID, NODE_ID, EDGE_ID, SOURCE_TYPE_ID, SOURCE_ID, EDR_TYPE_ID, EDR_SUB_TYPE_ID, IS_MIN, IS_MAX, IS_AVERAGE, IS_MOVING_AVERAGE, IS_FORECAST, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100110, 'SGSN: ST_DATA_WAP - EDR Count Metric Chart', '/vfi-um/vfi-um/chartMetricSwfDisplay.do?rebuildFilters=true', '14', '0', 100042, 100152, null, null, null, null, null, 'Y', 'Y', 'Y', 'Y', 'Y', 450, 175, '', '');




insert into um.mrec_definition_ref (MREC_DEFINITION_ID, MREC_CATEGORY_ID, MREC_TYPE, GRAPH_ID, NAME, DESCRIPTION)
values (100060, 100013, 'T', 100001, 'PGW vs SGSN (bytes) - ST_DATA_2G - EDR Bytes', 'PGW vs SGSN (bytes) - ST_DATA_2G - EDR Bytes');

insert into um.mrec_definition_ref (MREC_DEFINITION_ID, MREC_CATEGORY_ID, MREC_TYPE, GRAPH_ID, NAME, DESCRIPTION)
values (100061, 100013, 'T', 100001, 'PGW vs SGSN (bytes) - ST_DATA_3G - EDR Bytes', 'PGW vs SGSN (bytes) - ST_DATA_3G - EDR Bytes');

insert into um.mrec_definition_ref (MREC_DEFINITION_ID, MREC_CATEGORY_ID, MREC_TYPE, GRAPH_ID, NAME, DESCRIPTION)
values (100062, 100013, 'T', 100001, 'PGW vs SGW (bytes) - ST_DATA_4G - EDR Bytes', 'PGW vs SGW (bytes) - ST_DATA_4G - EDR Bytes');

insert into um.mrec_definition_ref (MREC_DEFINITION_ID, MREC_CATEGORY_ID, MREC_TYPE, GRAPH_ID, NAME, DESCRIPTION)
values (100063, 100013, 'T', 100001, 'PGW vs SGW (bytes) - ST_DATA_WAP - EDR Bytes', 'PGW vs SGW (bytes) - ST_DATA_WAP - EDR Bytes');

insert into um.mrec_definition_ref (MREC_DEFINITION_ID, MREC_CATEGORY_ID, MREC_TYPE, GRAPH_ID, NAME, DESCRIPTION)
values (100064, 100013, 'T', 100001, 'PGW vs SGSN (bytes) - ST_DATA_WAP - EDR Bytes', 'PGW vs SGSN (bytes) - ST_DATA_WAP - EDR Bytes');

insert into um.mrec_definition_ref (MREC_DEFINITION_ID, MREC_CATEGORY_ID, MREC_TYPE, GRAPH_ID, NAME, DESCRIPTION)
values (100065, 100013, 'T', 100001, 'SGSN vs SGW (bytes) - ST_DATA_WAP - EDR Bytes', 'SGSN vs SGW (bytes) - ST_DATA_WAP - EDR Bytes');

insert into um.mrec_definition_ref (MREC_DEFINITION_ID, MREC_CATEGORY_ID, MREC_TYPE, GRAPH_ID, NAME, DESCRIPTION)
values (100066, 100013, 'T', 100001, 'PGW vs SGW (bytes) - ST_DATA_GPRS - EDR Bytes', 'PGW vs SGW (bytes) - ST_DATA_GPRS - EDR Bytes');

insert into um.mrec_definition_ref (MREC_DEFINITION_ID, MREC_CATEGORY_ID, MREC_TYPE, GRAPH_ID, NAME, DESCRIPTION)
values (100067, 100013, 'T', 100001, 'PGW vs SGSN (bytes) - ST_DATA_GPRS - EDR Bytes', 'PGW vs SGSN (bytes) - ST_DATA_GPRS - EDR Bytes');

insert into um.mrec_definition_ref (MREC_DEFINITION_ID, MREC_CATEGORY_ID, MREC_TYPE, GRAPH_ID, NAME, DESCRIPTION)
values (100068, 100013, 'T', 100001, 'SGSN vs SGW (bytes) - ST_DATA_GPRS - EDR Bytes', 'SGSN vs SGW (bytes) - ST_DATA_GPRS - EDR Bytes');

insert into um.mrec_definition_ref (MREC_DEFINITION_ID, MREC_CATEGORY_ID, MREC_TYPE, GRAPH_ID, NAME, DESCRIPTION)
values (100069, 100013, 'T', 100001, 'PGW vs EMM Data (bytes) - ST_DATA_GPRS - EDR Bytes', 'PGW vs EMM Data (bytes) - ST_DATA_GPRS - EDR Bytes');

insert into um.mrec_definition_ref (MREC_DEFINITION_ID, MREC_CATEGORY_ID, MREC_TYPE, GRAPH_ID, NAME, DESCRIPTION)
values (100070, 100013, 'T', 100001, 'PGW vs EMM Data (bytes) - ST_DATA_WAP - EDR Bytes', 'PGW vs EMM Data (bytes) - ST_DATA_WAP - EDR Bytes');

insert into um.mrec_definition_ref (MREC_DEFINITION_ID, MREC_CATEGORY_ID, MREC_TYPE, GRAPH_ID, NAME, DESCRIPTION)
values (100071, 100013, 'T', 100001, 'PGW vs EMM Data (bytes) - ST_DATA_2G - EDR Bytes', 'PGW vs EMM Data (bytes) - ST_DATA_2G - EDR Bytes');

insert into um.mrec_definition_ref (MREC_DEFINITION_ID, MREC_CATEGORY_ID, MREC_TYPE, GRAPH_ID, NAME, DESCRIPTION)
values (100072, 100013, 'T', 100001, 'PGW vs EMM Data (bytes) - ST_DATA_3G - EDR Bytes', 'PGW vs EMM Data (bytes) - ST_DATA_3G - EDR Bytes');

insert into um.mrec_definition_ref (MREC_DEFINITION_ID, MREC_CATEGORY_ID, MREC_TYPE, GRAPH_ID, NAME, DESCRIPTION)
values (100073, 100013, 'T', 100001, 'PGW vs EMM Data (bytes) - ST_DATA_4G - EDR Bytes', 'PGW vs EMM Data (bytes) - ST_DATA_4G - EDR Bytes');










insert into um.mrec_version_ref (MREC_VERSION_ID, MREC_DEFINITION_ID, PARENT_VERSION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, FORECAST_MREC_ID, DESCRIPTION, PARAMETERS, VALID_FROM, VALID_TO, STATUS)
values (100060, 100060, null, null, null, null, 'PGW vs SGSN (bytes) - ST_DATA_2G - EDR Bytes', '', to_date('01-07-2013 00:00:01', 'dd-mm-yyyy hh24:mi:ss'), to_date('01-01-2021', 'dd-mm-yyyy'), 'A');

insert into um.mrec_version_ref (MREC_VERSION_ID, MREC_DEFINITION_ID, PARENT_VERSION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, FORECAST_MREC_ID, DESCRIPTION, PARAMETERS, VALID_FROM, VALID_TO, STATUS)
values (100061, 100061, null, null, null, null, 'PGW vs SGSN (bytes) - ST_DATA_3G - EDR Bytes', '', to_date('01-07-2013 00:00:01', 'dd-mm-yyyy hh24:mi:ss'), to_date('01-01-2021', 'dd-mm-yyyy'), 'A');

insert into um.mrec_version_ref (MREC_VERSION_ID, MREC_DEFINITION_ID, PARENT_VERSION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, FORECAST_MREC_ID, DESCRIPTION, PARAMETERS, VALID_FROM, VALID_TO, STATUS)
values (100062, 100062, null, null, null, null, 'PGW vs SGW (bytes) - ST_DATA_4G - EDR Bytes', '', to_date('01-07-2013 00:00:01', 'dd-mm-yyyy hh24:mi:ss'), to_date('01-01-2021', 'dd-mm-yyyy'), 'A');

insert into um.mrec_version_ref (MREC_VERSION_ID, MREC_DEFINITION_ID, PARENT_VERSION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, FORECAST_MREC_ID, DESCRIPTION, PARAMETERS, VALID_FROM, VALID_TO, STATUS)
values (100063, 100063, null, null, null, null, 'PGW vs SGW (bytes) - ST_DATA_WAP - EDR Bytes', '', to_date('01-07-2013 00:00:01', 'dd-mm-yyyy hh24:mi:ss'), to_date('01-01-2021', 'dd-mm-yyyy'), 'A');

insert into um.mrec_version_ref (MREC_VERSION_ID, MREC_DEFINITION_ID, PARENT_VERSION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, FORECAST_MREC_ID, DESCRIPTION, PARAMETERS, VALID_FROM, VALID_TO, STATUS)
values (100064, 100064, null, null, null, null, 'PGW vs SGSN (bytes) - ST_DATA_WAP - EDR Bytes', '', to_date('01-07-2013 00:00:01', 'dd-mm-yyyy hh24:mi:ss'), to_date('01-01-2021', 'dd-mm-yyyy'), 'A');

insert into um.mrec_version_ref (MREC_VERSION_ID, MREC_DEFINITION_ID, PARENT_VERSION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, FORECAST_MREC_ID, DESCRIPTION, PARAMETERS, VALID_FROM, VALID_TO, STATUS)
values (100065, 100065, null, null, null, null, 'SGSN vs SGW (bytes) - ST_DATA_WAP - EDR Bytes', '', to_date('01-07-2013 00:00:01', 'dd-mm-yyyy hh24:mi:ss'), to_date('01-01-2021', 'dd-mm-yyyy'), 'A');

insert into um.mrec_version_ref (MREC_VERSION_ID, MREC_DEFINITION_ID, PARENT_VERSION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, FORECAST_MREC_ID, DESCRIPTION, PARAMETERS, VALID_FROM, VALID_TO, STATUS)
values (100066, 100066, null, null, null, null, 'PGW vs SGW (bytes) - ST_DATA_GPRS - EDR Bytes', '', to_date('01-07-2013 00:00:01', 'dd-mm-yyyy hh24:mi:ss'), to_date('01-01-2021', 'dd-mm-yyyy'), 'A');

insert into um.mrec_version_ref (MREC_VERSION_ID, MREC_DEFINITION_ID, PARENT_VERSION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, FORECAST_MREC_ID, DESCRIPTION, PARAMETERS, VALID_FROM, VALID_TO, STATUS)
values (100067, 100067, null, null, null, null, 'PGW vs SGSN (bytes) - ST_DATA_GPRS - EDR Bytes', '', to_date('01-07-2013 00:00:01', 'dd-mm-yyyy hh24:mi:ss'), to_date('01-01-2021', 'dd-mm-yyyy'), 'A');

insert into um.mrec_version_ref (MREC_VERSION_ID, MREC_DEFINITION_ID, PARENT_VERSION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, FORECAST_MREC_ID, DESCRIPTION, PARAMETERS, VALID_FROM, VALID_TO, STATUS)
values (100068, 100068, null, null, null, null, 'SGSN vs SGW (bytes) - ST_DATA_GPRS - EDR Bytes', '', to_date('01-07-2013 00:00:01', 'dd-mm-yyyy hh24:mi:ss'), to_date('01-01-2021', 'dd-mm-yyyy'), 'A');

insert into um.mrec_version_ref (MREC_VERSION_ID, MREC_DEFINITION_ID, PARENT_VERSION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, FORECAST_MREC_ID, DESCRIPTION, PARAMETERS, VALID_FROM, VALID_TO, STATUS)
values (100069, 100069, null, null, null, null, 'PGW vs EMM Data (bytes) - ST_DATA_GPRS - EDR Bytes', '', to_date('01-07-2013 00:00:01', 'dd-mm-yyyy hh24:mi:ss'), to_date('01-01-2021', 'dd-mm-yyyy'), 'A');

insert into um.mrec_version_ref (MREC_VERSION_ID, MREC_DEFINITION_ID, PARENT_VERSION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, FORECAST_MREC_ID, DESCRIPTION, PARAMETERS, VALID_FROM, VALID_TO, STATUS)
values (100070, 100070, null, null, null, null, 'PGW vs EMM Data (bytes) - ST_DATA_WAP - EDR Bytes', '', to_date('01-07-2013 00:00:01', 'dd-mm-yyyy hh24:mi:ss'), to_date('01-01-2021', 'dd-mm-yyyy'), 'A');

insert into um.mrec_version_ref (MREC_VERSION_ID, MREC_DEFINITION_ID, PARENT_VERSION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, FORECAST_MREC_ID, DESCRIPTION, PARAMETERS, VALID_FROM, VALID_TO, STATUS)
values (100071, 100071, null, null, null, null, 'PGW vs EMM Data (bytes) - ST_DATA_2G - EDR Bytes', '', to_date('01-07-2013 00:00:01', 'dd-mm-yyyy hh24:mi:ss'), to_date('01-01-2021', 'dd-mm-yyyy'), 'A');

insert into um.mrec_version_ref (MREC_VERSION_ID, MREC_DEFINITION_ID, PARENT_VERSION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, FORECAST_MREC_ID, DESCRIPTION, PARAMETERS, VALID_FROM, VALID_TO, STATUS)
values (100072, 100072, null, null, null, null, 'PGW vs EMM Data (bytes) - ST_DATA_3G - EDR Bytes', '', to_date('01-07-2013 00:00:01', 'dd-mm-yyyy hh24:mi:ss'), to_date('01-01-2021', 'dd-mm-yyyy'), 'A');

insert into um.mrec_version_ref (MREC_VERSION_ID, MREC_DEFINITION_ID, PARENT_VERSION_ID, THRESHOLD_DEFINITION_ID, THRESHOLD_SEQUENCE_ID, FORECAST_MREC_ID, DESCRIPTION, PARAMETERS, VALID_FROM, VALID_TO, STATUS)
values (100073, 100073, null, null, null, null, 'PGW vs EMM Data (bytes) - ST_DATA_4G - EDR Bytes', '', to_date('01-07-2013 00:00:01', 'dd-mm-yyyy hh24:mi:ss'), to_date('01-01-2021', 'dd-mm-yyyy'), 'A');






insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100060, 100442, 100152, -1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100060, 100442, 100150, 1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100061, 100446, 100152, -1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100061, 100446, 100150, 1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100062, 100450, 100151, -1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100062, 100450, 100150, 1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100063, 100274, 100151, -1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100063, 100274, 100150, 1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100064, 100274, 100152, -1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100064, 100274, 100150, 1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100065, 100274, 100152, 1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100065, 100274, 100151, -1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100066, 100271, 100151, -1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100066, 100271, 100150, 1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100067, 100271, 100152, -1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100067, 100271, 100150, 1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100068, 100271, 100152, 1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100068, 100271, 100151, -1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100069, 100271, 100150, 1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100069, 100271, 100107, -1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100070, 100274, 100150, 1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100070, 100274, 100107, -1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100071, 100442, 100150, 1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100071, 100442, 100107, -1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100072, 100446, 100150, 1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100072, 100446, 100107, -1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100073, 100450, 100150, 1);

insert into um.mrec_metric_ref (MREC_VERSION_ID, METRIC_DEFINITION_ID, NODE_ID, MREC_SET)
values (100073, 100450, 100107, -1);


insert into um.CD_MREC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, MREC_DEFINITION_ID, EDGE_ID, SAMPLE_FROM, SAMPLE_TO, SHOW_DETAILS, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100060, 'PGW vs SGSN (bytes) - ST_DATA_2G - EDR Bytes', '/um/um/mrecChartSetup.do?mrecType=TIME&mrecDefinitionId_time=100060', 100060, null, '14', '0', 'R', 450, 175, '', '');

insert into um.CD_MREC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, MREC_DEFINITION_ID, EDGE_ID, SAMPLE_FROM, SAMPLE_TO, SHOW_DETAILS, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100061, 'PGW vs SGSN (bytes) - ST_DATA_3G - EDR Bytes', '/um/um/mrecChartSetup.do?mrecType=TIME&mrecDefinitionId_time=100061', 100061, null, '14', '0', 'R', 450, 175, '', '');

insert into um.CD_MREC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, MREC_DEFINITION_ID, EDGE_ID, SAMPLE_FROM, SAMPLE_TO, SHOW_DETAILS, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100062, 'PGW vs SGW (bytes) - ST_DATA_4G - EDR Bytes', '/um/um/mrecChartSetup.do?mrecType=TIME&mrecDefinitionId_time=100062', 100062, null, '14', '0', 'R', 450, 175, '', '');

insert into um.CD_MREC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, MREC_DEFINITION_ID, EDGE_ID, SAMPLE_FROM, SAMPLE_TO, SHOW_DETAILS, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100063, 'PGW vs SGW (bytes) - ST_DATA_WAP - EDR Bytes', '/um/um/mrecChartSetup.do?mrecType=TIME&mrecDefinitionId_time=100063', 100063, null, '14', '0', 'R', 450, 175, '', '');

insert into um.CD_MREC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, MREC_DEFINITION_ID, EDGE_ID, SAMPLE_FROM, SAMPLE_TO, SHOW_DETAILS, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100064, 'PGW vs SGSN (bytes) - ST_DATA_WAP - EDR Bytes', '/um/um/mrecChartSetup.do?mrecType=TIME&mrecDefinitionId_time=100064', 100064, null, '14', '0', 'R', 450, 175, '', '');

insert into um.CD_MREC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, MREC_DEFINITION_ID, EDGE_ID, SAMPLE_FROM, SAMPLE_TO, SHOW_DETAILS, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100065, 'SGSN vs SGW (bytes) - ST_DATA_WAP - EDR Bytes', '/um/um/mrecChartSetup.do?mrecType=TIME&mrecDefinitionId_time=100065', 100065, null, '14', '0', 'R', 450, 175, '', '');

insert into um.CD_MREC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, MREC_DEFINITION_ID, EDGE_ID, SAMPLE_FROM, SAMPLE_TO, SHOW_DETAILS, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100066, 'PGW vs SGW (bytes) - ST_DATA_GPRS - EDR Bytes', '/um/um/mrecChartSetup.do?mrecType=TIME&mrecDefinitionId_time=100066', 100066, null, '14', '0', 'R', 450, 175, '', '');

insert into um.CD_MREC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, MREC_DEFINITION_ID, EDGE_ID, SAMPLE_FROM, SAMPLE_TO, SHOW_DETAILS, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100067, 'PGW vs SGSN (bytes) - ST_DATA_GPRS - EDR Bytes', '/um/um/mrecChartSetup.do?mrecType=TIME&mrecDefinitionId_time=100067', 100067, null, '14', '0', 'R', 450, 175, '', '');

insert into um.CD_MREC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, MREC_DEFINITION_ID, EDGE_ID, SAMPLE_FROM, SAMPLE_TO, SHOW_DETAILS, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100068, 'SGSN vs SGW (bytes) - ST_DATA_GPRS - EDR Bytes', '/um/um/mrecChartSetup.do?mrecType=TIME&mrecDefinitionId_time=100068', 100068, null, '14', '0', 'R', 450, 175, '', '');

insert into um.CD_MREC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, MREC_DEFINITION_ID, EDGE_ID, SAMPLE_FROM, SAMPLE_TO, SHOW_DETAILS, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100069, 'PGW vs EMM Data (bytes) - ST_DATA_GPRS - EDR Bytes', '/um/um/mrecChartSetup.do?mrecType=TIME&mrecDefinitionId_time=100069', 100069, null, '14', '0', 'R', 450, 175, '', '');

insert into um.CD_MREC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, MREC_DEFINITION_ID, EDGE_ID, SAMPLE_FROM, SAMPLE_TO, SHOW_DETAILS, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100070, 'PGW vs EMM Data (bytes) - ST_DATA_WAP - EDR Bytes', '/um/um/mrecChartSetup.do?mrecType=TIME&mrecDefinitionId_time=100070', 100070, null, '14', '0', 'R', 450, 175, '', '');

insert into um.CD_MREC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, MREC_DEFINITION_ID, EDGE_ID, SAMPLE_FROM, SAMPLE_TO, SHOW_DETAILS, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100071, 'PGW vs EMM Data (bytes) - ST_DATA_2G - EDR Bytes', '/um/um/mrecChartSetup.do?mrecType=TIME&mrecDefinitionId_time=100071', 100071, null, '14', '0', 'R', 450, 175, '', '');

insert into um.CD_MREC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, MREC_DEFINITION_ID, EDGE_ID, SAMPLE_FROM, SAMPLE_TO, SHOW_DETAILS, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100072, 'PGW vs EMM Data (bytes) - ST_DATA_3G - EDR Bytes', '/um/um/mrecChartSetup.do?mrecType=TIME&mrecDefinitionId_time=100072', 100072, null, '14', '0', 'R', 450, 175, '', '');

insert into um.CD_MREC_REF (INSTANCE_ID, LABEL, CLICKTHROUGH_URL, MREC_DEFINITION_ID, EDGE_ID, SAMPLE_FROM, SAMPLE_TO, SHOW_DETAILS, WIDTH, HEIGHT, PARAMETERS, PDF_PARAMETERS)
values (100073, 'PGW vs EMM Data (bytes) - ST_DATA_4G - EDR Bytes', '/um/um/mrecChartSetup.do?mrecType=TIME&mrecDefinitionId_time=100073', 100073, null, '14', '0', 'R', 450, 175, '', '');



commit;

exit
