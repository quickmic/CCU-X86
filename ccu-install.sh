#!/bin/bash
cp /opt/occu-x86/root/etc/apt/sources.list.d/linuxuprising-java.list /etc/apt/sources.list.d/

dpkg --add-architecture i386
apt-get update
apt-get dist-upgrade -y
apt-get install etherwake digitemp u-boot-tools dirmngr lighttpd git libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 libusb-1.0.0:i386 libusb-1.0.0 curl psmisc socat keyboard-configuration libasound2 wget libasound2-data autoconf libusb-1.0 build-essential msmtp git net-tools usbutils -y
/usr/sbin/update-usbids
dpkg-reconfigure tzdata
dpkg-reconfigure keyboard-configuration
locale-gen
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
mkdir /www/config/
mkdir /etc/config/
mkdir /etc/config_templates/
mkdir /etc/config/rfd/
mkdir /var/status/
mkdir /etc/config/hs485d/
mkdir /etc/config/rc.d/
mkdir /usr/local/etc/
mkdir /etc/config/crRFD/
mkdir /etc/config/crRFD/data
mkdir /usr/local/tmp/
chmod 775 /etc/config
mkdir /etc/config/addons/
mkdir /etc/config/addons/www/
mkdir /opt/java/
mkdir /opt/java/bin/

ln -s $(which java) /opt/java/bin/

mkdir /var/tmp
chmod 775 /var/tmp
mkdir /var/rega
chmod 775 /var/rega
mkdir /var/run
chmod 775 /var/run
mkdir /var/spool
chmod 775 /var/spool
mkdir /var/lock
chmod 775 /var/lock
mkdir /var/cache
chmod 775 /var/cache
mkdir /var/lib
chmod 775 /var/lib
mkdir /var/lib/misc
chmod 775 /var/lib/misc
mkdir /var/lib/dbus
chmod 775 /var/lib/dbus
mkdir /var/empty
chmod 600 /var/empty
mkdir /var/etc
chmod 775 /var/etc
mkdir /var/status
chmod 775 /var/status



cp -rf /opt/occu-x86/root/* /

git clone https://github.com/quickmic/occu.git /opt/occu/
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
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/RFD/etc/config_templates/rfd.conf /etc/config/rfd.conf
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/RFD/etc/config_templates/* /etc/config_templates/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/bin/* /bin/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/lib/* /lib/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/etc/* /etc/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/etc/config_templates/* /etc/config/
cp /opt/occu/HMserver/etc/config_templates/log4j.xml /etc/config/
cp -rf /opt/occu/HMserver/opt/HMServer/* /opt/HMServer/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages/lighttpd/etc/lighttpd/* /etc/lighttpd/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI-Beta/bin/* /bin/
cp -rf /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI-Beta/lib/* /lib/
cp /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/RFD/etc/crRFD.conf /etc/config/crRFD.conf

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

while true
do
	read -r -p "Enable HMIP? (y/n): " HMIP

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

			echo "Enter the ssh password for root user of your rmote device:"
			mkdir /etc/ssl/homematic-socat
			openssl genrsa -out /etc/ssl/homematic-socat/client.key 4096
			openssl req -new -key /etc/ssl/homematic-socat/client.key -x509 -days 100000 -subj /C=EN -out /etc/ssl/homematic-socat/client.crt
			scp /etc/ssl/homematic-socat/client.crt root@192.168.0.107:/etc/ssl/homematic-socat/client.crt
			scp root@192.168.0.107:/etc/ssl/homematic-socat/server.crt  /etc/ssl/homematic-socat/server.crt
		fi

		break
	elif [ "$HMIP" = "n" ]
	then
		/bin/sed -i '/<ipc>/{:a;N;/<\/ipc>/!ba};/<name>HmIP-RF<\/name>/d' /etc/config/InterfacesList.xml
		break
	fi
done

while true
do
	read -r -p  "Enable BidCos? (y/n): " BIDCOS

	if [ "$BIDCOS" = "y" ]
	then
		touch /var/status/BIDCOSenable
		break
	elif [ "$BIDCOS" = "n" ]
	then
		/bin/sed -i '/<ipc>/{:a;N;/<\/ipc>/!ba};/<name>BidCos-RF<\/name>/d' /etc/config/InterfacesList.xml
		break
	fi
done

systemctl enable ccu

#Apply patches
for f in /opt/occu-x86/patches/0*
do
	patch -d / -p0 < $f
done

while true
do
        read -r -p  "Install extented features? (y/n): " EXTFEATURES

        if [ "$EXTFEATURES" = "y" ]
        then
		for f in /opt/occu-x86/patches/1*
		do
		        patch -d / -p0 < $f
			touch /var/status/ExtendedFeatures
		done


		break
        elif [ "$EXTFEATURES" = "n" ]
        then
                break
        fi
done

#reboot
