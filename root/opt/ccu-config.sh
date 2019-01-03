#!/bin/bash
rm -f /var/status/BIDCOSenable
rm -f /var/status/HMIPlocaldevice
rm -f /var/status/HMIPremserialhost

cp -f /opt/occu/X86_32_Debian_Wheezy/packages-eQ-3/WebUI/etc/config_templates/InterfacesList.xml /etc/config/InterfacesList.xml

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
			/bin/sed -i 's/Adapter.1.Port=\/dev\/ttyS1000/Adapter.1.Port=\/dev\/ttyUSB0/g' /etc/config/crRFD.conf
                else
                        echo "Enter IP Adress of the HmIP-USB-Stick Host (Usually Raspberry Pi):"
                        read HMIPREMOTEIP
                        echo $HMIPREMOTEIP > /var/status/HMIPremserialhost
                        /bin/sed -i 's/Adapter.1.Port=\/dev\/ttyS0/Adapter.1.Port=\/dev\/ttyS1000/g' /etc/config/crRFD.conf
			/bin/sed -i 's/Adapter.1.Port=\/dev\/ttyUSB0/Adapter.1.Port=\/dev\/ttyS1000/g' /etc/config/crRFD.conf

                        echo "Enter the ssh password for root user of your remote device:"
                        mkdir -p /etc/ssl/homematic-socat
                        openssl genrsa -out /etc/ssl/homematic-socat/client.key 4096
                        openssl req -new -key /etc/ssl/homematic-socat/client.key -x509 -days 100000 -subj /C=EN -out /etc/ssl/homematic-socat/client.crt
                        scp /etc/ssl/homematic-socat/client.crt root@$HMIPREMOTEIP:/etc/ssl/homematic-socat/client.crt
                        scp root@$HMIPREMOTEIP:/etc/ssl/homematic-socat/server.crt  /etc/ssl/homematic-socat/server.crt
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
