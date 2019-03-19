#! /bin/bash
grep vmlinuz- /boot/grub/grub.cfg | head -1 | awk '{print $2}' | sed 's/\/boot\/vmlinuz-//g' > /tmp/kernel.txt
cd /opt/occu-x86/kernel-modules/
make
rm /opt/occu-x86/kernel-modules/*.o
rm /opt/occu-x86/kernel-modules/*.mod.c
rm /opt/occu-x86/kernel-modules/modules.order
rm /opt/occu-x86/kernel-modules/Module.symvers
rm /opt/occu-x86/kernel-modules/.tmp_versions/*
rmdir /opt/occu-x86/kernel-modules/.tmp_versions/
rm /opt/occu-x86/kernel-modules/.*
KernelVersion=`cat /tmp/kernel.txt`
mv /opt/occu-x86/kernel-modules/*.ko /lib/modules/$KernelVersion/
depmod $KernelVersion
