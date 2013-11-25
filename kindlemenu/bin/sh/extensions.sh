#!/bin/sh


cd /mnt/us/extensions/kindlemenu/bin/html/
echo 'var myJSONObject = {"items": [' > parsed.txt
find /mnt/us/extensions/ -maxdepth 2 -name '*.json' -exec sh -c 'cat {} >> parsed.txt; echo -n "," >>parsed.txt; echo $(dirname $(realpath {})) >> path.txt;' \;

awk '{printf "var path%d=\"%s\"\n", NR, $0}' path.txt > path2.txt


cd /mnt/us/extensions/kindlemenu/bin/html/
echo ']};' >> parsed.txt

cat extensions_PART1.html parsed.txt path2.txt extensions_PART2.html > /mnt/us/extensions/kindlemenu/bin/html/extensions.html



lipc-set-prop com.lab126.pillow customDialog '{"name": "../../../../mnt/us/extensions/kindlemenu/bin/html/extensions", "clientParams": {"dismiss": true}}' &


# Comment the following lines to inspect parsed.txt, path.txt or path.txt files
rm -f parsed.txt
rm -f path.txt path2.txt





