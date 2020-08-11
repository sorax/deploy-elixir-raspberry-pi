#!/bin/bash

CONFIG=data/setup.cfg

function get_config {
  echo "No config present. I need to ask a few things."
  echo ""
  # set defaults
  HTTPS=false
  HTTPS_DOMAIN=
  HTTPS_MAIL=

  read -p "PI-HOST: " HOST
  read -p "PI-PORT: " PORT
  # https://github.com/sorax/hausgedacht
  read -p "git repo url: " GIT_URL

  read -p "Use https? [Yn]" -n 1
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    HTTPS=true
    echo ""
    read -p "Domain: " HTTPS_DOMAIN
    read -p "E-Mail: " HTTPS_MAIL
  fi
}

function store_config {
  echo "Storing config"
  mkdir -p data
/bin/cat <<EOM >$CONFIG
HOST=$HOST
PORT=$PORT
GIT_URL=$GIT_URL
HTTPS=$HTTPS
HTTPS_DOMAIN=$HTTPS_DOMAIN
HTTPS_MAIL=$HTTPS_MAIL
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

  ssh-copy-id -p $PORT pi@$HOST
  ssh -T -p $PORT pi@$HOST sudo passwd -l pi

  scp -P $PORT $CONFIG pi@$HOST:/home/pi
  scp -P $PORT pi_remote.sh pi@$HOST:/home/pi
  scp -P $PORT pull.sh pi@$HOST:/home/pi
  ssh -T -p $PORT pi@$HOST chmod +x pi_remote.sh
  ssh -T -p $PORT pi@$HOST chmod +x pull.sh
  ssh -T -p $PORT pi@$HOST sudo apt install -y screen
  # ssh -T -p $PORT pi@$HOST screen -dmS Setup ./pi_remote.sh
}

if [ ! -f "$CONFIG" ]; then
  get_config
  store_config
else
  echo "Config exists"
fi
load_config $CONFIG
setup_remote
