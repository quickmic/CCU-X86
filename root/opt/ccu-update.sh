#!/bin/bash

#Legacy Migration
if [[ -e /var/status/HMIPlocaldevice ]]
then
	rm /var/status/HMIPlocaldevice
	echo "ttyUSB0" > /var/status/HMIPenabled
fi

rm /www/* -R

#Debian update
apt-get update
apt-get dist-upgrade -y
apt-get clean

#Kill processes
killall socat
killall hs485dLoader
killall java
killall hs485d
killall rfd
killall ReGaHss
killall ReGaHss.community
killall ReGaHss.normal
killall ReGaHss.legacy
killall cuxd

cp -rf /opt/occu-x86/root/bin/* /bin/
cp -rf /opt/occu-x86/root/opt/* /opt/
cp -rf /opt/occu-x86/root/www/* /www/
cp -rf /opt/occu-x86/root/etc/init.d/* /etc/init.d/

#git clone https://github.com/quickmic/occu.git /opt/occu/
cp /opt/occu/HMserver/opt/HMServer/HMIPServer.jar /opt/HMServer/
cp /opt/occu/HMserver/opt/HMServer/HMServer.jar /opt/HMServer/
cp -rf /opt/occu/WebUI/bin/* /bin/
cp -rf /opt/occu/WebUI/www/* /www/
cp -rf /opt/occu/firmware/* /firmware/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/HS485D/bin/* /bin/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/HS485D/lib/*  /lib/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/LinuxBasis/* /
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/RFD/bin/* /bin/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/RFD/lib/* /lib/
cp -rf /opt/occu/HMserver/opt/HmIP/* /opt/HmIP/
#cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/RFD/etc/config_templates/rfd.conf /etc/config/rfd.conf
#cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/RFD/etc/config_templates/* /etc/config_templates/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/bin/* /bin/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/lib/* /lib/
#cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/etc/* /etc/
#cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/etc/config_templates/* /etc/config/
#cp /opt/occu/HMserver/etc/config_templates/log4j.xml /etc/config/
cp -rf /opt/occu/HMserver/opt/HMServer/* /opt/HMServer/
#cp -rf /opt/occu/X86_32_Debian_Wheezy/packages/lighttpd/etc/lighttpd/* /etc/lighttpd/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI-Beta/bin/* /bin/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI-Beta/lib/* /lib/
#cp /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/RFD/etc/crRFD.conf /etc/config/crRFD.conf

versionOCCU=`git -C /opt/occu/ describe --tags`
versionX86=`git -C /opt/occu-x86/ describe --tags`
/bin/sed -i -n '/WEBUI_VERSION = "/{:a;N;/;/!ba;N;s/.*\n/    WEBUI_VERSION = "'$versionOCCU' \/ '$versionX86'";\n\n/};p' /www/rega/pages/index.htm

#Remove buildID (char) from Version
chrlen=${#versionOCCU}
counter=1

while [ $counter -le $chrlen ]
do
        temp=${versionOCCU:$counter:1}

        if [[ "$temp"  =~ [\-] ]]
        then
                chrlen=$counter
                break
        fi

        ((counter++))
done

version=${versionOCCU:0:$chrlen}
echo "VERSION="$version > /boot/VERSION

echo "CCU Update Log:" > /var/log/ccuupdate.txt

#Apply patches
for f in /opt/occu-x86/patches/0*
do
	echo $f >> /var/log/ccuupdate.txt
        patch --forward -d / -p0 < $f >> /var/log/ccuupdate.txt
done


if [ -f /var/status/ExtendedFeatures ]
then

	for f in /opt/occu-x86/patches/1*
	do
		echo $f >> /var/log/ccuupdate.txt
		patch --forward -d / -p0 < $f >> /var/log/ccuupdate.txt
	done
fi

find /etc/ -type f -name '*.rej' -delete
find /etc/ -type f -name '*.orig' -delete
find /www/ -type f -name '*.rej' -delete
find /www/ -type f -name '*.orig' -delete


/sbin/reboot
