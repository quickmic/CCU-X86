#!/bin/tclsh

catch {
  set input $env(QUERY_STRING)
  set pairs [split $input &]
  foreach pair $pairs {
    if {0 != [regexp "^(\[^=]*)=(.*)$" $pair dummy varname val]} {
      set $varname $val
    }
  }
}

if { [info exists cmd ] && $cmd == "download"} {
#	catch {exec cp /opt/hm_email/www/* -R /www/addons/email/}
#	catch {exec chmod 755 /www/addons/email/}
#	catch {exec cp /opt/hm_email/addon/* -R /etc/config/addons/email/}
#	catch {exec cp /opt/hm_email/account.conf /etc/config/addons/email/}
#	catch {exec cp /opt/hm_email/msmtp.conf /etc/config/addons/email/}
#	catch {exec cp -af /opt/hm_email/mails /etc/config/addons/email/}
#	catch {exec cp /opt/hm_email/mails/log.mail /etc/config/addons/email/mails/log.mail}
#	catch {exec cp /opt/hm_email/mails/cam.mail /etc/config/addons/email/mails/cam.mail}
#	catch {exec cp -af /opt/hm_email/ccurm/* /etc/config/addons/email/}
#	catch {exec cp /opt/hm_email/VERSION /etc/config/addons/email/}

	catch {exec rm -f /etc/config/addons/cuxd/fw.tar.gz}
	catch {exec rm -f /etc/config/addons/cuxd/*.ko}
	catch {exec rm -f /etc/config/addons/cuxd/lib*.so*}
	catch {exec rm -f /etc/config/addons/cuxd/*.ccc}
	catch {exec rm -f /etc/config/addons/cuxd/hm_addons.cfg.*}
	catch {exec rm -f /etc/config/addons/cuxd/cuxd_addon.cfg}
	catch {exec rm -f /etc/config/addons/cuxd/extra/curl}
	catch {exec rm -f /etc/config/addons/cuxd/extra/socat}
	catch {exec rm -f /etc/config/addons/cuxd/libusb-1.0.*}
	catch {exec rm -f /etc/config/addons/cuxd/cuxd}
	catch {exec rm -f /etc/config/addons/cuxd/cuxd.dbg}
	catch {exec ln -sf /etc/config/addons/cuxd /etc/config/addons/www/cuxd}
	catch {exec cp -af /etc/config/addons/cuxd/cuxd.ps /etc/config/addons/cuxd/cuxd.ps.old}
	catch {exec cp -af /opt/cuxd/ccu_x86_32/cuxd/* /etc/config/addons/cuxd/}
	catch {exec cp -af /opt/cuxd/common/cuxd/* -R /etc/config/addons/cuxd/}
	catch {exec ln -s /bin/dfu-programmer /etc/config/addons/cuxd/}
	catch {exec ln -s /usr/bin/curl /etc/config/addons/cuxd/extra/}
	catch {exec ln -s /usr/bin/socat /etc/config/addons/cuxd/extra/}
	catch {exec ln -s /usr/sbin/etherwake /etc/config/addons/cuxd/extra/ether-wake}
	catch {exec ln -s /usr/bin/digitemp_DS9097U /etc/config/addons/cuxd/extra/}
	catch {exec cp /opt/occu-x86/addon-mods/cuxd/cuxdaemon /etc/config/rc.d/}
	catch {exec cp /opt/occu-x86/addon-mods/cuxd/cuxd.ini /etc/config/addons/cuxd/cuxd.ini}
	#catch {exec versionCUXD=`git -C /opt/cuxd/ describe --tags`}
	catch {exec echo $versionCUXD > /etc/config/addons/cuxd/VERSION}
	catch {exec /sbin/reboot}
} else {
	puts [ exec cat /etc/config/addons/cuxd/versionUpdate ]
}
