#!/bin/bash

# Update and upgrade Termux packages
echo "Updating and upgrading Termux packages..."
pkg update && pkg upgrade -y

# Install necessary packages
echo "Installing necessary packages..."
# List of packages to install
packages=(
    "bash"          # Bash shell (already default in Termux, just for completeness)
    "git"           # Version control system
    "curl"          # Command line tool for transferring data with URLs
    "wget"          # Network downloader
    # "zsh"           # Z Shell (optional if you want to have both bash and zsh)
    "mpv"
    "openssh"
    "fzf"
    "bat"
    "lsd"
    "sxiv"
    "chafa"
)

# Loop through the package list and install each one
for pkg in "${packages[@]}"; do
    if ! command -v $pkg &> /dev/null; then
        echo "Installing $pkg..."
        pkg install "$pkg" -y
    else
        echo "$pkg is already installed."
    fi
done

# Backup existing .bashrc if it exists
if [ -f ~/.bashrc ]; then
    echo "Backing up existing .bashrc to .bashrc.backup"
    mv ~/.bashrc ~/.bashrc.backup
fi

# Setup custom .bashrc
echo "Setting up .bashrc..."
cp bashrc ~/.bashrc

# Source the .bashrc file to load configurations
echo "Sourcing .bashrc..."
source ~/.bashrc

# Setup Termux properties for better key config
echo "Setting up Termux properties..."
mkdir -p ~/.termux
cp termux.properties ~/.termux/termux.properties
termux-reload-settings

# Ensure bash is the default shell (usually already is in Termux)
echo "Setting bash as the default shell..."
chsh -s bash

# Setup storage permissions
echo "Setting up storage permissions..."
termux-setup-storage

# Prompt user to set up a password
echo "Please set up a password for Termux."
passwd

echo "Setup complete. Please restart Termux."