#!/bin/bash
rm -f /var/status/BIDCOSenable
rm -f /var/status/HMIPlocaldevice
rm -f /var/status/HMIPremserialhost
rm -f /var/status/HMIPenabled

cp -f /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/etc/config_templates/InterfacesList.xml /etc/config/
cp -f /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/RFD/etc/config_templates/rfd.conf /etc/config/
cp -f /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/RFD/etc/config_templates/multimacd.conf /etc/config/
cp -f /opt/occu-x86/root/etc/init.d/S60multimacd /etc/init.d/

patch --forward -d / -p0 < /opt/occu-x86/patches/1017-multimacd.patch
patch --forward -d / -p0 < /opt/occu-x86/patches/1002-rfd-interface.patch

#Check if running in lxc container
if ! grep lxc /proc/1/environ -qa
then
        while true
        do
                read -r -p "Are you using a HB-RF-USB interface? (y/n): " HBRFUSB

                if [ "$HBRFUSB" = "y" ]
                then
                        apt-get install build-essential -y
                        apt-get -t stretch-backports install linux-image-amd64 -y
                        apt-get -t stretch-backports install linux-headers-amd64 -y
                        /opt/occu-x86/kernel-modules/compile.sh
                        break
                elif [ "$HBRFUSB" = "n" ]
                then
                        rm /etc/config/multimacd.conf
                        rm /etc/init.d/S60multimacd
                        break
                fi
        done
fi

while true
do
        read -r -p "Enable HMIP? (y/n): " HMIP

        if [ "$HMIP" = "y" ]
        then
                if [ "$HBRFUSB" = "y" ]
                then
                        echo "mmd_hmip" > /var/status/HMIPenabled
                        /bin/sed -i 's/Adapter.1.Port=\/dev\/ttyS0/Adapter.1.Port=\/dev\/mmd_hmip/g' /etc/config/crRFD.conf
                else
                        echo "ttyUSB0" > /var/status/HMIPenabled
                        /bin/sed -i 's/Adapter.1.Port=\/dev\/ttyS0/Adapter.1.Port=\/dev\/ttyUSB0/g' /etc/config/crRFD.conf
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
                if [ "$HBRFUSB" = "y" ]
                then
                        echo "mmd_bidcos" > /var/status/BIDCOSenable
                        echo "[Interface 0]" >> /etc/config/rfd.conf
                        echo "Type = CCU2" >> /etc/config/rfd.conf
                        echo "ComPortFile = /dev/mmd_bidcos" >> /etc/config/rfd.conf
                        echo "AccessFile = /dev/null" >> /etc/config/rfd.conf
                        echo "ResetFile = /dev/null" >> /etc/config/rfd.conf
                else
                        echo "gateways" > /var/status/BIDCOSenable
                fi

                break
        elif [ "$BIDCOS" = "n" ]
        then
                /bin/sed -i '/<ipc>/{:a;N;/<\/ipc>/!ba};/<name>BidCos-RF<\/name>/d' /etc/config/InterfacesList.xml
                break
        fi
done
