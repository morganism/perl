---------------------------------------
-- Ascertain IMM
-- Cartesian Limited
-- Joanna Clark
-- Kazan Glenn
--
-- matrix report of issue open/closed status
-- and counts by day over the last 20 days
-- this version includes static colour values 
-- for use by chart servlet
-- based on v_issue_state_severity_summary
---------------------------------------
create or replace view v_alarm_summary_matrix_graph as
select
 date_raised,
 date_raised_flt,
 sum(open_critical)    open_critical,    'FF0000' oc_colour,
 sum(open_high)        open_high,        'FF6600' oh_colour,
 sum(open_medium)      open_medium,      'FF9900' om_colour,
 sum(open_low)         open_low,         'FFCC00' ol_colour,
 sum(open_information) open_information, 'FFFF00' oi_colour,
 sum(closed_critical)    closed_critical,    '0000FF' cc_colour,
 sum(closed_high)        closed_high,        '0066FF' ch_colour,
 sum(closed_medium)      closed_medium,      '0099FF' cm_colour,
 sum(closed_low)         closed_low,         '00CCFF' cl_colour,
 sum(closed_information) closed_information, '00FFFF' ci_colour
from (
select
 trim(date_raised) as date_raised,
 to_char(to_date(trim(date_raised),'YYYY/MM/DD'),'DD-MM-YYYY,DD-MM-YYYY') as date_raised_flt,
 (case when status = 'Open' and severity = 'Critical' then count else 0 end) open_critical,
 (case when status = 'Open' and severity = 'High' then count else 0 end) open_high,
 (case when status = 'Open' and severity = 'Medium' then count else 0 end) open_medium,
 (case when status = 'Open' and severity = 'Low' then count else 0 end) open_low,
 (case when status = 'Open' and severity = 'Information' then count else 0 end) open_information,
 (case when status = 'Closed' and severity = 'Critical' then count else 0 end) closed_critical,
 (case when status = 'Closed' and severity = 'High' then count else 0 end) closed_high,
 (case when status = 'Closed' and severity = 'Medium' then count else 0 end) closed_medium,
 (case when status = 'Closed' and severity = 'Low' then count else 0 end) closed_low,
 (case when status = 'Closed' and severity = 'Information' then count else 0 end) closed_information
from
 imm.v_alarm_state_severity_summary
where
 to_date(date_raised,'YYYY/MM/DD') >= sysdate - 61
union all
 	(select trim(to_char(sysdate-rownum+1,'YYYY/MM/DD')) as date_raised,
   to_char(sysdate-rownum+1,'DD-MM-YYYY,DD-MM-YYYY') as date_raised_flt,
   0,0,0,0,0,0,0,0,0,0 from dual connect by rownum <= 61)
 	 ) 
group by date_raised,date_raised_flt
order by date_raised;

exit;
