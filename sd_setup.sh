#!/bin/bash

CONFIG=config/sd_card.cfg

function get_config {
  echo "No config present. I need to ask a few things."
  echo ""
  # set defaults
  VOLUME=/Volumes/boot
  NETWORK=ethernet
  WLAN_SSID=
  WLAN_PASS=

  read -p "Use WLAN or Ethernet? (W)LAN (E)thernet " -n 1
  if [[ $REPLY =~ ^[Ww]$ ]]; then
    NETWORK=wlan
    echo ""
    echo "WLAN-Config"
    read -p "WLAN-SSID: " WLAN_SSID
    read -sp "Password: " WLAN_PASS
  else
    echo ""
  fi
}

function store_config {
  echo "Storing config"
  mkdir -p data
/bin/cat <<EOM >$CONFIG
VOLUME=$VOLUME
NETWORK=$NETWORK
WLAN_SSID=$WLAN_SSID
WLAN_PASS=$WLAN_PASS
EOM
}

function load_config {
  echo "Loading config"
  source $1
}

function write_card {
  echo "Write to SD-Card"
  touch $VOLUME/ssh

  if [[ $NETWORK = "wlan" ]]; then
/bin/cat <<EOM >$VOLUME/wpa_supplicant.conf
country=DE
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
  ssid="$WLAN_SSID"
  psk="$WLAN_PASS"
  key_mgmt=WPA-PSK
}
EOM
  fi
}

if [ ! -f "$CONFIG" ]; then
  get_config
  store_config
else
  echo "Config exists"
fi
load_config $CONFIG
write_card
