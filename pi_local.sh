#!/bin/bash

CONFIG=config/.env

function get_config {
  echo ""
  echo "No config present. I need to ask a few things."
  read -p "pi ssh host: " PI_HOST
  read -p "repo name: " REPO
  read -p "domain: " DOMAIN
  read -p "certbot mail: " CERTBOT_MAIL
  read -p "SECRET_KEY_BASE (e.g. use mix phx.gen.secret): " SECRET_KEY_BASE
}

function store_config {
  echo "Storing config"
  mkdir -p data
/bin/cat <<EOM >$CONFIG
CERTBOT_MAIL=$CERTBOT_MAIL
DATABASE_URL=ecto://postgres:postgres@localhost/$REPO
PI_HOST=$PI_HOST
HTTP_PORT=8080
HTTPS_PORT=8443
INSTANCE=
KERL_CONFIGURE_OPTIONS="--without-wx"
MIX_ENV=prod
PHX_HOST=$DOMAIN
POOL_SIZE=10
REPO=$REPO
SECRET_KEY_BASE=$SECRET_KEY_BASE
SSL_CERT_PATH=/etc/letsencrypt/live/$DOMAIN/fullchain.pem
SSL_KEY_PATH=/etc/letsencrypt/live/$DOMAIN/privkey.pem
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

  ssh-copy-id pi@$PI_HOST
  ssh -T pi@$PI_HOST sudo passwd -l pi

  scp $CONFIG pi@$PI_HOST:/home/pi
  scp pi_remote.sh pi@$PI_HOST:/home/pi
  scp run.sh pi@$PI_HOST:/home/pi
  ssh -T pi@$PI_HOST chmod +x pi_remote.sh
  ssh -T pi@$PI_HOST chmod +x run.sh
  ssh -T pi@$PI_HOST sudo apt install -y screen
  # ssh -T pi@$PI_HOST screen -dmS Setup ./pi_remote.sh
}

if [ ! -f "$CONFIG" ]; then
  get_config
  store_config
else
  echo "Config exists"
fi
load_config $CONFIG
setup_remote
