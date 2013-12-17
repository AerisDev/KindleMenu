#!/bin/sh
SSSTATE=`lipc-get-prop com.lab126.powerd preventScreenSaver`
lipc-set-prop com.lab126.powerd preventScreenSaver 0
/usr/bin/xtestlab126 &

( lipc-wait-event com.lab126.powerd goingToScreenSaver; powerd_test -h ; powerd_test -p & killall xtestlab126 & lipc-set-prop com.lab126.powerd preventScreenSaver "$SSSTATE" & ) &


