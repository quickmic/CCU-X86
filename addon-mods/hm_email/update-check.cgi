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
	catch {exec cp /opt/hm_email/www/* -R /www/addons/email/}
	catch {exec chmod 755 /www/addons/email/}
	catch {exec cp /opt/hm_email/addon/* -R /etc/config/addons/email/}
	catch {exec cp /opt/hm_email/account.conf /etc/config/addons/email/}
	catch {exec cp /opt/hm_email/msmtp.conf /etc/config/addons/email/}
	catch {exec cp -af /opt/hm_email/mails /etc/config/addons/email/}
	catch {exec cp /opt/hm_email/mails/log.mail /etc/config/addons/email/mails/log.mail}
	catch {exec cp /opt/hm_email/mails/cam.mail /etc/config/addons/email/mails/cam.mail}
	catch {exec cp -af /opt/hm_email/ccurm/* /etc/config/addons/email/}
	catch {exec cp /opt/hm_email/VERSION /etc/config/addons/email/}
	catch {exec /sbin/reboot}
} else {
	puts [ exec cat /etc/config/addons/email/versionUpdate ]
}
