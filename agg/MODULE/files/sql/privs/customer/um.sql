grant um_ro to customer;

grant select, references                         on um.source_ref to customer;
grant select, insert, update, delete, references on um.d_customer_type_ref to customer;
grant select, references                         on um.d_measure_type to customer;
grant select,references                          on um.d_edr_type_mv to customer;
grant select                                     on um.edr_type_ref to customer;

grant select, references                         on um.f_file to customer;
grant select, references                         on um.log_record to customer with grant option;
grant select                                     on um.f_metric to customer;
grant select                                     on um.f_mrec   to customer;
grant select                                     on um.mrec     to customer;
grant select, insert                             on um.fmo_fileset to customer;
grant select                                     on um.f_attribute to customer;
grant select, insert, update, delete, references on um.f_file_staging to customer;
grant select, insert, update, delete, references on um.log_record_staging to customer;
grant select, insert, update, delete, references on um.source_desc_ref to customer;
grant select, insert, update, delete, references on um.source_edr_type_jn to customer;
grant select, insert, update, delete, references on um.d_custom_01 to customer;
grant select                                     on um.node_metric_jn to customer;
grant select                                     on um.file_match_operator_ref to customer;
grant select                                     on um.mrec_metric_ref  to customer;
grant select                                     on metric_issue_jn to customer;

--Needed for CUSTOMER.V_MREC_CAT_OPEN_ISSUES - view behind mrec category main dashboard table
grant select on um.mrec_definition_ref to customer;
grant select on um.mrec_version_ref    to customer;
grant select on um.mrec_category_ref   to customer;
 
--Needed for CUSTOMER.V_METRIC_ISSUES_BY_SEVERITY - view behind metric issue main dashboard table
grant select on um.metric_definition_ref to customer;
grant select on um.metric_version_ref    to customer;
grant select on um.metric_operator_ref   to customer;
grant select on um.fmo_equation          to customer;

--Needed to retrieve values from customer.forecasting package. which in turn is used by our custom metric charts to display aggregated forecast data 
grant all on um.forecast_metric_jn    to customer;
grant all on um.forecast_model_values to customer;
grant all on um.forecast              to customer;
 
-- Additional privileges so that partitions can be created as part of Import
GRANT ALTER ON UM.LOG_RECORD_STAGING to CUSTOMER;
GRANT ALTER ON UM.F_FILE_STAGING to CUSTOMER;

grant insert on um.late_file_match_queue to customer;

--needed for POPULATE_UM_STAGING
grant select on um.seq_log_record_id to customer;
grant select on um.seq_f_file_id to customer;
grant select on um.d_period to customer;

-- with grant option
grant select on UM.D_CUSTOM_01 to customer with grant option;
grant select on UM.D_EDR_TYPE_MV to customer with grant option;
grant select on UM.D_MEASURE_TYPE to customer with grant option;
grant select on UM.EDR_TYPE_REF to customer with grant option;
grant select on UM.FMO_EQUATION to customer with grant option;
grant select on UM.F_ATTRIBUTE to customer with grant option;
grant select on UM.F_FILE to customer with grant option;
grant select on UM.F_METRIC to customer with grant option;
grant select on UM.F_MREC to customer with grant option;
grant select on UM.METRIC_DEFINITION_REF to customer with grant option;
grant select on UM.METRIC_OPERATOR_REF to customer with grant option;
grant select on UM.METRIC_VERSION_REF to customer with grant option;
grant select on UM.MREC to customer with grant option;
grant select on UM.MREC_CATEGORY_REF to customer with grant option;
grant select on UM.MREC_DEFINITION_REF to customer with grant option;
grant select on UM.MREC_VERSION_REF to customer with grant option;
grant select on UM.NODE_METRIC_JN to customer with grant option;
grant select on UM.SOURCE_REF to customer with grant option;


grant execute on um.etl to customer;

exit
