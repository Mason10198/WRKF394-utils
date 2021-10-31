# WRKF394-utils

This package contains the following tools & utilities:
- [AutoSkywarn](https://kizzy03.wixsite.com/kf5vh/auto-skywarn)
    - Suite of tools for automatically checking for and announcing severe weather alerts. Documentation available at link above.
- `read_alerts.php`
    - Supplementary to AutoSkywarn, this script reads current weather alerts in more detail. Ex: AutoSkywarn will only say "tornado warning", whereas `read_alerts.php` will tell you when, where, direction, speed, etc.
- `say_daycast.sh`
    - Announces the forecast for the remainder of the current day
- `say_time.pl`
    - Says a greeting, and announces the current time and/or weather conditions
- `say_short_time.pl`
    - The same as `say_time.pl`, but without greeting
- `say_wx_time.sh`
    - Announces the combined output of `say_time.pl` and `say_daycast.sh`

All of the above utilities are intended to be scheduled via `crontab` and will, by default, do ***nothing*** until `crontab` entries are manually added.

# Installation

***FIRST***, make sure you are using the [ASL 2.0.0 beta image](http://downloads.allstarlink.org/index.php?b=ASL_Images_Beta) and have completed the *first-time setup* in the ASL menu (run `$ asl-menu`) to configure your node with your correct node number (node password is not used and can be left blank).

***AFTER*** you have a configured setup and have verified that your interface settings are good, audio levels are good, and have done ***ALL*** of the proper setup and tuning, you may proceed.

---
Download the package:

    $ cd /home/repeater
    $ git clone https://github.com/mason10198/WRKF394-utils.git
    $ cd WRKF394-utils

Edit `params.conf` before building audio files. The `params.conf` file itself contains instructions on how to do this.

    $ nano params.conf

After this is done, run the audio file builder:
    
    $ sudo chmod +x build_audio.sh
    $ ./build_audio.sh

### NOTE: The package ***MUST*** be located at `/home/repeater/WRKF394-utils`

# Script Usage Examples
All scripts can be scheduled in via `crontab`. Here are some examples of `crontab` entries:

- To have AutoSkywarn check every 60 seconds for severe weather:

        */1 * * * * /home/repeater/WRKF394-utils/AUTOSKY/AutoSky1

- For an hourly time announcement with greeting & current weather conditions:

        00 * * * * /usr/bin/perl /home/repeater/WRKF394-utils/say_time.pl [zipcode] [nodenumber]

- For an hourly "short" time announcement:

        00 * * * * /usr/bin/perl /home/repeater/WRKF394-utils/say_short_time.pl [nodenumber]

- For an hourly time announcement with greeting & current weather conditions, followed by a local forecast for the remainder of the day:
        
        00 * * * * /home/repeater/WRKF394-utils/say_wx_time.sh

Remember that you can tie any of these scripts to a DTMF command in `rpt.conf`.

Hint:

- You hear AutoSkywarn announce a "special weather statement"
- You think to yourself, "I wonder what the special weather is..."
- You key *83 into your radio and `read_alerts.php` runs, telling you all of the details of the "special weather statement"
