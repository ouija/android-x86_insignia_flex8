#!/system/bin/sh

# Sleep fix (suspend-to-ram) script (c) 2020 by @ouija - for Insignia Flex8
log -p v -t "Sleep script (/etc/scripts/sleep.sh) (c) 2020 by @ouija" "Script loaded!"

# get device wakefulness state
WAKE_STATE=$(dumpsys power | grep -m1 'mWakefulness' | cut -d = -f 2)

# get current power state
PWR_STATE=$(cat /sys/power/state)

# check download activity
#UPLOAD=$(dumpsys netstats | grep -m1 'tb=' | cut -d = -f 5 | cut -d " " -f 1)
#DOWNLOAD=$(dumpsys netstats | grep -m1 'rb=' | cut -d = -f 3 | cut -d " " -f 1)
UL=$(ifconfig wlan0|grep "TX bytes"|cut -d ":" -f 3)
DL=$(ifconfig wlan0|grep "RX bytes"|cut -d ":" -f 2|cut -d " " -f 1)
UPLOAD="$(($UL + 500000))"
DOWNLOAD="$(($DL + 500000))"

#echo "$UL"
#echo "$UPLOAD"
#echo
#echo "$DL"
#echo "$DOWNLOAD"

while true
do


if [ "$DOWNLOAD" -lt $(ifconfig wlan0|grep "RX bytes"|cut -d ":" -f 2|cut -d " " -f 1) ]; then
	echo "greater than 0.5 mb has been downloaded!"
else
	echo "less than 0.5 mb has been downloaded!"
fi

sleep 30

done
