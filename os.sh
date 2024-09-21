#!/bin/bash

# Update and upgrade Termux packages
pkg update && pkg upgrade -y

# Install necessary packages
echo "Installing necessary packages..."
./install-pkg.sh

# Setup Termux properties
echo "Setting up Termux properties..."
mkdir -p ~/.termux
cp termux.properties ~/.termux/termux.properties
termux-reload-settings

echo "Setup complete. Bash is set as the default shell. Please restart Termux."
