#!/bin/bash

echo "WLAN-Config"
read -p "WLAN-SSID: " WLANSSID
read -p "Password: " WLANPASS

echo "#############################"
echo "# When asked for a password #"
echo "# Type in: raspberry        #"
echo "#############################"
ssh-copy-id -p $PORT pi@$HOST
ssh -T -p $PORT pi@$HOST sudo passwd -l pi

scp -P $PORT hooks/post-receive pi@$HOST:/home/pi
scp -P $PORT pi_remote.sh pi@$HOST:/home/pi
ssh -T -p $PORT pi@$HOST chmod +x pi_remote.sh
ssh -T -p $PORT pi@$HOST sudo apt install -y screen
