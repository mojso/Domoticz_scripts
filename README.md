# Domoticz Scripts



## Domoticz backup to USB device. 

Domoticz_backup_to_usb_drive.sh

* checks if the USB is mounted
* then makes a backup of domoticz.db, the entire Domoticz folder and the Domoticz.sh file in etc_init_d
* notifies if the backup was successfully made
* If the USB is not mounted, reports that the backup failed


## Internet speed measurement, Speedtest-cli in Docker container

Speedtest.sh

* Internet speed measurement, Speedtest-cli in Docker container, script modification from this link
https://www.domoticz.com/wiki/Bash_-_Speedtest.net_Download/Upload/Ping_monitoring

* and Internet Speed Test in a Container from here
https://github.com/robinmanuelthiel/speedtest?tab=readme-ov-file

## Internet speed measurement, Speedtest-cli in Docker container from Libreelec - Kodi
SpeedTestfromLibreelecKodi.sh

## Earthquake info from www.seismicportal.eu

EarthquakeEuRadius.lua

Earthquake info from www.seismicportal.eu
more detailed information on telegram about the earthquake

# Venetian Blinds  and Device to control  Blindsv from Dmoticz

-- Blinds dimmer script using ESPEasy by mojso
-- 1. put the script in Events as Lua script
-- 2.in setup -> more option --> user variable put in variable name dimmer -- , variable type string and update
-- 3.Setup -> Hardware  dymmy device 
--create virtual device,  Select rgb switch,  
-- Then in Switches find the created device end click edit. -- then in switch type select blinds precentage and save
