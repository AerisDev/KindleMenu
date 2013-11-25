#!/bin/sh
#
# KUAL USBNetwork actions helper script
#
# $Id: usbnet.sh 9916 2013-10-05 13:43:31Z NiLuJe $
#
##

# Get hackname from the script's path (NOTE: Will only work for scripts called from /mnt/us/extensions/${KH_HACKNAME})
KH_HACKNAME="${PWD##/mnt/us/extensions/}"

# Try to pull our custom helper lib
libkh_fail="false"
# Handle both the K5 & legacy helper, so I don't have to maintain the exact same thing in two different places :P
for my_libkh in libkh5 libkh ; do
	_KH_FUNCS="/mnt/us/${KH_HACKNAME}/bin/${my_libkh}"
	if [ -f ${_KH_FUNCS} ] ; then
		. ${_KH_FUNCS}
		# Got it, go away!
		libkh_fail="false"
		break
	else
		libkh_fail="true"
	fi
done

if [ "${libkh_fail}" == "true" ] ; then
	# Pull default helper functions for logging
	_FUNCTIONS=/etc/rc.d/functions
	[ -f ${_FUNCTIONS} ] && . ${_FUNCTIONS}
	# We couldn't get our custom lib, abort
	msg "couldn't source libkh5 nor libkh from '${KH_HACKNAME}'" W
	exit 0
fi

## Enable a specific trigger file in the hack's basedir
# Arg 1 is exact config trigger file name
##
enable_hack_trigger_file()
{
	if [ $# -lt 1 ] ; then
		kh_msg "not enough arguments passed to enable_hack_trigger_file ($# while we need at least 1)" W v "missing trigger file name"
	fi

	kh_trigger_file="${KH_HACK_BASEDIR}/${1}"

	touch "${kh_trigger_file}"
}

## Remove a specific trigger file in the hack's basedir
# Arg 1 is exact config trigger file name
##
disable_hack_trigger_file()
{
	if [ $# -lt 1 ] ; then
		kh_msg "not enough arguments passed to disable_hack_trigger_file ($# while we need at least 1)" W v "missing trigger file name"
		return 1
	fi

	kh_trigger_file="${KH_HACK_BASEDIR}/${1}"

	rm -f "${kh_trigger_file}"
}

## Check if we're in USBMS mode
check_is_in_usbnet()
{
	if lsmod | grep g_ether > /dev/null ; then
		kh_msg "will not edit usbnet config file in usbnet mode, switch to usbms" W v "must be in usbms mode to safely do this"
		return 0
	fi

	# Avoid touching the config while SSHD is up in wifi only mode, too
	if [ "${USE_WIFI_SSHD_ONLY}" == "true" ] ; then
		if [ -f "${SSH_PID}" ] ; then
			kh_msg "will not edit usbnet config file while sshd is up, shut it down" W v "sshd must be down to safely do this"
			return 0
		fi
	fi

	# All good, we're in USBMS mode
	return 1
}

## Check the current USBNET status (in more details than check_is_in_usbnet ;)
check_usbnet_status()
{
	# Source the config to get the wifi only current status
	. "${KH_HACK_BASEDIR}/etc/config"

	if [ "${USE_WIFI_SSHD_ONLY}" == "true" ] ; then
		# Don't do anything fancier (like checking if the pid still exists), because the actual usbnetwork script doesnt ;).
		if [ -f "${SSH_PID}" ] ; then
			kh_msg "wifi only, sshd should be up" I q
			return 3
		else
			kh_msg "wifi only, sshd should be down" I q
			return 4
		fi
	else
		# We're not in wifi only mode, do it like check_is_in_usbnet
		if lsmod | grep g_ether > /dev/null ; then
			kh_msg "currently in usbnet mode" I q
			return 5
		else
			kh_msg "currently in usbms mode" I q
			return 6
		fi
	fi

	# Huh. Unknown state, shouldn't happen.
	return 1
}

## Check if we're plugged in to something
check_is_plugged_in()
{
	# Try to check if we're plugged in...
	is_plugged_in="false"
	# There's no kdb in FW 2.x...
	if [ -d "/etc/kdb" ] ; then
		if [ "$(cat $(kdb get system/driver/usb/SYS_CONNECTED))" == "1" ] ; then
			is_plugged_in="true"
		fi
	else
		# NOTE: Seems to be more useful than lipc-get-prop -i -e -- com.lab126.powerd isCharging (accurate in USBMS mode)...
		# On the other hand, /sys/devices/platform/arc_udc/connected doesn't seem to be very useful...
		if [ "$(cat /sys/devices/platform/charger/charging)" == "1" ] ; then
			is_plugged_in="true"
		fi
	fi
	if [ "${is_plugged_in}" == "true" ] ; then
		kh_msg "will not toggle usbnet while plugged in, unplug your kindle" W v "must not be plugged in to safely do that"
		return 0
	fi

	# All god, (apparently) not plugged in to anything
	return 1
}

## Check if we're a WiFi device (!= K1/K2/DX/DXG)
check_is_wifi_device()
{
	[ "${IS_K1}" == "true" ] && return 1
	# DX & DXG are folded in IS_K2
	[ "${IS_K2}" == "true" ] && return 1

	# We are, all good :)
	return 0
}

## Check if we're a legacy device (< K4)
check_is_legacy_device()
{
	[ "${IS_K1}" == "true" ] && return 0
	[ "${IS_K2}" == "true" ] && return 0
	[ "${IS_K3}" == "true" ] && return 0

	# We're not, all good :)
	return 1
}

## Check if we're a Touch device (>= K5)
check_is_touch_device()
{
	[ "${IS_K5}" == "true" ] && return 0
	[ "${IS_PW}" == "true" ] && return 0

	# We're not, all good :)
	return 1
}

## Toggle a specific config switch in the hack's config
# Arg 1 is the exact name of the config switch (var name)
# Arg 2 is the value of the switch (true || false)
##
edit_hack_config()
{
	if [ $# -lt 2 ] ; then
		kh_msg "not enough arguments passed to disable_hack_trigger_file ($# while we need at least 2)" W v "missing config switch and value"
		return 1
	fi

	kh_config_file="${KH_HACK_BASEDIR}/etc/config"

	kh_config_switch_name="${1}"
	kh_config_switch_value="${2}"
	# Sanitize user input
	if ! grep "${kh_config_switch_name}" "${kh_config_file}" ; then
		kh_msg "invalid config switch name (${kh_config_switch_name})" W v "invalid config switch"
		return 1
	fi

	# This is slightly overkill, the hack already discards the value if it's not true or false in lowercase...
	case "$kh_config_switch_value" in
		t* | y* | T* | Y* | 1 )
			kh_config_switch_value="true"
		;;
		f* | n* | F* | N* | 0 )
			kh_config_switch_value="false"
		;;
		* )
			kh_msg "invalid config switch value (${kh_config_switch_value})" W v "invalid config value"
			return 1
		;;
	esac

	# We do NOT want to edit the config file if we're not in USBMS mode, to avoid leaving the hack in an undefined state
	if check_is_in_usbnet ; then
		return 1
	fi

	# Do the deed...
	sed -r -e "s/^(${kh_config_switch_name})(=)([\"'])(.*?)([\"'])$/\1\2\3${kh_config_switch_value}\5/" -i "${kh_config_file}"
}

