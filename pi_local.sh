#!/bin/bash

CONFIG=data/setup.cfg

function get_config {
  echo ""
  echo "No config present. I need to ask a few things."
  read -p "pi ssh host: " HOST
  read -p "git repo url: " GIT_URL
  read -p "domains (comma separated): " DOMAINS
  read -p "certbot mail: " CERTBOT_MAIL
  read -p "SECRET_KEY_BASE (e.g. use mix phx.gen.secret): " SECRET_KEY_BASE
}

function store_config {
  echo "Storing config"
  mkdir -p data
/bin/cat <<EOM >$CONFIG
HOST=$HOST
GIT_URL=$GIT_URL
DOMAINS=$DOMAINS
CERTBOT_HTTP_PORT=8080
CERTBOT_HTTPS_PORT=8443
CERTBOT_MAIL=$CERTBOT_MAIL
SECRET_KEY_BASE=$SECRET_KEY_BASE
CUR_VERSION=NONE
EOM
}

function load_config {
  echo "Loading config"
  . $1
}

function setup_remote {
  echo ""
  echo "#############################"
  echo "When asked for a password"
  echo "Type in: raspberry"
  echo "#############################"
  echo ""

  ssh-copy-id pi@$HOST
  ssh -T pi@$HOST sudo passwd -l pi

  scp $CONFIG pi@$HOST:/home/pi
  scp pi_remote.sh pi@$HOST:/home/pi
  scp pull.sh pi@$HOST:/home/pi
  scp run.sh pi@$HOST:/home/pi
  ssh -T pi@$HOST chmod +x pi_remote.sh
  ssh -T pi@$HOST chmod +x pull.sh
  ssh -T pi@$HOST chmod +x run.sh
  ssh -T pi@$HOST sudo apt install -y screen
  ssh -T pi@$HOST screen -dmS Setup ./pi_remote.sh
}

if [ ! -f "$CONFIG" ]; then
  get_config
  store_config
else
  echo "Config exists"
fi
load_config $CONFIG
setup_remote
