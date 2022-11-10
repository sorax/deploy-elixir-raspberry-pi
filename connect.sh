#!/bin/bash

CONFIG=config/.env

if [ ! -f "$CONFIG" ]; then
  echo "Error: Config is missing. Please run pi_local.sh first."
else
  echo "Load config"
  source $CONFIG
  echo "Connect"
  ssh pi@$PI_HOST
fi
