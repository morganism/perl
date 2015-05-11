#!/bin/bash

################################################################

echo "usage: $0 <DS> <num_days> <service_type_pattern>"
echo "   eg: $0 8 7 ST_ALL"
echo ""

offset=$3

timestamp=`date '+%Y%m%d%H%M%S'`
spoolfile=$HOME/data/gdl/input/DS$1/$timestamp.DS$1.out
echo $spoolfile

sqlplus -S um/ascertain << ENDSQL

----------------------------------------------------------------
-- 
-- 
-- 
-- 
-- 
----------------------------------------------------------------

-- DS (data feed) vs ST (service type) matrix
create or replace view um.steve_ds_to_st_xref
as
select distinct 
       n.name ds
       ,substr(n.name,3) dsno
       ,substr(d.name,1,instr(d.name,'-') - 2) st
   from dgf.node_ref       n
       ,um.node_metric_jn  m
       ,um.metric_definition_ref d
 where n.node_id = m.node_id
 and   m.metric_definition_id = d.metric_definition_id
 /

 -- DS (data feed) vs NE (NeId) matrix
 create or replace view um.steve_ds_to_ne_xref
 as
 select n.name ds, s.source_description ne
   from um.source_desc_ref s, dgf.node_ref n
 where n.node_id = s.node_id
 /

 -- DS (data feed) vs UT (usage type) matrix
 -- This one derived "manually" by observation of data flows
 create or replace view um.steve_ds_to_ut_xref
 as
 select 'DS11' ds,'SMS' ut from dual union all
 select 'DS12','SMS'       from dual union all
 select 'DS20','SMS'       from dual union all
 select 'DS23','SMS'       from dual union all
 select 'DS28','SMS'       from dual union all
 select 'DS20','Voice'     from dual union all
 select 'DS23','Voice'     from dual union all
 select 'DS28','Voice'     from dual union all
 select 'DS28','SMS'       from dual union all
 select 'DS28','Voice'     from dual union all
 select 'DS33','SMS'       from dual union all
 select 'DS33','Voice'     from dual union all
 select 'DS39','Data'      from dual union all
 select 'DS4' ,'Voice'     from dual union all
 select 'DS40','Content'   from dual union all
 select 'DS44','Content'   from dual union all
 select 'DS45','Data'      from dual union all
 select 'DS48','MMS'       from dual union all
 select 'DS49','MMS'       from dual union all
 select 'DS5' ,'Voice'     from dual union all
 select 'DS53','Data'      from dual union all
 select 'DS54','Data'      from dual union all
 select 'DS55','Data'      from dual union all
 select 'DS56','Data'      from dual union all
 select 'DS6' ,'Content'   from dual union all
 select 'DS6' ,'Data'      from dual union all
 select 'DS6' ,'MMS'       from dual union all
 select 'DS6' ,'SMS'       from dual union all
 select 'DS6' ,'Voice'     from dual union all
 select 'DS64','MMS'       from dual union all
 select 'DS8' ,'SMS'       from dual union all
 select 'DS80','SMS'       from dual union all
 select 'DS81','SMS'       from dual union all
 select 'DS80','Voice'     from dual union all
 select 'DS81','Voice'     from dual
 /

 -- Generate a list of timelsots for 14 days, starting at yesterday (could get this to take a parameter??)
 create or replace view um.steve_dayslot
 as
 select rownum day
       ,trunc(sysdate - $offset) - rownum daydate 
       ,to_char(trunc(sysdate - $offset) - rownum,'DD') dayday
 from all_tab_columns where rownum < 29
 /



 ----------------------------------------------------------------
 -- 
 -- 
 -- 
 -- 
 -- 
 ----------------------------------------------------------------
create or replace view um.steve_hour_factor as
 select 0 hour,0.05 factor from dual union all
 select 1,0.04  from dual union all
 select 2,0.03  from dual union all
 select 3,0.04  from dual union all
 select 4,0.1   from dual union all
 select 5,0.2   from dual union all
 select 6,0.3   from dual union all
 select 7,0.45  from dual union all
 select 8,0.7   from dual union all
 select 9,0.85  from dual union all
 select 10,0.9  from dual union all
 select 11,0.88 from dual union all
 select 12,0.93 from dual union all
 select 13,1    from dual union all
 select 14,0.96 from dual union all
 select 15,0.87 from dual union all
 select 16,0.6  from dual union all
 select 17,0.4  from dual union all
 select 18,0.25 from dual union all
 select 19,0.2  from dual union all
 select 20,0.15 from dual union all
 select 21,0.1  from dual union all
 select 22,0.07 from dual union all
 select 23,0.05 from dual 
/

