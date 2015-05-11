grant execute on customer.forecasting to um;
grant select on customer.daily_mrecs to um;
grant select on v_Metric_Issues_By_Severity to um;
grant select on V_MREC_CAT_OPEN_ISSUES to um;
grant select on v_Aggregator_Status to um;

grant select on customer.v_Metric_Issues_By_Severity to um;
grant select on customer.V_MREC_CAT_OPEN_ISSUES to um;
grant select on customer.v_Aggregator_Status to um;

grant execute on customer.dropStagingPartitions to um;

grant select on customer.aggregator_status to um;

exit;
