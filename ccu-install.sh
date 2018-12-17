#!/bin/bash
cp /opt/occu-x86/root/etc/apt/sources.list.d/linuxuprising-java.list /etc/apt/sources.list.d/

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
cp /opt/occu-x86/root/* -R /

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
else
	/bin/sed -i '/<ipc>/{:a;N;/<\/ipc>/!ba};/<name>HmIP-RF<\/name>/d' /etc/config/InterfacesList.xml
fi

echo "Enable BidCos? (y/n):"
read BIDCOS

if [ "$BIDCOS" = "y" ]
then
	touch /var/status/BIDCOSenable
else
	/bin/sed -i '/<ipc>/{:a;N;/<\/ipc>/!ba};/<name>BidCos-RF<\/name>/d' /etc/config/InterfacesList.xml
fi

echo "Install cuxd? (y/n):"
read CUXD

if [ "$CUXD" = "y" ]
then
	touch /var/status/CUXDenable
	/bin/sed -i 's/<\/interfaces>//g' /etc/config/InterfacesList.xml
	echo "        <ipc>" >> /etc/config/InterfacesList.xml
	echo "                <name>CUxD</name>" >> /etc/config/InterfacesList.xml
	echo "                <url>xmlrpc_bin://127.0.0.1:8701</url>" >> /etc/config/InterfacesList.xml
	echo "                <info>CUxD</info>" >> /etc/config/InterfacesList.xml
	echo "        </ipc>" >> /etc/config/InterfacesList.xml
	echo "</interfaces>" >> /etc/config/InterfacesList.xml
	/bin/update_addon cuxd /etc/config/addons/www/cuxd/cuxd_addon.cfg
else
	rm /etc/config/rc.d/cuxdaemon
fi

echo "Install email? (y/n):"
read EMAIL

if [ "$EMAIL" = "y" ]
then
	mkdir /opt/hm_email
	git clone https://github.com/jens-maus/hm_email /opt/hm_email/
	chmod 777 /etc/config/rc.d/email
	mkdir /www/addons/email
	cp /opt/hm_email/www/* -R /www/addons/email/
	chmod 755 /www/addons/email/
	mkdir /etc/config/addons/email
	cp /opt/hm_email/addon/* -R /etc/config/addons/email/
	chmod 755 /etc/config/addons/email
	cp /opt/hm_email/userscript.tcl /etc/config/addons/email/
	cp /opt/hm_email/account.conf /etc/config/addons/email/
	cp /opt/hm_email/msmtp.conf /etc/config/addons/email/
	cp -af /opt/hm_email/mails /etc/config/addons/email/
	cp /opt/hm_email/mails/log.mail /etc/config/addons/email/mails/log.mail
	cp /opt/hm_email/mails/cam.mail /etc/config/addons/email/mails/cam.mail
	cp -af /opt/hm_email/ccurm/* /etc/config/addons/email/
	cp /opt/hm_email/VERSION /etc/config/addons/email/
	/bin/update_addon email /etc/config/addons/email/hm_email-addon.cfg
else
	rm /etc/config/rc.d/email
fi

echo "Install xml-api? (y/n):"
read XMLAPI

if [ "$XMLAPI" = "y" ]
then
	mkdir /opt/xmlapi/
	git clone https://github.com/hobbyquaker/XML-API /opt/xmlapi/
	mkdir /www/addons/xmlapi/
	cp -r /opt/xmlapi//xmlapi/* /www/addons/xmlapi/
	cp /opt/xmlapi/VERSION /www/addons/xmlapi/
	chmod 777 /etc/config/rc.d/xml-api
else
	rm /etc/config/rc.d/xml-api
fi

systemctl enable ccu

