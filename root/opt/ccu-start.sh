#!/bin/bash
for i in /etc/init.d/S??*
do
	$i start
done
