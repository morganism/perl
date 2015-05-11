create or replace view temp_sm_work_out_match_rerun as
with
um_proper as
(
select node_id, trunc(d_period_id) daydate, count(*) recs
from um.log_record
group by node_id, trunc(d_period_id)
)
,staging as
(
select node_id, trunc(sample_date) daydate, count(*) recs
from um.log_record_staging
group by node_id, trunc(sample_date)
)
,staging_and_un_proper_joined as
(
select
       staging.node_id   stagnode
       ,staging.daydate   stagdaydate
       ,um_proper.node_id umnode
       ,um_proper.daydate umdaydate
       ,staging.node_id
       ,decode(staging.node_id,null,0,1) + decode(um_proper.node_id,null,0,2) inwhat
 from staging
 full outer join um_proper
  on staging.node_id = um_proper.node_id
and staging.daydate = um_proper.daydate
)
select
'jssubmitJob "Node Matching" " -matchdate '||
to_char(nvl(stagdaydate,umdaydate),'YYYYMMDD')||
' -rerun '||decode(inwhat
         ,1,'NO' -- incoming but for first time so no need to recalc
          ,2,'no incoming data so no need to recalc'
         ,3,'YES' -- incoming PLUS already in UM --> recalc required
          ,0,'unknown'
         ,'unknown'
        ) ||
' -node '||nvl(stagnode,umnode)||
' -match 100000  -daemon no  -threads 1"' submit_text
 from staging_and_un_proper_joined
 where inwhat <> 2;
/

exit
