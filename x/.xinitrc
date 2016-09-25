#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Need to start daemon for Sublime Text 3 to pickup settings.
/usr/lib/gnome-settings-daemon/gnome-settings-daemon-localeexec &
gsettings set org.gnome.desktop.interface scaling-factor 2

#compton --vsync drm &

source ~/.profile

set-wallpaper --copy-root-window
random-wallpaper

# Might need to do this again after changing DPI, even though lightdm
# does it.
xrdb -merge ~/.Xresources

exec qtile

