insert into web.CD_NAV_SET_ITEMS (NAVIGATION_ITEM_ID, NAVIGATION_SET_ID, USER_ID, NAME, URL, ICON, USER_PRIVILEGE_ID)
values (3226, 3101, null, '[I18Nweb.cd_nav_set_items.label.Issue_Templates]', '/web/emInit.do?emId=3026', '', 3100);

update web.em_ref e
set    e.add_rule_sql = 'DECODE((SELECT IS_SYSTEM FROM IMM.ISSUE_TYPE_REF ITR WHERE ITR.ISSUE_TYPE_ID=[ISSUE_TYPE_ID]),''Y'',''D'',''E'')',
       e.delete_rule_sql = 'DECODE(t.STATE,''N'',''E'',''D'')'
where   em_id = 3130;

insert into web.em_ref (EM_ID, TITLE, CONNECTION_POOL, SCHEMA, DB_TABLE, DISPLAY_ENTITY, EM_TYPE_ID, VIEW_PRIV_ID, MODIFY_PRIV_ID, HEADER_BLOCK, FOOTER_BLOCK, ADD_RULE_SQL, EDIT_RULE_SQL, COPY_RULE_SQL, DELETE_RULE_SQL, ADD_BUTTON_URL, EDIT_BUTTON_URL, COPY_BUTTON_URL, DELETE_BUTTON_URL, CUSTOM_ROW_HANDLER, UNUSED_2, IS_AUDITED, IS_SYSTEM, IS_DEPLOYABLE, ICON, HELP)
values (3026, '[I18Nweb.em_ref.title.Issue_Templates]', 'IMMCP', '', 'ISSUE_TEMPLATE_REF', '', 3, 3100, 3100, '', '', '', '', '', '', '', '', '', '', '', '', 'Y', 'Y', '', '', '');

insert into web.em_field_ref (EM_FIELD_ID, EM_ID, COLUMN_ID, COLUMN_LABEL, COLUMN_DESCRIPTION, EM_FIELD_TYPE_ID, COLUMN_POSITION, FK_VALUE_COLUMN, VISIBILITY, SIZE_LIMIT, DISABLE_COLLAPSE, ORDER_BY, ORDER_BY_POSITION, EM_FILTER_ID, EM_FILTER_POSITION, IS_DUPLICATE, MODIFY_TYPE, DISABLE_EDIT_SQL, DROP_DOWN_VALUES_OVERRIDE, INSERT_RULE, IS_SYSTEM, IS_REPORTABLE, FILE_NAME_SQL, IS_I18N)
values (3090, 3026, 'ISSUE_TYPE_ID', '[I18Nweb.em_field_ref.label.Issue_Type_Id]', '', null, null, 'NAME', '', null, '', '', null, null, null, '', '', '', '', '', 'Y', '', '', '');

insert into web.em_field_ref (EM_FIELD_ID, EM_ID, COLUMN_ID, COLUMN_LABEL, COLUMN_DESCRIPTION, EM_FIELD_TYPE_ID, COLUMN_POSITION, FK_VALUE_COLUMN, VISIBILITY, SIZE_LIMIT, DISABLE_COLLAPSE, ORDER_BY, ORDER_BY_POSITION, EM_FILTER_ID, EM_FILTER_POSITION, IS_DUPLICATE, MODIFY_TYPE, DISABLE_EDIT_SQL, DROP_DOWN_VALUES_OVERRIDE, INSERT_RULE, IS_SYSTEM, IS_REPORTABLE, FILE_NAME_SQL, IS_I18N)
values (3091, 3026, 'SEVERITY_ID', '[I18Nweb.em_field_ref.label.Severity_Id]', '', null, null, 'NAME', '', null, '', '', null, null, null, '', '', '', '', '', 'Y', '', '', '');

insert into web.em_field_ref (EM_FIELD_ID, EM_ID, COLUMN_ID, COLUMN_LABEL, COLUMN_DESCRIPTION, EM_FIELD_TYPE_ID, COLUMN_POSITION, FK_VALUE_COLUMN, VISIBILITY, SIZE_LIMIT, DISABLE_COLLAPSE, ORDER_BY, ORDER_BY_POSITION, EM_FILTER_ID, EM_FILTER_POSITION, IS_DUPLICATE, MODIFY_TYPE, DISABLE_EDIT_SQL, DROP_DOWN_VALUES_OVERRIDE, INSERT_RULE, IS_SYSTEM, IS_REPORTABLE, FILE_NAME_SQL, IS_I18N)
values (3092, 3026, 'PRIORITY_ID', '[I18Nweb.em_field_ref.label.Priority_Id]', '', null, null, 'NAME', '', null, '', '', null, null, null, '', '', '', '', '', 'Y', '', '', '');

