#!/bin/bash
## This script was created by mojso
## https://github.com/mojso/Domoticz_scripts


#setup
host='localhost'
#idx for download, upload and ping
idxdl=1519
idxul=1520
idxpng=1521
idxbb=1522

# speedtest server number
# serverst=yyyy

# no need to edit
# speedtest-cli --simple --server $serverst > outst.txt
#speedtest-cli --simple > speedtest.txt
docker run --rm robinmanuelthiel/speedtest:latest > speedtest.txt

download=$(cat speedtest.txt | sed -n 's/.*download speed is \([0-9]*\) Mbps.*/\1/p')
upload=$(cat speedtest.txt | sed -n 's/.*upload speed is \([0-9]*\) Mbps.*/\1/p')
png=$(cat speedtest.txt | sed -n 's/Your ping is \(.*\) ms\./\1/p')

#download=$(cat speedtest.txt | sed -n 's/.*download speed is \([0-9]*\) Mbps.*/\1/p')
#upload=$(cat speedtest.txt | sed -n 's/.*upload speed is \([0-9]*\) Mbps.*/\1/p')
#png=$(cat speedtest.txt | sed -n 's/Your ping is \(.*\) ms\./\1/p')


# output if you run it manually
echo "Download = $download Mbps"
echo "Upload =  $upload Mbps"
echo "Ping =  $png ms"

# Updating download, upload and ping ..
wget -q --delete-after "http://$host/json.htm?type=command&param=udevice&idx=$idxdl&svalue=$download" >/dev/null 2>&1
wget -q --delete-after "http://$host/json.htm?type=command&param=udevice&idx=$idxul&svalue=$upload" >/dev/null 2>&1
wget -q --delete-after "http://$host/json.htm?type=command&param=udevice&idx=$idxpng&svalue=$png" >/dev/null 2>&1

# Reset Broadband switch
wget -q --delete-after "http://$host/json.htm?type=command&param=udevice&idx=$idxbb&svalue=0" >/dev/null 2>&1

# Domoticz logging
wget -q --delete-after "http://$host/json.htm?type=command&param=addlogmessage&message=speedtest.net-logging" >/dev/null 2>&1

