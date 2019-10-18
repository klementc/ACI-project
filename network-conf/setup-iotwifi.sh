#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

set -x
# prevent wpa_supplicant from starting on boot
systemctl mask wpa_supplicant.service

# rename wpa_supplicant on the host to ensure that it is not
# used.
mv /sbin/wpa_supplicant /sbin/no_wpa_supplicant

# kill any running processes named wpa_supplicant
pkill wpa_supplicant

# Docker install script
curl -sSL https://get.docker.com | sh

#adding user to docker group
usermod -aG docker aci


