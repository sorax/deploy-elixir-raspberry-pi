#!/bin/bash

. setup.cfg

NEW_VERSION=$(curl -s $GIT_URL | grep -o 'releases/tag/.*"' | cut -d '"' -f 1 | cut -d / -f 3)
echo "Current version: $CUR_VERSION => New version: $NEW_VERSION"

if [ "$NEW_VERSION" != "$CUR_VERSION" ]; then
  echo "Installing version $NEW_VERSION"

  if [ ! -d "releases/$NEW_VERSION" ]; then
    mkdir -p releases/$NEW_VERSION
    cd releases/$NEW_VERSION

    ## wget $GIT_URL/releases/download/$NEW_VERSION/release.zip

    wget $GIT_URL/archive/$NEW_VERSION.tar.gz
    wget $GIT_URL/releases/download/$NEW_VERSION/static.zip
    tar -xvf $NEW_VERSION.tar.gz --strip 1
    unzip static.zip
  else
    cd releases/$NEW_VERSION
  fi

  if [ -d "releases/$CUR_VERSION" ]; then
    cp ../$CUR_VERSION/deps .
  fi

  export MIX_ENV=prod
  mix deps.get --only prod
  mix compile
  mix release --overwrite

  cd ../..

  # Start new version with sudo
  sudo ./run.sh $HOME $CUR_VERSION $NEW_VERSION

  # Update version in setup.cfg
  sed -i "/CUR_VERSION=.*/c\CUR_VERSION=$NEW_VERSION" setup.cfg
else
  echo "Latest version already installed."
fi
