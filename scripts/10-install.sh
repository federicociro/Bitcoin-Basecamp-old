#!/bin/bash

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Make executables all the scripts
echo "--------------------------------------------------"
echo "Adding execution capability to the scripts"
chmod +x *.sh

# replace $USER with the non-root user
#usermod -a -G sudo $USER

# Check if users exist, if not add them
echo "--------------------------------------------------"
echo "Adding users..."
if ! id -u bitcoin > /dev/null 2>&1; then
  sudo useradd -m bitcoin
fi

if ! id -u fulcrum > /dev/null 2>&1; then
  sudo useradd -m fulcrum
  sudo adduser fulcrum bitcoin
fi

if ! id -u mempool > /dev/null 2>&1; then
  sudo useradd -m mempool
  sudo adduser mempool bitcoin
fi

# Update the system.
sudo apt update
sudo apt upgrade -y

# Prompt the user to set a hostname.
read -p "Enter a hostname (press Enter to skip): " hostname
if [ -n "$hostname" ]; then
  hostnamectl set-hostname "$hostname"
  echo "Hostname set to $hostname"
  echo "A reboot is needed to apply the changes."
fi