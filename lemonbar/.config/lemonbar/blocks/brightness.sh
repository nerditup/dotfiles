#!/bin/sh

#max_brightness=$(cat /sys/class/backlight/intel_backlight/max_brightness)
#brightness=$(cat /sys/class/backlight/intel_backlight/brightness)

printf "%s" "$(paste /sys/class/backlight/*/{brightness,max_brightness} | awk '{BRIGHT=$1/$2*100} END {if(BRIGHT!=0){printf "%.f%s", BRIGHT, "%"} else {print "none"}}')"
