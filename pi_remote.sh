#!/bin/bash

echo "Config"
read -p "Repository: " REPOSITORY
read -p "Domain: " DOMAIN
read -p "E-Mail: " MAIL

# Add additional sources
echo "deb https://packages.erlang-solutions.com/debian buster contrib" | sudo tee /etc/apt/sources.list.d/erlang-solutions.list
wget https://packages.erlang-solutions.com/debian/erlang_solutions.asc
sudo apt-key add erlang_solutions.asc
curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -

# Update & upgrade system
sudo apt update && sudo apt-get upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove --purge && sudo apt-get autoclean

# Install additionals
sudo apt install -y certbot elixir git nodejs postgresql

# Install mix
mix local.hex --force

# Fix npm 
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.profile
source ~/.profile

# Start postgres
sudo systemctl start postgresql

# Create directories
mkdir -p www/$REPOSITORY
mkdir -p builds/$REPOSITORY
mkdir -p repos/$REPOSITORY.git

# Init git + hooks
git init --bare repos/$REPOSITORY.git
mv post-receive repos/$REPOSITORY.git/hooks
chmod +x repos/$REPOSITORY.git/hooks/post-receive

# Create https certificate
sudo certbot certonly --standalone -d $DOMAIN -d www.$DOMAIN -m $MAIL --redirect

# Create & enable swap
#sudo fallocate -l 1G /tmp/swapfile
#sudo chmod 600 /tmp/swapfile
#sudo mkswap /tmp/swapfile
#sudo swapon /tmp/swapfile

# Disable & delete swap
#sudo swapoff /tmp/swapfile
#sudo rm /tmp/swapfile
