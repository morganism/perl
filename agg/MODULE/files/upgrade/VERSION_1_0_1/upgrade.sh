#!/bin/sh

log="VFI-UM_1_0_1_upgrade_`date +\"%d%m%Y%H%M%S\"`.log"
echo "VFI-UM_1_0_1 `date`" > $log

# make sure ASCERTAIN_BUILD is set
if [ ! -e $ASCERTAIN_BUILD/upgrade/VERSION_1_0_1 ]; then
        echo "ASCERTAIN_BUILD needs to be set to the VFI_UM_1_0_1 build" 2>&1 | tee -a $log
        exit 1
fi


echo "Running UM_6_0_1 core upgrade...\n" 2>&1 | tee -a $log
$ASCERTAIN_BUILD/upgrade/VERSION_1_0_1/UM_6_0_1_upgrade/bin/UM_6_0_1_upgrade.sh 2>&1 | tee -a $log

echo "Running Mediation Zone Phase 1 upgrade...\n" 2>&1 | tee -a $log
$ASCERTAIN_BUILD/upgrade/VERSION_1_0_1/MZ_phase_1_upgrade/bin/MZ_Phase1_upgrade.sh 2>&1 | tee -a $log


echo "VFI-UM_1_0_1 update complete" 2>&1 | tee -a $log

