#!/bin/bash
rm -f /var/status/BIDCOSenable
rm -f /var/status/HMIPlocaldevice
rm -f /var/status/HMIPremserialhost
rm -f /var/status/HMIPenabled

cp -f /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/etc/config_templates/InterfacesList.xml /etc/config/InterfacesList.xml

while true
do
        read -r -p "Enable HMIP? (y/n): " HMIP

        if [ "$HMIP" = "y" ]
        then
                echo "ttyUSB0" > /var/status/HMIPenabled
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
