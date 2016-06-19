xrdb -merge ~/.Xresources

# Puts the same background on two monitors:
feh --bg-fill ~/Photos/wallpaper --bg-fill ~/Photos/wallpaper &

# Need to start daemon for Sublime Text 3 to pickup settings.
/usr/lib/gnome-settings-daemon/gnome-settings-daemon-localeexec &
gsettings set org.gnome.desktop.interface scaling-factor 2

compton --vsync drm &

source ~/.profile

exec qtile

