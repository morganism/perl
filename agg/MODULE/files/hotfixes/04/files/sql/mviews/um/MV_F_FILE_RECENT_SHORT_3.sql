create materialized view MV_F_FILE_RECENT_SHORT3
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
    "D_EDR_TYPE_MV"."EDR_DIRECTION" as EDR_DIRECTION,
    "D_EDR_TYPE_MV"."EDR_TYPE" as EDR_TYPE,
    "D_EDR_TYPE_MV"."EDR_SUB_TYPE" as EDR_SUB_TYPE,
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
    "D_EDR_TYPE_MV" "D_EDR_TYPE_MV"
  where
    "D_PERIOD"."D_PERIOD_ID" = "FILE".d_period_id and
    "FILE"."D_EDR_TYPE_ID" = "D_EDR_TYPE_MV"."D_EDR_TYPE_ID"
  group by
    "D_PERIOD"."YEAR",
    "D_PERIOD"."QUARTER",
    "D_PERIOD"."MONTH",
    "D_EDR_TYPE_MV"."EDR_DIRECTION",
    "D_EDR_TYPE_MV"."EDR_TYPE",
    "D_EDR_TYPE_MV"."EDR_SUB_TYPE";

create bitmap index MV_F_FILE_RECENT_short3_04_IDX on MV_F_FILE_RECENT_short3(EDR_DIRECTION);
create index MV_F_FILE_RECENT_short3_06_IDX on MV_F_FILE_RECENT_SHORT3(PERIOD_YEAR);
create index MV_F_FILE_RECENT_short3_07_IDX on MV_F_FILE_RECENT_SHORT3(PERIOD_QUARTER);
create index MV_F_FILE_RECENT_short3_08_IDX on MV_F_FILE_RECENT_SHORT3(PERIOD_MONTH);

analyze table MV_F_FILE_RECENT_short3
 estimate statistics
 for table
 for all indexes
 for all indexed columns sample 2000 rows;

exit;
