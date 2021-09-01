#!/bin/bash

# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")

. /home/repeater/WRKF394-utils/params.conf

url="https://api.voicerss.org/?key="$voicerss_key"&hl=en-us&src="

clear="The national weather service has no current alerts, watches, or warnings for "
alert="Updated weather information for "

clearurl=$( printf "%s\n" "$url$clear$county_name" | sed 's/ /%20/g' )
alerturl=$( printf "%s\n" "$url$clear$county_name" | sed 's/ /%20/g' )

wget -U Mozilla -O "/tmp/clear.wav" $clearurl
wget -U Mozilla -O "/tmp/alert.wav" $alerturl

cp ./AUTOSKY/SOUNDS/asn96Z.wav ./AUTOSKY/SOUNDS/asn96Z.wav.old
cp ./AUTOSKY/SOUNDS/asn97.wav ./AUTOSKY/SOUNDS/asn97.wav.old

echo "Compiling audio files..."
sox ./AUTOSKY/SOUNDS/asn96Z-tweet.wav /tmp/clear.wav ./AUTOSKY/SOUNDS/asn96Z.wav
sox ./AUTOSKY/SOUNDS/asn97-tweet.wav /tmp/alert.wav /AUTOSKY/SOUNDS/asn97.wav
echo "Done."