#!/bin/bash

# Update and upgrade Termux packages
pkg update && pkg upgrade -y

# Install necessary packages (if you have any additional ones for bash)
echo "Installing necessary packages..."
./install-pkg.sh

# Backup existing .bashrc if it exists
if [ -f ~/.bashrc ]; then
    echo "Backing up existing .bashrc to .bashrc.backup"
    mv ~/.bashrc ~/.bashrc.backup
fi

# Setup bashrc
echo "Setting up .bashrc..."
cp bashrc ~/.bashrc

# Source the .bashrc file to load configurations
echo "Sourcing .bashrc..."
source ~/.bashrc

# Setup Termux properties
echo "Setting up Termux properties..."
mkdir -p ~/.termux
cp termux.properties ~/.termux/termux.properties
termux-reload-settings

echo "Setup complete. Please restart Termux."
