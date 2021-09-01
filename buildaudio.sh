#!/bin/bash
. ./params.conf
cd $(dirname "$0")/AUTOSKY/SOUNDS
url="https://api.voicerss.org/?key="$voicerss_key"&hl=en-us&src="

clear="The national weather service has no current alerts, watches, or warnings for "
alert="Updated weather information for "

clearurl=$( printf "%s\n" "$url$clear$county_name" | sed 's/ /%20/g' )
alerturl=$( printf "%s\n" "$url$clear$county_name" | sed 's/ /%20/g' )

wget -U Mozilla -O "/tmp/clear.wav" $clearurl
wget -U Mozilla -O "/tmp/alert.wav" $alerturl

cp $(dirname "$0")/asn96Z.wav $(dirname "$0")/asn96Z.wav.old
cp $(dirname "$0")/asn97.wav $(dirname "$0")/asn97.wav.old

echo "Compiling audio files..."
sox $(dirname "$0")/asn96Z-tweet.wav /tmp/clear.wav $(dirname "$0")/asn96Z.wav
sox $(dirname "$0")/asn97-tweet.wav /tmp/alert.wav $(dirname "$0")/asn97.wav
echo "Done."