BIN_DIR=$ASCERTAIN_BUILD/tools/export_config
timestamp=`date '+%Y%m%d%k%M%S'`
DATA_DIR=$HOME/data/saved_config
PASSWORD=ascertain
SCHEMA_LIST=$(find $BIN_DIR/sql -type d -exec basename {} \; | grep -v sql ) # worked out from the SQL config files about to be executed
if [ ! -d $DATA_DIR ] ; then mkdir $DATA_DIR ; fi

cd $DATA_DIR

for FILE in $( find $BIN_DIR/sql -type f | grep sql$ )  
do 

  SCHEMA=$(echo ${FILE##/*sql/} | cut -d"/" -f1 )
  TABLE=$(echo ${FILE##/*/} | cut -d"." -f1)
  echo "owner="$SCHEMA", table="$TABLE

  # Create a directory if not exists
  if [ ! -d $SCHEMA ] ; then  mkdir $SCHEMA ; fi
  
  echo "create or replace view $SCHEMA.XX_TEMP_VIEW_XX as " > _viewdef.sql
  cat $FILE >> _viewdef.sql
  echo ";"  >> _viewdef.sql

  sqlplus -S $SCHEMA/$PASSWORD@$ORACLE_SID << ENDSQL
  set feedback off
  start _viewdef.sql
ENDSQL

  db2csv -Q -d $DATA_DIR/$SCHEMA/ -o $ORACLE_SID -s $SCHEMA -p $PASSWORD -v -t /XX_TEMP_VIEW_XX/ --date-format 'YYYYMMDDHH24MISS'
  mv $DATA_DIR/$SCHEMA/XX_TEMP_VIEW_XX $DATA_DIR/$SCHEMA/add.$TABLE.csv     # rename to reasonable data CSV file name

done

for SCHEMA in $SCHEMA_LIST
do
  sqlplus -S $SCHEMA/$PASSWORD@$ORACLE_SID << ENDSQL
  set termout off
  set feedback off
  drop view $SCHEMA.XX_TEMP_VIEW_XX;
ENDSQL
done

#rm _viewdef.sql

tar -cvf exported_config_$timestamp.tar */*csv
echo "==========================================================================================================================================="
echo ""
echo "Now scp $DATA_DIR/exported_config_$timestamp.tar to <user>@<host>:src/vfi-um-x.x.x.dev/VFI-UM/files/sql/reference/csv"
echo ""
echo "Then, after appropriate checks, untar into the sandbox directory"
echo ""
echo "==========================================================================================================================================="

cd -
