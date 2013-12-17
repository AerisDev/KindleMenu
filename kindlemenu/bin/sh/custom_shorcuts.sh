#!/bin/sh

APP_PATH="/mnt/us/extensions/kindlemenu"

# if custom_shorcuts doesn't exist, create it from the sample
if [ ! -f "$APP_PATH/custom_shortcuts.txt" ]; then
	cp -f "$APP_PATH/bin/misc/custom_shortcuts_sample.txt" "$APP_PATH/custom_shortcuts.txt"
fi

source "$APP_PATH/custom_shortcuts.txt"


cd "$APP_PATH/bin/html"

for i in `seq 1 30`;do


	eval 'commandold="''$'"command$i"'"' # Save variable
	commandnew=$(eval echo ${commandold%?}) # Drop last character (line break)
	eval 'linkold="''$'"link$i"'"'
	linknew=$(eval echo ${linkold%?})

	if [ ! -z "$commandnew" ] && [ ! -z "$linknew" ] ;then
	path=$(dirname ${commandnew})

		echo "<script>function function$i(){nativeBridge.dismissMe();nativeBridge.setLipcProperty( "'"com.lab126.system", "sendEvent", "; su -c '"'cd $path; DISPLAY=:0 ""$commandnew"" &'"'");}</script>' >> custom_links_list.txt
		echo '<div class="button" onclick="force_portrait();function'"$i"'()">'"$linknew"'</div>' >> custom_links_list.txt
	fi
done

cat custom_shortcuts_PART1.html custom_links_list.txt custom_shortcuts_PART2.html > custom_shortcuts.html

rm -rf custom_links_list.txt


lipc-set-prop com.lab126.pillow customDialog '{"name": "../../../../mnt/us/extensions/kindlemenu/bin/html/custom_shortcuts", "clientParams": {"dismiss": true}}'



