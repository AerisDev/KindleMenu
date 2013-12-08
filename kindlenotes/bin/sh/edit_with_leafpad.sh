#!/bin/sh

cd /mnt/us/extensions/kindlenotes/bin/html/

# Get note number from active kindlenote.html file number
notenumber=$(ls kindlenotes*.html | sed -e s/[^0-9]//g)

# Dismiss the window
MESSAGE='{"pillowId": "../../../../mnt/us/extensions/kindlenotes/bin/html/kindlenotes'"$notenumber"'","function":"nativeBridge.hideKb();nativeBridge.dismissMe();"}'
lipc-set-prop com.lab126.pillow interrogatePillow "$MESSAGE"

FIRST='{"name": "../../../../mnt/us/extensions/kindlenotes/bin/html/kindlenotes'
SECOND='", "clientParams": {"dismiss": true}}'
lipc-set-prop com.lab126.pillow customDialog "$FIRST""$notenumber""$SECOND"

# Launch Leafpad
/mnt/us/extensions/leafpad/bin/leafpad /mnt/us/extensions/kindlenotes/bin/notes/note"$notenumber".txt

