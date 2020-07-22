#!/bin/bash

. setup.cfg

# Add additional sources
echo "deb https://packages.erlang-solutions.com/debian buster contrib" | sudo tee /etc/apt/sources.list.d/erlang-solutions.list
wget https://packages.erlang-solutions.com/debian/erlang_solutions.asc
sudo apt-key add erlang_solutions.asc

# Update & upgrade system
sudo apt update && sudo apt upgrade -y
sudo apt full-upgrade -y
sudo apt autoremove --purge -y && sudo apt autoclean -y

# Install additionals
sudo apt install -y elixir inotify-tools postgresql

# Install mix
mix local.hex --force
mix local.rebar --force

# Start postgres
sudo systemctl start postgresql
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"
sudo -u postgres psql -c "CREATE DATABASE $REPOSITORY;"

# Create directories
mkdir -p releases

# Create https certificate
sudo apt install -y certbot
sudo certbot certonly --standalone -d $DOMAIN -d www.$DOMAIN -m $MAIL --redirect

# Create cronjobs
(crontab -l ; echo "14 04 * * * sudo certbot renew") | crontab -
(crontab -l ; echo "0 * * * * sudo ./pull.sh") | crontab -
