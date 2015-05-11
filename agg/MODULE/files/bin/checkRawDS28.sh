rawfiles=/tmp/rawfiles
rawfiletotals=/tmp/rawfiletotals
touch $rawfiletotals ; rm -f $rawfiletotals


ls -1 /usr/revo/datafeed/xacct/gsm/inputs | sed 's/-/_/' | sed 's/-/ /' > $rawfiles

echo "P01 POST ODD " $(grep MSSP01 $rawfiles | grep TTFILE   | awk '{print $1 " " $2/2 " " }' | grep    "\.5" | wc -l) >> $rawfiletotals
echo "P01 POST EVEN" $(grep MSSP01 $rawfiles | grep TTFILE   | awk '{print $1 " " $2/2 " " }' | grep -v "\.5" | wc -l) >> $rawfiletotals
echo "P01 PRE  ODD " $(grep MSSP01 $rawfiles | grep ICIFILE  | awk '{print $1 " " $2/2 " " }' | grep    "\.5" | wc -l) >> $rawfiletotals
echo "P01 PRE  EVEN" $(grep MSSP01 $rawfiles | grep ICIFILE  | awk '{print $1 " " $2/2 " " }' | grep -v "\.5" | wc -l) >> $rawfiletotals
echo "" >> $rawfiletotals
echo "P02 POST ODD " $(grep MSSP02 $rawfiles | grep TTFILE   | awk '{print $1 " " $2/2 " " }' | grep    "\.5" | wc -l) >> $rawfiletotals
echo "P02 POST EVEN" $(grep MSSP02 $rawfiles | grep TTFILE   | awk '{print $1 " " $2/2 " " }' | grep -v "\.5" | wc -l) >> $rawfiletotals
echo "P02 PRE  ODD " $(grep MSSP02 $rawfiles | grep ICIFILE  | awk '{print $1 " " $2/2 " " }' | grep    "\.5" | wc -l) >> $rawfiletotals
echo "P02 PRE  EVEN" $(grep MSSP02 $rawfiles | grep ICIFILE  | awk '{print $1 " " $2/2 " " }' | grep -v "\.5" | wc -l) >> $rawfiletotals
echo "" >> $rawfiletotals
echo "P03 POST ODD " $(grep MSSP03 $rawfiles | grep TTFILE   | awk '{print $1 " " $2/2 " " }' | grep    "\.5" | wc -l) >> $rawfiletotals
echo "P03 POST EVEN" $(grep MSSP03 $rawfiles | grep TTFILE   | awk '{print $1 " " $2/2 " " }' | grep -v "\.5" | wc -l) >> $rawfiletotals
echo "P03 PRE  ODD " $(grep MSSP03 $rawfiles | grep ICIFILE  | awk '{print $1 " " $2/2 " " }' | grep    "\.5" | wc -l) >> $rawfiletotals
echo "P03 PRE  EVEN" $(grep MSSP03 $rawfiles | grep ICIFILE  | awk '{print $1 " " $2/2 " " }' | grep -v "\.5" | wc -l) >> $rawfiletotals
echo "" >> $rawfiletotals
echo "P04 POST ODD " $(grep MSSP04 $rawfiles | grep TTFILE   | awk '{print $1 " " $2/2 " " }' | grep    "\.5" | wc -l) >> $rawfiletotals
echo "P04 POST EVEN" $(grep MSSP04 $rawfiles | grep TTFILE   | awk '{print $1 " " $2/2 " " }' | grep -v "\.5" | wc -l) >> $rawfiletotals
echo "P04 PRE  ODD " $(grep MSSP04 $rawfiles | grep ICIFILE  | awk '{print $1 " " $2/2 " " }' | grep    "\.5" | wc -l) >> $rawfiletotals
echo "P04 PRE  EVEN" $(grep MSSP04 $rawfiles | grep ICIFILE  | awk '{print $1 " " $2/2 " " }' | grep -v "\.5" | wc -l) >> $rawfiletotals

echo ""
echo "===== DS28 raw files awaiting processing ===="
cat $rawfiletotals
echo "=============================================" 
echo "Total =" $(wc -l $rawfiles | awk '{print $1}')
echo "=============================================" 
echo "Check =" $(cat /tmp/rawfiletotals | awk '{sum += $4} END {print sum}')
echo "=============================================" 


rm -f $rawfiles
rm -f $rawfiletotals
