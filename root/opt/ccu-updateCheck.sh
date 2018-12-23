#!/bin/bash

#CCU
git -C /opt/occu/ pull
git -C /opt/occu-x86/ pull

versionOCCU=`git -C /opt/occu/ describe --tags`
versionX86=`git -C /opt/occu-x86/ describe --tags`
versionCombined=$versionOCCU" / "$versionX86
echo "homematic.com.setLatestVersion('"$versionCombined"', 'HM-CCU3');" > /www/ccuupdate.txt


#XMLAPI
if [ -d /opt/xmlapi ]
then
	git -C /opt/xmlapi/ pull
	versionXMLAPI=`git -C /opt/xmlapi/ describe --tags`
fi


#EMail
if [ -d /opt/hm_email ]
then
        git -C /opt/hm_email/ pull
	versionEMAIL=`git -C /opt/hm_email/ describe --tags`
        echo $versionEMAIL > /etc/config/addons/email/versionUpdate
fi
