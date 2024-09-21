#!/bin/bash

# List of necessary packages
packages=(
    "bash"
    "git"
    "curl"
    "wget"
    "mpv"
    "openssh"
    # Add other packages here if needed
)

# Install packages
for pkg in "${packages[@]}"; do
    pkg install "$pkg" -y
done
