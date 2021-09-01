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

cp $(pwd)/asn96Z.wav $(pwd)/asn96Z.wav.old
cp $(pwd)/asn97.wav $(pwd)/asn97.wav.old

echo "Compiling audio files..."
sox $(pwd)/asn96Z-tweet.wav /tmp/clear.wav $(pwd)/asn96Z.wav
sox $(pwd)/asn97-tweet.wav /tmp/alert.wav $(pwd)/asn97.wav