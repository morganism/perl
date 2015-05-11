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

sqlplus dgf/$dgf_pass@$ORACLE_SID @ $ASCERTAIN_BUILD/upgrade/VERSION_1_0_1/MZ_phase_1_upgrade/sql/DGF_UPDATES.sql
sqlplus gdl/$gdl_pass@$ORACLE_SID @ $ASCERTAIN_BUILD/upgrade/VERSION_1_0_1/MZ_phase_1_upgrade/sql/GDL_UPDATES.sql
sqlplus um/$um_pass@$ORACLE_SID @ $ASCERTAIN_BUILD/upgrade/VERSION_1_0_1/MZ_phase_1_upgrade/sql/UM_UPDATES.sql
sqlplus customer/$customer_pass@$ORACLE_SID @ $ASCERTAIN_BUILD/upgrade/VERSION_1_0_1/MZ_phase_1_upgrade/sql/CUSTOMER_UPDATES.sql
sqlplus jobs/$jobs_pass@$ORACLE_SID @ $ASCERTAIN_BUILD/upgrade/VERSION_1_0_1/MZ_phase_1_upgrade/sql/JOB_UPDATES.sql

sqlplus jobs/$jobs_pass@$ORACLE_SID <<endsql
grant select on jobs.job to web with grant option;
grant select on jobs.job to customer with grant option;
exit;
endsql

sqlplus customer/$customer_pass@$ORACLE_SID @ $ASCERTAIN_BUILD/sql/views/customer/V_MREC_CAT_OPEN_ISSUES.sql
sqlplus customer/$customer_pass@$ORACLE_SID @ $ASCERTAIN_BUILD/sql/views/customer/V_METRIC_ISSUES_BY_SEVERITY.sql

sqlplus customer/$customer_pass@$ORACLE_SID <<endsql
grant select on customer.V_METRIC_ISSUES_BY_SEVERITY to web;
grant select on customer.V_MREC_CAT_OPEN_ISSUES to web;
exit;
endsql


echo "Mediation Zone Phase 1 upgrade completed"

