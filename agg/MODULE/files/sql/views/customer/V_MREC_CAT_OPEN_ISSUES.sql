create or replace view CUSTOMER.V_MREC_CAT_OPEN_ISSUES as
select /*+ RESULT_CACHE */
 c.description as mrec_category,
 sum(case
       when i.date_raised > (
	-- This might look weird but its faster than using sysdate
	select /*+ RESULT_CACHE */  trunc(max(j.actual_start_time)) as date_today from jobs.job j
	) - 7 
       then 1  else    0 end
 ) as recent_count,
 count(*) as total_count,
 c.mrec_category_id
   from imm.issue i
 inner join imm.state_ref sr on i.state_id = sr.state_id
 inner join imm.issue_attribute ia on ia.issue_id = i.issue_id
 inner join um.mrec_definition_ref d on d.mrec_definition_id = ia.value
 inner join um.mrec_category_ref c on c.mrec_category_id =
                                      d.mrec_category_id
 where i.issue_type_id = 35300 /*time based mrec*/
   and ia.attribute_id = 35004 /*mrec category*/
   and sr.state_type in ('S', 'I')
 group by c.description, c.mrec_category_id;
 
exit;
