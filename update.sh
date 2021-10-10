#!/bin/bash
echo "Updating nodename audio files and privatenodes.txt..."
sudo rm -rf /tmp/WRKF394-utils/
git clone http://github.com/mason10198/WRKF394-utils /tmp/WRKF394-utils/
sudo mv /tmp/WRKF394-utils/nodenames/* /home/repeater/WRKF394-utils/nodenames/
sudo mv /tmp/WRKF394-utils/privatenodes.txt /home/repeater/WRKF394-utils/
echo ""
echo "Update downloaded. You need to re-run the installer to apply the update."
echo ""
while true; do
    read -p "Would you like to run the installer now? y/n - " yn
    case $yn in
        [Yy]* ) ./install.sh; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer '"'y'"' or '"'n'"'.";;
    esac
done