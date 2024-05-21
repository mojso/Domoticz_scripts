#!/bin/bash
### This script was created by mojso
### https://github.com/mojso/Domoticz_scripts

DOMO_IP="127.0.0.1"  # Domoticz IP 
DOMO_PORT="8080"        # Domoticz port 
CHECKMOUNT="/media/pi/UsbStorage5"  #address of the usb device to check if it is mounted
BACKUPFOLDER="/media/pi/UsbStorage5/domoticz/Domoticz_backup" #backup folder address
BMSGOK="Бекапот%20од%20Domoticz%20е%20направен" #message notification if the backup is successful
BMSGNOTOK="УСБ-то%20не%20е%20монтирано%20Бекапот%20од%20Domoticz%20не%20е%20направен%20!!!!" #message notification if the backup is not successful
SLEEP_TIME="2"
### END OF USER CONFIGURABLE PARAMETERS
TIMESTAMP=`/bin/date +%Y%m%d%H%M%S`
BACKUPFILE="domoticzbackup_$TIMESTAMP.db" # backups will be named "domoticz_YYYYMMDDHHMMSS.db.gz"
BACKUPFILEGZ="$BACKUPFILE".gz

if mountpoint -q $CHECKMOUNT
then
   
   #Create backup and make tar archives
mkdir -p "$BACKUPFOLDER"/database
/usr/bin/sudo curl -sS http://$DOMO_IP:$DOMO_PORT/backupdatabase.php > "$BACKUPFOLDER"/database/$BACKUPFILE
#mkdir -p "$BACKUPFOLDER"/scripts
#tar -zcvf /media/pi/UsbStorage2/domoticz/Domoticz_backup/scripts/domoticz_scripts_$TIMESTAMP.tar.gz /home/pi/domoticz/scripts/
#mkdir -p "$BACKUPFOLDER"/www
#tar -zcvf /media/pi/UsbStorage2/domoticz/Domoticz_backup/www/domoticz_wwwfolder_$TIMESTAMP.tar.gz /home/pi/domoticz/www/
sleep ${SLEEP_TIME}
mkdir -p "$BACKUPFOLDER"/domoticz_all
tar --exclude backups -zcvf "$BACKUPFOLDER"/domoticz_all/domoticz_all_$TIMESTAMP.tar.gz  /home/pi/domoticz/
sleep ${SLEEP_TIME}
mkdir -p "$BACKUPFOLDER"/etc_init_d
tar -zcvf "$BACKUPFOLDER"/etc_init_d/domoticz_sh_$TIMESTAMP.tar.gz -P /etc/init.d/domoticz.sh

#Delete backups older than 31 days
/usr/bin/find "$BACKUPFOLDER"/database/ -name '*.db' -mtime +31 -delete
#/usr/bin/find /media/pi/UsbStorage2/domoticz/Domoticz_backup/scripts/ -name '*.tar.gz' -mtime +31 -delete
#/usr/bin/find /media/pi/UsbStorage2/domoticz/Domoticz_backup/www/ -name '*.tar.gz' -mtime +31 -delete
/usr/bin/find "$BACKUPFOLDER"/domoticz_all/ -name '*.tar.gz' -mtime +25 -delete
/usr/bin/find "$BACKUPFOLDER"/etc_init_d/ -name '*.tar.gz' -mtime +31 -delete

#message notification if the backup is successful
curl -X post 'http://'$DOMO_IP:$DOMO_PORT'/json.htm?type=command&param=sendnotification&subject=BACKUP%20Domoticz&body='$BMSGOK'&subsystem=kodi;telegram'
 curl  -X post 'http://'$DOMO_IP:$DOMO_PORT'/json.htm?type=command&param=udevice&idx=1335&nvalue=0&svalue='$BMSGOK%20$TIMESTAMP''
   
else
   #echo "not mounted"
   #message notification if the backup is not successful
   curl -X post 'http://'$DOMO_IP:$DOMO_PORT'/json.htm?type=command&param=sendnotification&subject=BACKUP%20Domoticz&body='$BMSGNOTOK'&subsystem=kodi;telegram'
   curl  -X post 'http://'$DOMO_IP:$DOMO_PORT'/json.htm?type=command&param=udevice&idx=1335&nvalue=0&svalue='$BMSGNOTOK%20$TIMESTAMP''
   fi

