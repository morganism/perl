alter table UM.LOG_RECORD_STAGING modify FILE_NAME VARCHAR2(500);
alter table UM.LOG_RECORD_STAGING modify OUT_FILE_NAME VARCHAR2(500);

alter table UM.LOG_RECORD modify FILE_NAME VARCHAR2(500);
alter table UM.LOG_RECORD modify OUT_FILE_NAME VARCHAR2(500);

--need to give these grants otherwise no user can access Metric Definition Issues by Sample Date screen
grant select on um.metric_type_ref to utils;
grant select on um.metric_category_ref to utils;
grant select on um.mrec_category_ref to utils;

--no longer exists and breaks MV Rebuild job
delete from um.mv_rebuild_ref where mv_name = 'IMM.M_OPEN_ISSUES_BY_USER';

-- Olap chart fixes
delete from um.mv_rebuild_ref where mv_name = 'UM.MV_F_FILE';
insert into um.mv_rebuild_ref values (7, 'UM.MV_F_FILE_SHORT', 'FORCE', '40', '');
insert into um.mv_rebuild_ref values (7, 'UM.MV_F_FILE_SHORT_2', 'FORCE', '41', '');
insert into um.mv_rebuild_ref values (7, 'UM.MV_F_FILE_SHORT_3', 'FORCE', '42', '');

create index MREC_XX_IDX on MREC (MREC_DEFINITION_ID, D_PERIOD_ID, MREC_ID) tablespace um_dwh_mtr_idx  compress 2  local;

exit;
