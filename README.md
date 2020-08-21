# Run Elixir on Raspberry Pi

## Setup for a Raspberry Pi with Elixir &amp; Phoenix

1. Flash SD card

- Download [Raspberry Pi OS (32-bit) Lite](https://downloads.raspberrypi.org/raspios_lite_armhf_latest)
- Unzip downloaded file
- Flash .img on sd-card (e.g. with [balenaEtcher](https://www.balena.io/etcher/))

2. Setup SD card

- make sure the SD card is mounted (should be `/Volumes/boot`)
- `chmod +x *.sh` (makes .sh files executable)
- `./sd_setup.sh` (run script)

3. Insert SD card into Raspberry Pi and power on

4. Configure & setup Raspberry Pi

- `./pi_local.sh`
