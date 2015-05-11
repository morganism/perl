
insert into gdl.format_mapping (MAPPING_ID, NAME, DESCRIPTION, PROCESS_TYPE)
values (100079, 'PGW Importer (DS70)', 'PGW Importer (DS70)', 'IMPORT');

insert into gdl.format_mapping (MAPPING_ID, NAME, DESCRIPTION, PROCESS_TYPE)
values (100080, 'SGW Importer (DS71)', 'SGW Importer (DS71)', 'IMPORT');

insert into gdl.format_mapping (MAPPING_ID, NAME, DESCRIPTION, PROCESS_TYPE)
values (100081, 'SGSN Importer (DS72)', 'SGSN Importer (DS72)', 'IMPORT');


insert into gdl.loadable_tables_ref (LOADABLE_TABLE_ID, DB_POOL, TARGET_SCHEMA, TARGET_TABLE, SUPPORTS_ROLLBACK, EM_ID)
values (100031, 'CUSTOMERCP', 'CUSTOMER', 'stg_agg_data_ds70', 'N', null);

insert into gdl.loadable_tables_ref (LOADABLE_TABLE_ID, DB_POOL, TARGET_SCHEMA, TARGET_TABLE, SUPPORTS_ROLLBACK, EM_ID)
values (100032, 'CUSTOMERCP', 'CUSTOMER', 'stg_agg_data_ds71', 'N', null);

insert into gdl.loadable_tables_ref (LOADABLE_TABLE_ID, DB_POOL, TARGET_SCHEMA, TARGET_TABLE, SUPPORTS_ROLLBACK, EM_ID)
values (100033, 'CUSTOMERCP', 'CUSTOMER', 'stg_agg_data_ds72', 'N', null);


