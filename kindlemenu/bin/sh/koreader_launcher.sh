#!/bin/sh
sleep 12
/mnt/us/koreader/koreader.sh /mnt/us/documents
# wait the script to finish, i.e. until koreader closes
wait
# sleep a while until chrome bar is displayed again
sleep 4
/mnt/us/extensions/kindlemenu/bin/sh/batterylevel.sh
/mnt/us/extensions/kindlemenu/bin/shortcut.sh


