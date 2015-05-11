#!/bin/bash
####################################################
# A script to record the number of records
# in all tables in a database - may be of
# use to assess the impact of an UPGRADE process
# to highlight the 'BEFORE' and 'AFTER' states.
#
# Uses bash with embedded SQL that queries
# the Oracle data dictionary in order to generate
# SQL that is then executed
####################################################
password=ascertain                    # hard-coded password
ORACLE_SID=$1
run=$2                                # a parameter to be supplied on the command line to tag the run of this script
counts_table=TEMP_ROW_COUNTS
timestamp=`date '+%Y%m%d%H%M%S'`
SCHEMA_LIST='UTILS JOBS CUSTOMER DGF GDL UM'

if [ $# -lt 2 ] 
then 
  echo "USAGE: $0 ORACLE_SID RUN_ID"; 
  exit
fi

# Create a table in the schema to store results 
for schema in $SCHEMA_LIST
do
sqlplus -S $schema/$password@$ORACLE_SID << ENDSQL
    set pagesize 0
    set linesize 200
    set feedback off
    spool _temp_create_table_$timestamp.sql
    -- only create table if if doesn't exist
		select 'create table $schema.$counts_table (run varchar2(30), schema varchar2(30), table_name varchar2(40), no_recs number);' from  dual 
    minus
		select 'create table $schema.$counts_table (run varchar2(30), schema varchar2(30), table_name varchar2(40), no_recs number);' from  all_tables where table_name = '$counts_table' and owner = '$schema' ;
    spool off
    start _temp_create_table_$timestamp.sql
ENDSQL
rm _temp_create_table_$timestamp.sql
done

# generate INSERTS that cout eows in each table
for schema in $SCHEMA_LIST
do
  echo $schema
  sqlplus -S $schema/$password@$ORACLE_SID << ENDSQL
          set pagesize 0
          set linesize 400
          set feedback off
          spool _temp_count_rows_$timestamp.sql
          select 'insert into $schema.$counts_table select ''$run'', ''$schema'','''||table_name||''', count(*) from '||table_name||';' from user_tables where table_name <> '$schema.$counts_table' and table_name not like 'MLOG%' and table_name not like 'MV%' and table_name not like '%MV' and table_name <> 'TEMP_ROW_COUNTS' order by table_name;
          spool off
          start _temp_count_rows_$timestamp.sql
ENDSQL
rm _temp_count_rows_$timestamp.sql
done

# display the results
rm rec_counts_$ORACLE_SID.log
for schema in $SCHEMA_LIST
do
  sqlplus -S $schema/$password@$ORACLE_SID << ENDSQL
          set linesize 120
          set pagesize 0
          set feedback off
          set termout  off
          set verify  off
          set echo  off
          spool _results_$timestamp.lst
          select run , schema , table_name , no_recs from $schema.$counts_table;
          spool off
ENDSQL
cat _results_$timestamp.lst >> rec_counts_$ORACLE_SID.log
rm _results_$timestamp.lst
done
