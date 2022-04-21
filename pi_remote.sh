#!/bin/bash

export $(grep -v '^#' .env | xargs)

# Update & upgrade system
sudo apt update && sudo apt upgrade -y
sudo apt full-upgrade -y
sudo apt autoremove --purge -y && sudo apt autoclean -y

# Install additionals
sudo apt install -y git
sudo apt install -y build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk
sudo apt install -y postgresql
# sudo apt install -y inotify-tools

# Install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1

# Add to shell
echo -e "\n# Add asdf bash completions" >> ~/.bashrc
echo ". \$HOME/.asdf/asdf.sh" >> ~/.bashrc
echo ". \$HOME/.asdf/completions/asdf.bash" >> ~/.bashrc
. ~/.bashrc

# Add asdf plugins
asdf plugin add erlang
asdf plugin add elixir

# Install asdf plugins
asdf install erlang latest
asdf install elixir latest

# Set asdf global versions
asdf global erlang latest
asdf global elixir latest

# Start postgres
sudo systemctl start postgresql

# Create user & database
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"
sudo -u postgres psql -c "CREATE DATABASE $REPO;"

# Install mix
mix local.hex --force
mix local.rebar --force

# Create https certificate
# sudo apt install -y certbot
# sudo certbot certonly -n --standalone --agree-tos --http-01-port $HTTP_PORT --https-port $HTTPS_PORT -d $CERTBOT_DOMAINS,www.${CERTBOT_DOMAINS//,/,www.} -m $CERTBOT_EMAIL

# Make certs readable by user `pi`
# sudo chmod 0755 -R /etc/letsencrypt/{live,archive}

# Create cronjob
# (crontab -l ; echo "14 04 * * * sudo certbot renew") | crontab -

# Clone Project
git clone https://github.com/sorax/$REPO.git

# Run latest version
chmod +x run.sh
./run.sh
