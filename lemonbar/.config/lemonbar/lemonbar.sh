#!/bin/sh

# Script Configuration
panel_fifo=/tmp/panel_fifo
panel_wm_name=bspwm_panel

# Panel Geometry
panel_height=28
panel_width=1920
panel_horizontal_offset=0
panel_vertical_offset=0

# Panel Fonts
panel_font="-misc-dejavu sans mono-medium-r-normal--0-80-0-0-m-0-iso10646-1"
glyph_font=""

# Get the colour #HexCode value from ~/.Xresources.
get_colour_code() {
    echo -n $(xrdb -query | grep "$1" | awk '{printf "%s", $NF}');
}

# Set the colours used in the bar.
foreground=$(get_colour_code 'foreground');
background=$(get_colour_code 'background');
black=$(get_colour_code 'color0');
red=$(get_colour_code 'color1');
green=$(get_colour_code 'color2');
yellow=$(get_colour_code 'color3');
blue=$(get_colour_code 'color4');
magenta=$(get_colour_code 'color5');
cyan=$(get_colour_code 'color6');
white=$(get_colour_code 'color7');

# Ensure Lemonbar closes with X.
#trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

# Setup a FIFO such that the info is updating at different intervals, ie. when they change.
[ -e "$panel_fifo" ] && rm "$panel_fifo"
mkfifo "$panel_fifo"

# Clock
clock() {
    clock=$(date +"%a %l:%M %p");

    echo "Clock "${clock}"";
}

# Network
network() {
    device="wlp58s0";
    signal_strength=$(iw "${device}" link | grep 'signal' | awk '{printf "%s", $2}');
    essid=$(iw "${device}" link | grep 'SSID' | awk '{printf "%s", $2}');

    if [[ "${signal_strength}" -le -100 ]];
    then {
        percentage=0;
    }
    elif [[ "${signal_stength}" -ge -50 ]];
    then {
        percentage=100;
    }
    else
        percentage=$(( 2 * ("${signal_strength}" + 100) ));
    fi

    if [[ "${essid}" != "" ]];
    then {
        network=""${percentage}"% @ "${essid}"";
    }
    else
        network="Down";
    fi

    echo "Network "${network}"";
}

# Volume
volume() {
    master="$(amixer | head -1 | cut -d "'" -f 2)";
    volume="$(amixer get "${master}" | tail -1 | cut -d \[ -f 2 | cut -d \] -f 1)";

    echo "Volume V:"${volume}"";
}

# Battery
battery() {
    battery_status=$(cat /sys/class/power_supply/BAT0/status);
    battery_percent=$(cat /sys/class/power_supply/BAT0/capacity);

    if [ "${battery_status}" = "Charging" ] || [ "${battery_status}" = "Full" ];
    then {
        battery="${battery_status}";
    }
    else
        battery="${battery_percent}%";
    fi

    echo "Battery B:"${battery}"";
}

# Brightness
brightness() {
    actual=$(cat /sys/class/backlight/intel_backlight/brightness);
    max=$(cat /sys/class/backlight/intel_backlight/max_brightness);

    brightness="$(awk -v b="${actual}" -v mb="${max}" 'BEGIN{printf "%0.0f%", (b/mb)*100}')";

    echo "Brightness BL:"${brightness}"";
}

# BSPWM
bspwm() {
    while IFS=':' read -ra item;
    do
        wm='';
        for i in "${item[@]}";
        do
            case ${i} in
                [mM]*)
                    case ${i} in
                        m*)
                            ;;
                        M*)
                            ;;
                    esac
                    ;;
                [fFoOuU]*)
                    case ${i} in
                        f*)
                            ;;
                        F*)
                            ;;
                        o*)
                            ;;
                        O*)
                            ;;
                        u*)
                            ;;
                        U*)
                            ;;
                    esac
                    wm="${wm} ${i#?} ";
                    ;;
            esac
        done
        echo "${wm}";
    done <<< "${1}"
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
            wm="$(bspwm "${line}")"
            ;;
    esac

    echo "%{l}${wm}%{r} [${br}] [${vm}] [${bt}] [${wl}] [${cl}] "

done < "$panel_fifo" | lemonbar -f "$panel_font" -B "$background" -F "$foreground" -g "$panel_width"x"$panel_height"+"$panel_horizontal_offset"+"$panel_vertical_offset" -n "$panel_wm_name" | sh &
