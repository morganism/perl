--------------------------------
-- A view to generate one record
-- with time / day values
--------------------------------
create or replace view customer.v_aggregator_timeslots_ref
as
select to_date(to_char(sysdate - (0/24),'YYYYMMDDHH24'), 'YYYYMMDDHH24') hour0
      ,to_date(to_char(sysdate - (1/24),'YYYYMMDDHH24'), 'YYYYMMDDHH24') hour1
      ,to_date(to_char(sysdate - (2/24),'YYYYMMDDHH24'), 'YYYYMMDDHH24') hour2
      ,to_date(to_char(sysdate - (3/24),'YYYYMMDDHH24'), 'YYYYMMDDHH24') hour3
      ,to_date(to_char(sysdate - 0     ,'YYYYMMDD')    , 'YYYYMMDD')     day0
      ,to_date(to_char(sysdate - 1     ,'YYYYMMDD')    , 'YYYYMMDD')     day1
      ,to_date(to_char(sysdate - 2     ,'YYYYMMDD')    , 'YYYYMMDD')     day2
      ,to_date(to_char(sysdate - 3     ,'YYYYMMDD')    , 'YYYYMMDD')     day3
from dual 
/

exit
