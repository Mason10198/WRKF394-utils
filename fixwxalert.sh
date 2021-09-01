WX_file="/tmp/alert.txt"
# Remove periods from beginning of lines
sed -i -e 's/^\.//' $WX_file

# Remove multiple periods, leave single periods
sed -i -r -e 's/\.{2,}/ /' $WX_file

# Alter text for proper weather vocalization
sed -i -e 's/mph/miles per hour/g' $WX_file
sed -i -e 's/MPH/miles per hour/g' $WX_file
sed -i -e 's/kph/kilometers per hour/g' $WX_file
sed -i -e 's/KPH/kilometers per hour/g' $WX_file
sed -i -e 's/winds/wends/g' $WX_file
sed -i -e 's/Winds/wends/g' $WX_file
sed -i -e 's/WINDS/wends/g' $WX_file
sed -i -e 's/wind/wend/g' $WX_file
sed -i -e 's/Wind/wend/g' $WX_file
sed -i -e 's/WIND/wend/g' $WX_file
#sed -i -e 's/wind/wind,/g' $WX_file
sed -i -e 's/ est /\U&/g' $WX_file
sed -i -e 's/ edt /\U&/g' $WX_file
#sed -i -e 's/ CST / Central Standard Time /g' $WX_file  # Change this for your Time ZONE
#sed -i -e 's/ CDT / Central Daylight Time /g' $WX_file  #   "      "   "   "    "    "
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
sed -i -e 's/IN/inches/g' $WX_file
sed -i -e 's/MIN/minimum/g' $WX_file
sed -i -e 's/MAX/maximum/g' $WX_file
sed -i -e 's/ 0./ zero point /g' $WX_file
#sed -i -e '/hdisk/!d' -e 's/ \{2,\}/ /g' $WX_file
sed -i -e 's/ CDT/ central daylight time, /g' $WX_file
#sed -i -e 's/.../,/g' $WX_file
sed -i -e 's/SOURCE//g' $WX_file
sed -i -e 's/IMPACT//g' $WX_file
sed -i -e 's/HAZARD//g' $WX_file
sed -i -e 's/  */ /g' $WX_file
#sed -i -e 's/SALINE/suhleen/g' $WX_file
#sed -i -e 's/saline/suhleen/g' $WX_file
#sed -i -e 's/Saline/suhleen/g' $WX_file

# Fix Time/Date for proper Vocalization
#D1=$(cat $WX_file | awk "c&&!--c;/$WeatherLocation/{c=2}" | cut -c -4)
#D2=$(printf "%04d\n" $D1)
#D3=". $(date -d"$D2" +%H:%M | sed 's/^0*//')"
#linen="$(cat $WX_file | awk "c&&!--c;/$WeatherLocation/{c=2}" | sed  's/....//') ." 
#LineNum=$(cat $WX_file | awk "/$WeatherLocation/{ print NR+2; exit }")
#sed -i "$LineNum s/.*/$D3$linen/" $WX_file

# Remove newlines
sed -i ':a;N;$!ba;s/\n/ /g' $WX_file

# add new header
sed -i '1s/^/The following message contains current weather alerts for saline county. /' $WX_file

#sed -i -e 's/^.*\(This is*Locations impacted include\).*$/\1/' $WX_file
#sed -i 's/\Locations impacted include*/./' $WX_file
sed -i 's/Locations impacted.*//' $WX_file
sed -i -e 's/  */ /g' $WX_file
sed -i -e 's/and/, and/g' $WX_file
sed -i -e 's/ ,//g' $WX_file
sed -i -e 's/SALINE/suhleen/g' $WX_file
sed -i -e 's/saline/suhleen/g' $WX_file
sed -i -e 's/Saline/suhleen/g' $WX_file

