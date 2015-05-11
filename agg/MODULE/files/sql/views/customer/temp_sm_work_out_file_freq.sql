create or replace view temp_sm_work_out_file_freq
as
select node
      , round(avg(files),0) average_per_day
      , min(files)          minimum_per_day
      , max(files)          maximum_per_day
      , count(files)        days_sampled
from 
      (
      select nr.description node
            ,trunc(lr.process_date) daydate
            ,count(distinct lr.file_name) files
      from (select * from um.log_record 
            where d_period_id > trunc(sysdate) - 20 ) lr 
      inner join dgf.node_ref nr 
      on nr.node_id = lr.node_id
      group by nr.description
              ,trunc(lr.process_date) 
      )        
group by node      
order by to_number(substr(node,3))
/

exit
