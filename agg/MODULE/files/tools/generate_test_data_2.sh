#!/bin/bash

sqlplus -S um/ascertain << ENDSQL

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
spool $HOME/data/test/um/_um_data.dat

-- The meat...
with timeslots
as
(
select days.day
      ,hours.hour
      ,to_number(to_char(days.daydate + (hours.hour/24),'D')) dayofweek
      ,to_char(days.daydate + (hours.hour/24),'YYYYMMDDHH24') timeslot
      ,days.daydate + (hours.hour/24) timeslotdate
from (select rownum - 1 hour from all_tab_columns where rownum < 25) hours
    ,(select rownum day, trunc(sysdate) + 1 - rownum daydate from all_tab_columns where rownum < 36) days
--order by 4 desc 
),
ds_to_ut_xref
as
(
select 'DS11' ds,'SMS' ut from dual union all
select 'DS12','SMS' from dual union all
select 'DS20','SMS' from dual union all
select 'DS20','Voice' from dual union all
select 'DS23','SMS' from dual union all
select 'DS23','Voice' from dual union all
select 'DS28','Voice' from dual union all
select 'DS28','SMS' from dual union all
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
select 'DS80','Voice' from dual union all
select 'DS81','SMS' from dual union all
select 'DS81','Voice' from dual
),
ds_to_st_xref
as
(
select distinct
       n.name ds
      ,substr(n.name,3) dsno
      ,substr(d.name,1,instr(d.name,'-') - 2) st
  from dgf.node_ref       n
      ,um.node_metric_jn  m
      ,um.metric_definition_ref d
where n.node_id = m.node_id
and   m.metric_definition_id = d.metric_definition_id
)
/*
select '/dummy/dir'                                 currentDir
      ,'20110101000000.'||ds_to_ut_xref.ds||'.out'  edrFileName
      ,s.source_description                         neid
      ,ds_to_ut_xref.ds||'.'||ds_to_ut_xref.ut||'.'||timeslots.timeslot   umIdentifier
      ,ds_to_ut_xref.ut                             usageType
      ,timeslots.timeslot                           timeslot
      ,ds_to_st_xref.st                             serviceType
      ,round(
                 1 *  -- a factor
               ( 30 + timeslots.dayofweek) * 
               (100 - timeslots.hour) * 
               (5 + (1 - abs(DBMS_RANDOM.NORMAL)/10)) 
            )                                       eventCount
      ,round(
                 2 *  -- a factor
               ( 30 + timeslots.dayofweek) * 
               (100 - timeslots.hour) * 
               (5 + (1 - abs(DBMS_RANDOM.NORMAL)/10)) 
            )                                       sumDuration
      ,round(
                 5.3 *  -- a factor
               ( 30 + timeslots.dayofweek) * 
               (100 - timeslots.hour) * 
               (5 + (1 - abs(DBMS_RANDOM.NORMAL)/10)) 
            )                                       sumBytes
      ,round(
                 0.0234 *  -- a factor
               ( 30 + timeslots.dayofweek) * 
               (100 - timeslots.hour) * 
               (5 + (1 - abs(DBMS_RANDOM.NORMAL)/10)) 
            ,2)                                     sumValue
      ,0                                            log_record_id
      ,to_date('20110101000000','YYYYMMDDHH24MISS') process_date
      ,ds_to_ut_xref.ds
--currentDir,edrFileName,neId,umIdentifier,usageType,timeSlot,serviceType,eventCount,sumDuration,sumBytes,sumValue
-- =E$1*(30 +C3)*(100-D3)*(5 +RAND())
*/
select '/dummy/dir'                                 ||','||--currentDir
       '20110101000000.'||ds_to_ut_xref.ds||'.out'  ||','||--edrFileName
       s.source_description                         ||','||--neid
       ds_to_ut_xref.ds||'.'||ds_to_ut_xref.ut||'.'||timeslots.timeslot   ||','||--umIdentifier
       ds_to_ut_xref.ut                             ||','||--usageType
       timeslots.timeslot                           ||','||--timeslot
       ds_to_st_xref.st                             ||','||--serviceType
       round(
                 1 *  -- a factor
               ( 30 + timeslots.dayofweek) * 
               (100 - timeslots.hour) * 
               (5 + (1 - abs(DBMS_RANDOM.NORMAL)/10)) 
            )                                       ||','||--eventCount
       round(
                 2 *  -- a factor
               ( 30 + timeslots.dayofweek) * 
               (100 - timeslots.hour) * 
               (5 + (1 - abs(DBMS_RANDOM.NORMAL)/10)) 
            )                                       ||','||--sumDuration
       round(
                 5.3 *  -- a factor
               ( 30 + timeslots.dayofweek) * 
               (100 - timeslots.hour) * 
               (5 + (1 - abs(DBMS_RANDOM.NORMAL)/10)) 
            )                                       ||','||--sumBytes
       round(
                 0.0234 *  -- a factor
               ( 30 + timeslots.dayofweek) * 
               (100 - timeslots.hour) * 
               (5 + (1 - abs(DBMS_RANDOM.NORMAL)/10)) 
            ,2)                            csv      --sumValue
from timeslots  
cross join ds_to_ut_xref 
inner join dgf.node_ref n
on n.name = ds_to_ut_xref.ds
inner join um.source_desc_ref s
on n.node_id = s.node_id
inner join ds_to_st_xref 
on ds_to_st_xref.ds = ds_to_ut_xref.ds
/

spool off

ENDSQL

#
# Now split the output file
#
for DS in DS11 DS12 DS20 DS23 DS28 DS33 DS39 DS4 DS40 DS44 DS45 DS48 DS49 DS5 DS53 DS54 DS55 DS56 DS6 DS64 DS65 DS8 DS80 DS81
do
  OUTFILE=$HOME/data/gdl/input/$DS/20110101000000.$DS.out
	echo "currentDir,edrFileName,neId,umIdentifier,usageType,timeSlot,serviceType,eventCount,sumDuration,sumBytes,sumValue" > $OUTFILE
  grep "\.$DS\." $HOME/data/test/um/_um_data.dat                                                                         >> $OUTFILE
  COUNT=`wc -l $OUTFILE`
	echo "Done $DS....$COUNT records created"
done

## Checks
wc -l $HOME/data/test/um/_um_data.dat
wc -l $HOME/data/gdl/input/DS*/201101010000*DS*out

## Tidy up
rm $HOME/data/test/um/_um_data.dat
