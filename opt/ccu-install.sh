#!/bin/bash
cp /opt/occu-x86/etc/apt/sources.list.d/linuxuprising-java.list /etc/apt/sources.list.d/

dpkg --add-architecture i386
apt-get update
apt-get dist-upgrade -y
apt-get install dirmngr lighttpd git libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 libusb-1.0.0 curl psmisc socat keyboard-configuration libasound2 wget libasound2-data autoconf libusb-1.0 build-essential msmtp git net-tools usbutils -y
/usr/sbin/update-usbids
dpkg-reconfigure tzdata
dpkg-reconfigure keyboard-configuration
dpkg-reconfigure locales
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 73C3DB2A
apt-get update
apt-get install oracle-java11-installer -y --allow-unauthenticated
apt-get remove postfix --purge -y
apt-get remove x11-common --purge -y
apt-get autoremove  --purge -y

rm /usr/local/* -R
rm /etc/lighttpd/* -R
rm /var/www* -R
rm /var/status/* -R
mkdir /opt/occu/
mkdir /opt/HMServer/
mkdir /firmware/
mkdir /opt/HmIP/
mkdir /www/
mkdir /etc/config/
mkdir /etc/config_templates/
mkdir /etc/config/rfd/
mkdir /var/status/
mkdir /etc/config/hs485d/
mkdir /etc/config/rc.d/
mkdir /usr/local/etc/
mkdir /etc/config/crRFD/
mkdir /etc/config/crRFD/data
cp /opt/occu-x86/* -R /

git clone https://github.com/quickmic/occu.git /opt/occu/
cp /opt/occu/HMserver/opt/HMServer/HMIPServer.jar /opt/HMServer/
cp /opt/occu/HMserver/opt/HMServer/HMServer.jar /opt/HMServer/
cp /opt/occu/WebUI/bin/* -R /bin/
cp /opt/occu/WebUI/www/* -R /www/
cp /opt/occu/firmware/* -R /firmware/
cp /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/HS485D/bin/* -R /bin/
cp /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/HS485D/lib/* -R /lib/
cp /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/LinuxBasis/* -R /
cp /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/RFD/bin/* -R /bin/
cp /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/RFD/lib/* -R /lib/
cp /opt/occu/HMserver/opt/HmIP/* -R /opt/HmIP/
cp /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/RFD/etc/config_templates/rfd.conf -R /etc/config/rfd.conf
cp /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/RFD/etc/config_templates/* -R /etc/config_templates/
cp /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/RFD/etc/crRFD.conf /etc/
cp /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/bin/* -R /bin/
cp /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/lib/* -R /lib/
cp /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/etc/* -R /etc/
cp /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/etc/config_templates/* -R /etc/config/
cp /opt/occu/HMserver/etc/config_templates/log4j.xml /etc/config/
cp /opt/occu/HMserver/opt/HMServer/* -R /opt/HMServer/
cp /opt/occu/X86_32_Debian_Wheezy/packages/lighttpd/etc/lighttpd/* -R /etc/lighttpd/
cp /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI-Beta/bin/* -R /bin/
cp /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI-Beta/lib/* -R /lib/
cp /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/RFD/etc/crRFD.conf /etc/config/crRFD.conf




version=`/usr/bin/git -C /opt/occu/ describe --tags`
echo "VERSION="$version > /VERSION
/bin/sed -i -n '/WEBUI_VERSION = "/{:a;N;/;/!ba;N;s/.*\n/    WEBUI_VERSION = "'$version'";\n\n/};p' /www/rega/pages/index.htm


echo "Enable HMIP? (y/n):"
read HMIP

if [ "$HMIP" = "y" ]
then
    echo "Is HmIP-RFUSB directly plugged to the CCU? (y/n):"
    read HMIPLOCAL

    if [ "$HMIPLOCAL" = "y" ]
    then
        touch /var/status/HMIPlocaldevice
	/bin/sed -i 's/Adapter.1.Port=\/dev\/ttyS0/Adapter.1.Port=\/dev\/ttyUSB0/g' /etc/config/crRFD.conf
    else
        echo "Enter IP Adress of the HmIP-USB-Stick Host (Usually Raspberry Pi):"
        read HMIPREMOTEIP
        echo $HMIPREMOTEIP > /var/status/HMIPremserialhost
	/bin/sed -i 's/Adapter.1.Port=\/dev\/ttyS0/Adapter.1.Port=\/dev\/ttyS1000/g' /etc/config/crRFD.conf
    fi
fi

echo "Enable BidCos? (y/n):"
read BIDCOS

if [ "$BIDCOS" = "y" ]
then
    touch /var/status/BIDCOSenable
fi

echo "Enable cuxd? (y/n):"
read CUXD

if [ "$CUXD" = "y" ]
then
    touch /var/status/CUXDenable
fi

systemctl enable ccu

