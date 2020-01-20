#!/bin/bash

echo WLAN-Config
read -p 'WLAN-SSID: ' WLANSSID
read -p 'Password: ' WLANPASS

volume=/Volumes/boot

touch $volume/ssh
touch $volume/wpa_supplicant.conf

/bin/cat <<EOM >$volume/wpa_supplicant.conf
country=DE
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
  ssid="$WLANSSID"
  psk="$WLANPASS"
  key_mgmt=WPA-PSK
}
EOM
