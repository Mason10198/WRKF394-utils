#!/bin/bash

. /home/repeater/WRKF394-utils/params.conf

install_utils () {
    echo "Setting exec permissions..."
    sudo chmod -R +x /home/repeater/WRKF394-utils/

    echo "Building audio files..."
    url="https://api.voicerss.org/?key="$voicerss_key"&hl=en-us&src="

    clear="The national weather service has no current alerts, watches, or warnings for "
    alert="Updated weather information for "

    clearurl=$( printf "%s\n" "$url$clear$county_name" | sed 's/ /%20/g' )
    alerturl=$( printf "%s\n" "$url$alert$county_name" | sed 's/ /%20/g' )

    wget -U Mozilla -O "/tmp/clear.wav" $clearurl
    wget -U Mozilla -O "/tmp/alert.wav" $alerturl

    cp $base_dir/AUTOSKY/SOUNDS/asn96Z.wav $base_dir/AUTOSKY/SOUNDS/asn96Z.wav.old
    cp $base_dir/AUTOSKY/SOUNDS/asn97.wav $base_dir/AUTOSKY/SOUNDS/asn97.wav.old

    echo "Compiling audio files..."
    sox $base_dir/AUTOSKY/SOUNDS/asn96Z-tweet.wav /tmp/clear.wav $base_dir/AUTOSKY/SOUNDS/asn96Z.wav
    sox $base_dir/AUTOSKY/SOUNDS/asn97-tweet.wav /tmp/alert.wav $base_dir/AUTOSKY/SOUNDS/asn97.wav
    
    echo "Building local node name file..."
    wget -U Mozilla -O "/home/repeater/WRKF394-utils/nodenames/"$node_number".wav" "https://api.voicerss.org/?key="$voicerss_key"&hl=en-us&src="$( printf "%s\n" "$repeater_name" | sed 's/ /%20/g' )
    sox -V "/home/repeater/WRKF394-utils/nodenames/"$node_number".wav" -r 8000 -c 1 -t ul "/home/repeater/WRKF394-utils/nodenames/"$node_number".ul"
    rm "/home/repeater/WRKF394-utils/nodenames/"$node_number".wav"

    echo "Moving node name files..."
    sudo rm -rf /var/lib/asterisk/sounds/rpt/nodenames
    sudo cp -avr /home/repeater/WRKF394-utils/nodenames /var/lib/asterisk/sounds/rpt/nodenames

    echo "Moving privatenodes.txt..."
    sudo cp /home/repeater/WRKF394-utils/privatenodes.txt /var/www/html/allmon2/privatenodes.txt
    sudo cp /home/repeater/WRKF394-utils/privatenodes.txt /var/www/html/supermon/privatenodes.txt

    echo "Updating node info via astdb.php..."
    sudo chmod +x /var/www/html/allmon2/astdb.php
    sudo chmod +x /var/www/html/supermon/astdb.php
    sudo /var/www/html/allmon2/astdb.php
    sudo /var/www/html/supermon/astdb.php


    echo ""
    echo "Done. Hopefully nothing explodes :)"
    echo ""
}

while true; do
    read -p "WARNING: You must FIRST configure params.conf for your system. Do you wish to continue? y/n - " yn
    case $yn in
        [Yy]* ) install_utils; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer '"'y'"' or '"'n'"'.";;
    esac
done