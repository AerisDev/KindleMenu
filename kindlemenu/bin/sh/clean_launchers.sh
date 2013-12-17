#!/bin/sh

# if Kindle Touch, disable light tray buttons
PLATFORM="$(cat /sys/devices/platform/mxc_epdc_fb/graphics/fb0/modes)"

if [ "$PLATFORM" = "${PLATFORM/758/}" ]; then
MESSAGE='{"pillowId": "../../../../mnt/us/extensions/kindlemenu/bin/kindlemenupage","function":"document.getElementById('"'light_toogle'"').style.display='"'none'"';document.getElementById('"'light_bars'"').style.display='"'none'"';"}'
/usr/bin/lipc-set-prop com.lab126.pillow interrogatePillow "$MESSAGE" &
fi

# if Midori is not installed, hide the launcher
if [ ! -f "/mnt/us/extensions/midori/config.xml" ];then
MESSAGE='{"pillowId": "../../../../mnt/us/extensions/kindlemenu/bin/kindlemenupage","function":"document.getElementById('"'midori'"').style.display='"'none'"';"}'
/usr/bin/lipc-set-prop com.lab126.pillow interrogatePillow "$MESSAGE" &
fi

# if Koreader is not installed, hide the launcher
if [ ! -f "/mnt/us/koreader/koreader.sh" ];then
MESSAGE='{"pillowId": "../../../../mnt/us/extensions/kindlemenu/bin/kindlemenupage","function":"document.getElementById('"'koreader'"').style.display='"'none'"';"}'
/usr/bin/lipc-set-prop com.lab126.pillow interrogatePillow "$MESSAGE" &
fi
