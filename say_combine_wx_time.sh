#!/bin/bash
/home/repeater/saytime.pl 72122 1998 1
/home/repeater/saveweather.sh -f
sox -V /tmp/current-time.gsm -r 8000 -c 1 -t ul /tmp/currenttime.ul
sox /tmp/currenttime.ul /home/repeater/silence.ul /tmp/Saline.ul /tmp/combined_time_forecast.ul
/usr/sbin/asterisk -rx "rpt localplay 1998 /tmp/combined_time_forecast"
#cp /tmp/combined_time_forecast.ul /home/repeater/test.ul
