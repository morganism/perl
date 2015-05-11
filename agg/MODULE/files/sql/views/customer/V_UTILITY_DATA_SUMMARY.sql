create or replace view customer.v_utility_data_summary
as
select 
       node,
       metric_name,
       decode(metric_quantity
             ,'--No f_metric data--','No data'
             ,'OK'
             ) metric_status,
       decode(log_record_quantity
             ,'--No usage data loaded--','No data'
             ,'OK'
             ) load_status,
      count(*) number_of_metrics
from customer.V_UTILITY_DATA_COMPLETENESS t
group by 
       node,
       metric_name,
       decode(metric_quantity
             ,'--No f_metric data--','No data'
             ,'OK'
             ) ,
       decode(log_record_quantity
             ,'--No usage data loaded--','No data'
             ,'OK'
             ) 
--order by to_number(replace(node,'DS'))
/

exit
