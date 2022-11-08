#!/bin/bash

if [ ! -f ".env" ]; then
  echo "Error: Config is missing. Please run pi_local.sh first."
else
  echo "Load config"
  source .env
  echo "Connect"
  ssh pi@$PI_HOST
fi
