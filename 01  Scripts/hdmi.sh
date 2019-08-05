#!/system/bin/sh

# HDMI detection audio switcher script by @ouija

# note the following patches may be required for HDMI connect/disconnect status to work properly in some kernels
# drm/i915: Fix the HDMI hot plug disconnection failure (v2) -> https://patchwork.kernel.org/patch/10625143/
# drm/i915: delay hotplug scheduling -> https://patchwork.kernel.org/patch/10613549/

# get hdmi insert input device [disabled/not reliable]
# DEVICE=$(getevent -Sv | grep -B 5 -m1 'HDMI/DP,pcm=2' | grep -m1 'add device' | cut -d : -f 2)

#if [ ! -z "$DEVICE" ]; then
        while true
        do

        # get hdmi connect/disconnect event [not reliable]
        #HDMI_EVENT=$(getevent -l -c 1 $DEVICE)

        #if [ ! -z "$HDMI_EVENT" ]; then
            # check if HDMI connected
            HDMI_STATUS=$(cat /sys/class/drm/card0/card0-HDMI-A-2/status)
            if [ "$HDMI_STATUS" == "connected" ]; then
                #echo "HDMI Connected!"

                # Dirty fix for HDMI audio
                #if ls /dev/snd/pcmC0D2p 1> /dev/null 2>&1; then
                #    mv /dev/snd/pcmC0D0p /dev/snd/pcmC0D0p_tmp
                #    mv /dev/snd/pcmC0D2p /dev/snd/pcmC0D0p
                #fi
                
                # Get audio out prop
                AUDIO_OUT=$(getprop hal.audio.out)
                
                if [ "$AUDIO_OUT" != "pcmC0D2p" ]; then                
                    #echo "Setting to pcmC0D2p"
                    # set prop to use hdmi out
                    setprop hal.audio.out pcmC0D2p
                    pkill audioserver
                fi
            elif [ "$HDMI_STATUS" == "disconnected" ]; then
                #echo "HDMI Disconnected!"
                
                # Revert Dirty fix for HDMI audio
                #if ls /dev/snd/pcmC0D0p_tmp 1> /dev/null 2>&1; then
                #    mv /dev/snd/pcmC0D0p /dev/snd/pcmC0D2p
                #    mv /dev/snd/pcmC0D0p_tmp /dev/snd/pcmC0D0p
                #fi

                # Get audio out prop
                AUDIO_OUT=$(getprop hal.audio.out)
                if [ ! -z "$AUDIO_OUT" ]; then
                    if [ "$AUDIO_OUT" != "pcmC1D0p" ]; then
                        #echo "Setting to pcmC1D0p"
                        # set prop to use hdmi out
                        setprop hal.audio.out pcmC1D0p
                        pkill audioserver
                    fi
                fi
            fi
        #fi

        sleep 3

        done
#fi
