--Needed for CUSTOMER.V_MREC_CAT_OPEN_ISSUES - view behind mrec category main dashboard table
grant select on imm.issue to customer;
grant select on imm.state_ref to customer;
grant select on imm.issue_attribute to customer;
 
--Needed for CUSTOMER.V_METRIC_ISSUES_BY_SEVERITY - view behind metric issue main dashboard table
grant select on imm.severity_ref to customer;
 
-- with grant option
grant select on IMM.ISSUE to customer with grant option;
grant select on IMM.ISSUE_ATTRIBUTE to customer with grant option;
grant select on IMM.SEVERITY_REF to customer with grant option;
grant select on IMM.STATE_REF to customer with grant option;
exit
