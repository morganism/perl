#!/bin/bash

# used for VFI-UM configuration - set all the sequence numbers for the project ref data to 1000000 so that
# we can create it through the front end then port it straight from db to the build

for i in "WEB" "UTILS" "TOOLS" "SOA" "RDM" "OLAP" "JOBS" "IMM" "GDL" "DGF" "CWE" "BLE" "UM";
do
    echo Run on $i;
    updateSequenceNumbers $i ;
done

# Update the customized reference data tables so that the next number is one greater than whatever we've added 
updateSequenceNumbers -f $ASCERTAIN_BUILD/tools/sequencing/sequences.gdl GDL
updateSequenceNumbers -f $ASCERTAIN_BUILD/tools/sequencing/sequences.dgf DGF
updateSequenceNumbers -f $ASCERTAIN_BUILD/tools/sequencing/sequences.um UM

exit;
