#!/bin/bash

# List of necessary packages
packages=(
    "zsh"
    "git"
    "curl"
    "wget"
    "mpv"
    "openssh"
    # Add other necessary packages here
)

# Install packages
for pkg in "${packages[@]}"; do
    if pkg install "$pkg" -y; then
        echo "$pkg installed successfully."
    else
        echo "Failed to install $pkg. Continuing with the next package..."
    fi
done

# Change shell to ZSH
chsh -s zsh
