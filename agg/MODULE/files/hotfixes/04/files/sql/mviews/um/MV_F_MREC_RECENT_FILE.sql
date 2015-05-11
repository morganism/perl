REM --------------------------------------------------------------
REM Cartesian Limited
REM Materialized View: MV_F_MREC_RECENT_FILE
REM
REM denormalised F_MREC_RECENT and F_ATTRIBUTE
REM --------------------------------------------------------------

create materialized view MV_F_MREC_RECENT_FILE
  PARTITION BY RANGE (D_PERIOD_ID)
    ( PARTITION MV_F_MREC_RCNT_FILE_P00000000 VALUES LESS THAN (TO_DATE('20000101','yyyymmdd')) TABLESPACE UM_MV_DATA)
  tablespace um_mv_data
  nologging
  storage ( initial 128K next 128K)
  refresh force on demand
  enable query rewrite
as
select
 m.d_period_id,
 m.d_mrec_line_id,
 nvl(m.d_edge_id, -1) d_edge_id,
 nvl(a.d_node_id, -1) d_node_id,
 nvl(a.d_source_id, -1) d_source_id,
 nvl(a.d_edr_type_id, -1) d_edr_type_id,
 nvl(a.d_measure_type_id, -1) d_measure_type_id,
 nvl(a.d_billing_type_id, -1) d_billing_type_id,
 nvl(a.d_payment_type_id, -1) d_payment_type_id,
 nvl(a.d_call_type_id, -1) d_call_type_id,
 nvl(a.d_customer_type_id, -1) d_customer_type_id,
 nvl(a.d_service_provider_id, -1) d_service_provider_id,
 nvl(a.d_custom_01_id, -1) d_custom_01_id,
 m.measure_type,
 m.mrec
from 
 f_attribute a, 
 f_mrec_recent m
where m.f_attribute_id = a.f_attribute_id
and m.mrec_set != 0
and m.mrec_type = 'F';

create bitmap index MV_F_MREC_RECENT_FILE_01_IDX on MV_F_MREC_RECENT_FILE(d_period_id)
	local tablespace um_mv_idx;

create bitmap index MV_F_MREC_RECENT_FILE_31_IDX on MV_F_MREC_RECENT_FILE(d_mrec_line_id)
	local tablespace um_mv_idx;

create bitmap index MV_F_MREC_RECENT_FILE_02_IDX on MV_F_MREC_RECENT_FILE(d_node_id)
  local tablespace um_mv_idx;

create bitmap index MV_F_MREC_RECENT_FILE_03_IDX on MV_F_MREC_RECENT_FILE(d_source_id)
  local tablespace um_mv_idx;

create bitmap index MV_F_MREC_RECENT_FILE_04_IDX on MV_F_MREC_RECENT_FILE(d_edr_type_id)
  local tablespace um_mv_idx;

create bitmap index MV_F_MREC_RECENT_FILE_05_IDX on MV_F_MREC_RECENT_FILE(d_measure_type_id)
  local tablespace um_mv_idx;

create bitmap index MV_F_MREC_RECENT_FILE_06_IDX on MV_F_MREC_RECENT_FILE(d_billing_type_id)
  local tablespace um_mv_idx;

create bitmap index MV_F_MREC_RECENT_FILE_07_IDX on MV_F_MREC_RECENT_FILE(d_payment_type_id)
  local tablespace um_mv_idx;

create bitmap index MV_F_MREC_RECENT_FILE_08_IDX on MV_F_MREC_RECENT_FILE(d_call_type_id)
  local tablespace um_mv_idx;

create bitmap index MV_F_MREC_RECENT_FILE_09_IDX on MV_F_MREC_RECENT_FILE(d_customer_type_id)
  local tablespace um_mv_idx;

create bitmap index MV_F_MREC_RECENT_FILE_10_IDX on MV_F_MREC_RECENT_FILE(d_service_provider_id)
  local tablespace um_mv_idx;

create bitmap index MV_F_MREC_RECENT_FILE_11_IDX on MV_F_MREC_RECENT_FILE(d_custom_01_id)
  local tablespace um_mv_idx;

analyze table MV_F_MREC_RECENT_FILE
 estimate statistics
 for table
 for all indexes
 for all indexed columns sample 2000 rows;

exit;
