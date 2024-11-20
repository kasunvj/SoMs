#!/bin/sh-e

# /etc/X11/xinit/xinitrc
#
# global xinitrc file, used by all X sessions started by xinit (startx)

# invoke global X session script
#. /etc/X11/Xsession

xset -dpms           # Disable DPMS (Energy Star) features
xset s off           # Disable screen saver
xset s noblank       # Disable screen blanking
matchbox-window-manager &

xrandr --output HDMI-1 --rotate left
node /home/linaro/server/server.js &
sleep 4
midori -e Fullscreen -e Navigationbar -a http://127.0.0.1:3000/ &
wmctrl -r :ACTIVE: -b add,fullscreen

xdotool mousemove 10 10

#exec xterm
while true; do
        sleep 3600
        xdotool key "r"
done