insert into gdl.format_mapping_version (MAPPING_VERSION_ID, MAPPING_ID, PARENT_VERSION_ID, VALID_FROM, VALID_TO, STATUS, LOADABLE_TABLE_ID, LOAD_ACTION, TRAILING_NULLS, DESCRIPTION, MAX_REJECTS, UNIQUE_FILENAMES, IS_DIRECT, UNRECOVERABLE, FILE_TYPE, INPUT_DIRECTORY, ACCEPTED_DIRECTORY, REJECTED_DIRECTORY, BAD_DIRECTORY, LOG_DIRECTORY, FILE_MASK, DELIMITERS, ENCLOSING_CHARS, SKIP_COUNT)
values (100079, 100079, null, to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020', 'dd-mm-yyyy'), 'A', 100031, 'TRUNCATE', 'Y', 'PGW', 1, 'N', 'Y', 'N', 'D', 'gdl/input/DS70/out', 'gdl/accepted/DS70', 'gdl/rejected/DS70', 'gdl/bad/DS70', 'gdl/log/DS70', '[0-9]{20}\.DS70\.out', ',', '', 1);

insert into gdl.format_mapping_version (MAPPING_VERSION_ID, MAPPING_ID, PARENT_VERSION_ID, VALID_FROM, VALID_TO, STATUS, LOADABLE_TABLE_ID, LOAD_ACTION, TRAILING_NULLS, DESCRIPTION, MAX_REJECTS, UNIQUE_FILENAMES, IS_DIRECT, UNRECOVERABLE, FILE_TYPE, INPUT_DIRECTORY, ACCEPTED_DIRECTORY, REJECTED_DIRECTORY, BAD_DIRECTORY, LOG_DIRECTORY, FILE_MASK, DELIMITERS, ENCLOSING_CHARS, SKIP_COUNT)
values (100080, 100080, null, to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020', 'dd-mm-yyyy'), 'A', 100032, 'TRUNCATE', 'Y', 'SGW', 1, 'N', 'Y', 'N', 'D', 'gdl/input/DS71/out', 'gdl/accepted/DS71', 'gdl/rejected/DS71', 'gdl/bad/DS71', 'gdl/log/DS71', '[0-9]{20}\.DS71\.out', ',', '', 1);

insert into gdl.format_mapping_version (MAPPING_VERSION_ID, MAPPING_ID, PARENT_VERSION_ID, VALID_FROM, VALID_TO, STATUS, LOADABLE_TABLE_ID, LOAD_ACTION, TRAILING_NULLS, DESCRIPTION, MAX_REJECTS, UNIQUE_FILENAMES, IS_DIRECT, UNRECOVERABLE, FILE_TYPE, INPUT_DIRECTORY, ACCEPTED_DIRECTORY, REJECTED_DIRECTORY, BAD_DIRECTORY, LOG_DIRECTORY, FILE_MASK, DELIMITERS, ENCLOSING_CHARS, SKIP_COUNT)
values (100081, 100081, null, to_date('01-07-2013', 'dd-mm-yyyy'), to_date('31-12-2020', 'dd-mm-yyyy'), 'A', 100033, 'TRUNCATE', 'Y', 'SGSN', 1, 'N', 'Y', 'N', 'D', 'gdl/input/DS72/out', 'gdl/accepted/DS72', 'gdl/rejected/DS72', 'gdl/bad/DS72', 'gdl/log/DS72', '[0-9]{20}\.DS72\.out', ',', '', 1);



insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100700, 100079, 'currentDir', 1, null, null, '', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100701, 100079, 'edrFileName', 2, null, null, '', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100702, 100079, 'neId', 3, null, null, '', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100703, 100079, 'umIdentifier', 4, null, null, '', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100704, 100079, 'usageType', 5, null, null, '', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100705, 100079, 'timeSlot', 7, null, null, 'INTEGER EXTERNAL', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100706, 100079, 'serviceType', 8, null, null, '', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100707, 100079, 'eventCount', 11, null, null, 'INTEGER EXTERNAL', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100708, 100079, 'sumDuration', 12, null, null, 'INTEGER EXTERNAL', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100709, 100079, 'sumBytes', 13, null, null, 'INTEGER EXTERNAL', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100710, 100079, 'sumValue', 14, null, null, 'INTEGER EXTERNAL', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100711, 100079, 'dummy filler', 15, null, null, '', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100712, 100080, 'currentDir', 1, null, null, '', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100713, 100080, 'edrFileName', 2, null, null, '', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100714, 100080, 'neId', 3, null, null, '', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100715, 100080, 'umIdentifier', 4, null, null, '', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100716, 100080, 'usageType', 5, null, null, '', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100717, 100080, 'timeSlot', 7, null, null, 'INTEGER EXTERNAL', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100718, 100080, 'serviceType', 8, null, null, '', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100719, 100080, 'eventCount', 11, null, null, 'INTEGER EXTERNAL', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100720, 100080, 'sumDuration', 12, null, null, 'INTEGER EXTERNAL', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100721, 100080, 'sumBytes', 13, null, null, 'INTEGER EXTERNAL', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100722, 100080, 'sumValue', 14, null, null, 'INTEGER EXTERNAL', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100723, 100080, 'dummy filler', 15, null, null, '', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100724, 100081, 'currentDir', 1, null, null, '', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100725, 100081, 'edrFileName', 2, null, null, '', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100726, 100081, 'neId', 3, null, null, '', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100727, 100081, 'umIdentifier', 4, null, null, '', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100728, 100081, 'usageType', 5, null, null, '', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100729, 100081, 'timeSlot', 7, null, null, 'INTEGER EXTERNAL', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100730, 100081, 'serviceType', 8, null, null, '', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100731, 100081, 'eventCount', 11, null, null, 'INTEGER EXTERNAL', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100732, 100081, 'sumDuration', 12, null, null, 'INTEGER EXTERNAL', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100733, 100081, 'sumBytes', 13, null, null, 'INTEGER EXTERNAL', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100734, 100081, 'sumValue', 14, null, null, 'INTEGER EXTERNAL', 'N');

insert into gdl.format_field_ref (FORMAT_FIELD_ID, MAPPING_VERSION_ID, FIELD_NAME, FIELD_SEQUENCE, FIELD_START_POSITION, FIELD_END_POSITION, FORMAT_FIELD_TYPE, FILLER)
values (100735, 100081, 'dummy filler', 15, null, null, '', 'N');



insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100079, 'PROCESSDATE', null, 'get_process_date_from_filename(''[FILENAME]'')');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100079, 'CURRENTDIR', 100700, 'concat(concat(:currentDir,''/''),:edrFileName)');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100079, 'EDRFILENAME', 100701, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100079, 'NEID', 100702, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100079, 'UMIDENTIFIER', 100703, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100079, 'USAGETYPE', 100704, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100079, 'TIMESLOT', 100705, 'to_date(:timeslot,''YYYYMMDDHH24'')');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100079, 'SERVICETYPE', 100706, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100079, 'EVENTCOUNT', 100707, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100079, 'SUMDURATION', 100708, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100079, 'SUMBYTES', 100709, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100079, 'SUMVALUE', 100710, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100080, 'PROCESSDATE', null, 'get_process_date_from_filename(''[FILENAME]'')');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100080, 'CURRENTDIR', 100712, 'concat(concat(:currentDir,''/''),:edrFileName)');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100080, 'EDRFILENAME', 100713, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100080, 'NEID', 100714, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100080, 'UMIDENTIFIER', 100715, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100080, 'USAGETYPE', 100716, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100080, 'TIMESLOT', 100717, 'to_date(:timeslot,''YYYYMMDDHH24'')');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100080, 'SERVICETYPE', 100718, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100080, 'EVENTCOUNT', 100719, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100080, 'SUMDURATION', 100720, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100080, 'SUMBYTES', 100721, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100080, 'SUMVALUE', 100722, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100081, 'PROCESSDATE', null, 'get_process_date_from_filename(''[FILENAME]'')');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100081, 'CURRENTDIR', 100724, 'concat(concat(:currentDir,''/''),:edrFileName)');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100081, 'EDRFILENAME', 100725, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100081, 'NEID', 100726, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100081, 'UMIDENTIFIER', 100727, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100081, 'USAGETYPE', 100728, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100081, 'TIMESLOT', 100729, 'to_date(:timeslot,''YYYYMMDDHH24'')');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100081, 'SERVICETYPE', 100730, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100081, 'EVENTCOUNT', 100731, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100081, 'SUMDURATION', 100732, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100081, 'SUMBYTES', 100733, '');

