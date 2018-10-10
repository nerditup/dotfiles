#!/bin/sh

battery_status=$(cat /sys/class/power_supply/BAT0/status)
battery_percent=$(cat /sys/class/power_supply/BAT0/capacity)

if [ "$battery_status" = "Charging" ]
then {
    echo -n "  "
}
else
    if [ "$battery_percent" -gt 80 ]
    then {
        echo -n "  $battery_percent%"
    }
    elif [ "$battery_percent" -gt 30 ]
    then {
        echo -n "  $battery_percent%"
    }
    else
        echo -n "  $battery_percent%"
    fi
fi
