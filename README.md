# Raspbian Elixir Phoenix

## Setup for a raspberry pi with elixir &amp; phoenix

1. Flash SD card

- Download [Raspbian Lite](https://downloads.raspberrypi.org/raspbian_lite_latest)
- Unzip downloaded file
- Flash .img on sd-card (e.g. with [balenaEtcher](https://www.balena.io/etcher/))

2. Setup SD card

- make sure the SD card is mounted (should be `/Volumes/boot`)
- `chmod +x *.sh` (makes .sh files executable)
- `./sd_setup.sh` (run script)

3. Insert SD card into Raspberry Pi and power on

4. Configure access & upload remote-script

- `./pi_local.sh`
