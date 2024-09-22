#!/bin/bash

# Define some variables
REPO_DIR="$HOME/ms3"
BASHRC_SOURCE="$REPO_DIR/bashrc"
BASHRC_DEST="$HOME/.bashrc"
TERMUX_PROPERTIES_SOURCE="$REPO_DIR/termux.properties"
TERMUX_PROPERTIES_DEST="$HOME/.termux/termux.properties"

# Function to install necessary packages
install_packages() {
    echo "Installing necessary packages..."
    pkg update -y && pkg upgrade -y
    pkg install -y wget curl git fzf zsh nano bash mpv openssh bat lsd sxiv chafa
    echo "Packages installed successfully."
}

# Function to set up storage and password
setup_storage_passwd() {
    echo "Setting up storage..."
    termux-setup-storage
    echo "Storage setup completed."

    echo "Setting up password..."
    passwd
    echo "Password setup completed."
}

copy_files() {
    echo "Copying .bashrc and termux.properties..."
    cp "$BASHRC_SOURCE" "$BASHRC_DEST"
    mkdir -p "$(dirname $TERMUX_PROPERTIES_DEST)"
    cp "$TERMUX_PROPERTIES_SOURCE" "$TERMUX_PROPERTIES_DEST"
    termux-reload-settings
    echo "Files copied and settings reloaded."
}

# Function to remove the repository
remove_repo() {
    echo "Removing the repository folder ($REPO_DIR)..."
    rm -rf "$REPO_DIR"
    echo "Repository folder removed successfully."
}


# Display the menu
while true; do
    echo ""
    echo "Select an option:"
    echo "1. Initial Setup (install necessary packages, setup storage and password)"
    echo "2. Copy .bashrc and termux.properties"
    echo "3. Remove the repo folder (ms3)"
    echo "4. Exit"
    echo ""
    read -p "Enter your choice [1-4]: " choice

    case $choice in
        1)
            echo "Starting initial setup..."
            install_packages
            setup_storage_passwd
            ;;
        2)
            echo "Copying configuration files..."
            copy_files
            ;;
        3)
            echo "Removing the repo..."
            remove_repo
            ;;
        4)
            echo "Exiting the script. Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
done