insert into gdl.field_mapping (MAPPING_VERSION_ID, TARGET_FIELD, FORMAT_FIELD_ID, OPERATION)
values (100081, 'SUMVALUE', 100734, '');



insert into gdl.fmt_map_action_map (MAP_ACTION_MAP_ID, MAPPING_VERSION_ID, ACTION_CODE_ID, TYPE, ACTION_ORDER, PARAMETERS, DESCRIPTION)
values (100193, 100079, 5014, 'POST', 10, '-iv 100002 -icn sql_ID -tn um.sql_ref -staging_table customer.stg_agg_data_ds70 -scn sql -et U', '');

insert into gdl.fmt_map_action_map (MAP_ACTION_MAP_ID, MAPPING_VERSION_ID, ACTION_CODE_ID, TYPE, ACTION_ORDER, PARAMETERS, DESCRIPTION)
values (100194, 100079, 5002, 'EXEC', 10, '-direct false -parallel false -loadRejectedFiles false', '');

insert into gdl.fmt_map_action_map (MAP_ACTION_MAP_ID, MAPPING_VERSION_ID, ACTION_CODE_ID, TYPE, ACTION_ORDER, PARAMETERS, DESCRIPTION)
values (100195, 100079, 5017, 'INIT', 10, '', '');

insert into gdl.fmt_map_action_map (MAP_ACTION_MAP_ID, MAPPING_VERSION_ID, ACTION_CODE_ID, TYPE, ACTION_ORDER, PARAMETERS, DESCRIPTION)
values (100196, 100079, 5007, 'POST', 20, '', '');

insert into gdl.fmt_map_action_map (MAP_ACTION_MAP_ID, MAPPING_VERSION_ID, ACTION_CODE_ID, TYPE, ACTION_ORDER, PARAMETERS, DESCRIPTION)
values (100197, 100079, 5001, 'POST', 30, 'il_success_dir gdl/accepted/DS70 il_reject_dir gdl/rejected/DS70', '');

insert into gdl.fmt_map_action_map (MAP_ACTION_MAP_ID, MAPPING_VERSION_ID, ACTION_CODE_ID, TYPE, ACTION_ORDER, PARAMETERS, DESCRIPTION)
values (100198, 100079, 5014, 'POST', 40, '-iv 100003 -icn sql_id -tn um.sql_ref -scn sql -et U', '');

