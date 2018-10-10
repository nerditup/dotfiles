#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# VirtualBox Guest Additions
#VBoxClient-all

# Synchronize PRIMARY and CLIPBOARD
autocutsel -fork &
autocutsel -selection PRIMARY -fork &
# Composite Manager
compton -b --config ~/.compton.conf &
# Keyboard Function Keys
xbindkeys &
# Terminal Emulator Daemon
urxvtd -q -f &
# Automounter
udiskie &
# Wallpaper
$HOME/.config/feh/.fehbg &
# Bar
$HOME/.config/lemonbar/.lemonbar &
# Window Manager
exec bspwm
