#!/bin/bash

# . setup.cfg

GIT_USER="sorax"
GIT_REPO="hausgedacht"
CUR_VERSION="NONE"

URL="https://github.com/$GIT_USER/$GIT_REPO/releases/latest"
NEW_VERSION="$(curl -s $URL | grep -o 'releases/tag/.*"' | cut -d '"' -f 1 | cut -d / -f 3)"

echo "Current Version: $CUR_VERSION => New Version: $NEW_VERSION"

if [ "$NEW_VERSION" != "$CUR_VERSION" ]; then
  echo "Installing version $NEW_VERSION"

  rm -Rf releases/$NEW_VERSION
  mkdir -p releases/$NEW_VERSION
  cd releases/$NEW_VERSION

  wget "https://github.com/$GIT_USER/$GIT_REPO/archive/$NEW_VERSION.tar.gz"
  #wget "https://github.com/$GIT_USER/$GIT_REPO/releases/download/$NEW_VERSION/release.zip"
  wget "https://github.com/$GIT_USER/$GIT_REPO/releases/download/$NEW_VERSION/static.zip"

  tar -xvf $NEW_VERSION.tar.gz --strip 1
  unzip static.zip

  mix deps.get --only prod
  #mix test

  MIX_ENV=prod mix release

  # env:
  #   DATABASE_URL: ecto://USER:PASS@HOST/DATABASE
  #   POOL_SIZE: 10
  #   SECRET_KEY_BASE:
  #   PORT: 80
  #   #PORT: 443
else
  echo Latest version already installed
fi
