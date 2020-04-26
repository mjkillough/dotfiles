#!/bin/sh

. ~/.profile

xrdb ~/.Xresources

setxkbmap "gb(mac)"

syndaemon -i 0.5 -d

/home/mjk/Code/cnx/target/debug/cnx &
exec /home/mjk/Code/lanta/target/debug/lanta
