column text format a150
set linesize 150
set pagesize 0
set feedback off
set termout off
set wrap on


spool _selects.sh

select 'echo "select * from '||col.owner||'.'||col.table_name||
             ' where '||col.column_name||
--             ' between 99999 and 200000;" '||
             ' > 99999 ;" '||
             '> sql/'||lower(col.owner)||'/'||col.table_name||'.sql' text
from all_cons_columns col
    ,all_constraints  con
where col.CONSTRAINT_NAME = con.CONSTRAINT_NAME
and   con.CONSTRAINT_TYPE = 'P'
and   col.owner in ( 'UM', 'CUSTOMER', 'DGF', 'JOBS', 'GDL', 'UTILS' )
--and   rownum < 11 -- TESTING ONLY
/

spool off

!chmod +x _selects.sh

exit
