#!/bin/sh
SSSTATE=`lipc-get-prop com.lab126.powerd preventScreenSaver`
lipc-set-prop com.lab126.powerd preventScreenSaver 0
/usr/bin/xtestlab126 &
( dbus-monitor "interface='com.lab126.powerd',member='goingToScreenSaver'" --system; sleep 2;  killall xtestlab126; lipc-set-prop com.lab126.powerd powerButton 1; lipc-set-prop com.lab126.powerd preventScreenSaver "$SSSTATE" ) &
usleep 50000
killall -INT dbus-monitor

