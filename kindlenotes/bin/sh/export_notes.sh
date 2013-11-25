#!/bin/sh

/mnt/us/extensions/kindlenotes/bin/sh/show_alert.sh "Exporting note..." 0 &

# If no parameter is given, exit the program
if [ -z "$1" ];then
echo "Missing path!"
return 1
fi

# Enter the test directory
cd /mnt/us/extensions/kindlenotes/bin/html/

# Take the path as first argument
EXPORT_PATH="$1"

# Get note number from active kindlenote.html file
notenumber=$(ls kindlenotes*.html | sed -e s/[^0-9]//g)

# Enter the working directory
cd /mnt/us/extensions/kindlenotes/bin/notes


# Prepare output filename
newfile="$EXPORT_PATH""KindleNote_"$(date +%d-%m-%y_%k-%M-%S)".txt"
cp "note$notenumber.txt" "$newfile" 

if [ $? == 0 ]; then
/mnt/us/extensions/kindlenotes/bin/sh/show_alert.sh "Note n°$notenumber exported succesfully!" 5 &
else
/mnt/us/extensions/kindlenotes/bin/sh/show_alert.sh "Something did go wrong!" 2 &
fi

# Clean up temporary files
rm -rf exportednote*




# If the second parameter is "leafpad"
if [ "$2" == "leafpad" ]; then
/mnt/us/extensions/leafpad/bin/leafpad "$newfile"
fi


