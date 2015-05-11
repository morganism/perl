#!/usr/bin/bash

set +x 
DATE=`date '+%Y%m%d'`
echo Running $0 at `date`
LOG_DIR=/usr/revo/datafeed/log/

for file in `ls $LOG_DIR/*log`
do 
  if [ -e $file.$DATE ]
  then
    echo Already run for today. Leaving $file and $file.$DATE alone.
  else
    echo Renaming $file to $file $file.$DATE
    mv $file $file.$DATE
  fi
done
