#!/bin/bash

#Debian update
#apt-get update
#apt-get dist-upgrade -y
#apt-get clean

#Kill processes
/etc/init.d/ccu stop
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

wget -q -O - https://www.debmatic.de/debmatic/public.key | sudo apt-key add -
apt update

apt-get install etherwake -y
apt-get install digitemp -y
apt-get install u-boot-tools -y
apt-get install dirmngr -y
apt-get install lighttpd -y
apt-get install git -y
apt-get install libc6-i386 -y
apt-get install lib32stdc++6 -y
apt-get install lib32gcc1 -y
apt-get install lib32ncurses5 -y
apt-get install libusb-1.0.0:i386 -y
apt-get install libusb-1.0.0 -y
apt-get install curl -y
apt-get install psmisc -y
apt-get install socat -y
apt-get install keyboard-configuration -y
apt-get install libasound2 -y
apt-get install wget -y
apt-get install libasound2-data -y
apt-get install autoconf -y
apt-get install libusb-1.0 -y
apt-get install build-essential -y
apt-get install msmtp -y
apt-get install net-tools -y
apt-get install usbutils -y
apt-get install openjdk-11-jre-headless -y
apt-get install rsync -y
apt-get install cron -y
apt-get install sudo -y

rm /www/* -R
rm -f /etc/init.d/S01InitHost
rm -f /etc/init.d/S49hs485d
rm -f /etc/init.d/S62HMServer
rm -f /etc/init.d/S99CustomStartscript
rm -f /etc/init.d/S05CheckBackupRestore
rm -f /etc/init.d/S60hs485d
rm -f /etc/init.d/S70ReGaHss
rm -f /etc/init.d/S00InstallAddon
rm -f /etc/init.d/S07logging
rm -f /etc/init.d/S61rfd
rm -f /etc/init.d/S98StartAddons
rm -f /etc/init.d/S01CheckBackupRestore
rm -f /etc/init.d/S02InitHost

cp -rf /opt/occu-x86/root/bin/* /bin/
cp -rf /opt/occu-x86/root/opt/ccu* /opt/
cp -rf /opt/occu-x86/root/www/* /www/
cp -rf /opt/occu-x86/root/etc/init.d/* /etc/init.d/
cp -rf /opt/occu-x86/root/etc/cron.d/ccu /etc/cron.d/

rm -rf /etc/lighttpd/*
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages/lighttpd/etc/lighttpd/* /etc/lighttpd/
rm -f /etc/lighttpd/lighttpd_ssl.conf

cp /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/RFD/etc/config_templates/multimacd.conf /etc/config/
cp /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/etc/rega_http.port /etc/
cp /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/etc/rega.conf /etc/
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
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/bin/* /bin/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/lib/* /lib/
cp -rf /opt/occu/HMserver/opt/HMServer/* /opt/HMServer/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI-Beta/bin/* /bin/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI-Beta/lib/* /lib/

versionOCCU=`git -C /opt/occu/ describe --tags`
versionX86=`git -C /opt/occu-x86/ describe --tags`

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
for f in /opt/occu-x86/patches/*
do
	echo $f >> /var/log/ccuupdate.txt
        patch --forward -d / -p0 < $f >> /var/log/ccuupdate.txt
done

#Update version ID
/bin/sed -i -n '/WEBUI_VERSION = "/{:a;N;/;/!ba;N;s/.*\n/    WEBUI_VERSION = "'$versionOCCU' \/ '$versionX86'";\n\n/};p' /www/rega/pages/index.htm

#Legacy mods
if [[ -e /etc/config/crRFD.conf ]]
then
        hmipdevice=`cat /etc/config/crRFD.conf`

        if [[ $hmipdevice != *"mmd"* ]]
        then
                rm -f /etc/init.d/S60multimacd
        fi
fi

rm -f /var/status/BIDCOSenable
rm -f /var/status/HMIPlocaldevice
rm -f /var/status/HMIPremserialhost
rm -f /var/status/HMIPenabled

#crRfr.conf mods
crRFDMod=`cat /etc/config/crRFD.conf|grep Legacy.Port`

if [ -z "$crRFDMod" ]
then

        echo "Legacy.Port=2010" >> /etc/config/crRFD.conf
fi

crRFDMod=`cat /etc/config/crRFD.conf|grep Legacy.VirtualRemoteControl.Enabled`

if [ -z "$crRFDMod" ]
then

        echo "Legacy.VirtualRemoteControl.Enabled=true" >> /etc/config/crRFD.conf
fi

crRFDMod=`cat /etc/config/crRFD.conf|grep Legacy.CallDeleteDevicesForChangedDevices`

if [ -z "$crRFDMod" ]
then

        echo "Legacy.CallDeleteDevicesForChangedDevices=false" >> /etc/config/crRFD.conf
fi


/sbin/reboot
