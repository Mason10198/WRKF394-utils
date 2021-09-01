#!/bin/bash
. ./params.conf
cd $(pwd)/AUTOSKY/SOUNDS
url="https://api.voicerss.org/?key="$voicerss_key"&hl=en-us&src="

clear="The national weather sevice has no current alerts, watches, or warnings for "
alert="Updated weather information for "

clearurl=$( printf "%s\n" "$url$clear$county_name" | sed 's/ /%20/g' )
alerturl=$( printf "%s\n" "$url$clear$county_name" | sed 's/ /%20/g' )

wget -U Mozilla -O "/tmp/clear.wav" $clearurl
wget -U Mozilla -O "/tmp/alert.wav" $alerturl

if test -f "as96Z.wav"; then
    mv asn96Z.wav asn96Z.wav.old
    sox asn96Z-tweet.wav /tmp/clear.wav asn96Z.wav
else
    echo "asn96Z.wav not detected!"
fi
if test -f "as97.wav"; then
    mv asn97.wav asn97.wav.old
    sox asn97-tweet.wav /tmp/alert.wav asn97.wav
else
    echo "asn97.wav not detected!"
fi