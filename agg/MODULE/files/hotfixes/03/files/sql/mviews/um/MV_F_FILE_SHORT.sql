create materialized view MV_F_FILE_SHORT
  PARTITION BY RANGE (D_PERIOD_ID)
    ( PARTITION MV_F_FILE_SHORT_P00000000 VALUES LESS THAN (TO_DATE('20130101','yyyymmdd')) TABLESPACE UM_MV_DATA)
  tablespace um_mv_data
  nologging
  storage ( initial 128K next 128K)
  refresh force on demand
  enable query rewrite
as
select
 "D_PERIOD"."YEAR" period_year, "D_PERIOD"."QUARTER" period_quarter, "D_PERIOD"."MONTH" period_month,
"D_PERIOD"."DAY" as period_day,
"D_PERIOD"."HOUR" as period_hour,
"FILE".d_period_id,
"FILE".d_node_id,
"FILE".d_source_id,
"FILE".d_edr_type_id,
"FILE".d_measure_type_id,
"FILE".d_billing_type_id,
"FILE".d_payment_type_id,
"FILE".d_call_type_id,
"FILE".d_customer_type_id,
"FILE".d_service_provider_id,
"FILE".d_custom_01_id,
"FILE".edr_count,
"FILE".edr_value,
"FILE".edr_duration,
"FILE".edr_bytes
from "D_PERIOD" "D_PERIOD",
(select
 f.d_period_id,
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
 f.edr_count,
 f.edr_value,
 f.edr_duration,
 f.edr_bytes
from
 f_attribute a,
 f_file f
 where f.f_attribute_id = a.f_attribute_id) "FILE" 
where  "D_PERIOD"."D_PERIOD_ID" = "FILE".d_period_id;

create bitmap index MV_F_FILE_short_01_IDX on MV_F_FILE_short(d_period_id)
  local tablespace um_mv_idx;

create bitmap index MV_F_FILE_short_02_IDX on MV_F_FILE_short(d_node_id)
  local tablespace um_mv_idx;

create bitmap index MV_F_FILE_short_03_IDX on MV_F_FILE_short(d_source_id)
  local tablespace um_mv_idx;

create bitmap index MV_F_FILE_short_04_IDX on MV_F_FILE_short(d_edr_type_id)
  local tablespace um_mv_idx;

create bitmap index MV_F_FILE_short_05_IDX on MV_F_FILE_short(d_measure_type_id)
  local tablespace um_mv_idx;

create index MV_F_FILE_short_06_IDX on MV_F_FILE_SHORT(PERIOD_YEAR)
  local tablespace um_mv_idx;

create index MV_F_FILE_short_07_IDX on MV_F_FILE_short(period_quarter)
  local tablespace um_mv_idx;

create index MV_F_FILE_short_08_IDX on MV_F_FILE_short(period_month)
  local tablespace um_mv_idx;

create index MV_F_FILE_short_09_IDX on MV_F_FILE_short(period_day)
  local tablespace um_mv_idx;

create index MV_F_FILE_short_10_IDX on MV_F_FILE_short(period_hour)
  local tablespace um_mv_idx;

analyze table MV_F_FILE_short
 estimate statistics
 for table
 for all indexes
 for all indexed columns sample 2000 rows;

exit;
