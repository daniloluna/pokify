#!/bin/sh
rm -f tmp
mkdir tmp
vboxmanage createmedium disk --filename tmp/extendedDisk.vdi --size 50000 --format vmdk
packer build -force template.json
