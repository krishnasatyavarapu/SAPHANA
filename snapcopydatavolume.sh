#!/bin/bash

# This script uses an date-stamped suffix for the snapshot rather than depend on the array generated suffix.
###This script will ssh to Pure Storage FlashArray//m to take snapshot of SAP HANA Data Volume

# Set up source and target array names and users

runtime=scripted-`date "+%Y-%m-%d-%H-%M-%S"`
sourcearray="XXXXXXXXXXX"

# Using username auth, this should use public keys instead if you want it to run without asking for a password.
# Using password auth can be a failsafe that prevents accidental use of the script, however.

sourceuser="pureuser"
targetuser="pureuser"

hanadatavolume="p66hanadatavolume"


echo "Running command ssh $sourceuser@$sourcearray purevol snap $hanadatavolume --suffix=$runtime"
          response=$(ssh $sourceuser@$sourcearray "purevol snap $hanadatavolume --suffix=$runtime" 2>&1)

