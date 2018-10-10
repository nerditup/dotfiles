#!/bin/sh

signal_strength=$(iw wlp58s0 link | grep 'signal' | awk '{printf "%s", $2}')
essid=$(iw wlp58s0 link | grep 'SSID' | awk '{printf "%s", $2}')

if [[ "$signal_strength" -le -100 ]]; then
    percentage=0
elif [[ "$signal_stength" -ge -50 ]]; then
    percentage=100
else
    percentage=$(( 2 * ("$signal_strength" + 100) ))
fi
if [[ "$essid" != "" ]]; then
    echo "$percentage% $essid"
fi
