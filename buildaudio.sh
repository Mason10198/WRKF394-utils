#!/bin/bash
. ./params.conf
url="https://api.voicerss.org/?key="$voicerss_key"&hl=en-us&src="

clear="The national weather sevice has no current alerts, watches, or warning for "
alert="Updated weather information for "

clearurl=$( printf "%s\n" "$url$clear$county_name" | sed 's/ /%20/g' )
alerturl=$( printf "%s\n" "$url$clear$county_name" | sed 's/ /%20/g' )

wget -U Mozilla -O "/tmp/clear.wav" $clearurl
wget -U Mozilla -O "/tmp/alert.wav" $alerturl

rm ./AUTOSKY/SOUNDS/asn96Z.wav.old
rm ./AUTOSKY/SOUNDS/asn97.wav.old

mv ./AUTOSKY/SOUNDS/asn96Z.wav ./AUTOSKY/SOUNDS/asn96Z.wav.old
mv ./AUTOSKY/SOUNDS/asn97.wav ./AUTOSKY/SOUNDS/asn97.wav.old

sox ./AUTOSKY/SOUNDS/asn96Z.wav /tmp/clear.wav ./AUTOSKY/SOUNDS/asn96Z.wav
sox ./AUTOSKY/SOUNDS/asn97.wav /tmp/alert.wav ./AUTOSKY/SOUNDS/asn97.wav