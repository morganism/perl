#!/bin/bash
password=ascertain                    # hard-coded password
counts_table=temp_row_counts
timestamp=`date '+%Y%m%d%H%M%S'`
SCHEMA_LIST='UTILS JOBS CUSTOMER DGF GDL UM'
LOCAL_DB=$1
OTHER_DB=$2

# Create a table in the schema to store results 
for schema in $SCHEMA_LIST
do
sqlplus -S $schema/$password@$LOCAL_DB << ENDSQL
    set pagesize 0
    set linesize 200
    set feedback off
    spool _temp_trunc_table_$timestamp.sql
    select 'truncate table $schema.$counts_table ;' from  dual ;
    spool off
    start _temp_trunc_table_$timestamp.sql
ENDSQL
rm _temp_trunc_table_$timestamp.sql
done

# Create a table in the schema to store results 
for schema in $SCHEMA_LIST
do
sqlplus -S $schema/$password@$OTHER_DB << ENDSQL
    set pagesize 0
    set linesize 200
    set feedback off
    spool _temp_trunc_table_$timestamp.sql
    select 'truncate table $schema.$counts_table ;' from  dual ;
    spool off
    start _temp_trunc_table_$timestamp.sql
ENDSQL
rm _temp_trunc_table_$timestamp.sql
done


