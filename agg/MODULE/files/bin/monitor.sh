###################################################################################################
# monitor.sh
# 
# Intended to be a collection of measurements regarding the performance of the EDR Aggregator
#
###################################################################################################

# Set up log file
DATE=`date '+%Y%m%d'`
LOG=/usr/revo/datafeed/log/monitor.$DATE.log

##
## Measurement #1 - size of DS28 decoded files
##
#STARTDATE=`date '+%Y%m%d%H%M%S'`
#BYTES=`find /usr/revo/datafeed/um/DS28/arc* -name "*decoded*" -type f -exec ls -l {} \; | awk '{sum += $5} END {print sum}'` 
#ENDDATE=`date '+%Y%m%d%H%M%S'`
#TIMETOMEASURE=`echo $ENDDATE - $STARTDATE | bc -l`
#echo                          \
#     $STARTDATE ","           \
#     $TIMETOMEASURE ","       \
#     "DS28 decoded files" "," \
#     $BYTES                   \
#      >> $LOG

#
# Measurement #2 - Disk Usage
#
STARTDATE=`date '+%Y%m%d%H%M%S'`
PERCENTAGE=`df -k /usr/revo/datafeed | grep "[0-9]%" | awk '{print $4}'`           
ENDDATE=`date '+%Y%m%d%H%M%S'`
TIMETOMEASURE=`echo $ENDDATE - $STARTDATE | bc -l`
echo                         \
     $STARTDATE ","          \
     $TIMETOMEASURE ","      \
     "/usr/revo/datafeed disk usage" "," \
     $PERCENTAGE             \
      >> $LOG

#
# Measurement #3 - DS28 input file count
#
STARTDATE=`date '+%Y%m%d%H%M%S'`
NUMBER_FILES=`find /usr/revo/datafeed/um/DS28/in_P0* -follow -type f -name "*decoded*" | wc -l`
ENDDATE=`date '+%Y%m%d%H%M%S'`
TIMETOMEASURE=`echo $ENDDATE - $STARTDATE | bc -l`
echo                         \
     $STARTDATE ","          \
     $TIMETOMEASURE ","      \
     "" "," \
     "DS28 file backlog" "," \
     $NUMBER_FILES           \
      >> $LOG

#
# Measurement #4 - DS56 input file count
#
STARTDATE=`date '+%Y%m%d%H%M%S'`
NUMBER_FILES=`find /usr/revo/datafeed/um/DS56/in* -follow -type f -name "NGME*" | wc -l`
ENDDATE=`date '+%Y%m%d%H%M%S'`
TIMETOMEASURE=`echo $ENDDATE - $STARTDATE | bc -l`
echo                         \
     $STARTDATE ","          \
     $TIMETOMEASURE ","      \
     "" "," \
     "DS56 file backlog" "," \
     $NUMBER_FILES           \
      >> $LOG

#
# Measurement #5 - DS33 input file count
#
STARTDATE=`date '+%Y%m%d%H%M%S'`
NUMBER_FILES=`find /usr/revo/datafeed/um/DS33/in* -follow -type f -name "GSM*" | wc -l`
ENDDATE=`date '+%Y%m%d%H%M%S'`
TIMETOMEASURE=`echo $ENDDATE - $STARTDATE | bc -l`
echo                         \
     $STARTDATE ","          \
     $TIMETOMEASURE ","      \
     "" "," \
     "DS33 file backlog" "," \
     $NUMBER_FILES           \
      >> $LOG
