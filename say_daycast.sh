#!/bin/bash

# D. Crompton WA3DSP 12/2018

# NOTE - this script requires voicerss
# http://www.voicerss.org be setup first.

# This is an example weather report script using voicerss
# and the National Weather Service text reporting.
# You must sign up with voicerss and update the configuration
# file with your key. The service is free for the level
# of activity most hams would have. See the TTS howto 
# at hamvoip.org for setup info.

# This script performs the required formatting of the NWS
# file for voicerss TTS. This is formatted for a particular
# text file format proviced by NWS. As of this writing it
# appears all zones use the same format but the format 
# could change at any time which would require re-analysis
# of this script. The formatting is done in a logical order
# and is comment for each step that takes place.

# This script checks for an updated file and exits if the
# file has not changed . Users can force the update with
# a -f parameter.

# Visit - https://tgftp.nws.noaa.gov/data/forecasts/zone
# and pich your state and zone and use it in the wget line 
# below. Also  you weather location must be configured to
# the location described in the file. Here is an example -

#Expires:201812040900;;251725
#FPUS51 KPHI 032038
#ZFPPHI
#
#Zone Forecast Product for SE PA...NJ...and Northern Delmarva
#National Weather Service Mount Holly NJ
#330 PM EST Mon Dec 3 2018
#
#PAZ106-040900-
#Lower Bucks-   <<< THIS IS YOUR LOCATION. Use what is here for WeatherLocation
#Including the cities of Morrisville and Doylestown
#331 PM EST Mon Dec 3 2018

# Begin Script

# Set to location as shown above
# Must be exact including case

. /home/repeater/WRKF394-utils/params.conf
WeatherLocation=$wx_location

# Text base name
# Generally set to location name no spaces
# It is highly recommended this be in /tmp the default

# The audio file created is in the same directory
# with a .ul extent. Play it from there or if a
# more permanent file to where you want to play it from.
# /tmp files go away at boot.

WX_file="/tmp/daycast.txt"

echo -e "\nDownloading Weather Data\n"

#Get the weather data
url=$(echo "https://tgftp.nws.noaa.gov/data/forecasts/zone/"$state_code"/"$zone_code".txt" | sed -e 's/\(.*\)/\L\1/')
echo "URL = "$url
wget $url --no-check-certificate -O $WX_file

diff $WX_file /tmp/WX_prior.txt > /dev/null 2>&1

if [ $? -eq 0 ] && [ "$1" != "-f" ]
   then
      echo -e "Prior update matches current - use -f to force\n"
      exit
fi

cp $WX_file /tmp/WX_prior.txt

echo -e "Formatting Data\n"

# Strip off header
#sed -i -n "/$WeatherLocation/,\$p" $WX_file
#sed -i "s/.*Including //g" $WX_file

# Strip off tail
sed -i -e 's/\$//g' $WX_file

# Remove periods from beginning of lines
sed -i -e 's/^\.//' $WX_file

# Remove multiple periods, leave single periods
sed -i -r -e 's/\.{3,}/, /' $WX_file
#sed -i -e 's/../, /g' $WX_file

# Alter text for proper weather vocalization
sed -i -e 's/mph/miles per hour/g' $WX_file
sed -i -e 's/kph/kilometers per hour/g' $WX_file
sed -i -e 's/ winds/ wends/g' $WX_file
#sed -i -e 's/wind/wind,/g' $WX_file
sed -i -e 's/ est /\U&/g' $WX_file
sed -i -e 's/ edt /\U&/g' $WX_file
sed -i -e 's/ CST / Central Standard Time /g' $WX_file  # Change this for your Time ZONE
sed -i -e 's/ CDT / Central Daylight Time /g' $WX_file  #   "      "   "   "    "    "
sed -i -e 's/10s/tens,/g' $WX_file
sed -i -e 's/20s/twenties/g' $WX_file
sed -i -e 's/30s/thirties/g' $WX_file
sed -i -e 's/40s/forties/g' $WX_file
sed -i -e 's/50s/fifties/g' $WX_file
sed -i -e 's/60s/sixties/g' $WX_file
sed -i -e 's/70s/seventies/g' $WX_file
sed -i -e 's/80s/eighties/g' $WX_file
sed -i -e 's/90s/nineties/g' $WX_file
sed -i -e 's/100s/one hundreds/g' $WX_file

# Fix Time/Date for proper Vocalization
D1=$(cat $WX_file | awk "c&&!--c;/$WeatherLocation/{c=2}" | cut -c -4)
D2=$(printf "%04d\n" $D1)
D3=". $(date -d"$D2" +%H:%M | sed 's/^0*//')"
linen="$(cat $WX_file | awk "c&&!--c;/$WeatherLocation/{c=2}" | sed  's/....//') ." 
LineNum=$(cat $WX_file | awk "/$WeatherLocation/{ print NR+2; exit }")
sed -i "$LineNum s/.*/$D3$linen/" $WX_file

#remove first 4 lines
sed -i '1,14d' $WX_file

# Remove newlines
sed -i ':a;N;$!ba;s/\n/ /g' $WX_file

# strip old header
#sed -i -e 's/^\s*Including/Including/' $WX_file
#sed -i "s/.*Saline- //g" $WX_file

# add new header
txt="The following message contains todays weather forcast for "$county_name". "
sed -i "1s/^/$txt/" $WX_file

sed -i 's/SUNDAY.*//' $WX_file
sed -i 's/MONDAY.*//' $WX_file
sed -i 's/TUESDAY.*//' $WX_file
sed -i 's/WEDNESDAY.*//' $WX_file
sed -i 's/THURSDAY.*//' $WX_file
sed -i 's/FRIDAY.*//' $WX_file
sed -i 's/SATURDAY.*//' $WX_file

echo -e "File has $(wc -c < "$WX_file") Characters\n"

echo -e "Converting text to speech\n"

#tts_audio.sh $WX_file
#pico2wave -w /tmp/Saline.wav "$(cat $WX_file)"
url2="https://api.voicerss.org/?key="$voicerss_key"&hl=en-us&src="$(cat /tmp/daycast.txt)
url2=$( printf "%s\n" "$url2" | sed 's/ /%20/g' )
echo "URL = "$url2
wget -U Mozilla -O "/tmp/daycast.wav" $url2

# echo -e "TTS Complete - $(echo "$WX_file" | rev | cut -f 2- -d '.' | rev).ul Saved\n"
echo -e "TTS complete."
sleep 2

sox -V /tmp/daycast.wav -r 8000 -c 1 -t ul /tmp/daycast.ul

astcmd="rpt localplay "$node_number" /tmp/daycast"
sudo asterisk -rx $astcmd 
#/usr/sbin/asterisk -rx "rpt playback 1998 /tmp/Saline"

# END of Script
