create materialized view MV_F_FILE_SHORT2
  tablespace um_mv_data
  nologging
  storage ( initial 128K next 128K)
  refresh force on demand
  enable query rewrite
as
select
    "D_PERIOD"."YEAR" period_year,
    "D_PERIOD"."QUARTER" period_quarter,
    "D_PERIOD"."MONTH" period_month,
    "D_SOURCE_MV"."SOURCE_TYPE" as SOURCE_TYPE,
    "D_EDR_TYPE_MV"."EDR_DIRECTION" as EDR_DIRECTION,
    "D_MEASURE_TYPE"."MEASURE_TYPE" as MEASURE_TYPE,
    sum("FILE".edr_count)
  from
    "D_PERIOD" "D_PERIOD",
    (
      select
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
        where
          f.f_attribute_id = a.f_attribute_id) "FILE",
    "D_SOURCE_MV" "D_SOURCE_MV",
    "D_EDR_TYPE_MV" "D_EDR_TYPE_MV",
    "D_MEASURE_TYPE" "D_MEASURE_TYPE"
  where
    "D_PERIOD"."D_PERIOD_ID" = "FILE".d_period_id and
    "FILE"."D_SOURCE_ID" = "D_SOURCE_MV"."D_SOURCE_ID" and
    "FILE"."D_EDR_TYPE_ID" = "D_EDR_TYPE_MV"."D_EDR_TYPE_ID" and
    "FILE"."D_MEASURE_TYPE_ID" = "D_MEASURE_TYPE"."D_MEASURE_TYPE_ID"
  group by
    "D_PERIOD"."YEAR",
    "D_PERIOD"."QUARTER",
    "D_PERIOD"."MONTH",
    "D_SOURCE_MV"."SOURCE_TYPE",
    "D_EDR_TYPE_MV"."EDR_DIRECTION",
    "D_MEASURE_TYPE"."MEASURE_TYPE";

create bitmap index MV_F_FILE_short2_03_IDX on MV_F_FILE_short2(SOURCE_TYPE);
create bitmap index MV_F_FILE_short2_04_IDX on MV_F_FILE_short2(EDR_DIRECTION);
create bitmap index MV_F_FILE_short2_05_IDX on MV_F_FILE_short2(MEASURE_TYPE);
create  index MV_F_FILE_short2_06_IDX on MV_F_FILE_SHORT2(PERIOD_YEAR);
create  index MV_F_FILE_short2_07_IDX on MV_F_FILE_SHORT2(PERIOD_QUARTER);
create  index MV_F_FILE_short2_08_IDX on MV_F_FILE_SHORT2(PERIOD_MONTH);

analyze table MV_F_FILE_short2
 estimate statistics
 for table
 for all indexes
 for all indexed columns sample 2000 rows;

exit;
