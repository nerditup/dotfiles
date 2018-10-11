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
bspc subscribe report > "$panel_fifo" &

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
        W*)
            wm=""    # Clear the string each iteration
            IFS=":"  # Set the Internal Field Separator
            set -- ${line:1}    # Strip the leading W
            while [ $# -gt 0 ] ; do  # While the number of command-line arguments is not 0
                item=$1
                case $item in
                    [mM]*)
                        case $item in
                            m*)
                                # monitor
                                FG=$foreground
                                BG=$background
                                on_focused_monitor=
                                ;;
                            M*)
                                # focused monitor
                                FG=$foreground
                                BG=$background
                                on_focused_monitor=1
                                ;;
                        esac
                        ;;
                    [fFoOuU]*)
                        case $item in
                            f*)
                                # free desktop
                                FG=$foreground
                                BG=$background
                                UL=$red
                                name="□"
                                ;;
                            F*)
                                if [ "$on_focused_monitor" ] ; then
                                    # focused free desktop
                                    FG=$red
                                    BG=$background
                                    UL=$red
                                    name="■"
                                else
                                    # active free desktop
                                    FG=$foreground
                                    BG=$background
                                    UL=$red
                                    name="□"
                                fi
                                ;;
                            o*)
                                # occupied desktop
                                FG=$foreground
                                BG=$background
                                UL=$red
                                name="□"
                                ;;
                            O*)
                                if [ "$on_focused_monitor" ] ; then
                                    # focused occupied desktop
                                    FG=$red
                                    BG=$background
                                    UL=$red
                                    name="■"
                                else
                                    # active occupied desktop
                                    FG=$foreground
                                    BG=$background
                                    UL=$red
                                    name="□"
                                fi
                                ;;
                            u*)
                                # urgent desktop
                                FG=$foreground
                                BG=$background
                                UL=$red
                                name="□"
                                ;;
                            U*)
                                if [ "$on_focused_monitor" ] ; then
                                    # focused urgent desktop
                                    FG=$foreground
                                    BG=$background
                                    UL=$red
                                    name="■"
                                else
                                    # active urgent desktop
                                    FG=$foreground
                                    BG=$background
                                    UL=$red
                                    name="□"
                                fi
                                ;;
                        esac
                        wm="${wm}%{B${BG}}%{F${FG}}%{U${UL}} ${name} "
                        ;;
                esac
                shift
            done
            ;;
    esac
    echo "%{l+u}${wm}%{r+u} [${br}] [${vm}] [${bt}] [${wl}] [${cl}] "
done < "$panel_fifo" | lemonbar -f "$panel_font" -U "$red" -B "$background" -F "$foreground" -g "$panel_width"x"$panel_height"+"$panel_horizontal_offset"+"$panel_vertical_offset" -n "$panel_wm_name" | sh &
