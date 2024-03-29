#!/system/bin/sh

# Audio pop fix script (c) 2020 by @ouija - for Insignia Flex8 (bytcrrt5651)

while true
do
	WAKE_STATE=$(dumpsys power | grep -m1 'mWakefulness' | cut -d = -f 2)
	HEADPH_CONNECTED=$(dumpsys activity broadcasts | grep microphone | tail -n 1 | grep -m1 'state=1')

	if [ "$WAKE_STATE" != "Asleep" ] && [ ! -z "$HEADPH_CONNECTED" ]; then
		# echo "headph connected; playing audible silence.."
		play-audio /etc/scripts/silence.wav > /dev/null 2>&1
	else
		#echo "headph not connected or device sleeping.."
		sleep 1
	fi
done
