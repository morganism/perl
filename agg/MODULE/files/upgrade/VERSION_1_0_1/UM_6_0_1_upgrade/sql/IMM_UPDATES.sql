set define off;


ALTER TABLE ATTRIBUTE_FILTER_CONF_REF
DROP CONSTRAINT ATTRIBUTE_FILTER_CONF_REF_3_CK;

ALTER TABLE ATTRIBUTE_FILTER_CONF_REF
ADD CONSTRAINT ATTRIBUTE_FILTER_CONF_REF_3_CK CHECK (FILTER_TYPE IN ('DATE','DATERANGE','DATETIME','DROPDOWN','MULTISELECT','FREETEXT','FREETEXT_REG'));


UPDATE imm.attribute_column_conf_ref 
set    DISPLAY_SQL = 'DECODE((select count(*) from imm.parent_child_issue_jn pcij where pcij.parent_issue_id = t.issue_id),0,''&nbsp;'',''<a href="/imm/issueManagementSetup.do?filter_3014=''|| t.issue_id ||''&emId=3001"><img width="16" height="16" src="/images/icons/png/regular/16x16/hierarchy_down.png" border="0" alt="\\[View Children\\]" title="View Children"></a>'')',
       REPORT_SQL = 'DECODE((select count(*) from imm.parent_child_issue_jn pcij where pcij.parent_issue_id = t.issue_id),0,'''',''Parent Issue'')'
where  IM_ID = 3001
and    ATTRIBUTE_ID = 3015;

UPDATE imm.attribute_column_conf_ref 
set    DISPLAY_SQL = 'DECODE((select count(*) from imm.parent_child_issue_jn pcij where pcij.parent_issue_id = t.issue_id),0,''&nbsp;'',''<a href="/imm/issueManagementSetup.do?filter_3014=''|| t.issue_id ||''&imId=3002"><img width="16" height="16" src="/images/icons/png/regular/16x16/hierarchy_down.png" border="0" alt="\\[View Children\\]" title="View Children"></a>'')',
       REPORT_SQL = 'DECODE((select count(*) from imm.parent_child_issue_jn pcij where pcij.parent_issue_id = t.issue_id),0,'''',''Parent Issue'')'
where  IM_ID = 3002
and    ATTRIBUTE_ID = 3015;

UPDATE imm.attribute_column_conf_ref 
set    DISPLAY_SQL = 'DECODE((select count(*) from imm.parent_child_issue_jn pcij where pcij.parent_issue_id = t.issue_id),0,''&nbsp;'',''<a href="/imm/issueManagementSetup.do?filter_3014=''|| t.issue_id ||''&imId=3003"><img width="16" height="16" src="/images/icons/png/regular/16x16/hierarchy_down.png" border="0" alt="\\[View Children\\]" title="View Children"></a>'')',
       REPORT_SQL = 'DECODE((select count(*) from imm.parent_child_issue_jn pcij where pcij.parent_issue_id = t.issue_id),0,'''',''Parent Issue'')'
where  IM_ID = 3003
and    ATTRIBUTE_ID = 3015;


commit;
exit
