#!/bin/bash

dpkg --add-architecture i386
cp /opt/occu-x86/root/etc/apt/sources.list.d/* /etc/apt/sources.list.d/
apt-get update
apt-get install apt-transport-https -y
apt-get install gnupg -y
wget https://www.debmatic.de/debmatic/public.key -O /tmp/debmatic-public.key
apt-key add /tmp/debmatic-public.key
apt-get update
apt-get dist-upgrade -y
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

/usr/sbin/update-usbids
dpkg-reconfigure tzdata
dpkg-reconfigure keyboard-configuration
locale-gen

apt-get remove postfix --purge -y
apt-get autoremove  --purge -y

rm -rf /usr/local/*
rm -rf /etc/lighttpd/*
rm -rf /var/www*
rm -rf /var/status/*
mkdir -p /opt/occu/
mkdir -p /opt/HMServer/
mkdir -p /firmware/
mkdir -p /opt/HmIP/
mkdir -p /www/config/
mkdir -p /etc/config/
mkdir -p /etc/config/firmware/
mkdir -p /etc/config/rfd/
mkdir -p /var/status/
mkdir -p /etc/config/hs485d/
mkdir -p /etc/config/rc.d/
mkdir -p /usr/local/etc/
mkdir -p /etc/config/crRFD/data
mkdir -p /usr/local/tmp/
chmod 775 /etc/config
mkdir -p /etc/config/addons/www/
mkdir -p /opt/java/bin/

ln -s $(which java) /opt/java/bin/

mkdir -p /var/tmp
chmod 775 /var/tmp
mkdir -p /var/rega
chmod 775 /var/rega
mkdir -p /var/run
chmod 775 /var/run
mkdir -p /var/spool
chmod 775 /var/spool
mkdir -p /var/lock
chmod 775 /var/lock
mkdir -p /var/cache
chmod 775 /var/cache
mkdir -p /var/lib
chmod 775 /var/lib
mkdir -p /var/lib/misc
chmod 775 /var/lib/misc
mkdir -p /var/lib/dbus
chmod 775 /var/lib/dbus
mkdir -p /var/empty
chmod 600 /var/empty
mkdir -p /var/etc
chmod 775 /var/etc
mkdir -p /var/status
chmod 775 /var/status

mkdir -p /etc/ssl/homematic-webui
openssl genrsa -out /etc/ssl/homematic-webui/lighttpd.key 4096
openssl req -new -key /etc/ssl/homematic-webui/lighttpd.key -x509 -days 100000 -subj /C=EN -out /etc/ssl/homematic-webui/lighttpd.crt
cat /etc/ssl/homematic-webui/lighttpd.key /etc/ssl/homematic-webui/lighttpd.crt > /etc/ssl/homematic-webui/lighttpd.pem

mkdir -p /etc/ssl/homematic-socat
openssl genrsa -out /etc/ssl/homematic-socat/client.key 4096
openssl req -new -key /etc/ssl/homematic-socat/client.key -x509 -days 100000 -subj /C=EN -out /etc/ssl/homematic-socat/client.crt

cp -rf /opt/occu-x86/root/* /

git clone https://github.com/quickmic/occu.git /opt/occu/
cp -f /opt/occu/HMserver/opt/HMServer/HMIPServer.jar /opt/HMServer/
cp -f /opt/occu/HMserver/opt/HMServer/HMServer.jar /opt/HMServer/
cp -rf /opt/occu/WebUI/bin/* /bin/
cp -rf /opt/occu/WebUI/www/* /www/
cp -rf /opt/occu/firmware/* /firmware/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/HS485D/bin/* /bin/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/HS485D/lib/*  /lib/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/LinuxBasis/* /
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/RFD/bin/* /bin/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/RFD/lib/* /lib/
cp -rf /opt/occu/HMserver/opt/HmIP/* /opt/HmIP/
cp -f /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/RFD/etc/config_templates/rfd.conf /etc/config/
cp -f /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/RFD/etc/config_templates/multimacd.conf /etc/config/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/bin/* /bin/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/lib/* /lib/
cp -f /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/etc/* /etc/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/etc/config/* /etc/config/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/etc/config_templates/* /etc/config/
cp -f /opt/occu/HMserver/etc/config_templates/log4j.xml /etc/config/
cp -rf /opt/occu/HMserver/opt/HMServer/* /opt/HMServer/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages/lighttpd/etc/lighttpd/* /etc/lighttpd/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI-Beta/bin/* /bin/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI-Beta/lib/* /lib/
cp -f /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/RFD/etc/crRFD.conf /etc/config/crRFD.conf

versionOCCU=`/usr/bin/git -C /opt/occu/ describe --tags`
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

#Apply patches
for f in /opt/occu-x86/patches/*
do
        patch -d / -p0 < $f
done

rm -f /etc/lighttpd/lighttpd_ssl.conf
systemctl enable ccu

/opt/ccu-config.sh
reboot
