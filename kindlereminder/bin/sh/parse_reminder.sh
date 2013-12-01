#!/bin/sh


cd /mnt/us/extensions/kindlereminder/bin/reminder/

# Parse the reminder
sed 's/'`echo -e "\001"`'/\n/g' reminder.txt > exportedreminder1.txt &&
sed "s/"`echo -e '\002'`"/'/g" exportedreminder1.txt > exportedreminder2.txt &&
sed 's/'`echo -e "\003"`'/"/g' exportedreminder2.txt > exportedreminder3.txt &&
sed 's/'`echo -e "\004"`'/$/g' exportedreminder3.txt > exportedreminder4.txt &&
sed '1s/^.//' exportedreminder4.txt > exportedreminder5.txt && # Removes the first character of the file
sed -e '$s/.$//' exportedreminder5.txt > exportedreminder6.txt

mv exportedreminder6.txt reminder.txt
rm -rf exportedreminder*.txt
rm /mnt/us/extensions/kindlereminder/bin/js/reminder.js
rm /mnt/us/extensions/kindlereminder/bin/js/todo.js

