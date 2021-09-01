#!/bin/bash
. /home/repeater/WRKF394-utils/params.conf
/home/repeater/WRKF394-utils/say_time.pl $zip_code $node_number 1
/home/repeater/WRKF394-utils/save_weather.sh -f
sox -V /tmp/current-time.gsm -r 8000 -c 1 -t ul /tmp/currenttime.ul
sox /tmp/currenttime.ul /home/repeater/WRKF394-utils/silence.ul /tmp/daycast.ul /tmp/combined_time_forecast.ul
astcmd="rpt localplay "$node_number" /tmp/combined_time_forecast"
/usr/sbin/asterisk -rx \"$astcmd\"