#!/system/bin/sh

# sleep fix script by @ouija - for baytrail/cherrytrail devices that only support 'Suspend-to-Idle' or freeze power state

while true
do

# get device wakefulness state
WAKE_STATE=$(dumpsys power | grep -m1 'mWakefulness' | cut -d = -f 2)

# get current power state
PWR_STATE=$(cat /sys/power/state)

# inital check to see if device asleep and power state is default
if [ "$WAKE_STATE" == "Asleep" ] && [ "$PWR_STATE" == "freeze mem" ]; then
    # wait 30 seconds before doing anything
    sleep 29
    # verify device wakefulness state as asleep
    WAKE_STATE_VERIFY=$(dumpsys power | grep -m1 'mWakefulness' | cut -d = -f 2)
    # verify current power state as default
    PWR_STATE_VERIFY=$(cat /sys/power/state)
    if [ "$WAKE_STATE_VERIFY" == "Asleep" ] && [ "$PWR_STATE_VERIFY" == "freeze mem" ]; then
        # all systems go, let's freeze the bitch
        echo freeze > /sys/power/state
    fi
fi

# check sleep state every second
sleep 1

done