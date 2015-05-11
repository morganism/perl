################################################################
## 
##  generate_test_data.sh
## 
##  To create a set of usage summary records for every 
##  combination of key values
## 
##  Steve Makinson - January 2011
##
################################################################

echo "usage: $0 <DS> <num_days> <service_type_pattern>"
echo "   eg: $0 8 7 ST_ALL"
echo ""

sqlplus -S um/ascertain << ENDSQL

-- DS (data feed) vs ST (service type) matrix
create or replace view steve_ds_to_st_xref
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
create or replace view steve_ds_to_ne_xref
as
select n.name ds, s.source_description ne
  from um.source_desc_ref s, dgf.node_ref n
where n.node_id = s.node_id
/

-- DS (data feed) vs UT (usage type) matrix
-- This one derived "manually" by observation of data flows
create or replace view steve_ds_to_ut_xref
as
select 'DS11' ds,'SMS' ut from dual union all
select 'DS12','SMS' from dual union all
select 'DS20','SMS' from dual union all
select 'DS23','SMS' from dual union all
select 'DS28','SMS' from dual union all
select 'DS20','Voice' from dual union all
select 'DS23','Voice' from dual union all
select 'DS28','Voice' from dual union all
select 'DS28','SMS' from dual union all
select 'DS28','Voice' from dual union all
select 'DS33','SMS' from dual union all
select 'DS33','Voice' from dual union all
select 'DS39','Data' from dual union all
select 'DS4','Voice' from dual union all
select 'DS40','Content' from dual union all
select 'DS44','Content' from dual union all
select 'DS45','Data' from dual union all
select 'DS48','MMS' from dual union all
select 'DS49','MMS' from dual union all
select 'DS5','Voice' from dual union all
select 'DS53','Data' from dual union all
select 'DS54','Data' from dual union all
select 'DS55','Data' from dual union all
select 'DS56','Data' from dual union all
select 'DS6','Content' from dual union all
select 'DS6','Data' from dual union all
select 'DS6','MMS' from dual union all
select 'DS6','SMS' from dual union all
select 'DS6','Voice' from dual union all
select 'DS64','MMS' from dual union all
select 'DS8','SMS' from dual union all
select 'DS80','SMS' from dual union all
select 'DS81','SMS' from dual union all
select 'DS80','Voice' from dual union all
select 'DS81','Voice' from dual
/

-- Generate a list of timelsots for 14 days, starting at yesterday (could get this to take a parameter??)
create or replace view steve_timeslot
as
select hours.hour
      ,days.day
      ,days.day + (hours.hour / 24) timeslotdate
      ,to_number(to_char(days.daydate + (hours.hour / 24),'YYYYMMDDHH24')) timeslot
      ,to_char(days.daydate,'DD') dayno
from (select rownum - 1             hour from all_tab_columns where rownum < 25) hours
    ,(select rownum day, trunc(sysdate) - rownum daydate from all_tab_columns where rownum < 15) days
/

--select count(*) recs, 'steve_ds_to_st_xref' tab from steve_ds_to_st_xref
--union all
--select count(*) , 'steve_ds_to_ne_xref' from steve_ds_to_ne_xref
--union all
--select count(*) , 'steve_ds_to_ut_xref' from steve_ds_to_ut_xref
--union all
--select count(*) , 'steve_timeslot' from steve_timeslot
--/


set pagesize 0
set linesize 200
set verify off
set feedback off
set termout off
set trimspool on

define ds='$1'
define days='$2'
define st='$3'

!mkdir -p $HOME/data/test/um
spool $HOME/data/test/um/um_data.dat

-- Create header
select 'currentDir,edrFileName,neId,umIdentifier,usageType,'||
       'timeSlot,serviceType,eventCount,sumDuration,sumBytes,sumValue'
from dual
/

-- Create data
select '/u01/data/agg/'||ds_st.ds                            ||','||  /* currentDir   */
       to_char(to_date(ts.timeslot,'YYYYMMDDHH24')+(sysdate - trunc(sysdate)) -- ACTUALLY BOLLOCKS
                      ,'YYYYMMDDHH24MISS')||
                      '.'||ds_st.ds||'.out'                  ||','||  /* edrFileName   */
       ds_ne.ne                                              ||','||  /* neId         */
       ds_st.ds||'.'||ds_ut.ut||'.'||ts.timeslot             ||','||  /* umIdentifier */
       ds_ut.ut                                              ||','||  /* usageType    */
       ts.timeslot                                           ||','||  /* timeSlot     */
       ds_st.st                                              ||','||  /* serviceType  */
       ((ds_st.dsno * 10000) + (ts.dayno * 100) + ts.hour)*1    ||','||  /* eventCount   */
       ((ds_st.dsno * 10000) + (ts.dayno * 100) + ts.hour)*10   ||','||  /* sumDuration  */
       ((ds_st.dsno * 10000) + (ts.dayno * 100) + ts.hour)*100  ||','||  /* sumBytes     */
       ((ds_st.dsno * 10000) + (ts.dayno * 100) + ts.hour)/10            /* sumValue     */
           csv_record
----------------------------------------------------------------
-- Start of column-wise alternative
----------------------------------------------------------------
--select '/u01/data/agg/'||ds_st.ds                                     f /* currentDir   */
--      ,to_char(to_date(ts.timeslot,'YYYYMMDDHH24')+(sysdate - trunc(sysdate)),'YYYYMMDDHH24MISS')||
--                                      '.'||ds_st.ds||'.out'             /* edrFileName   */
--      ,ds_ne.ne                                                         /* neId         */
--      ,ds_st.ds||'.'||ds_ut.ut||'.'||ts.timeslot                        /* umIdentifier */
--      ,ds_ut.ut                                                         /* usageType    */
--      ,ts.timeslot                                                      /* timeSlot     */
--      ,ds_st.st                                                         /* serviceType  */
--      ,((ds_st.dsno * 1000) + (ts.day * 100) + ts.hour)*1             c /* eventCount   */
--      ,((ds_st.dsno * 1000) + (ts.day * 100) + ts.hour)*10            d /* sumDuration  */
--      ,((ds_st.dsno * 1000) + (ts.day * 100) + ts.hour)*1             b /* sumBytes     */
--      ,((ds_st.dsno * 1000) + (ts.day * 100) + ts.hour)*100           v /* sumValue     */
--,ts.day
--,ts.hour
--,ds_st.dsno
----------------------------------------------------------------
-- End of column-wise alternative
----------------------------------------------------------------
from steve_ds_to_st_xref ds_st
    ,steve_ds_to_ne_xref ds_ne
    ,steve_ds_to_ut_xref ds_ut
    ,steve_timeslot      ts
where ds_st.ds = ds_ne.ds
and   ds_st.ds = ds_ut.ds
and   ts.day            < nvl('&days',99) + 1
and   ds_st.ds like 'DS'||nvl('&ds','%')
and   ds_st.st like       nvl('&st','ST%')
--order by ts.timeslot desc
/

spool off

------------------------
-- Tidy up
------------------------
drop view steve_ds_to_st_xref
/
drop view steve_ds_to_ne_xref
/
drop view steve_ds_to_ut_xref
/
drop view steve_timeslot
/

ENDSQL

echo ""
echo "----------------------------------------------------------------------------------------------------------------"
echo "output generated for DS$1, for $2 days and service type $3, creating  " `wc -l $HOME/data/test/um/um_data.dat` "lines."
echo "----------------------------------------------------------------------------------------------------------------"
