#!/bin/bash

SCRIPT=$(readlink -f "$0") # Absolute path to this script, e.g. /home/user/bin/foo.sh
echo "SCRIPT= "$SCRIPT
SCRIPTPATH=$(dirname "$SCRIPT") # Absolute path this script is in, e.g. /home/user/bin
echo "SCRIPTPATH= "$SCRIPTPATH

. $SCRIPTPATH/params.conf

url="https://api.voicerss.org/?key="$voicerss_key"&hl=en-us&src="

clear="The national weather service has no current alerts, watches, or warnings for "
alert="Updated weather information for "

clearurl=$( printf "%s\n" "$url$clear$county_name" | sed 's/ /%20/g' )
alerturl=$( printf "%s\n" "$url$clear$county_name" | sed 's/ /%20/g' )

wget -U Mozilla -O "/tmp/clear.wav" $clearurl
wget -U Mozilla -O "/tmp/alert.wav" $alerturl

cp $SCRIPTPATH/AUTOSKY/SOUNDS/asn96Z.wav $SCRIPTPATH/AUTOSKY/SOUNDS/asn96Z.wav.old
cp $SCRIPTPATH/AUTOSKY/SOUNDS/asn97.wav $SCRIPTPATH/AUTOSKY/SOUNDS/asn97.wav.old

echo "Compiling audio files..."
sox $SCRIPTPATH/AUTOSKY/SOUNDS/asn96Z-tweet.wav /tmp/clear.wav $SCRIPTPATH/AUTOSKY/SOUNDS/asn96Z.wav
echo "asn96Z.wav saved to "$SCRIPTPATH"/AUTOSKY/SOUNDS/asn96Z.wav"
sox $SCRIPTPATH/AUTOSKY/SOUNDS/asn97-tweet.wav /tmp/alert.wav $SCRIPTPATH/AUTOSKY/SOUNDS/asn97.wav
echo "asn97.wav saved to "$SCRIPTPATH"/AUTOSKY/SOUNDS/asn97.wav"
echo "Done."