-- TT20775: Adding Columns to new screen config cant set column name
update web.em_field_ref efr
   set efr.drop_down_values_override = 'select atc.column_name as value, atc.column_name as label from all_tab_cols atc, em_ref er where atc.table_name = upper(er.db_table) and er.em_id = [FILTER]'
 where efr.em_field_id = 1118;

update web.em_field_ref efr
   set efr.drop_down_values_override = replace(EFR.DROP_DOWN_VALUES_OVERRIDE, 'where ac.table_name = er.db_table', 'where ac.table_name = UPPER(er.db_table)')
 where efr.em_field_id = 1120;

commit;

exit;
