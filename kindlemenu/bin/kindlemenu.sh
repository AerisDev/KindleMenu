#!/bin/sh



# Launch Kindle Menu html page
lipc-set-prop com.lab126.pillow customDialog '{"name": "../../../../mnt/us/extensions/kindlemenu/bin/kindlemenupage", "clientParams": {"dismiss": true}}' &


# kill already running clean_launchers.sh processes, if any
killall clean_launchers.sh

# If Kindle Touch, disable light tray buttons. Disable also
# launcher of Midori and KOreader, if not installed
/mnt/us/extensions/kindlemenu/bin/sh/clean_launchers.sh &

