#!/bin/bash
rm /var/tmp/*
rm /var/status/HMServerStarted
#/bin/eq3configd &
/bin/hs485dLoader -l 0 -ds -dd /etc/config/hs485d.conf -ilp /etc/config/InterfacesList.xml #Updates Wired Interfaces



if [ -f /var/status/HMIPremserialhost ]
then
	value=`cat /var/status/HMIPremserialhost`
	/usr/bin/remserial -d -r $value -p 23000 -l /dev/ttyS1000 /dev/ptmx &

	for i in $(seq 1 60)
	do
        	sleep 1
	        PID=`pidof remserial`
        	if [[ ${PID} != "" ]]
	        then
                	break
        	fi
	done
fi

if [ -f /var/status/HMIPlocaldevice ]
then
	modprobe cp210x
	sh -c 'echo 1b1f c020 > /sys/bus/usb-serial/drivers/cp210x/new_id'
fi

/bin/hs485dLoader -dw /etc/config/hs485d.conf &

if [ -f /var/status/BIDCOSenable ]
then
	/bin/rfd -d -f /etc/config/rfd.conf -l 2 &

	for i in $(seq 1 60)
	do
        	sleep 1
	        PID=`pidof rfd`
        	if [[ ${PID} != "" ]]
	        then
                	break
        	fi
	done
fi

if [ -f /var/status/CUXDenable ]
then
	/www/addons/cuxd/cuxd &

	for i in $(seq 1 60)
	do
        	sleep 1
	        PID=`pidof cuxd`
        	if [[ ${PID} != "" ]]
	        then
        	        break
	        fi
	done
fi

if [ -f /var/status/HMIPremserialhost ] || [ -f /var/status/HMIPlocaldevice ]
then
	/usr/bin/java -Xmx128m -Dlog4j.configuration=file:///etc/config/log4j.xml -jar /opt/HMServer/HMIPServer.jar /etc/config/crRFD.conf &
else
	/usr/bin/java -Xmx128m -Dlog4j.configuration=file:///etc/config/log4j.xml -Dfile.encoding=ISO-8859-1 -jar /opt/HMServer/HMServer.jar &
fi

for i in $(seq 1 120)
do
        sleep 1
        if [[ -e /var/status/HMServerStarted ]]
        then
                break
        fi
done

/bin/ReGaHss.community -f /etc/rega.conf -l 2 &
for i in $(seq 1 60)
do
        sleep 1
        PID=`pidof ReGaHss`
        if [[ ${PID} != "" ]]
        then
                break
        fi
done
