#!/bin/bash

PI_HOME=$1
CUR_VERSION=$2
NEW_VERSION=$3

. $PI_HOME/setup.cfg

# Set env vars
GIT_REPO=${GIT_URL##*/}
export DATABASE_URL=ecto://postgres:postgres@localhost/$GIT_REPO
export SECRET_KEY_BASE=$SECRET_KEY_BASE
export HOST=$HOST
export HTTP_PORT=$HTTP_PORT
export HTTPS_PORT=$HTTPS_PORT
export POOL_SIZE=10
if [[ "$HTTPS" == "true" ]]; then
  #export SSL_KEY_PATH=/etc/letsencrypt/live/$DOMAIN/privkey.pem
  #export SSL_CERT_PATH=/etc/letsencrypt/live/$DOMAIN/fullchain.pem
  export SSL_KEY_PATH=$PI_HOME/letsencrypt/config/live/$HTTPS_DOMAIN/privkey.pem
  export SSL_CERT_PATH=$PI_HOME/letsencrypt/config/live/$HTTPS_DOMAIN/fullchain.pem
fi

# Shutdown old version or noop
#~/releases/$CUR_VERSION/_build/prod/rel/$GIT_REPO/bin/$GIT_REPO stop || :

# Migration
#releases/$NEW_VERSION/_build/prod/rel/$GIT_REPO/bin/$GIT_REPO rpc "${GIT_REPO^}.Release.migrate"
#~/releases/$NEW_VERSION/_build/prod/rel/$GIT_REPO/bin/$GIT_REPO eval "${GIT_REPO^}.Release.migrate"

# Start new version
#releases/$NEW_VERSION/_build/prod/rel/$GIT_REPO/bin/$GIT_REPO restart
#releases/$NEW_VERSION/_build/prod/rel/$GIT_REPO/bin/$GIT_REPO daemon
$PI_HOME/releases/$NEW_VERSION/_build/prod/rel/$GIT_REPO/bin/$GIT_REPO start_iex

# Update version in setup.cfg
sed -i "/CUR_VERSION=.*/c\CUR_VERSION=$NEW_VERSION" setup.cfg
