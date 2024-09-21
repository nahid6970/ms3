#!/bin/bash

# Update and upgrade Termux packages
pkg update && pkg upgrade -y

# Install ZSH if not already installed
if ! command -v zsh &> /dev/null; then
    echo "ZSH is not installed. Installing ZSH..."
    pkg install zsh -y
else
    echo "ZSH is already installed."
fi

# Install other necessary packages
echo "Installing other necessary packages..."
./install-pkg.sh

# Setup auto suggestion and syntax highlighting for ZSH
echo "Setting up ZSH auto suggestion and syntax highlighting..."
mkdir -p ${HOME}/.zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ${HOME}/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.zsh/zsh-syntax-highlighting

# Backup existing .zshrc if it exists
if [ -f ~/.zshrc ]; then
    echo "Backing up existing .zshrc to .zshrc.backup"
    mv ~/.zshrc ~/.zshrc.backup
fi

# Setup zshrc
echo "Setting up .zshrc..."
cp zshrc ~/.zshrc

# Set ZSH as the default shell
chsh -s zsh

# Source the .zshrc file to load configurations
echo "Sourcing .zshrc..."
source ~/.zshrc

# Setup Termux properties
echo "Setting up Termux properties..."
mkdir -p ~/.termux
cp termux.properties ~/.termux/termux.properties
termux-reload-settings

echo "Setup complete. Please restart Termux or type 'zsh' to start a new ZSH session."
