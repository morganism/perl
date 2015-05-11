-- TT#20735 - VFI-UM: Front-end error
update web.em_field_value_formatting_ref efvfr
   set efvfr.link_url = '''/imm/alertManagementSetup.do?imId=35000' || chr(38) || 'filter_3010=TODAYS_DATE,TODAYS_DATE' || chr(38) || 'filter_35000=''||METRIC_DEFINITION_ID'
 where em_field_id = 100005;

commit; 

exit;
