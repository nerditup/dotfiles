#!/bin/sh

# Pull the Colours from Xresources
foreground=$(xrdb -query | grep 'foreground:'| awk '{printf "%s", $NF}')
background=$(xrdb -query | grep 'background:'| awk '{printf "%s", $NF}')
black=$(xrdb -query | grep 'color0:'| awk '{printf "%s", $NF}')
red=$(xrdb -query | grep 'color1:'| awk '{printf "%s", $NF}')
green=$(xrdb -query | grep 'color2:'| awk '{printf "%s", $NF}')
yellow=$(xrdb -query | grep 'color3:'| awk '{printf "%s", $NF}')
blue=$(xrdb -query | grep 'color4:'| awk '{printf "%s", $NF}')
magenta=$(xrdb -query | grep 'color5:'| awk '{printf "%s", $NF}')
cyan=$(xrdb -query | grep 'color6:'| awk '{printf "%s", $NF}')
white=$(xrdb -query | grep 'color7:'| awk '{printf "%s", $NF}')
