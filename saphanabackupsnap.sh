echo "Prepare the SAP HANA for Storage Snapshot..."
ssh p66adm@XXXXXXXXX "
/usr/sap/P66/home/.profile
/usr/sap/P66/home/.bashrc
/usr/sap/P66/home/.sapsrc.sh
/usr/sap/P66/home/.sapenv.sh
pwd
cd /usr/sap/P66/HDB00
export PATH=/usr/sap/P66/HDB00/saphana:/usr/sap/P66/HDB00:/usr/sap/P66/HDB00/exe:/usr/sap/P66/HDB00/exe/mdc:/usr/sap/P66/HDB00/exe/Python/bin:/usr/sap/P66/HDB00/exe/dat_bin_dir:.:/usr/sap/P66/home:/usr/sap/P66/home/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/X11R6/bin:/usr/games:/usr/lib/mit/bin:/usr/lib/mit/sbin

pwd
hdbsql -S P66 -n XXXXXXXXXX:30015 -u system -p XXXXXXXXX <<EOF
BACKUP DATA CREATE SNAPSHOT;
select * from M_BACKUP_CATALOG WHERE "ENTRY_TYPE_NAME" = 'data snapshot' and "STATE_NAME" = 'prepared'
exit
EOF
" > backup_id.txt

varbackupid=`sed '12!d' backup_id.txt | cut -d',' -f1`
echo "Backup id $varbackupid"

echo "Freezing the Data volumes File system"
ssh root@XXXXXXXXX "
xfs_freeze -f /hana/data/P66
"

echo "Take the Storage Snapshot and copy it to target"

echo "Take snapshot of Data volume..."
./snapcopydatavolume.sh


echo "Unfreezing the Data volumes File system"
ssh root@XXXXXXXX "
xfs_freeze -u /hana/data/P66
"

echo "Close SAP HANA for Storage Snapshot..."
ssh p66adm@XXXXXXXXXX "
/usr/sap/P66/home/.profile
/usr/sap/P66/home/.bashrc
/usr/sap/P66/home/.sapsrc.sh
/usr/sap/P66/home/.sapenv.sh
pwd
cd /usr/sap/P66/HDB00
export PATH=/usr/sap/P66/HDB00/saphana:/usr/sap/P66/HDB00:/usr/sap/P66/HDB00/exe:/usr/sap/P66/HDB00/exe/mdc:/usr/sap/P66/HDB00/exe/Python/bin:/usr/sap/P66/HDB00/exe/dat_bin_dir:.:/usr/sap/P66/home:/usr/sap/P66/home/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/X11R6/bin:/usr/games:/usr/lib/mit/bin:/usr/lib/mit/sbin
pwd
hdbsql -S P66 -n XXXXXXXXXX:30015 -u system -p XXXXXXXXX <<EOF
BACKUP DATA CLOSE SNAPSHOT BACKUP_ID $varbackupid SUCCESSFUL 'USE THIS';
exit
EOF
"