insert into web.em_field_ref (EM_FIELD_ID, EM_ID, COLUMN_ID, COLUMN_LABEL, COLUMN_DESCRIPTION, EM_FIELD_TYPE_ID, COLUMN_POSITION, FK_VALUE_COLUMN, VISIBILITY, SIZE_LIMIT, DISABLE_COLLAPSE, ORDER_BY, ORDER_BY_POSITION, EM_FILTER_ID, EM_FILTER_POSITION, IS_DUPLICATE, MODIFY_TYPE, DISABLE_EDIT_SQL, DROP_DOWN_VALUES_OVERRIDE, INSERT_RULE, IS_SYSTEM, IS_REPORTABLE, FILE_NAME_SQL, IS_I18N)
values (3093, 3026, 'RAISED_BY', '[I18Nweb.em_field_ref.label.Raised_By]', '', null, null, 'ALIAS', '', null, '', '', null, null, null, '', '', '', '', '', 'Y', '', '', '');

insert into web.em_field_ref (EM_FIELD_ID, EM_ID, COLUMN_ID, COLUMN_LABEL, COLUMN_DESCRIPTION, EM_FIELD_TYPE_ID, COLUMN_POSITION, FK_VALUE_COLUMN, VISIBILITY, SIZE_LIMIT, DISABLE_COLLAPSE, ORDER_BY, ORDER_BY_POSITION, EM_FILTER_ID, EM_FILTER_POSITION, IS_DUPLICATE, MODIFY_TYPE, DISABLE_EDIT_SQL, DROP_DOWN_VALUES_OVERRIDE, INSERT_RULE, IS_SYSTEM, IS_REPORTABLE, FILE_NAME_SQL, IS_I18N)
values (3094, 3026, 'OWNING_GROUP_ID', '[I18Nweb.em_field_ref.label.Owning_User_Group]', '', null, null, 'GROUP_NAME', '', null, '', '', null, null, null, '', '', '', '', '', 'Y', '', '', '');

insert into web.em_field_ref (EM_FIELD_ID, EM_ID, COLUMN_ID, COLUMN_LABEL, COLUMN_DESCRIPTION, EM_FIELD_TYPE_ID, COLUMN_POSITION, FK_VALUE_COLUMN, VISIBILITY, SIZE_LIMIT, DISABLE_COLLAPSE, ORDER_BY, ORDER_BY_POSITION, EM_FILTER_ID, EM_FILTER_POSITION, IS_DUPLICATE, MODIFY_TYPE, DISABLE_EDIT_SQL, DROP_DOWN_VALUES_OVERRIDE, INSERT_RULE, IS_SYSTEM, IS_REPORTABLE, FILE_NAME_SQL, IS_I18N)
values (3095, 3026, 'OWNING_USER_ID', '[I18Nweb.em_field_ref.label.Owning_User]', '', null, null, 'ALIAS', '', null, '', '', null, null, null, '', '', '', '', '', 'Y', '', '', '');


insert into web.menu_item (MENU_ITEM_ID, LABEL, ICON, VALUE, URL, USER_PRIVILEGE_ID, IS_SYSTEM)
values (3226, '[I18Nweb.menu_item.label.Issue_Templates]', '', '/web/emInit.do?emId=3026', 'Y', 3100, '');

insert into web.menu_entry (MENU_ID, SUB_MENU_ID, MENU_ITEM_ID, PLACEMENT, IS_SYSTEM)
values (3300, null, 3226, 41, '');


update web.em_filter_ref ef
set    ef.drop_down_values_as_sql = 'select distinct alarm_category as value, alarm_category as label from JOBS.ALARM_TYPE_REF order by alarm_category'
where  em_filter_id = 87;

insert into web.em_filter_ref (EM_FILTER_ID, TYPE, DESCRIPTION, OVERRIDE_LABEL, INITIAL_VALUE, IS_NULLABLE, IS_HIDDEN, DROP_DOWN_VALUES_AS_SQL, DROP_DOWN_VALUES_AS_LIST, DROP_DOWN_HAS_ALL, DROP_DOWN_IS_MULTISELECT, IS_SYSTEM)
values (88, 'DROPDOWN', 'Description', '[I18Nweb.em_filter_ref.override_label.Description]', '', '', '', 'select t.description as value, t.description as label from jobs.alarm t order by description', '', 'Y', '', 'Y');


