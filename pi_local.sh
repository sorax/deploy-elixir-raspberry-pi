#!/bin/bash

CONFIG=data/setup.cfg

function get_config {
  echo "No config present. I need to ask a few things."
  echo ""
  # set defaults
  HTTPS=false
  HTTPS_DOMAIN=
  HTTPS_MAIL=
  HTTPS_PORT=

  read -p "pi ssh host: " PI_HOST
  read -p "pi ssh port: " PI_PORT
  read -p "git repo url: " GIT_URL
  read -p "http port (e.g. 80): " HTTP_PORT

  read -p "Use https? [Yn]" -n 1
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    HTTPS=true
    echo ""
    read -p "https domain: " HTTPS_DOMAIN
    read -p "host mail: " HTTPS_MAIL
    read -p "https port (e.g. 443): " HTTPS_PORT
  fi
  read -p "SECRET_KEY_BASE: (e.g. use mix phx.gen.secret)" SECRET_KEY_BASE
}

function store_config {
  echo "Storing config"
  mkdir -p data
/bin/cat <<EOM >$CONFIG
PI_HOST=$PI_HOST
PI_PORT=$PI_PORT
GIT_URL=$GIT_URL
HTTP_PORT=$HTTP_PORT
HTTPS=$HTTPS
HTTPS_DOMAIN=$HTTPS_DOMAIN
HTTPS_MAIL=$HTTPS_MAIL
HTTPS_PORT=$HTTPS_PORT
SECRET_KEY_BASE=$SECRET_KEY_BASE
CUR_VERSION=NONE
EOM
}

function load_config {
  echo "Loading config"
  . $1
}

function setup_remote {
  echo "#############################"
  echo "When asked for a password"
  echo "Type in: raspberry"
  echo "#############################"

  ssh-copy-id -p $PI_PORT pi@$PI_HOST
  ssh -T -p $PI_PORT pi@$PI_HOST sudo passwd -l pi

  scp -P $PI_PORT $CONFIG pi@$PI_HOST:/home/pi
  scp -P $PI_PORT pi_remote.sh pi@$PI_HOST:/home/pi
  scp -P $PI_PORT pull.sh pi@$PI_HOST:/home/pi
  ssh -T -p $PI_PORT pi@$PI_HOST chmod +x pi_remote.sh
  ssh -T -p $PI_PORT pi@$PI_HOST chmod +x pull.sh
  ssh -T -p $PI_PORT pi@$PI_HOST sudo apt install -y screen
  ssh -T -p $PI_PORT pi@$PI_HOST screen -dmS Setup ./pi_remote.sh
}

if [ ! -f "$CONFIG" ]; then
  get_config
  store_config
else
  echo "Config exists"
fi
load_config $CONFIG
setup_remote
