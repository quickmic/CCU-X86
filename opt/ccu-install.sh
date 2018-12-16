#!/bin/bash
echo "Enable HMIP? (y/n):"
read HMIP

if [ "$HMIP" = "y" ]
then
    echo "Is HmIP-RFUSB directly plugged to the CCU? (y/n):"
    read HMIPLOCAL
    
    if [ "$HMIPLOCAL" = "y" ]
    then
        echo "/dev/ttyUSB0" > /var/status/HMIPlocaldevice
    else
        echo "Enter IP Adress of the HmIP-USB-Stick Host (Usually Raspberry Pi):"
        read HMIPREMOTEIP
        echo $HMIPREMOTEIP > /var/status/HMIPremserialhost
    fi
fi

echo "Enable BidCos? (y/n):"
read BIDCOS

if [ "$BIDCOS" = "y" ]
then
    touch /var/status/HMIPlocaldevice
fi

echo "Enable cuxd? (y/n):"
read CUXD

if [ "$CUXD" = "y" ]
then
    touch /var/status/CUXDenable
fi

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

rm /usr/local/* -R
rm /etc/lighttpd/* -R
rm /var/www* -R
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
mkdir /etc/config/addons/
mkdir /www/addons/
mkdir /etc/config/rc.d/
mkdir /usr/local/etc/
mkdir /etc/config/crRFD/
mkdir /etc/config/crRFD/data

git clone https://github.com/quickmic/occu.git /opt/occu/
