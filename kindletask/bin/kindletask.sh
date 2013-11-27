#!/bin/sh

cd /mnt/us/extensions/kindletask/bin/html/

ps axo "<span>%p</span>%a" --no-headers --sort -pid > tasklist.txt
# Remove first two lines, ./kindletask.sh and ps commands
tail -n +3 "tasklist.txt" > tasklist2.txt
# Parse the list
sed -e 's/^/\<div class="task" onclick="select(this)" \>/' -e 's/$/\<\/div>/' -i tasklist2.txt

cat kindletask_PART1.html tasklist2.txt kindletask_PART2.html > kindletask.html

lipc-set-prop com.lab126.pillow customDialog '{"name": "../../../../mnt/us/extensions/kindletask/bin/html/kindletask", "clientParams": {"dismiss": true}}' &

rm tasklist.txt tasklist2.txt