create or replace view um.steve_ds_volume as
 select 'DS4'  ds, 2500000 volume from dual union all
 select 'DS5'  ds, 1500000 volume from dual union all
 select 'DS6'  ds,15500000 volume from dual union all
 select 'DS8'  ds,12000000 volume from dual union all
 select 'DS11' ds, 2500000 volume from dual union all
 select 'DS12' ds, 9500000 volume from dual union all
 select 'DS20' ds, 2000000 volume from dual union all
 select 'DS23' ds, 2900000 volume from dual union all
 select 'DS28' ds,22000000 volume from dual union all
 select 'DS33' ds, 5000000 volume from dual union all
 select 'DS39' ds,   80000 volume from dual union all
 select 'DS40' ds,    5000 volume from dual union all
 select 'DS44' ds,   10000 volume from dual union all
 select 'DS45' ds, 1000000 volume from dual union all
 select 'DS48' ds,  120000 volume from dual union all
 select 'DS49' ds,   20000 volume from dual union all
 select 'DS53' ds, 1000000 volume from dual union all
 select 'DS54' ds, 5000000 volume from dual union all
 select 'DS55' ds,  500000 volume from dual union all
 select 'DS56' ds,34000000 volume from dual union all
 select 'DS64' ds,   25000 volume from dual union all
 select 'DS65' ds,  140000 volume from dual union all
 select 'DS80' ds, 1000000 volume from dual union all
 select 'DS81' ds, 1000000 volume from dual
/

create or replace view um.steve_src_hr_vol_Adj as
 select hrs.hour
      , src.ds
      , src.ne
      , round(vol.volume / ne_cnt.recs / 24,0) src_hr_vol  
      , round((vol.volume / ne_cnt.recs / 24) * hrs.factor, 0) src_hr_vol_adj
 from 
  (select n.name ds, s.source_description ne from um.source_desc_ref s, dgf.node_ref n where n.node_id = s.node_id)       src
 ,(select n.name ds, count(*) recs from um.source_desc_ref s, dgf.node_ref n where n.node_id = s.node_id group by n.name) ne_cnt
 ,um.steve_ds_volume  vol
 ,um.steve_hour_factor  hrs
where src.ds = ne_cnt.ds
and   src.ds = vol.ds
/


set pagesize 0
set linesize 200
set verify off
set feedback off
set termout off
set trimspool on

define ds='$1'
define days='$2'
--define st='$3'

--!mkdir -p $HOME/data/test/um
--spool $HOME/data/test/um/um_data.dat
spool $spoolfile

-- Create header
select 'currentDir,edrFileName,neId,umIdentifier,usageType,'||
       'timeSlot,serviceType,eventCount,sumDuration,sumBytes,sumValue'
 from dual
/
-- Create data
select '/u01/data/agg/'||ds_st.ds                            ||','||  /* currentDir   */
        to_char(ts.daydate + (ds_ne.hour/24),'YYYYMMDDHH24MISS')||
                      '.'||ds_st.ds||
                      '.out'                  ||','||  /* edrFileName   */
       ds_ne.ne                                              ||','||  /* neId         */
       ds_st.ds||'.'||ds_ut.ut||'.'||to_char(ts.daydate + (ds_ne.hour/24),'YYYYMMDDHH24')             ||','||  /* umIdentifier */
       ds_ut.ut                                              ||','||  /* usageType    */
       to_char(ts.daydate + (ds_ne.hour/24),'YYYYMMDDHH24')                                           ||','||  /* timeSlot     */
       ds_st.st                                              ||','||  /* serviceType  */
       (round((1000000 - rownum)/1000000 * ds_ne.src_hr_vol_adj * 1,0)+  abs(mod(dbms_random.random,100000)))  ||','||  /* eventCount   */
       ((1000000 - rownum)/1000000 * ds_ne.src_hr_vol_adj * 10 + abs(mod(dbms_random.random,100000))) ||','||  /* sumDuration  */
       ((1000000 - rownum)/1000000 * ds_ne.src_hr_vol_adj * 1000 + abs(mod(dbms_random.random,100000))) ||','||  /* sumBytes     */
       ((1000000 - rownum)/1000000 * ds_ne.src_hr_vol_adj * 0.1 + abs(mod(dbms_random.random,100000)))          /* sumValue     */
            csv_record
from um.steve_ds_to_st_xref ds_st
--    ,um.steve_ds_to_ne_xref ds_ne
    ,um.steve_src_hr_vol_Adj  ds_ne
    ,um.steve_ds_to_ut_xref ds_ut
    ,um.steve_dayslot      ts
where ds_st.ds = ds_ne.ds
and   ds_st.ds = ds_ut.ds
and   ts.day            < nvl(&days,99) + 1
and   ds_st.ds like 'DS'||nvl('&ds','%')
and   ds_st.st like       nvl('&st','ST%')
order by ds_ne.ds
        ,to_char(ts.daydate + (ds_ne.hour/24),'YYYYMMDDHH24')
/

spool off


ENDSQL

