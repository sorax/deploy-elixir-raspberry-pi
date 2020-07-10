#!/bin/bash

. setup.cfg

URL="https://github.com/$GIT_USER/$GIT_REPO/releases/latest"
NEW_VERSION="$(curl -s "$URL" | grep -o 'releases/tag/.*"' | cut -d '"' -f 1 | cut -d / -f 3)"

echo "Current Version: $CUR_VERSION => New Version: $NEW_VERSION"

if [ "$NEW_VERSION" != "$CUR_VERSION" ]; then
  echo "Installing version $NEW_VERSION"

  rm -Rf releases/"$NEW_VERSION"
  mkdir -p releases/"$NEW_VERSION"
  cd releases/"$NEW_VERSION" || exit

  wget "https://github.com/$GIT_USER/$GIT_REPO/archive/$NEW_VERSION.tar.gz"
  ## wget "https://github.com/$GIT_USER/$GIT_REPO/releases/download/$NEW_VERSION/release.zip"
  wget "https://github.com/$GIT_USER/$GIT_REPO/releases/download/$NEW_VERSION/static.zip"

  tar -xvf "$NEW_VERSION".tar.gz --strip 1
  unzip static.zip

  # Set env vars
  export DATABASE_URL=ecto://postgres:postgres@localhost/$GIT_REPO
  export SECRET_KEY_BASE=pxsjyQAT2P+ZqvSxmbc4x5JkonQstRITaSeMgCQqHIoDREH47dhgpMEIXUd2nlED
  export POOL_SIZE=10
  export SSL_KEY_PATH=/etc/letsencrypt/live/$DOMAIN/privkey.pem
  export SSL_CERT_PATH=/etc/letsencrypt/live/$DOMAIN/fullchain.pem
  export MIX_ENV=prod

  mix deps.get --only prod
  mix compile
  mix phx.digest

  if [ "$CUR_VERSION" == "NONE" ]; then
    sudo -u postgres psql -c "CREATE DATABASE $REPOSITORY;"
    mix ecto.setup
  fi

  mix ecto.migrate
  mix release

  cd ../..

  # Shutdown old version or noop
  sudo releases/"$CUR_VERSION"/_build/prod/rel/"$GIT_REPO"/bin/"$GIT_REPO" stop || :

  # Start new version
  sudo releases/"$NEW_VERSION"/_build/prod/rel/$GIT_REPO/bin/$GIT_REPO daemon

  # Update version in setup.cfg
  sed -i "/CUR_VERSION=.*/c\CUR_VERSION=$NEW_VERSION" setup.cfg
else
  echo Latest version already installed
fi
