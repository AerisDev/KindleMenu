#!/bin/bash

cd /mnt/us/extensions/usbnet
/mnt/us/extensions/usbnet/bin/usbnet.sh toggle_usbnet
sleep 1
/mnt/us/extensions/kindlemenu/bin/sh/usbnet.sh usbnet_status


