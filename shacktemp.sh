#!/bin/bash
url="https://api.voicerss.org/?key=b48acdb943e446c8b67dec46fb24f51e&hl=en-us&src="
temp=$(python3 /home/repeater/gettemp.py 1)
fullurl=$url$temp
fullurl2=$( printf "%s\n" "$fullurl" | sed 's/ /%20/g' )
wget -U Mozilla -O "/tmp/shacktemp.wav" $fullurl2
sox -V /tmp/shacktemp.wav -r 8000 -c 1 -t ul /tmp/shacktemp.ul
asterisk -rx "rpt localplay 1998 /tmp/shacktemp"
