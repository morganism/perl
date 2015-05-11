update web.cd_nav_set_ref
set STYLE = 'FULL'
where navigation_set_id = 1000;

update web.menu_entry e
   set e.menu_item_id = 100000
 where e.menu_id = 1011
   and e.placement = 50051;

commit;

--one of the dashboard items on the Alerts Overview dashboard is broken
update web.em_ref set DB_TABLE = 'V_ALERTS_BY_RES_CODE' WHERE em_id = 3304;

grant select on web.entity_ref to utils;
grant select on web.entity_field_ref to utils;
grant select on web.entity_filter_ref to utils;

--give UM User ability to view File Details report
update web.em_ref e set e.view_priv_id = 35000 where em_id = 37001;

--add IM Reporting priv to IM User group so access to various dashboards isn't broken
insert into utils.join_group_privilege values (3000,3010);

update web.chart_parameters_ref set parameters='table=JOBS.V_JOB_SUMMARY_MATRIX_GRAPH&'||'values=pending,running,complete,cancelled,failed,killed,warning&'||'series=Pending,Running,Complete,Cancelled,Failed,Killed,Warning&'||'title=Job%20Summary%20Chart&'||'width=800&'||'data=off&'||'colours=pending_colour,running_colour,complete_colour,cancelled_colour,failed_colour,killed_colour,warning_colour&'||'height=450&'||'sieve=Status.Pending.pending,Status.Running.running,Status.Complete.complete,Status.Cancelled.cancelled,Status.Failed.failed,Status.Killed.killed,Status.Warning.warning&'||'url_base=/web/emInit.do&'||'url_param_serie=filter_58&'||'url_param_value_column=start_time_flt&'||'url_param_name=filter_52&'||'format=htmlflash&'||'reload_data_interval=10&'||'url_param_serie_values=Pending%26emId=60,Running%26emId=60,Complete%26emId=50,Cancelled%26emId=50,Failed%26emId=50,Killed%26emId=50,Warning%26emId=50' where chart_id=10;

delete from web.cd_dashboard_detail where cd_dashboard_id=1200 and type_id=1008 and instance_id=1203;

exit;
