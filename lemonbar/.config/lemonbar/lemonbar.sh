#!/bin/sh

# Script Configuration
panel_fifo=/tmp/panel_fifo
panel_wm_name=bspwm_panel
# Colours
source ./colors.sh
# Panel Geometry
panel_height=28
panel_width=1920
panel_horizontal_offset=0
panel_vertical_offset=0
panel_font="-misc-dejavu sans mono-medium-r-normal--0-80-0-0-m-0-iso10646-1"

# Setup a FIFO such that the info is updating at different intervals, ie. when they change.
[ -e "$panel_fifo" ] && rm "$panel_fifo"
mkfifo "$panel_fifo"

# Clock
clock() {
    echo "Clock "$(blocks/time.sh)
}

# Network
network() {
    echo "Network "$(blocks/network.sh)
}

# Volume
volume() {
    echo "Volume V:"$(blocks/volume.sh)
}

# Battery
battery() {
    echo "Battery B:"$(blocks/battery.sh)
}

# Brightness
brightness() {
    echo "Brightness BL:"$(blocks/brightness.sh)
}

while :; do clock; sleep 60s; done > "$panel_fifo" &
while :; do network; sleep 10s; done > "$panel_fifo" &
while :; do battery; sleep 10s; done > "$panel_fifo" &
while :; do volume; sleep 0.05s; done > "$panel_fifo" &
while :; do brightness; sleep 1s; done > "$panel_fifo" &

while read -r line ; do
    case $line in
        Clock*)
            cl="${line:6}"
            ;;
        Network*)
            wl="${line:8}"
            ;;
        Battery*)
            bt="${line:8}"
            ;;
        Volume*)
            vm="${line:7}"
            ;;
        Brightness*)
            br="${line:11}"
            ;;
    esac
    echo "%{l}test%{c+u}test1%{r+u} [$br] [$vm] [$bt] [$wl] [$cl] "
done < "$panel_fifo" | lemonbar -f "$panel_font" -U "$red" -B "$background" -F "$foreground" -g "$panel_width"x"$panel_height"+"$panel_horizontal_offset"+"$panel_vertical_offset" -n "$panel_wm_name" | sh &
