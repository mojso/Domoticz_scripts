#!/bin/bash
# Add this at the beginning of your script
exec 2>/storage/downloads/error.log
set -x
#setup
host='UAER:PASS@192.168.1.101:8080'
#idx for download, upload and ping
idxdl=1519
idxul=1520
idxpng=1521
idxbb=1522
path='/storage/downloads'
dockerpath='/storage/.kodi/addons/service.system.docker/bin'

# speedtest server number
# serverst=yyyy

# no need to edit
# speedtest-cli --simple --server $serverst > outst.txt
#speedtest-cli --simple > speedtest.txt
$dockerpath/docker run --rm robinmanuelthiel/speedtest:latest > $path/speedtest.txt

download=$(cat $path/speedtest.txt | sed -n 's/.*download speed is \([0-9]*\) Mbps.*/\1/p')
upload=$(cat $path/speedtest.txt | sed -n 's/.*upload speed is \([0-9]*\) Mbps.*/\1/p')
png=$(cat $path/speedtest.txt | sed -n 's/Your ping is \(.*\) ms\./\1/p')

# output if you run it manually
echo "Download = $download Mbps"
echo "Upload =  $upload Mbps"
echo "Ping =  $png ms"

# Updating download, upload and ping ..
wget -O down.ext "http://$host/json.htm?type=command&param=udevice&idx=$idxdl&svalue=$download" && rm down.ext >/dev/null 2>&1
wget -O up.ext "http://$host/json.htm?type=command&param=udevice&idx=$idxul&svalue=$upload" && rm up.ext >/dev/null 2>&1
wget -O ping.ext "http://$host/json.htm?type=command&param=udevice&idx=$idxpng&svalue=$png"  && rm ping.ext >/dev/null 2>&1

# Reset Broadband switch
wget -O broa.ext "http://$host/json.htm?type=command&param=udevice&idx=$idxbb&svalue=0" && rm broa.ext >/dev/null 2>&1

# Domoticz logging
wget -O log.ext "http://$host/json.htm?type=command&param=addlogmessage&message=speedtest.net-logging" && rm log.ext >/dev/null 2>&1
