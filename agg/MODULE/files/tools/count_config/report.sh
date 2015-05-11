#!/bin/bash
password=ascertain                    # hard-coded password
counts_table=temp_row_counts
timestamp=`date '+%Y%m%d%H%M%S'`
SCHEMA_LIST='UTILS JOBS CUSTOMER DGF GDL UM'
LOCAL_DB=$1
OTHER_DB=$2
run=$3                                # a parameter to be supplied on the command line to tag the run of this script

# Create a table in the schema to store results 
echo "============================================================"
echo "==                   CREATING DB_LINKS                    =="
echo "============================================================"
for schema in $SCHEMA_LIST
do
LINK_NAME=$schema"_"
LINK_NAME=$LINK_NAME$OTHER_DB
LINK_NAME=$LINK_NAME"_TEMP";
echo "                 " $LINK_NAME 
sqlplus -S system/manager@$LOCAL_DB << ENDSQL
    set pagesize 0
    set linesize 200
    set feedback off
    drop public database link $LINK_NAME;
    create public database link $LINK_NAME connect to $schema identified by $password using '$OTHER_DB';
ENDSQL
done
echo "============================================================"
echo "==                        DONE                            =="
echo "============================================================"

if [ -f bad_report.lst ] ; then  rm bad_report.lst ; fi
echo "============================================================" >> bad_report.lst
echo "==                      BAD DATA                          ==" >> bad_report.lst
echo "============================================================" >> bad_report.lst
for schema in $SCHEMA_LIST
do
LINK_NAME=$schema"_"
LINK_NAME=$LINK_NAME$OTHER_DB
LINK_NAME=$LINK_NAME"_TEMP";
sqlplus -S $schema/$password@$LOCAL_DB << ENDSQL
    set pagesize 0
    set linesize 200
    set feedback off

    spool _temp_report_$timestamp.sql
        set linesize 150
        set feedback off
        set pagesize 0
        set null ~~~~~~~~~~~

        select ' ' from dual;
        select '=================' from dual;
        select username from user_users;
        select '=================' from dual;

        set pagesize 999
        column local_table format a35
        column remote_table format a35
        column local_count format 999,999,999,990
        column remote_count format 999,999,999,990
        column match_status format a15

        select * 
        from (
                select t1.table_name    local_table
                     , t2.table_name    remote_table
                     , t1.no_recs       local_count
                     , t2.no_recs       remote_count
                     , case
                        when t1.no_recs = t2.no_recs then 'MATCH'
                        when t1.no_recs > t2.no_recs then 'Less @ remote'
                        when t1.no_recs < t2.no_recs then 'More @ remote'
                        when t1.no_recs is null or t2.no_recs is null then 'TABLE MISMATCH'
                       end  MATCH_STATUS
                from temp_row_counts t1
                   full outer join
                     temp_row_counts@$LINK_NAME t2
                on   t1.run        = t2.run
                and  t1.schema     = t2.schema
                and  t1.table_name = t2.table_name
             )
        where MATCH_STATUS <> 'MATCH'
        order by 
              case
               when nvl(local_table, remote_table) like '%REF%' then 1
               when nvl(local_table, remote_table) like '%JN%' then 2
               else 3
              end 
            , MATCH_STATUS
            , nvl(local_count, remote_count) asc
            , nvl(local_table, remote_table);

    spool off

ENDSQL
cat _temp_report_$timestamp.sql >> bad_report.lst
rm _temp_report_$timestamp.sql
done

if [ -f good_report.lst ] ; then  rm good_report.lst ; fi
echo "============================================================" >> good_report.lst
echo "==                     GOOD DATA                          ==" >> good_report.lst
echo "============================================================" >> good_report.lst
for schema in $SCHEMA_LIST
do
LINK_NAME=$schema"_"
LINK_NAME=$LINK_NAME$OTHER_DB
LINK_NAME=$LINK_NAME"_TEMP";
sqlplus -S $schema/$password@$LOCAL_DB << ENDSQL
    set pagesize 0
    set linesize 200
    set feedback off

    spool _temp_report_$timestamp.sql
        set linesize 150
        set feedback off
        set pagesize 0
        set null ~~~~~~~~~~~

        select ' ' from dual;
        select '=================' from dual;
        select username from user_users;
        select '=================' from dual;

        set pagesize 999
        column local_table format a35
        column remote_table format a35
        column local_count format 999,999,999,990
        column remote_count format 999,999,999,990
        column match_status format a15

        select * 
        from (
                select t1.table_name    local_table
                     , t2.table_name    remote_table
                     , t1.no_recs       local_count
                     , t2.no_recs       remote_count
                     , case
                        when t1.no_recs = t2.no_recs then 'MATCH'
                        when t1.no_recs > t2.no_recs then 'Less @ remote'
                        when t1.no_recs < t2.no_recs then 'More @ remote'
                        when t1.no_recs is null or t2.no_recs is null then 'TABLE MISMATCH'
                       end  MATCH_STATUS
                from temp_row_counts t1
                   full outer join
                     temp_row_counts@$LINK_NAME t2
                on   t1.run        = t2.run
                and  t1.schema     = t2.schema
                and  t1.table_name = t2.table_name
             )
        where MATCH_STATUS = 'MATCH'
        order by 
              case
               when nvl(local_table, remote_table) like '%REF%' then 1
               when nvl(local_table, remote_table) like '%JN%' then 2
               else 3
              end 
            , MATCH_STATUS
            , nvl(local_count, remote_count) asc
            , nvl(local_table, remote_table);

    spool off

ENDSQL
cat _temp_report_$timestamp.sql >> good_report.lst
rm _temp_report_$timestamp.sql
done