insert into gdl.fmt_map_action_map (MAP_ACTION_MAP_ID, MAPPING_VERSION_ID, ACTION_CODE_ID, TYPE, ACTION_ORDER, PARAMETERS, DESCRIPTION)
values (100200, 100080, 5014, 'POST', 10, '-iv 100002 -icn sql_ID -tn um.sql_ref -staging_table customer.stg_agg_data_ds71 -scn sql -et U', '');

insert into gdl.fmt_map_action_map (MAP_ACTION_MAP_ID, MAPPING_VERSION_ID, ACTION_CODE_ID, TYPE, ACTION_ORDER, PARAMETERS, DESCRIPTION)
values (100201, 100080, 5002, 'EXEC', 10, '-direct false -parallel false -loadRejectedFiles false', '');

insert into gdl.fmt_map_action_map (MAP_ACTION_MAP_ID, MAPPING_VERSION_ID, ACTION_CODE_ID, TYPE, ACTION_ORDER, PARAMETERS, DESCRIPTION)
values (100202, 100080, 5017, 'INIT', 10, '', '');

insert into gdl.fmt_map_action_map (MAP_ACTION_MAP_ID, MAPPING_VERSION_ID, ACTION_CODE_ID, TYPE, ACTION_ORDER, PARAMETERS, DESCRIPTION)
values (100203, 100080, 5007, 'POST', 20, '', '');

insert into gdl.fmt_map_action_map (MAP_ACTION_MAP_ID, MAPPING_VERSION_ID, ACTION_CODE_ID, TYPE, ACTION_ORDER, PARAMETERS, DESCRIPTION)
values (100204, 100080, 5001, 'POST', 30, 'il_success_dir gdl/accepted/DS71 il_reject_dir gdl/rejected/DS71', '');

insert into gdl.fmt_map_action_map (MAP_ACTION_MAP_ID, MAPPING_VERSION_ID, ACTION_CODE_ID, TYPE, ACTION_ORDER, PARAMETERS, DESCRIPTION)
values (100205, 100080, 5014, 'POST', 40, '-iv 100003 -icn sql_id -tn um.sql_ref -scn sql -et U', '');

insert into gdl.fmt_map_action_map (MAP_ACTION_MAP_ID, MAPPING_VERSION_ID, ACTION_CODE_ID, TYPE, ACTION_ORDER, PARAMETERS, DESCRIPTION)
values (100207, 100081, 5014, 'POST', 10, '-iv 100002 -icn sql_ID -tn um.sql_ref -staging_table customer.stg_agg_data_ds72 -scn sql -et U', '');

insert into gdl.fmt_map_action_map (MAP_ACTION_MAP_ID, MAPPING_VERSION_ID, ACTION_CODE_ID, TYPE, ACTION_ORDER, PARAMETERS, DESCRIPTION)
values (100208, 100081, 5002, 'EXEC', 10, '-direct false -parallel false -loadRejectedFiles false', '');

insert into gdl.fmt_map_action_map (MAP_ACTION_MAP_ID, MAPPING_VERSION_ID, ACTION_CODE_ID, TYPE, ACTION_ORDER, PARAMETERS, DESCRIPTION)
values (100209, 100081, 5017, 'INIT', 10, '', '');

insert into gdl.fmt_map_action_map (MAP_ACTION_MAP_ID, MAPPING_VERSION_ID, ACTION_CODE_ID, TYPE, ACTION_ORDER, PARAMETERS, DESCRIPTION)
values (100210, 100081, 5007, 'POST', 20, '', '');

insert into gdl.fmt_map_action_map (MAP_ACTION_MAP_ID, MAPPING_VERSION_ID, ACTION_CODE_ID, TYPE, ACTION_ORDER, PARAMETERS, DESCRIPTION)
values (100211, 100081, 5001, 'POST', 30, 'il_success_dir gdl/accepted/DS72 il_reject_dir gdl/rejected/DS72', '');

insert into gdl.fmt_map_action_map (MAP_ACTION_MAP_ID, MAPPING_VERSION_ID, ACTION_CODE_ID, TYPE, ACTION_ORDER, PARAMETERS, DESCRIPTION)
values (100212, 100081, 5014, 'POST', 40, '-iv 100003 -icn sql_id -tn um.sql_ref -scn sql -et U', '');




commit;

exit