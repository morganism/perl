#!/usr/bin/bash
age="+120"
DS6_age="+180"
LOG=/tmp/pidlog.log
touch $LOG
countPid=$(find $HOME/datafeed/um/pid/    -type f -name "*.pid" -mmin $age -exec ls -l {} \; | grep -v DS6.pid | wc -l)
countDS6Pid=$(find $HOME/datafeed/um/pid/ -type f -name "*.pid" -mmin $age -exec ls -l {} \; | grep    DS6.pid | wc -l)
if [ $countPid -gt 0 ] || [ $countDS6Pid -gt 0 ]
then
	echo " Script /usr/revo/datafeed/aggregator_config/bin/checkPID.sh has detected a potential problem " >> $LOG
	echo "" >> $LOG
	if [ $countPid -gt 0 ] 
	then
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >> $LOG
		echo "!!!!     The following processes are over $age minutes old, and may be hanging      !!!!!!" >> $LOG
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >> $LOG
		echo "" >> $LOG
		find $HOME/datafeed/um/pid/ -type f -name "*.pid" -mmin $age -exec ls -l {} \; | grep -v DS6.pid>> $LOG
		echo "" >> $LOG
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >> $LOG
		echo "" >> $LOG
	fi
	if [ $countDS6Pid -gt 0 ]
	then
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >> $LOG
		echo "!!!!     The following processes are over $DS6_age minutes old, and may be hanging      !!!!!!" >> $LOG
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >> $LOG
		echo "" >> $LOG
		find $HOME/datafeed/um/pid/ -type f -name "*.pid" -mmin $DS6_age -exec ls -l {} \; | grep DS6.pid >> $LOG
		echo "" >> $LOG
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >> $LOG
	fi
fi

# If the log is writte, ther eis someting to emali about...
if [ -s $LOG ]
then
	cat $LOG | mailx -s "VFI UM - PID file warning..." steve.makinson@cartesian.com
fi
rm -f $LOG
