
insert into utils.ble_type_ref (BLE_TYPE_ID, NAME, DESCRIPTION, USER_PRIVILEGE_ID, IS_SYSTEM)
values (100000, 'VFI-UM', 'VFI-UM', 1001, '');

insert into utils.ble_ref (BLE_ID, BLE_TYPE_ID, NAME, DESCRIPTION, DB_POOL)
values (100000, 100000, 'Regenerate recent F_FILE table', 'Regenerate recent F_FILE table', 'UMCP');

insert into utils.ble_version_ref (BLE_VERSION_ID, BLE_ID, NAME, DESCRIPTION, PARENT_VERSION_ID, STATUS, CREATOR_ID, CREATE_DATE, VALID_FROM, VALID_TO)
values (100000, 100000, 'Regenerate Recent F_FILE table - Version 1', 'Regenerate Recent F_FILE table - Version 1', null, 'A', 4000, to_date('01-01-2010', 'dd-mm-yyyy'), to_date('01-01-2010', 'dd-mm-yyyy'), to_date('01-01-2100', 'dd-mm-yyyy'));

insert into utils.ble_step_ref (BLE_STEP_ID, BLE_VERSION_ID, EXECUTION_ORDER, NAME, DESCRIPTION, SQL_STATEMENT, IS_COMMIT)
values (100000, 100000, 10, 'Regenerate Recent F_FILE table', 'Regenerate Recent F_FILE table', 'call um.olap_utils.update_f_file_snapshot()', '');
insert into utils.ble_step_ref (BLE_STEP_ID, BLE_VERSION_ID, EXECUTION_ORDER, NAME, DESCRIPTION, SQL_STATEMENT, IS_COMMIT)
values (100001, 100000, 20, 'Regenerate Recent F_MREC table', 'Regenerate Recent F_MREC table', 'call um.olap_utils.update_f_mrec_snapshot()', '');

exit;
