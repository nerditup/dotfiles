#!/bin/sh

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
PANEL_HEIGHT=28
PANEL_WIDTH=1920
PANEL_HORIZONTAL_OFFSET=0
PANEL_VERTICAL_OFFSET=0
PANEL_FONT="DejavuSansMono:size=8"
GLYPH_FONT="-wuncon-siji-medium-r-normal--10-100-75-75-c-80-iso10646-1"

# Setup a FIFO such that the info is updating at different intervals, ie. when they change.
[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"

# Clock
clock() {
    echo "Clock "$(~/dotfiles/lemonbar/.config/lemonbar/blocks/time.sh)
}

# Network
network() {
    echo "Network "$(~/dotfiles/lemonbar/.config/lemonbar/blocks/network.sh)
}

# Volume
volume() {
    echo "Volume "$(~/dotfiles/lemonbar/.config/lemonbar/blocks/volume.sh)
}

# Battery
battery() {
    echo "Battery "$(~/dotfiles/lemonbar/.config/lemonbar/blocks/battery.sh)
}

while :; do clock; sleep 60s; done > "$PANEL_FIFO" &
while :; do network; sleep 10s; done > "$PANEL_FIFO" &
while :; do battery; sleep 10s; done > "$PANEL_FIFO" &
while :; do volume; sleep 0.05s; done > "$PANEL_FIFO" &

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
    esac
    echo "%{l}test%{c+u}test1%{r+u} [$vm] [$bt] [$wl] [$cl] "
done < "$PANEL_FIFO" | lemonbar -o 0 -f "$PANEL_FONT" -o -1 -f "$GLYPH_FONT" -U "$RED" -B "$BACKGROUND" -F "$FOREGROUND" -g "$PANEL_WIDTH"x"$PANEL_HEIGHT"+"$PANEL_HORIZONTAL_OFFSET"+"$PANEL_VERTICAL_OFFSET" -n "$PANEL_WM_NAME" | sh &
