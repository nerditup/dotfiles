#!/bin/sh

max_brightness=$(cat /sys/class/backlight/intel_backlight/max_brightness);
brightness=$(cat /sys/class/backlight/intel_backlight/brightness);

echo -n "$(awk -v b="${brightness}" -v mb="${max_brightness}" 'BEGIN{printf "%0.0f%", (b/mb)*100}')";