insert into web.em_field_ref (EM_FIELD_ID, EM_ID, COLUMN_ID, COLUMN_LABEL, COLUMN_DESCRIPTION, EM_FIELD_TYPE_ID, COLUMN_POSITION, FK_VALUE_COLUMN, VISIBILITY, SIZE_LIMIT, DISABLE_COLLAPSE, ORDER_BY, ORDER_BY_POSITION, EM_FILTER_ID, EM_FILTER_POSITION, IS_DUPLICATE, MODIFY_TYPE, DISABLE_EDIT_SQL, DROP_DOWN_VALUES_OVERRIDE, INSERT_RULE, IS_SYSTEM, IS_REPORTABLE, FILE_NAME_SQL, IS_I18N)
values (706, 85, 'description', '[I18Nweb.em_field_ref.label.Description]', '', null, null, '', '', null, '', '', null, 88, 4, '', '', '', '', '', 'Y', '', '', '');

update web.em_field_ref e
set    e.column_label = '[I18Nweb.em_field_ref.label.Execute_Date]',
       e.column_position = '3' ,
       e.visibility = 'INVISIBLE'
where em_field_id = 609;

update web.em_field_ref e
set    e.em_filter_position = 2
where em_field_id = 702;

              
update web.em_field_ref e
set    e.column_label = '[I18Nweb.em_field_ref.label.Creation_Date]'
where em_field_id = 704;

update web.em_field_ref e
set    e.column_label = '[I18Nweb.em_field_ref.label.ALARM_CATEGORY]',
        e.em_filter_position = 3
where em_field_id = 705;



update web.em_field_ref ef
set    ef.order_by = 'ASCENDING',
       ef.order_by_position = 1,
       ef.em_filter_id = 500  
where  em_field_id = 7031;

update web.em_field_ref ef
set         ef.em_filter_id = 500  
where  em_field_id = 7032;


update web.em_ref em
set em.modify_priv_id = 7001,
    em.add_rule_sql = '(select 0 from dual)',
    em.edit_rule_sql = '(select 0 from dual)',
    em.copy_rule_sql = '(select 0 from dual)' 
where em_id = -7002;


insert into web.cd_item_type_ref (TYPE_ID, DESCRIPTION, JSP_RENDERER, PDF_RENDERER, FLASH_RENDERER, BEAN_CLASS, INSTANCE_SQL, EM_ID, INITIALISATION_CLASS)
values (7010, 'BTI Ad hoc Reports', '/jsp/olap/cd/renderers/olap_renderer.jsp', 'uk.co.cartesian.ascertain.olap.cd.renderers.OLAPPDFRenderer', 'None', 'uk.co.cartesian.ascertain.olap.cd.db.dao.beans.DashboardOLAP', 'select label,instance_id as value from olap.cd_olap_ref order by label', 7010, '');

delete from web.CD_NAV_SET_ITEMS n
where  n.navigation_item_id = 1331;

update web.Cd_Nav_Set_Items n
set    url = '/servlet/ChartServlet?csId=1002'
where  n.navigation_item_id = 1332;

update web.Cd_Nav_Set_Items n
set    url = '/servlet/ChartServlet?csId=1002'
where  n.navigation_item_id = 1003;

  
insert into web.cs_chart_ref (ID, NAME, DESCRIPTION, TABLE_NAME, SORT_ORDER, TITLE, CHART_TYPE, WIDTH, HEIGHT, LABEL_AXIS, VALUE_AXIS, DATA, DEBUG, FORMAT, HELP, SHOW_LEGEND)
values (1002, 'Tracking Chart', 'A graph which shows the user event count per day', 'WEB.V_TRACKING_EVENT', 'day', 'Tracking Chart', 'bar', 800, 600, 'Events', 'Count', 'off', 0, 'htmlflash', '', 'Y');

insert into web.cs_filter_ref (FILTER_ID, NAME, DESCRIPTION)
values (1002, 'User', 'User');

insert into web.cs_filter_value_ref (FILTER_ID, COLUMN_NAME, DATE_TYPE)
values (1002, 'Username', '');

insert into web.cs_line_chart_ref (ID, LABELS, VALUE_COLS, SERIES, FILTER_ID, DATASET_FILTER_ID, COLOUR_SET_ID, MAX)
values (1002, '', 'login,logoff,pageview,loginfail,timeout', 'login,logoff,pageview,loginfail,timeout', 1002, null, null, null);

update web.menu_item w
set    w.value = '/servlet/ChartServlet?csId=1002'
where   menu_item_id = 1511;


delete from web.menu_item w
where  w.menu_item_id = 1024;

commit;
exit;
