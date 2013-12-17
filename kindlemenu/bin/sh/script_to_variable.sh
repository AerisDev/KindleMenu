#!/bin/sh

# This script take a span number as first argument, and writes in that span the ouput of a script (second argument)
# Then, inject it into a custom dialog (third argument)

span_id="document.getElementById('span_$1').innerHTML"
script="$2"
# run the script and saves the output
script_result=$($script)

dialog_path="$3"

# send the output to the proper span of the dialog
MESSAGE1='{"pillowId": "../../../..'"$dialog_path"'","function":"'"$span_id""='""$script_result""'"'"}'
/usr/bin/lipc-set-prop com.lab126.pillow interrogatePillow "$MESSAGE1" &






