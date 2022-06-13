#!/bin/bash

export $(grep -v '^#' .env | xargs)

# DEFAULT_HTTP_PORT=$HTTP_PORT
# DEFAULT_HTTPS_PORT=$HTTPS_PORT

case $INSTANCE in
  green)
    NEW_INSTANCE=blue
    # export HTTP_PORT="$((HTTP_PORT + 2))"
    # export HTTPS_PORT="$((HTTPS_PORT + 2))"
    ;;

  *)
    NEW_INSTANCE=green
    # export HTTP_PORT="$((HTTP_PORT + 1))"
    # export HTTPS_PORT="$((HTTPS_PORT + 1))"
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
mix release $REPO --overwrite --path "../$NEW_INSTANCE"

cd ..

# Run DB migration
$NEW_INSTANCE/bin/$REPO eval "${REPO^}.Release.migrate"

# Start the new server
$NEW_INSTANCE/bin/$REPO daemon

# Switch Ports
# iptables -t nat -R PREROUTING 1 -p tcp --dport $DEFAULT_HTTP_PORT -j REDIRECT --to-port $HTTP_PORT
# iptables -t nat -R PREROUTING 2 -p tcp --dport $DEFAULT_HTTPS_PORT -j REDIRECT --to-port $HTTPS_PORT
# iptables -t nat -R OUTPUT 1 -o lo -p tcp --dport $DEFAULT_HTTP_PORT -j REDIRECT --to-port $HTTP_PORT
# iptables -t nat -R OUTPUT 2 -o lo -p tcp --dport $DEFAULT_HTTPS_PORT -j REDIRECT --to-port $HTTPS_PORT
# iptables-save

# Shutdown old version or noop
if [ "${INSTANCE}" != "" ] && [ -f "$INSTANCE/bin/$REPO" ]; then
  $INSTANCE/bin/$REPO stop || :
fi

# Update version in .env file
sed -i "/INSTANCE=.*/c\INSTANCE=$NEW_INSTANCE" .env
