#!/bin/sh
init_orientation=`/usr/bin/lipc-get-prop com.lab126.winmgr orientationLock`
/usr/bin/lipc-set-prop com.lab126.winmgr orientationLock U
SSSTATE=`lipc-get-prop com.lab126.powerd preventScreenSaver`
lipc-set-prop com.lab126.powerd preventScreenSaver 0
/mnt/us/extensions/kindlemenu/bin/sh/keepalive.sh &
/usr/bin/xtestlab126 &
( dbus-monitor "interface='com.lab126.powerd',member='goingToScreenSaver'" --system;  killall keepalive.sh; killall xtestlab126; lipc-set-prop com.lab126.powerd powerButton 1; lipc-set-prop com.lab126.powerd preventScreenSaver "$SSSTATE" ) &
usleep 50000
killall -INT dbus-monitor
/usr/bin/lipc-set-prop com.lab126.winmgr orientationLock ${init_orientation}

