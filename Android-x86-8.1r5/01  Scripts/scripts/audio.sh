#!/system/bin/sh

# Audio init script (c) 2020 by @ouija - for Insignia Flex 8 (bytcrrt5651)
log -p v -t "Audio script (c) 2020 by @ouija" "Script loaded!"

# sleep to allow for init
sleep 1

# Dirty fix for HDMI audio [not needed with hdmi.sh]
#mv /dev/snd/pcmC0D0p /dev/snd/pcmC0D0p_tmp
#mv /dev/snd/pcmC0D2p /dev/snd/pcmC0D0p

# Boost mic level
alsa_amixer -c1 cset name='ADC Boost Gain' 2


# Detect if headphones connected on boot and change state if so
HEADPH_CONNECTED=$(dumpsys activity broadcasts | grep microphone | tail -n 1 | grep -m1 'state=1')
# Alternate method
#HEADPH_CONNECTED=$(dumpsys audio | grep -m1 'setWiredDeviceConnectionState( type:4 state:DEVICE_STATE_AVAILABLE')

if [ ! -z "$HEADPH_CONNECTED" ]; then
        ALSA_STATE=$(alsa_amixer -c1 sget 'Speaker' | grep -m1 'Mono: Playback' | cut -d [ -f 2 | cut -d ] -f 1)
        if [ "$ALSA_STATE" == "on" ]; then
		HEADPH_MIC=$(dumpsys activity broadcasts | grep microphone | tail -n 1 | grep -m1 'state=1' | grep microphone=1)
		ALSA_STATE_MIC=$(alsa_amixer -c1 sget 'Headset Mic' | grep -m1 'Mono: Playback' | cut -d [ -f 2 | cut -d ] -f 1)
               	if [ ! -z "$HEADPH_MIC" ] && [ "$ALSA_STATE_MIC" == "off" ]; then
			log -p v -t "Audio script (c) 2020 by @ouija" "Headset connected -> switching mic input.."
			alsa_amixer -c1 cset name='Internal Mic Switch' off
			alsa_amixer -c1 cset name='Headset Mic Switch' on
		fi
		log -p v -t "Audio script (c) 2020 by @ouija" "Headphones connected -> switching output.."
        	sh /etc/scripts/bytcrrt5651/headphone.txt
	fi
fi


# Get headset input device
DEVICE=$(getevent -Sv | grep -B 5 -m1 'bytcr-rt5651 Headset' | grep -m1 'add device' | cut -d : -f 2)

if [ ! -z "$DEVICE" ]; then
        sleep 1
        while true
        do

        # 0005 - headphone jack event -> 0000 is unplugged, 0004 is plugged
        JACK_DET_N=$(getevent -s 0005 $DEVICE)

        if [ $JACK_DET_N -eq 0000 ]; then
                ALSA_STATE=$(alsa_amixer -c1 sget 'Speaker' | grep -m1 'Mono: Playback' | cut -d [ -f 2 | cut -d ] -f 1)
                if [ "$ALSA_STATE" == "off" ]; then
			ALSA_STATE_MIC=$(alsa_amixer -c1 sget 'Internal Mic' | grep -m1 'Mono: Playback' | cut -d [ -f 2 | cut -d ] -f 1)
	                if [ "$ALSA_STATE_MIC" == "off" ]; then
				log -p v -t "Audio script (c) 2020 by @ouija" "Headset NOT connected -> switching mic input.."
	                        alsa_amixer -c1 cset name='Headset Mic Switch' off
                            alsa_amixer -c1 cset name='Internal Mic Switch' on
        	        fi
			log -p v -t "Audio script (c) 2020 by @ouija" "Headphones NOT connected -> switching output.."
                	sh /etc/scripts/bytcrrt5651/monospeaker.txt
		fi
        else
                ALSA_STATE=$(alsa_amixer -c1 sget 'Speaker' | grep -m1 'Mono: Playback' | cut -d [ -f 2 | cut -d ] -f 1)
                if [ "$ALSA_STATE" == "on" ]; then
			HEADPH_MIC=$(dumpsys activity broadcasts | grep microphone | tail -n 1 | grep -m1 'state=1' | grep microphone=1)
			ALSA_STATE_MIC=$(alsa_amixer -c1 sget 'Headset Mic' | grep -m1 'Mono: Playback' | cut -d [ -f 2 | cut -d ] -f 1)
                	if [ ! -z "$HEADPH_MIC" ] && [ "$ALSA_STATE_MIC" == "off" ]; then
				log -p v -t "Audio script (c) 2020 by @ouija" "Headset connected -> switching mic input.."
                        	alsa_amixer -c1 cset name='Internal Mic Switch' off
	                        alsa_amixer -c1 cset name='Headset Mic Switch' on
                	fi
			log -p v -t "Audio script (c) 2020 by @ouija" "Headphones connected -> switching output.."
	        	sh /etc/scripts/bytcrrt5651/headphone.txt
                fi
        fi

        sleep 1
        done
fi
