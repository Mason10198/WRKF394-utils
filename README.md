# WRKF394-utils
This is a package of utilities for linked repeaters in the Arkansas GMRS Repeater Group.

---

## Installation

Do not forget to edit `params.conf` before installing.

    $ cd /home/repeater
    $ git clone https://github.com/mason10198/WRKF394-utils.git
    $ cd WRKF394-utils
    $ sudo chmod +x install.sh
    $ ./install.sh

---

## Usage
All scripts can be scheduled in via `crontab`

- To have AutoSkywarn check every 60 seconds for severe weather:
    - `*/1 * * * * /home/repeater/WRKF394-utils/AUTOSKY/AutoSky1`
- For an hourly time announcement with greeting & current weather conditions:
    - `00 * * * * /usr/bin/perl /home/repeater/WRKF394-utils/say_time.pl [zipcode] [nodenumber]`
- For an hourly "short" time announcement:
    - `00 * * * * /usr/bin/perl /home/repeater/WRKF394-utils/say_short_time.pl [nodenumber]`
- For an hourly time announcement with greeting & current weather conditions, followed by a local forecast for the remainder of the day:
    - `00 * * * * /home/repeater/WRKF394-utils/say_wx_time.sh`

---

## Updating
To update the node information file and download new nodename audio files:

`cd /home/repeater/WRKF394-utils`

`./update.sh`