#!/bin/sh

SCRIPT=""

PLATFORM="$(cat /sys/devices/platform/mxc_epdc_fb/graphics/fb0/modes)"

if [ "$PLATFORM" = "${PLATFORM/758/}" ]; then
#Touch
#setup touch version of stuff

SCRIPT=`cat << 'JAVASCRIPT' | tr -d '\n' | sed -e 's,",\\\\",g'
(function () {
  var _batteryMeterId = BatteryState.batteryFillDiv,
      _batteryMeterEl = _batteryMeterId && document.getElementById(_batteryMeterId),
      _currentBatteryLevel = nativeBridge.getIntLipcProperty("com.lab126.powerd", "battLevel"),
      _originalResolveLabel = BatteryState.resolveLabel;

  if (!_batteryMeterEl || !_originalResolveLabel) {
    return;
  }

/* If the % mode is already on, turn it off and exit */
if (_batteryMeterEl.style.backgroundColor=="black"){
nativeBridge.setLipcProperty("com.lab126.pillow","disableEnablePillow","disable");
nativeBridge.setLipcProperty("com.lab126.pillow","disableEnablePillow","enable");
nativeBridge.setLipcProperty("com.lab126.system", "sendEvent", "; sh -c '/mnt/us/extensions/kindlemenu/bin/kindlemenu.sh; /mnt/us/extensions/kindlemenu/bin/sh/sleep_and_run.sh 5 /mnt/us/extensions/kindlemenu/bin/shortcut.sh &'");return;}

   
  _batteryMeterEl.style.color = "white";
  _batteryMeterEl.style.lineHeight = "5.2pt";
  /* Add style for smaller font size. */
  _batteryMeterEl.style.fontSize = "7.2pt";
  /* Background color for hiding the battery */
  _batteryMeterEl.style.backgroundColor="black";
  _batteryMeterEl.style.marginTop="-1.6pt";
  _batteryMeterEl.style.marginLeft="-2pt";
  _batteryMeterEl.style.width="20pt";
  _batteryMeterEl.style.minWidth="20pt";
  _batteryMeterEl.style.height="12pt";
  _batteryMeterEl.style.paddingTop="0.8pt";

  if (_currentBatteryLevel) {
    _batteryMeterEl.textContent = _currentBatteryLevel + "%";
  }
      
  BatteryState.resolveLabel = function () {
    var batteryMeterId = BatteryState.batteryFillDiv,
        batteryMeterEl = batteryMeterId && document.getElementById(batteryMeterId);
        
    _originalResolveLabel();
    
    if (batteryMeterEl) {
      batteryMeterEl.textContent = BatteryState.percent + "%";
    }
  };
})();
`

fi


if [ "$PLATFORM" != "${PLATFORM/758/}" ]; then
#It's a PW
#setup PW version of stuff...


SCRIPT=`cat << 'JAVASCRIPT' | tr -d '\n' | sed -e 's,",\\\\",g'
(function () {


  var _batteryMeterId = BatteryState.batteryFillDiv,
      _batteryMeterEl = _batteryMeterId && document.getElementById(_batteryMeterId),
      _currentBatteryLevel = nativeBridge.getIntLipcProperty("com.lab126.powerd", "battLevel"),
      _originalResolveLabel = BatteryState.resolveLabel;

  if (!_batteryMeterEl || !_originalResolveLabel) {
    return;
  }


/* If the % mode is already on, turn it off and exit */
if (_batteryMeterEl.style.backgroundColor=="black"){
nativeBridge.setLipcProperty("com.lab126.pillow","disableEnablePillow","disable");
nativeBridge.setLipcProperty("com.lab126.pillow","disableEnablePillow","enable");
nativeBridge.setLipcProperty("com.lab126.system", "sendEvent", "; sh -c '/mnt/us/extensions/kindlemenu/bin/kindlemenu.sh; /mnt/us/extensions/kindlemenu/bin/sh/sleep_and_run.sh 5 /mnt/us/extensions/kindlemenu/bin/shortcut.sh &'");return;}

    
  _batteryMeterEl.style.color = "white";
  /* Hack style to set vertical alignment of text. */
  _batteryMeterEl.style.lineHeight = "5.2pt";
  _batteryMeterEl.style.fontSize = "7.2pt";
  /* Background color for hiding the battery */
  _batteryMeterEl.style.backgroundColor="black";
  _batteryMeterEl.style.marginTop="-1.4pt";
  _batteryMeterEl.style.marginLeft="-2pt";
  _batteryMeterEl.style.width="20pt";
  _batteryMeterEl.style.minWidth="20pt";
  _batteryMeterEl.style.height="12pt";
  _batteryMeterEl.style.paddingTop="0.8pt";

  if (_currentBatteryLevel) {
    _batteryMeterEl.textContent = _currentBatteryLevel + "%";
  }
    
  BatteryState.resolveLabel = function () {
    var batteryMeterId = BatteryState.batteryFillDiv,
        batteryMeterEl = batteryMeterId && document.getElementById(batteryMeterId);
        
    _originalResolveLabel();
    
    if (batteryMeterEl) {
      batteryMeterEl.textContent = BatteryState.percent + "%";
    }
  };
})();

`
fi

MESSAGE='{
  "pillowId": "default_status_bar",
  "function": "'${SCRIPT}'"
}'

lipc-set-prop -s com.lab126.pillow interrogatePillow "$MESSAGE"
