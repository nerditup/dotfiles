#!/bin/sh

battery_status=$(cat /sys/class/power_supply/BAT0/status);
battery_percent=$(cat /sys/class/power_supply/BAT0/capacity);

if [ "${battery_status}" = "Charging" ] || [ "${battery_status}" = "Full" ];
then {
    echo -n "${battery_status}";
}
else
    echo -n "${battery_percent}%";
fi
