#!/bin/bash

. setup.cfg

# Update & upgrade system
sudo apt update && sudo apt upgrade -y
sudo apt full-upgrade -y
sudo apt autoremove --purge -y && sudo apt autoclean -y

# Download packages
mkdir -p deb
wget -P deb https://packages.erlang-solutions.com/erlang/debian/pool/esl-erlang_22.1.6-1~raspbian~buster_armhf.deb
wget -P deb https://packages.erlang-solutions.com/erlang/debian/pool/elixir_1.8.1-1~raspbian~stretch_armhf.deb

# Install packages
sudo apt install -y /home/pi/deb/esl-erlang_22.1.6-1~raspbian~buster_armhf.deb
sudo apt install -y /home/pi/deb/elixir_1.8.1-1~raspbian~stretch_armhf.deb

# Install additionals
sudo apt install -y inotify-tools postgresql

# Start postgres
sudo systemctl start postgresql
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"
#sudo -u postgres psql -c "CREATE DATABASE $REPOSITORY;"

# Install mix
mix local.hex --force
mix local.rebar --force

# Create directories
mkdir -p releases

if [[ $HTTPS = "true" ]]; then
  # Create https certificate
  #sudo apt install -y certbot
  #sudo certbot certonly --standalone -d $HTTPS_DOMAIN -d www.$HTTPS_DOMAIN -m $HTTPS_MAIL --redirect
  # Create cronjob
  #(crontab -l ; echo "14 04 * * * sudo certbot renew") | crontab -
fi

# Create cronjob
#(crontab -l ; echo "0 * * * * ./pull.sh") | crontab -
