#!/bin/bash

export $(grep -v '^#' .env | xargs)

case $INSTANCE in
  green)
    NEW_INSTANCE=blue
    # export HTTP_PORT="$((HTTP_PORT + 2))"
    # export HTTPS_PORT="$((HTTP_PORT + 2))"
    ;;

  *)
    NEW_INSTANCE=green
    # export HTTP_PORT="$((HTTP_PORT + 2))"
    # export HTTPS_PORT="$((HTTP_PORT + 2))"
    ;;
esac

cd $REPO

# Cleanup repo
git reset --hard
git clean -df

# Checkout latest version
git pull --rebase

# Initial setup
mix deps.get --only prod
mix compile

# Compile assets
mix assets.deploy

# Build release
mix release --overwrite --path "../$NEW_INSTANCE"

cd ..

# Shutdown old version or noop
if [ "${INSTANCE}" != "" ] && [ -f "$INSTANCE/bin/$REPO" ]; then
  $INSTANCE/bin/$REPO stop || :
fi

# Run DB migration
$NEW_INSTANCE/bin/$REPO eval "${REPO^}.Release.migrate"

# Start the new server
$NEW_INSTANCE/bin/$REPO daemon

# Update version in .env file
sed -i "/INSTANCE=.*/c\INSTANCE=$NEW_INSTANCE" .env
