#!/bin/bash

#CCU
git -C /opt/occu/ pull
git -C /opt/occu-x86/ pull

versionOCCU=`git -C /opt/occu/ describe --tags`
versionX86=`git -C /opt/occu-x86/ describe --tags`
versionCombined=$versionOCCU" / "$versionX86
echo "homematic.com.setLatestVersion('"$versionCombined"', 'HM-CCU3');" > /www/ccuupdate.txt

#CUXD
if [ -d /opt/cuxd ]
then
        git -C /opt/cuxd/ pull
        versionCUXD=`git -C /opt/cuxd/ describe --tags`
        echo $versionCUXD > /etc/config/addons/cuxd/versionUpdate
fi
