WX_file="/tmp/alert.txt"
# Remove periods from beginning of lines
sed -i -e 's/^\.//' $WX_file

# Remove multiple periods, leave single periods
#sed -i -r -e 's/\.{2,}/ /' $WX_file

# Alter text for proper weather vocalization
sed -i -e 's/mph/miles per hour/g' $WX_file
sed -i -e 's/MPH/miles per hour/g' $WX_file
sed -i -e 's/ CDT/ central daylight time, /g' $WX_file
sed -i -e 's/  */ /g' $WX_file
sed -i -e 's/\*//g' $WX_file
sed -i -e 's/WHAT/WHAT,/g' $WX_file
sed -i -e 's/WHERE/WHERE,/g' $WX_file
sed -i -e 's/WHEN/WHEN,/g' $WX_file
sed -i -e 's/IMPACTS/IMPACTS,/g' $WX_file

# Remove newlines
sed -i ':a;N;$!ba;s/\n/ /g' $WX_file

# add new header
sed -i '1s/^/The following message contains current weather alerts for saline county. /' $WX_file

sed -i -e 's/  */ /g' $WX_file
sed -i -e 's/and/, and/g' $WX_file
sed -i -e 's/ ,//g' $WX_file
sed -i -e 's/SALINE/suhleen/g' $WX_file
sed -i -e 's/saline/suhleen/g' $WX_file
sed -i -e 's/Saline/suhleen/g' $WX_file

