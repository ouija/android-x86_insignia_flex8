#!/system/bin/sh

# sleep to allow for init
sleep 3

# Dirty fix for HDMI audio [not needed with hdmi.sh]
#mv /dev/snd/pcmC0D0p /dev/snd/pcmC0D0p_tmp
#mv /dev/snd/pcmC0D2p /dev/snd/pcmC0D0p


# get headset input device
DEVICE=$(getevent -Sv | grep -B 5 -m1 'bytcr-rt5651 Headset' | grep -m1 'add device' | cut -d : -f 2)

if [ ! -z "$DEVICE" ]; then
        sleep 1
        while true
        do

        # 0005 - headphone jack event -> 0000 is unplugged, 0004 is plugged
        JACK_DET_N=$(getevent -s 0005 $DEVICE)

        if [ $JACK_DET_N -eq 0000 ]; then
                currentState=$(alsa_amixer -c1 sget 'Speaker' | grep -m1 'Mono: Playback' | cut -d [ -f 2 | cut -d ] -f 1)
                if [ "$currentState" == "off" ]; then
                        alsa_amixer -c1 cset name='Stereo DAC MIXR DAC R1 Switch' off
                        alsa_amixer -c1 cset name='Stereo DAC MIXL DAC R1 Switch' on
                        alsa_amixer -c1 cset name='Speaker Switch' on
                        alsa_amixer -c1 cset name='LOUT L Playback Switch' on
                        # Done after turning the speaker on to keep the bias and clk on
                        alsa_amixer -c1 cset name='Headphone Switch' off
                        alsa_amixer -c1 cset name='HPO L Playback Switch' off
                        alsa_amixer -c1 cset name='HPO R Playback Switch' off
                fi
        else
                currentState=$(alsa_amixer -c1 sget 'Speaker' | grep -m1 'Mono: Playback' | cut -d [ -f 2 | cut -d ] -f 1)
                if [ "$currentState" == "on" ]; then
                        alsa_amixer -c1 cset name='Headphone Switch' on
                        alsa_amixer -c1 cset name='HPO L Playback Switch' on
                        alsa_amixer -c1 cset name='HPO R Playback Switch' on
                        # Done after turning the HP on to keep the bias and clk on
                        alsa_amixer -c1 cset name='Speaker Switch' off
                        alsa_amixer -c1 cset name='LOUT L Playback Switch' off
                        alsa_amixer -c1 cset name='LOUT R Playback Switch' off
                        # Undo mono mapping
                        alsa_amixer -c1 cset name='Stereo DAC MIXR DAC R1 Switch' on
                        alsa_amixer -c1 cset name='Stereo DAC MIXL DAC R1 Switch' off
                fi
        fi

        sleep 2

        done
fi
