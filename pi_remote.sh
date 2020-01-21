#!/bin/bash

REPOSITORY=spacegame

# Add additional sources
echo "deb https://packages.erlang-solutions.com/debian buster contrib" | sudo tee /etc/apt/sources.list.d/erlang-solutions.list
wget https://packages.erlang-solutions.com/debian/erlang_solutions.asc
sudo apt-key add erlang_solutions.asc
curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -

Update & upgrade system
sudo apt update && sudo apt-get upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove --purge && sudo apt-get autoclean

# Install additionals
sudo apt install -y elixir git nodejs postgresql

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

# Install & setup letsencrypt
wget https://dl.eff.org/certbot-auto
sudo mv certbot-auto /usr/local/bin/certbot-auto
sudo chown root /usr/local/bin/certbot-auto
sudo chmod 0755 /usr/local/bin/certbot-auto
sudo /usr/local/bin/certbot-auto certonly --standalone --noninteractive
