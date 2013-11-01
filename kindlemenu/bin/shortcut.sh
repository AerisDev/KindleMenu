#!/bin/sh
SCRIPT=`cat << 'JAVASCRIPT' | tr -d '\n' | sed -e 's,",\\\\",g'
(function () {

  var swiped = false;

  document.body.addEventListener("mousedown", function () {
    swiped = true;
  });
  document.body.addEventListener("mouseup", function () {
    swiped = false;
  });

  document.body.addEventListener("mouseout", function () {
    if (swiped) {
      swiped = false;
nativeBridge.setLipcProperty( "com.lab126.system", "sendEvent", "; sh -c 'DISPLAY=:0 /mnt/us/extensions/kindlemenu/bin/kindlemenu.sh'");
    }
  });
})();
`

MESSAGE='{
  "__id__":   "0",
  "pillowId": "default_status_bar",
  "replySrc": "",
  "function": "'${SCRIPT}'"
}'

lipc-set-prop -s com.lab126.pillow interrogatePillow "$MESSAGE"
