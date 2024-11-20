#!/bin/bash

echo "Display $DISPLAY" > /home/linaro/mytempx/display
echo "tty $(tty)" > /home/linaro/mytempx/tty

if [ "$(tty)" == "/dev/ttyFIQ0" ]; then
  nohup startx &
fi

#exec startx

