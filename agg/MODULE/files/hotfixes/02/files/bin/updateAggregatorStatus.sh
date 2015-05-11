#!/bin/bash

JOBID=$1
LOGFILE=$2

echo "Beginning job" >> $LOGFILE

sqlplus -S customer/ascertain@$ORACLE_SID 1>>$LOGFILE 2>&1 << EOF
drop table customer.aggregator_status;
create table customer.aggregator_status as select * From customer.v_aggregator_status;
EOF

