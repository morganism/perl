create or replace view v_utility_issue_list
/*
Intended to be the base of ISSUES queries  - references all normalised tables for description fields

Use a where clause to filter if required
Use a further group by if necessary
*/
as
select  i.issue_id
       ,i.title
       ,icr.name   issue_class
       ,itr.name   issue_type
       ,s.name     severity
       ,p.name     priority
       ,st.name    statex
       ,to_number(ia1.value) MRec_ID
       ,to_char(to_date(ia2.value,'Dy, DD Month YYYY HH24:MI'),'YYYYMMDDHH24') Period
       ,to_date(ia2.value,'Dy, DD Month YYYY HH24:MI') Period_Desc
       ,ia3.value "Reconciliation Definition"
       ,NVL(au.forename || decode(au.forename, null, '', ' ') || au.surname
            ,'Unassigned') owning_user
  from imm.ISSUE i
 inner join imm.Issue_Attribute ia1
     on i.issue_id = ia1.issue_id
  inner join imm.attribute_ref   ar1
    on ia1.attribute_id = ar1.attribute_id
 inner join imm.Issue_Attribute ia2
     on i.issue_id = ia2.issue_id
  inner join imm.attribute_ref   ar2
    on ia2.attribute_id = ar2.attribute_id
 inner join imm.Issue_Attribute ia3
     on i.issue_id = ia3.issue_id
  inner join imm.attribute_ref   ar3
    on ia3.attribute_id = ar3.attribute_id
 inner join imm.issue_class_ref icr
     on i.issue_class_id = icr.issue_class_id
  inner join imm.issue_type_ref itr
    on i.issue_type_id = itr.issue_type_id
 inner join imm.severity_ref s
     on i.severity_id = s.severity_id
  inner join imm.priority_ref p
    on i.priority_id = p.priority_id
 inner join imm.state_ref st
     on i.state_id = st.state_id
   left join utils.ascertain_user au
     on au.user_id = i.owning_user_id
 where ar1.name = 'MRec ID'
 and   ar2.name = 'Period'
 and   ar3.name = 'Reconciliation Definition'
/

exit
