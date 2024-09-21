#!/bin/bash

# Update and upgrade Termux packages
pkg update && pkg upgrade -y

# Install necessary packages
echo "Installing necessary packages..."
./install-pkg.sh

# Setup auto suggestion and syntax highlighting for ZSH
echo "Setting up ZSH auto suggestion and syntax highlighting..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${HOME}/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.zsh/zsh-syntax-highlighting

# Setup zshrc
echo "Setting up .zshrc..."
cp zshrc ~/.zshrc

# Setup Termux properties
echo "Setting up Termux properties..."
mkdir -p ~/.termux
cp termux.properties ~/.termux/termux.properties
termux-reload-settings

echo "Setup complete. Please restart Termux."
