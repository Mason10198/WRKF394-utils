# WRKF394-utils

This package contains install/update scripts to aid in the creation & downloading of Arkansas GMRS Repeater Group node information, as well as the following tools & utilities:
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

Edit `params.conf` before installing. The file itself contains instructions on how to do this.

Once `params.conf` is configured for your node:

    $ cd /home/repeater
    $ git clone https://github.com/mason10198/WRKF394-utils.git
    $ cd WRKF394-utils
    $ sudo chmod +x install.sh
    $ ./install.sh

### NOTE: The package ***MUST*** be located at `/home/repeater/WRKF394-utils`

# Linking

If you are setting up a repeater/node that will link to the Arkansas GMRS Repeater Group network, you will also need to install `wireguard` VPN and configure it to connect to our network, as well as make a few changes to your `rpt.conf` file.

## Wireguard VPN

Begin by installing the `wireguard` package:

    $ sudo apt update
    $ sudo apt install wireguard

Then configure `wireguard` by editing `wg0.conf` and adding your profile information (you should get this from an **admin**):

    $ sudo nano /etc/wireguard/wg0.conf

Once your profile information has been added to `wg0.conf`, you should tell `wireguard` to connect at boot:

    $ sudo systemctl enable wg-quick@wg0.service
    $ sudo systemctl daemon-reload

Now you can either reboot and let the VPN autostart, or manually start the VPN now:

    $ sudo systemctl start wg-quick@wg0

You should now be able to run `ifconfig` and see the interface `wg0` connected with an IP address of `10.6.0.x`.

## Editing Asterisk Config Files
You now need to configure your `rpt.conf` file so that Asterisk knows how to connect to your regional hub:

    $ sudo nano /etc/asterisk/rpt.conf

Underneath the line containing `[node_number] = radio@[ip_address]:4569/[node_number],NONE`, you need to add a similar line with the same formatting, containing the definition for the hub you are wanting to link to. You should get this information from an **admin**.

# Usage
All scripts can be scheduled in via `crontab`. Here are some examples of `crontab` entries:

- To have AutoSkywarn check every 60 seconds for severe weather:

        */1 * * * * /home/repeater/WRKF394-utils/AUTOSKY/AutoSky1

- For an hourly time announcement with greeting & current weather conditions:

        00 * * * * /usr/bin/perl /home/repeater/WRKF394-utils/say_time.pl [zipcode] [nodenumber]

- For an hourly "short" time announcement:

        00 * * * * /usr/bin/perl /home/repeater/WRKF394-utils/say_short_time.pl [nodenumber]

- For an hourly time announcement with greeting & current weather conditions, followed by a local forecast for the remainder of the day:
        
        00 * * * * /home/repeater/WRKF394-utils/say_wx_time.sh

# Updating Node Information
To update the node information file for Allmon2 and Supermon, and download new nodename audio files:

    $ cd /home/repeater/WRKF394-utils
    $ ./update_nodeinfo.sh

It is recommended that you schedule this updater script to run automatically in `crontab`:

    0 0 * * * /home/repeater/WRKF394-utils/update_nodeinfo.sh