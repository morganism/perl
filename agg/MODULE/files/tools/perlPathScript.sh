
for FILE in ` find $HOME/BUILD/sql/bin/ $HOME/BUILD/bin/ $HOME/BUILD/lib/ $HOME/AGGREGATOR_BUILD/sql/bin/ $HOME/AGGREGATOR_BUILD/bin/ $HOME/AGGREGATOR_BUILD/lib/ | xargs grep \#\!/usr\/bin\/perl$ | cut -d":" -f1`
do
    cat $FILE | sed 's/#\!\/usr\/bin\/perl$/#\!\/usr\/bin\/env perl/' > tmpfile
    mv tmpfile $FILE
    chmod +x $FILE
done


