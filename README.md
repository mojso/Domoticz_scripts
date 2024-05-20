# Domoticz Scripts



## Domoticz backup to USB device. 

Domoticz_backup_to_usb_drive.sh

* checks if the USB is mounted
* then makes a backup of domoticz.db, the entire Domoticz folder and the Domoticz.sh file in etc_init_d
* notifies if the backup was successfully made
* If the USB is not mounted, reports that the backup failed


## Internet speed measurement, Speedtest-cli in Docker container

* Internet speed measurement, Speedtest-cli in Docker container, script modification from this link
https://www.domoticz.com/wiki/Bash_-_Speedtest.net_Download/Upload/Ping_monitoring

* and Internet Speed Test in a Container from here
https://github.com/robinmanuelthiel/speedtest?tab=readme-ov-file
