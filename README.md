# Run Elixir on Raspberry Pi

## Setup for a Raspberry Pi with Elixir &amp; Phoenix

1. Flash SD card

- Download [Raspberry Pi OS (64-bit) Lite](https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2022-04-07/2022-04-04-raspios-bullseye-arm64-lite.img.xz)
- Flash .img on sd-card (e.g. with [balenaEtcher](https://www.balena.io/etcher/))

2. Setup SD card

- make sure the SD card is mounted (should be `/Volumes/boot`)
- `chmod +x *.sh` (makes .sh files executable)
- `./sd_setup.sh` (run script)

3. Insert SD card into Raspberry Pi and power on

4. Configure & setup Raspberry Pi

- `./pi_local.sh`