## Try to toggle USBNetwork
toggle_usbnet()
{
	# All kinds of weird stuff happens if we try to toggle USBNet while plugged in, so, well, don't do it ;)
	if check_is_plugged_in ; then
		return 1
	fi

	kh_msg "Toggle USBNetwork" I a
	${KH_HACK_BINDIR}/usbnetwork
	# NOTE: Send a blank kh_msg to avoid confusing users in verbose mode? That seem counterproductive...
}

## Print the current USBnetwork mode
usbnet_status()
{
	# Check...
	check_usbnet_status
	usbnet_status="$?"

	# Interpret it
	case "${usbnet_status}" in
		3 )	killall show_alert.sh & /mnt/us/extensions/kindlemenu/bin/sh/show_alert.sh "SSHD is up (usbms, wifi only)." 5 &
		;;
		4 )	killall show_alert.sh & /mnt/us/extensions/kindlemenu/bin/sh/show_alert.sh "SSHD is down (usbms, wifi only)." 5 &
		;;
		5 )	killall show_alert.sh & /mnt/us/extensions/kindlemenu/bin/sh/show_alert.sh "USBNetwork is ON (usbnet)." 5 &
		;;
		6 )	killall show_alert.sh & /mnt/us/extensions/kindlemenu/bin/sh/show_alert.sh "USBNetwork is OFF (usbms)." 5 &
		;;
		* )	killall show_alert.sh & /mnt/us/extensions/kindlemenu/bin/sh/show_alert.sh "USBNetwork is broken?" 5 &
		;;
	esac
}

## Enable SSH at boot
enable_auto()
{
	enable_hack_trigger_file "auto"
	# FIXME: Workaround broken? custom status message by using eips ourselves. Kill this once it works properly.
	kh_msg "Boot the Kindle in USBNet mode" I a
}

## Disable SSH at boot
disable_auto()
{
	disable_hack_trigger_file "auto"
	kh_msg "Boot the Kindle in USBMS mode" I a
}

## Enable verbose mode
enable_verbose()
{
	enable_hack_trigger_file "verbose"
	kh_msg "Make USBNetwork verbose" I a
}

## Disable verbose mode
disable_verbose()
{
	disable_hack_trigger_file "verbose"
	kh_msg "Make USBNetwork quiet" I a
}

