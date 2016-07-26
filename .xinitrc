#!/bin/sh

# Need to start daemon for Sublime Text 3 to pickup settings.
/usr/lib/gnome-settings-daemon/gnome-settings-daemon-localeexec &
gsettings set org.gnome.desktop.interface scaling-factor 2

compton --vsync drm &

source ~/.profile

random-wallpaper

xrdb -merge ~/.Xresources

exec qtile


