#!/bin/sh
if [ "$(devcap-get-feature -a frontlight)" -eq "1" ]
then
  FL="/sys/devices/system/fl_tps6116x/fl_tps6116x0/fl_intensity"
  if [ `head -n 1 $FL | sed s/[^0-9]//g` -eq "0" ]
  then
    FLINT=`lipc-get-prop com.lab126.powerd flIntensity`
    lipc-set-prop com.lab126.powerd flIntensity $FLINT &&
    (killall show_alert.sh; /mnt/us/extensions/kindlemenu/bin/sh/show_alert.sh "Light turned ON." 3 &)

  else
    echo -n 0 > $FL &&
    (killall show_alert.sh; /mnt/us/extensions/kindlemenu/bin/sh/show_alert.sh "Light turned OFF." 3 &)
  fi
fi
