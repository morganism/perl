#!/usr/bin/bash


# Check each pid file has an associated process that is still running.
# If running process is not attached then the pid file should be deleted.
# Otherwise the pid file will block subsequent aggregator actions for that DS

for file in `find $HOME/datafeed/um/pid/ -type f -name "*.pid" -mmin +5 -exec ls {} \;`; do
        for r in $(grep -h $(uname -n) $file 2>/dev/null) ; do
            pid=$(echo $r | cut -d":" -f2);
#           ps -ef |  awk '{print $2}' | grep "^${pid}$" 2>&1 1>/dev/null || echo pid $pid no longer in use, removing file $file $(grep iecar0vr:$pid *.pid | cut -d":" -f1)
            ps -ef |  awk '{print $2}' | grep "^${pid}$" 2>&1 1>/dev/null || rm $file
       done
done


