#!/bin/bash
#Check CCU updates
git -C /opt/occu/ pull
git -C /opt/occu-x86/ pull
versionOCCU=`git -C /opt/occu/ describe --tags`
versionX86=`git -C /opt/occu-x86/ describe --tags`
versionCombined=$versionOCCU" / "$versionX86
echo "homematic.com.setLatestVersion('"$versionCombined"', 'HM-CCU3');" > /www/ccuupdate.js
cp /opt/occu-x86/root/opt/ccu-update.sh /opt/ccu-update.sh

