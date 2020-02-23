#!/bin/bash

VOLUME=/Volumes/boot

touch $VOLUME/ssh

read -p "Use WLAN or Ethernet? (W)LAN (E)thernet " -n 1
if [[ $REPLY =~ ^[Ww]$ ]]; then
echo ""
echo "WLAN-Config"
read -p "WLAN-SSID: " WLANSSID
read -p "Password: " WLANPASS

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
fi
