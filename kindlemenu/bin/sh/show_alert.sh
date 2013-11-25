#!/bin/sh

# First passed argument is for alert content
ALERTCONTENT="$1"

# Second passed argument is for displaying time. 0 for infinite
TIME="$2"

# Show the alert
MESSAGE='{"pillowId": "../../../../mnt/us/extensions/kindlemenu/bin/kindlemenupage","function":"document.getElementById('"'alert'"').innerHTML='"'$ALERTCONTENT'"';document.getElementById('"'alert'"').style.display='"'block'"';"}'
/usr/bin/lipc-set-prop com.lab126.pillow interrogatePillow "$MESSAGE"

# Hide the alert after TIME seconds
if [ "$TIME" != 0 ];then
sleep "$TIME"
MESSAGE1='{"pillowId": "../../../../mnt/us/extensions/kindlemenu/bin/kindlemenupage","function":"document.getElementById('"'alert'"').style.display='"'none'"';"}'
/usr/bin/lipc-set-prop com.lab126.pillow interrogatePillow "$MESSAGE1"
fi

