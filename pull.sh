#!/bin/bash

. setup.cfg

URL="https://github.com/$GIT_USER/$GIT_REPO/releases/latest"
NEW_VERSION="$(curl -s $URL | grep -o 'releases/tag/.*"' | cut -d '"' -f 1 | cut -d / -f 3)"

echo "Current Version: $CUR_VERSION => New Version: $NEW_VERSION"

if [ "$NEW_VERSION" != "$CUR_VERSION" ]; then
  echo "Installing version $NEW_VERSION"

  rm -Rf releases/$NEW_VERSION
  mkdir -p releases/$NEW_VERSION
  cd releases/$NEW_VERSION

  wget "https://github.com/$GIT_USER/$GIT_REPO/archive/$NEW_VERSION.tar.gz"
  ## wget "https://github.com/$GIT_USER/$GIT_REPO/releases/download/$NEW_VERSION/release.zip"
  wget "https://github.com/$GIT_USER/$GIT_REPO/releases/download/$NEW_VERSION/static.zip"

  tar -xvf $NEW_VERSION.tar.gz --strip 1
  unzip static.zip

  export DATABASE_URL=ecto://postgres:postgres@localhost/$GIT_REPO
  export SECRET_KEY_BASE=pxsjyQAT2P+ZqvSxmbc4x5JkonQstRITaSeMgCQqHIoDREH47dhgpMEIXUd2nlED
  ## POOL_SIZE: 10
  ## PORT: 80
  ## PORT: 443

  #mix deps.get --only prod
  ## mix ecto.migrate
  #mix phx.digest
  #MIX_ENV=prod mix release
  #_build/prod/rel/$GIT_REPO/bin/$GIT_REPO start

  ## update cur_version
else
  echo Latest version already installed
fi
