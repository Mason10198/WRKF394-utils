#!/bin/bash

. /home/repeater/WRKF394-utils/params.conf

install_utils () {
    echo "Setting exec permissions..."
    sudo chmod -R +x /home/repeater/WRKF394-utils/

    echo "Building audio files..."
    sudo /home/repeater/WRKF394-utils/build_audio.sh

    echo "Building local node name file..."
    wget -q -U Mozilla -O "/home/repeater/WRKF394-utils/nodenames/"$node_number".wav" "https://api.voicerss.org/?key="$voicerss_key"&hl=en-us&src="$repeater_name

    echo "Moving node name files..."
    sudo rm -rf /var/lib/asterisk/sounds/rpt/nodenames
    sudo cp -avr /home/repeater/WRKF394-utils/nodenames /var/lib/asterisk/sounds/rpt/nodenames

    echo ""
    echo "Done. Hopefully nothing explodes :)"
}

while true; do
    read -p "WARNING: You must FIRST configure params.conf for your system. Do you wish to continue? y/n - " yn
    case $yn in
        [Yy]* ) install_utils; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done