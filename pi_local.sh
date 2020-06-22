#!/bin/bash

read -p "PI-HOST: " HOST
read -p "PI-PORT: " PORT
read -p "git user name: " GIT_USER
read -p "git repo name: " GIT_REPO
read -p "Domain: " DOMAIN
read -p "E-Mail: " MAIL
echo "#############################"
echo "When asked for a password"
echo "Type in: raspberry"
echo "#############################"

ssh-copy-id -p $PORT pi@$HOST
ssh -T -p $PORT pi@$HOST sudo passwd -l pi

ssh -T -p $PORT pi@$HOST << EOSSH
touch setup.cfg
/bin/cat <<EOM >setup.cfg
GIT_USER=$GIT_USER
GIT_REPO=$GIT_REPO
CUR_VERSION=NONE
DOMAIN=$DOMAIN
MAIL=$MAIL
EOM
EOSSH

scp -P $PORT pi_remote.sh pi@$HOST:/home/pi
scp -P $PORT pull.sh pi@$HOST:/home/pi
ssh -T -p $PORT pi@$HOST chmod +x pi_remote.sh
ssh -T -p $PORT pi@$HOST chmod +x pull.sh
ssh -T -p $PORT pi@$HOST sudo apt install -y screen
ssh -T -p $PORT pi@$HOST screen -dmS Setup ./pi_remote.sh
