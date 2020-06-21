#!/bin/bash

. setup.cfg

# Add additional sources
echo "deb https://packages.erlang-solutions.com/debian buster contrib" | sudo tee /etc/apt/sources.list.d/erlang-solutions.list
wget https://packages.erlang-solutions.com/debian/erlang_solutions.asc
sudo apt-key add erlang_solutions.asc
# curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -

# Update & upgrade system
sudo apt update && sudo apt upgrade -y
sudo apt full-upgrade -y
sudo apt autoremove --purge && sudo apt autoclean -y

# Install additionals
# sudo apt install -y elixir nodejs postgresql
sudo apt install -y elixir inotify-tools postgresql

# Install mix
mix local.hex --force
mix local.rebar --force

# # Fix npm
# mkdir -p ~/.npm-global
# npm config set prefix '~/.npm-global'
# echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.profile
# source ~/.profile

# Start postgres
sudo systemctl start postgresql
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"
sudo -u postgres psql -c "CREATE DATABASE $REPOSITORY;"

# Create directories
mkdir -p releases

if [[ $HTTPS =~ ^[Yy]$ ]]; then
  # Create https certificate
  sudo apt install -y certbot
  sudo certbot certonly --standalone -d $DOMAIN -d www.$DOMAIN -m $MAIL --redirect
  sudo certbot renew
fi

# # Create & enable swap
# #sudo fallocate -l 1G /tmp/swapfile
# #sudo chmod 600 /tmp/swapfile
# #sudo mkswap /tmp/swapfile
# #sudo swapon /tmp/swapfile

# # Disable & delete swap
# #sudo swapoff /tmp/swapfile
# #sudo rm /tmp/swapfile

# mv setup.cfg setup_done.cfg
