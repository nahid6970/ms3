#!/bin/bash

# Define some color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Define some variables
REPO_DIR="$HOME/ms3"
BASHRC_SOURCE="$REPO_DIR/bashrc"
TERMUX_PROPERTIES_SOURCE="$REPO_DIR/termux.properties"
BASHRC_DEST="$HOME/.bashrc"
TERMUX_PROPERTIES_DEST="$HOME/.termux/termux.properties"

# Function to install necessary packages
install_packages() {
    echo -e "${GREEN}Installing necessary packages...${NC}"
    pkg update -y && pkg upgrade -y
    pkg install -y wget curl git fzf zsh nano bash mpv openssh bat lsd sxiv chafa
    echo -e "${GREEN}Packages installed successfully.${NC}"
}

# Function to set up storage and password
setup_storage_passwd() {
    echo -e "${GREEN}Setting up storage...${NC}"
    termux-setup-storage
    echo -e "${GREEN}Storage setup completed.${NC}"

    echo -e "${GREEN}Setting up password...${NC}"
    passwd
    echo -e "${GREEN}Password setup completed.${NC}"
}

# Function to copy .bashrc and termux.properties
copy_files() {
    echo -e "${CYAN}Copying .bashrc and termux.properties...${NC}"
    cp "$BASHRC_SOURCE" "$BASHRC_DEST"
    mkdir -p "$(dirname $TERMUX_PROPERTIES_DEST)"
    cp "$TERMUX_PROPERTIES_SOURCE" "$TERMUX_PROPERTIES_DEST"
    termux-reload-settings
    echo -e "${CYAN}Files copied and settings reloaded.${NC}"
}

# Function to remove the repository
remove_repo() {
    echo -e "${RED}Removing the repository folder ($REPO_DIR)...${NC}"
    rm -rf "$REPO_DIR"
    echo -e "${RED}Repository folder removed successfully.${NC}"
}

# Display the menu
while true; do
    echo ""
    echo -e "${YELLOW}Select an option:${NC}"
    echo -e "${BLUE}1. Initial Setup${NC} (install necessary packages, setup storage and password)"
    echo -e "${BLUE}2. Copy .bashrc and termux.properties${NC}"
    echo -e "${BLUE}3. Remove the repo folder (ms3)${NC}"
    echo -e "${BLUE}4. Exit${NC}"
    echo ""
    read -p "Enter your choice [1-4]: " choice

    case $choice in
        1)
            echo -e "${MAGENTA}Starting initial setup...${NC}"
            install_packages
            setup_storage_passwd
            ;;
        2)
            echo -e "${MAGENTA}Copying configuration files...${NC}"
            copy_files
            ;;
        3)
            echo -e "${MAGENTA}Removing the repo...${NC}"
            remove_repo
            ;;
        4)
            echo -e "${GREEN}Exiting the script. Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please try again.${NC}"
            ;;
    esac
done
