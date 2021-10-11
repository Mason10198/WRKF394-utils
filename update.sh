#!/bin/bash
echo "Updating nodename audio files and privatenodes.txt..."
sudo rm -rf /tmp/WRKF394-utils/
git clone http://github.com/mason10198/WRKF394-utils /tmp/WRKF394-utils/
sudo cp /tmp/WRKF394-utils/nodenames/* /home/repeater/WRKF394-utils/nodenames/
sudo cp /tmp/WRKF394-utils/privatenodes.txt /home/repeater/WRKF394-utils/
echo "Moving node name files..."
sudo cp -avr /tmp/WRKF394-utils/nodenames /var/lib/asterisk/sounds/rpt/nodenames
echo "Moving privatenodes.txt..."
sudo cp /tmp/WRKF394-utils/privatenodes.txt /var/www/html/allmon2/privatenodes.txt
sudo cp /tmp/WRKF394-utils/privatenodes.txt /var/www/html/supermon/privatenodes.txt
echo "Updating node info via astdb.php..."
sudo chmod +x /var/www/html/allmon2/astdb.php
sudo chmod +x /var/www/html/supermon/astdb.php
sudo /var/www/html/allmon2/astdb.php
sudo /var/www/html/supermon/astdb.php