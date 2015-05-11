create table customer.data_feed_frequency_ref
(
 node                      varchar2(50)
,alarm_period_type         varchar2(10)
,expected_files_per_period number
,alarm_threshold           number
,latency				   number
,cap			   number
,node_id                   number
)
/

exit
