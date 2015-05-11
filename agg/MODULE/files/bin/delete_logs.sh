#!/usr/bin/bash

set +x 
AGE=30
echo Running $0 at `date`

for dir in `find $HOME/datafeed/um/DS*/ -type d -name "log*"`
do 
  echo Processing $dir
  find $dir -mtime +$AGE -type f -name "*log" -exec rm {} \;
done

# Also delete from $HOME/datafeed/log
find $HOME/datafeed/log -mtime +$AGE -type f -name "*log*" -exec rm {} \;
