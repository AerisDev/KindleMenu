#!/bin/sh
cd /mnt/us/extensions/kindletask/bin/html/

# Check if the process is still in memory...
ps o "pmem" -p "$1"
if [ "$?" != 0 ];then echo "<b>Process not found!</b><br /><br />It committed suicide while KindleTask was loading... R.I.P. ✞</div></body></html>" > info.txt; cat info_PART1.html info.txt > info.html; rm info.txt; lipc-set-prop com.lab126.pillow customDialog '{"name": "../../../../mnt/us/extensions/kindletask/bin/html/info", "clientParams": {"dismiss": true}}' &
return 1
fi

# If yes, display its details
ps o "<b>PID:</b> %p <br/><b>PPID:</b> %P <br/><b>USER:</b> %U <br/><b>NICE:</b> %n <br/><b>VSZ:</b> %z <br/><b>TTY:</b> %y<br/><b>CPU TIME:</b> %x <br/><b>CPU:</b> %C " -p "$1" --no-headers > /mnt/us/extensions/kindletask/bin/html/info.txt
echo "%<br /><b>MEMORY:</b> " >> info.txt
ps o "pmem" -p "$1" --no-headers >> info.txt
echo " %" >> info.txt
echo '</div></body></html>' >> info.txt

# Build the page
cat info_PART1.html info.txt > info.html

rm info.txt

# Launch the dialog
lipc-set-prop com.lab126.pillow customDialog '{"name": "../../../../mnt/us/extensions/kindletask/bin/html/info", "clientParams": {"dismiss": true}}' &
