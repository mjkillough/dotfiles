#!/bin/sh

. ~/.profile

xrdb ~/.Xresources

# xbacklight thinks its set to 100, so calling it once will do nothing.
xbacklight -set 50
xbacklight -set 100

setxkbmap "gb(mac)"

syndaemon -i 0.5 -d

~/.fehbg &

cnx &
lanta &

while true; do
    sleep 10000;
done
