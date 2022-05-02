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
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.9.0

# Add asdf & dart/sass to shell
sed -i '1i\
# Add asdf bash completions\
. \$HOME/.asdf/asdf.sh\
. \$HOME/.asdf/completions/asdf.bash\
\
# Add dart & sass to path\
export PATH=\$HOME/.pub-cache/bin:\$HOME/dart-sdk/bin:\$PATH\
' .bashrc

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

# Install Dart-Sass
wget https://storage.googleapis.com/dart-archive/channels/stable/release/2.16.2/sdk/dartsdk-linux-arm64-release.zip
unzip dartsdk-linux-arm64-release.zip
dart --disable-analytics
dart pub global activate sass 1.49.11

# Create user & database
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"
sudo -u postgres psql -c "CREATE DATABASE $REPO;"

# Install mix
mix local.hex --force
mix local.rebar --force

# Create https certificate
sudo apt install -y certbot
sudo certbot certonly -n --standalone --agree-tos --http-01-port $HTTP_PORT --https-port $HTTPS_PORT -d $CERTBOT_DOMAINS,www.${CERTBOT_DOMAINS//,/,www.} -m $CERTBOT_EMAIL

# Make certs readable by user `pi`
sudo chmod 0755 -R /etc/letsencrypt/{live,archive}

# Create cronjob
# (crontab -l ; echo "14 04 * * * sudo certbot renew") | crontab -

# Clone Project
git clone https://github.com/sorax/$REPO.git

# Create cronjob
(crontab -l ; echo "@reboot ./deploy.sh") | crontab -

# Reboot
sudo reboot
