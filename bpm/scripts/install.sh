#!/bin/bash

TMPDIR=/var/tmp/
TMPBPM=$TMPDIR/bpm
BPMHOME=/opt/ibm/BPM/v8.5

echo "extract files"
mkdir -p $TMPBPM
cd $TMPDIR
for f in *.tar.gz; do  tar -xzf $f -C $TMPBPM; done

echo "add ulimit values"
cat << EOF >> /etc/security/limits.conf
# BPM
# - stack - max stack size (KB)
* soft stack 32768
* hard stack 32768
# - nofile - max number of open files
* soft nofile 65536
* hard nofile 65536
# - nproc - max number of processes
* soft nproc 16384
* hard nproc 16384
# End BPM
EOF

ulimit -n 16384

echo "install"
cp BpmSilentInstall.xml bpm/responsefiles/BPM/
cd bpm
./IM64/installc -acceptLicense input ./responsefiles/BPM/BpmSilentInstall.xml -log silent_install.log

echo "create profiles"
cd $BPMHOME/bin
cp $TMPDIR/Standard-PC-SingleCluster-DB2.properties .
./BPMConfig.sh -create -de Standard-PC-SingleCluster-DB2.properties

echo "remove temp files"
rm -rf $TMPDIR/*

echo "create BPMDB"
su - db2inst1 -c "cd $BPMHOME/profiles/DmgrProfile/dbscripts/PCCell1.DEPC/DB2/BPMDB/ ; ./createDatabase.sh"
su - db2inst1 -c "cd $BPMHOME/profiles/DmgrProfile/dbscripts/PCCell1.DEPC/DB2/BPMDB; db2 connect to BPMDB ; db2 -tvf createSchema_Standard.sql; db2 -tdGO -vf create; db2 connect reset"

echo "create CMNDB"
su - db2inst1 -c "cd $BPMHOME/profiles/DmgrProfile/dbscripts/PCCell1.DEPC/DB2/CMNDB/ ; ./createDatabase.sh"
su - db2inst1 -c "cd $BPMHOME/profiles/DmgrProfile/dbscripts/PCCell1.DEPC/DB2/CMNDB; db2 connect to CMNDB ; db2 -tvf createSchema_Standard.sql; db2 -tdGO -vf create; db2 connect reset"

echo "create PDWDB"
su - db2inst1 -c "cd $BPMHOME/profiles/DmgrProfile/dbscripts/PCCell1.DEPC/DB2/PDWDB/ ; ./createDatabase.sh"
su - db2inst1 -c "cd $BPMHOME/profiles/DmgrProfile/dbscripts/PCCell1.DEPC/DB2/PDWDB; db2 connect to PDWDB ; db2 -tvf createSchema_Standard.sql; db2 -tdGO -vf create; db2 connect reset"

echo "start BPM"
cd $BPMHOME/bin/
./BPMConfig.sh -start Standard-PC-SingleCluster-DB2.properties

sleep 120

cd $BPMHOME/profiles/DmgrProfile/bin/
./bootstrapProcessServerData.sh -clusterName SingleCluster

sleep 120

echo "stop applications"
cd $BPMHOME/bin/
./BPMConfig.sh -stop Standard-PC-SingleCluster-DB2.properties

su - db2inst1 -c "db2stop"

echo "configure db2 service"
cp $TMPDIR/db2.service /etc/systemd/system
systemctl --system daemon-reload
systemctl enable db2.service

echo "configure bpm service"
cp $TMPDIR/bpm.service /etc/systemd/system
systemctl --system daemon-reload
systemctl enable bpm.service

echo "done"

exit
