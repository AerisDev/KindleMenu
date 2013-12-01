#!/bin/sh


# If the reminder.txt file doesn't exist, generate it it
if [ ! -f "/mnt/us/extensions/kindlereminder/bin/reminder/reminder.txt" ];then
	echo '{"text":"Sample TODO","done":false},{"text":"Sample TODO checked","done":true}' > /mnt/us/extensions/kindlereminder/bin/reminder/reminder.txt;
fi


# Build up the page
cp /mnt/us/extensions/kindlereminder/bin/reminder/reminder.txt /mnt/us/extensions/kindlereminder/bin/js/reminder.js
cd /mnt/us/extensions/kindlereminder/bin/js/
cat todo_PART1.js reminder.js todo_PART2.js > todo.js

# Launch the dialog
lipc-set-prop com.lab126.pillow customDialog '{"name": "../../../../mnt/us/extensions/kindlereminder/bin/kindlereminder", "clientParams": {"dismiss": true}}' &


