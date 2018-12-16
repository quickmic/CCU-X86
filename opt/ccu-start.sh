#!/bin/bash
rm /var/tmp/*
rm /var/status/HMServerStarted
#/bin/eq3configd &
/bin/hs485dLoader -l 0 -ds -dd /etc/config/hs485d.conf -ilp /etc/config/InterfacesList.xml #Updates Wired Interfaces




/var/remserial/remserial -d -r 192.168.0.107 -p 23000 -l /dev/ttyUSB2 /dev/ptmx &




for i in $(seq 1 60)
do
        sleep 1
        PID=`pidof remserial`
        if [[ ${PID} != "" ]]
        then
                break
        fi
done
/bin/hs485dLoader -dw /etc/config/hs485d.conf &
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
#sleep 10
#/usr/bin/java -server -Xms1024m -Xmx1024m -Dlog4j.configuration=file:///etc/config/log4j.xml -Dfile.encoding=ISO-8859-1 -jar /opt/HMServer/HMIPServer.jar /etc/config/crRFD.conf &

/usr/bin/java -Dlog4j.configuration=file:///etc/config/log4j.xml -jar /opt/HMServer/HMIPServer.jar /etc/config/crRFD.conf &

for i in $(seq 1 120)
do
        sleep 1
        if [[ -e /var/status/HMServerStarted ]]
        then
                break
        fi
done

/bin/ReGaHss.community -f /etc/config/rega.conf -l 2 &
for i in $(seq 1 60)
do
        sleep 1
        PID=`pidof ReGaHss`
        if [[ ${PID} != "" ]]
        then
                break
        fi
done
