#!/bin/bash

# List of necessary packages
packages=(
    "zsh"
    "git"
    "curl"
    "wget"
    "mpv"
    "openssh"
    # Add other packages here
)

# Install packages
for pkg in "${packages[@]}"; do
    pkg install "$pkg" -y
done

# Change shell to ZSH
chsh -s zsh
