#!/bin/bash

echo WLAN-Config
read -p 'WLAN-SSID: ' WLANSSID
read -p 'Password: ' WLANPASS

VOLUME=/Volumes/boot

touch $VOLUME/ssh
touch $VOLUME/wpa_supplicant.conf

/bin/cat <<EOM >$VOLUME/wpa_supplicant.conf
country=DE
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
  ssid="$WLANSSID"
  psk="$WLANPASS"
  key_mgmt=WPA-PSK
}
EOM
