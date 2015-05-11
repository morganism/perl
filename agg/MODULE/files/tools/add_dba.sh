###############################################################
# A horrible hack for dev environments to avoid wasting time
# on Oracle incompatability issues
###############################################################

for file in `ls $HOME/BUILD/sql/users/*sql`
do 
  cat $file | grep -v -i exit > a
	echo "grant dba to  ${file%%\.*} ;" >> a
	echo exit >> a
	mv a $file
done
