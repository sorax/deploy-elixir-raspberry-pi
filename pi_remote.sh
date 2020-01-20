#!/bin/bash

# Add additional sources
# echo "deb https://packages.erlang-solutions.com/debian buster contrib" | sudo tee /etc/apt/sources.list.d/erlang-solutions.list
# wget https://packages.erlang-solutions.com/debian/erlang_solutions.asc
# sudo apt-key add erlang_solutions.asc
# curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -

# Update & upgrade system
# sudo apt update && sudo apt-get upgrade -y
# sudo apt dist-upgrade -y
# sudo apt autoremove --purge && sudo apt-get autoclean

# Install additionals
# sudo apt install -y build-essential elixir git nodejs postgresql screen

# Install mix
# mix local.hex --force

# Fix npm 
# mkdir -p ~/.npm-global
# npm config set prefix '~/.npm-global'
# echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.profile
# source ~/.profile

# Start postgres
#sudo systemctl start postgresql@11-main

# Create directories
#mkdir -p www/spacegame
#mkdir -p builds/spacegame
#mkdir -p repos/spacegame.git

# Init git + hooks
#git init --bare repos/spacegame.git
#mv post-receive repos/spacegame.git/hooks
#chmod +x repos/spacegame.git/hooks/post-receive
