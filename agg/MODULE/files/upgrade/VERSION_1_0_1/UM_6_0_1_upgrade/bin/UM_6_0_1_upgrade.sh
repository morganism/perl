#!/bin/bash
##############################################
#Check the current OS to choose right commands
#for options compatibility
##############################################
OS=`uname -a | grep Linux`
if [ "$OS" != "" ]; then
        ##Linux commands
        AWK_CMD="awk"
        DIFF_CMD="diff"
else
        #Solaris commands
        AWK_CMD="nawk"
        DIFF_CMD="sdiff"
fi

##############################################
# check to see that ASCERTAIN_BUILD is set
##############################################
if [ -z $ASCERTAIN_BUILD ]; then
  echo "ASCERTAIN_BUILD environment variable not set, aborting"
  exit
fi

##############################################
# check to see that ORACLE_SID is set
##############################################
if [ -z $ORACLE_SID ]; then
  echo "ORACLE_SID environment variable not set, aborting"
  exit
fi

##############################################
# check to see that CARTESIAN_PROPERTIES is set
##############################################
if [ -z $CARTESIAN_PROPERTIES ]; then
  echo "CARTESIAN_PROPERTIES environment variable not set, aborting"
  exit
fi

##############################################
# function to get passwords from .cpm.xml
##############################################
setPasswords(){
  cpm=`grep CPM_CONFIG_FILE $CARTESIAN_PROPERTIES | $AWK_CMD '{print $2}' FS="\="`
  for line in $(egrep "(user=|password=)" $cpm) ; do
        lower_line=`echo $line | tr "[:upper:]" "[:lower:]"`
    eval "$lower_line"
    if [ "$password" != "" ] ; then
      eval "export ${user}_pass=\"$password\""
      user=""
      password=""
    fi
  done
}

##############################################
# load passwords using password function
##############################################
setPasswords

sqlplus gdl/$gdl_pass@$ORACLE_SID @ $ASCERTAIN_BUILD/upgrade/VERSION_1_0_1/UM_6_0_1_upgrade/sql/GDL_UPDATES.sql  
sqlplus imm/$imm_pass@$ORACLE_SID @ $ASCERTAIN_BUILD/upgrade/VERSION_1_0_1/UM_6_0_1_upgrade/sql/IMM_UPDATES.sql  
sqlplus jobs/$jobs_pass@$ORACLE_SID @ $ASCERTAIN_BUILD/upgrade/VERSION_1_0_1/UM_6_0_1_upgrade/sql/JOB_UPDATES.sql  
sqlplus um/$um_pass@$ORACLE_SID @ $ASCERTAIN_BUILD/upgrade/VERSION_1_0_1/UM_6_0_1_upgrade/sql/UM_UPDATES.sql  
sqlplus web/$web_pass@$ORACLE_SID @ $ASCERTAIN_BUILD/upgrade/VERSION_1_0_1/UM_6_0_1_upgrade/sql/WEB_UPDATES.sql

sqlplus imm/$imm_pass@$ORACLE_SID @ $ASCERTAIN_BUILD/upgrade/VERSION_1_0_1/UM_6_0_1_upgrade/sql/V_ALARM_SUMMARY_MATRIX_GRAPH.sql
sqlplus imm/$imm_pass@$ORACLE_SID @ $ASCERTAIN_BUILD/upgrade/VERSION_1_0_1/UM_6_0_1_upgrade/sql/V_ALERT_SUMMARY_MATRIX_GRAPH.sql
sqlplus imm/$imm_pass@$ORACLE_SID @ $ASCERTAIN_BUILD/upgrade/VERSION_1_0_1/UM_6_0_1_upgrade/sql/V_CASE_SUMMARY_MATRIX_GRAPH.sql
sqlplus jobs/$jobs_pass@$ORACLE_SID @ $ASCERTAIN_BUILD/upgrade/VERSION_1_0_1/UM_6_0_1_upgrade/sql/V_JOB_QUEUE.sql
sqlplus jobs/$jobs_pass@$ORACLE_SID @ $ASCERTAIN_BUILD/upgrade/VERSION_1_0_1/UM_6_0_1_upgrade/sql/V_SCHED_JOB_MANAGEMENT_QUEUE.sql

sqlplus imm/$imm_pass@$ORACLE_SID @ $ASCERTAIN_BUILD/upgrade/VERSION_1_0_1/UM_6_0_1_upgrade/sql/P_OPEN_ISSUES_BY_TYPE.prc

echo "UM 6.0.1 upgrade completed"

