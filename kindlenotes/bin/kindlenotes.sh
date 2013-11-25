#!/bin/sh

# renames passed paramater
notenumber="$1"

# if no paramater is passed, behave as if would be passed 1
if [ -z "$1" ];then
notenumber='1'
fi

# if the note doesn't exist, create one with default text
cd /mnt/us/extensions/kindlenotes/bin/notes/
if [ ! -f "note$notenumber.txt" ];then
echo "New note $notenumber" >> "note$notenumber.txt"
fi

cp "note$notenumber.txt" "/mnt/us/extensions/kindlenotes/bin/html/note$notenumber.txt"

cd /mnt/us/extensions/kindlenotes/bin/html/

# removes old dialog page files
rm -rf kindlenotes*.html

# Build up the html page
echo -n "function getCurrentPageNumber(){return $notenumber;}" | cat header1.html - header2.html "note$notenumber.txt" footer.html > "kindlenotes$notenumber.html"

rm -f /mnt/us/extensions/kindlenotes/bin/html/note$notenumber.txt

# Opens KindleText dialog
FIRST='{"name": "../../../../mnt/us/extensions/kindlenotes/bin/html/kindlenotes'
SECOND='", "clientParams": {"dismiss": true}}'
lipc-set-prop com.lab126.pillow customDialog "$FIRST""$notenumber""$SECOND"
