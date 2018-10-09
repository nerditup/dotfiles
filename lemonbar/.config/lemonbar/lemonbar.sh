#!/bin/bash

# Script Configuration
PANEL_FIFO=/tmp/panel_fifo
PANEL_WM_NAME=bspwm_panel
# Colours
FOREGROUND=$(xrdb -query | grep 'foreground:'| awk '{print $NF}')
BACKGROUND=$(xrdb -query | grep 'background:'| awk '{print $NF}')
BLACK=$(xrdb -query | grep 'color0:'| awk '{print $NF}')
RED=$(xrdb -query | grep 'color1:'| awk '{print $NF}')
GREEN=$(xrdb -query | grep 'color2:'| awk '{print $NF}')
YELLOW=$(xrdb -query | grep 'color3:'| awk '{print $NF}')
BLUE=$(xrdb -query | grep 'color4:'| awk '{print $NF}')
MAGENTA=$(xrdb -query | grep 'color5:'| awk '{print $NF}')
CYAN=$(xrdb -query | grep 'color6:'| awk '{print $NF}')
WHITE=$(xrdb -query | grep 'color7:'| awk '{print $NF}')
# Panel Geometry
PANEL_HEIGHT=30
PANEL_WIDTH=1900
PANEL_HORIZONTAL_OFFSET=10
PANEL_VERTICAL_OFFSET=8
PANEL_FONT="DejavuSansMono:size=10"

# Setup a FIFO such that the info is updating at different intervals, ie. when they change.
[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"

# Clock
clock() {
    echo "Clock 1234"
}

# WiFi
wifi() {
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
        echo "Network $percentage% $essid"
    fi
}

# Volume

# Battery

while :; do clock; sleep 60s; done > "$PANEL_FIFO" &
while :; do wifi; sleep 10s; done > "$PANEL_FIFO" &

while read -r line ; do
    case $line in
        Clock*)
            cl="${line:6}"
            ;;
        Network*)
            wl="${line:8}"
            ;;
    esac
    echo "%{l}test%{c+u}test1%{r+u}$wl $cl"
done < "$PANEL_FIFO" | lemonbar -f "$PANEL_FONT" -U "$BLUE" -B "$BACKGROUND" -F "$FOREGROUND" -g "$PANEL_WIDTH"x"$PANEL_HEIGHT"+"$PANEL_HORIZONTAL_OFFSET"+"$PANEL_VERTICAL_OFFSET" -n "$PANEL_WM_NAME"
