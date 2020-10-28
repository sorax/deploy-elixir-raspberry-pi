#!/bin/bash

CONFIG=data/setup.cfg

function get_config {
  echo "No config present. I need to ask a few things."
  echo ""

  read -p "pi ssh host: " PI_HOST
  read -p "pi ssh port [22]: " PI_PORT
  PI_PORT=${PI_PORT:-22}
  read -p "git repo url: " GIT_URL
  read -p "domains (comma separated): " DOMAINS
  read -p "http port [80]:" HTTP_PORT
  HTTP_PORT=${HTTP_PORT:-80}

  read -p "Use https? [Yn]" -n 1
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    HTTPS=true
    echo ""
    read -p "https port [443]: " HTTPS_PORT
    HTTPS_PORT=${HTTPS_PORT:-443}
    read -p "certbot http port [8080]: " CERTBOT_HTTP_PORT
    CERTBOT_HTTP_PORT=${CERTBOT_HTTP_PORT:-8080}
    read -p "certbot https port [8443]: " CERTBOT_HTTPS_PORT
    CERTBOT_HTTPS_PORT=${CERTBOT_HTTPS_PORT:-8443}
  else
    HTTPS=false
    HTTPS_MAIL=
  fi

  read -p "certbot mail: " CERTBOT_MAIL
  read -p "SECRET_KEY_BASE (e.g. use mix phx.gen.secret): " SECRET_KEY_BASE
}

function store_config {
  echo "Storing config"
  mkdir -p data
/bin/cat <<EOM >$CONFIG
PI_HOST=$PI_HOST
PI_PORT=$PI_PORT
GIT_URL=$GIT_URL
DOMAINS=$DOMAINS
HTTP_PORT=$HTTP_PORT
HTTPS=$HTTPS
HTTPS_PORT=$HTTPS_PORT
CERTBOT_HTTP_PORT=$CERTBOT_HTTP_PORT
CERTBOT_HTTPS_PORT=$CERTBOT_HTTPS_PORT
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
  echo "#############################"
  echo "When asked for a password"
  echo "Type in: raspberry"
  echo "#############################"

  ssh-copy-id -p $PI_PORT pi@$PI_HOST
  ssh -T -p $PI_PORT pi@$PI_HOST sudo passwd -l pi

  scp -P $PI_PORT $CONFIG pi@$PI_HOST:/home/pi
  scp -P $PI_PORT pi_remote.sh pi@$PI_HOST:/home/pi
  scp -P $PI_PORT pull.sh pi@$PI_HOST:/home/pi
  scp -P $PI_PORT run.sh pi@$PI_HOST:/home/pi
  ssh -T -p $PI_PORT pi@$PI_HOST chmod +x pi_remote.sh
  ssh -T -p $PI_PORT pi@$PI_HOST chmod +x pull.sh
  ssh -T -p $PI_PORT pi@$PI_HOST chmod +x run.sh
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
