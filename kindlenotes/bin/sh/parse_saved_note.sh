#!/bin/sh

# First passed argument is the note number
notenumber=$1

cd /mnt/us/extensions/kindlenotes/bin/notes/

# Parse the note
sed 's/'`echo -e "\001"`'/\n/g' "note$notenumber.txt" > exportednote1.txt &&
sed "s/"`echo -e '\002'`"/'/g" exportednote1.txt > exportednote2.txt &&
sed 's/'`echo -e "\003"`'/"/g' exportednote2.txt > exportednote3.txt &&
sed 's/'`echo -e "\004"`'/$/g' exportednote3.txt > exportednote4.txt &&
mv exportednote4.txt "note$notenumber.txt"

if [ $? == 0 ];then
/mnt/us/extensions/kindlenotes/bin/sh/show_alert.sh "Note n°$notenumber successfully saved." 5 &
else
/mnt/us/extensions/kindlenotes/bin/sh/show_alert.sh "Something did go wrong! :(" 5 &
fi

rm -rf exportednote*.txt

