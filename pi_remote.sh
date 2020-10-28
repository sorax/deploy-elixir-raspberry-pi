#!/bin/bash

. setup.cfg

# Update & upgrade system
sudo apt update && sudo apt upgrade -y
sudo apt full-upgrade -y
sudo apt autoremove --purge -y && sudo apt autoclean -y

# Install additionals
sudo apt install -y build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk
sudo apt install -y git inotify-tools postgresql

# Install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0-rc1

# Add to shell
echo -e "\n# Add asdf bash completions" >> ~/.bashrc
echo ". \$HOME/.asdf/asdf.sh" >> ~/.bashrc
echo ". \$HOME/.asdf/completions/asdf.bash" >> ~/.bashrc
. ~/.bashrc

# Add asdf plugins
asdf plugin add erlang
asdf plugin add elixir
asdf install erlang latest
asdf install elixir latest

# Set asdf global versions
asdf global erlang 23.0.3
asdf global elixir 1.10.4-otp-23

# Start postgres
sudo systemctl start postgresql
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"

# Install mix
mix local.hex --force
mix local.rebar --force

# Create directories
mkdir -p releases

# Create https certificate
sudo apt install -y certbot
sudo certbot certonly -n --standalone --agree-tos --http-01-port $CERTBOT_HTTP_PORT --https-port $CERTBOT_HTTPS_PORT -d $DOMAINS,www.${DOMAINS//,/,www.} -m $CERTBOT_MAIL

# Create cronjob
(crontab -l ; echo "14 04 * * * sudo certbot renew") | crontab -

# Create cronjob
#(crontab -l ; echo "0 * * * * ./pull.sh") | crontab -