## Enable SSH over WiFi
enable_wifi()
{
	# NOTE: Extra safety, this is nonsensical on devices without a WiFi chip ;).
	if ! check_is_wifi_device ; then
		kh_msg "Not applicable to your device" W v
		return 1
	fi

	# Put the kh_msg before the edit, to be able to see the warnings in case of error
	kh_msg "Enable SSH over WiFi" I a

	# In my infinite wisdom, I changed the variable name in the K5 version...
	if check_is_touch_device ; then
		edit_hack_config "USE_WIFI" "true"
	else
		edit_hack_config "K3_WIFI" "true"
	fi
}

## Disable SSH over WiFi
disable_wifi()
{
	if ! check_is_wifi_device ; then
		kh_msg "Not applicable to your device" W v
		return 1
	fi

	kh_msg "Disable SSH over WiFi" I a

	if check_is_touch_device ; then
		edit_hack_config "USE_WIFI" "false"
	else
		edit_hack_config "K3_WIFI" "false"
	fi
}

## Enable SSHD only mode
enable_sshd_only()
{
	if ! check_is_wifi_device ; then
		kh_msg "Not applicable to your device" W v
		return 1
	fi

	kh_msg "Enable SSHD only over WiFi" I a

	if check_is_touch_device ; then
		edit_hack_config "USE_WIFI_SSHD_ONLY" "true"
	else
		edit_hack_config "K3_WIFI_SSHD_ONLY" "true"
	fi
}

## Disable SSHD only mode
disable_sshd_only()
{
	if ! check_is_wifi_device ; then
		kh_msg "Not applicable to your device" W v
		return 1
	fi

	kh_msg "Disable SSHD only over WiFi" I a

	if check_is_touch_device ; then
		edit_hack_config "USE_WIFI_SSHD_ONLY" "false"
	else
		edit_hack_config "K3_WIFI_SSHD_ONLY" "false"
	fi
}

## Move to OpenSSH
use_openssh()
{
	kh_msg "Switch to OpenSSH" I a
	edit_hack_config "USE_OPENSSH" "true"
}

## Move back to Dropbear
use_dropbear()
{
	kh_msg "Switch to DropBear" I a
	edit_hack_config "USE_OPENSSH" "false"
}

## Make dropbear quieter
quiet_dropbear()
{
	kh_msg "Don't let dropbear print the banner file" I a "Make dropbear quieter"
	edit_hack_config "QUIET_DROPBEAR" "true"
}

## Let dropbear print the banner
verbose_dropbear()
{
	kh_msg "Let dropbear print the banner file" I a
	edit_hack_config "QUIET_DROPBEAR" "false"
}

## Unique MAC addresses
tweak_mac()
{
	kh_msg "Use unique MAC addresses" I a
	edit_hack_config "TWEAK_MAC_ADDRESS" "true"
}

## Default MAC addresses
default_mac()
{
	kh_msg "Use default MAC addresses" I a
	edit_hack_config "TWEAK_MAC_ADDRESS" "false"
}

## Let volumd do the low-level heavy-lifting (default on K4, K5 & PW)
use_volumd()
{
	# NOTE: Extra safety, we *really* don't want to run this on anything other than a K2/3
	if ! check_is_legacy_device ; then
		kh_msg "Not supported on your device" W v
		return 1
	fi

	kh_msg "Use volumd" I a
	edit_hack_config "USE_VOLUMD" "true"
}

## Do the kernel module switch & if up ourselves (default on legacy devices)
dont_use_volumd()
{
	if ! check_is_legacy_device ; then
		kh_msg "Not supported on your device" W v
		return 1
	fi

	kh_msg "Do not use volumd" I a
	edit_hack_config "USE_VOLUMD" "false"
}

## Restore the default config file
restore_config()
{
	# Don't touch the config if we're in usbnet mode...
	if check_is_in_usbnet ; then
		return 1
	fi

	if [ -f "${USBNET_BASEDIR}/etc/config.default" ] ; then
		kh_msg "Restore default config file" I a
		cp -f "${USBNET_BASEDIR}/etc/config.default" "${USBNET_BASEDIR}/etc/config"
	else
		kh_msg "No default config file!" W v
	fi
}

## Main
case "${1}" in
	"toggle_usbnet" )
		${1}
	;;
	"usbnet_status" )
		${1}
	;;
	"enable_auto" )
		${1}
	;;
	"disable_auto" )
		${1}
	;;
	"enable_verbose" )
		${1}
	;;
	"disable_verbose" )
		${1}
	;;
	"enable_wifi" )
		${1}
	;;
	"disable_wifi" )
		${1}
	;;
	"enable_sshd_only" )
		${1}
	;;
	"disable_sshd_only" )
		${1}
	;;
	"use_openssh" )
		${1}
	;;
	"use_dropbear" )
		${1}
	;;
	"quiet_dropbear" )
		${1}
	;;
	"verbose_dropbear" )
		${1}
	;;
	"tweak_mac" )
		${1}
	;;
	"default_mac" )
		${1}
	;;
	"use_volumd" )
		${1}
	;;
	"dont_use_volumd" )
		${1}
	;;
	"restore_config" )
		${1}
	;;
	* )
		kh_msg "invalid action (${1})" W v "invalid action"
	;;
esac
