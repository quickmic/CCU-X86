#!/bin/tclsh
source once.tcl
sourceOnce common.tcl

cgi_eval {
    division {class="popupTitle j_translate"} {
        puts "CCU update in progress, rebooting..."
    }

    cgi_javascript {
        puts {
          translatePage('#messagebox');
        }
    }

    exec /opt/ccu-update.sh
}


