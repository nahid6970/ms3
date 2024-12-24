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
NVIM_INIT_SOURCE="$REPO_DIR/dotfiles/neovim/init.lua"
NVIM_CONFIG_DEST="$HOME/.config/nvim"

# Function to install necessary packages
packages=(
    "bash"
    "bat"
    "chafa"
    "curl"
    "fzf"
    "git"
    "lsd"
    "mpv"
    "nano"
    "neovim"
    "oh-my-posh"
    "openssh"
    "rclone"
    "sshpass"
    "vim"
    "wget"
    "yazi"
    "zsh"
    # "x11-repo"
    # "xdotool"
)

# Function to install necessary packages
install_packages() {
    echo -e "${GREEN}Updating package list...${NC}"
    pkg update -y
    echo -e "${GREEN}Upgrading installed packages...${NC}"
    pkg upgrade -y
    echo -e "${GREEN}Installing necessary packages...${NC}"
    for pkg in "${packages[@]}"; do
        # Check if the package is already installed
        if ! command -v $pkg &> /dev/null; then
            echo -e "${GREEN}Installing $pkg...${NC}"
            if pkg install "$pkg" -y; then
                echo -e "${GREEN}$pkg installed successfully.${NC}"
            else
                echo -e "${RED}Failed to install $pkg. Please check your network or package name.${NC}"
            fi
        else
            echo -e "${GREEN}$pkg is already installed.${NC}"
        fi
    done
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

# Font Download and Setup
install_font_with_oh_my_posh() {
    echo -e "\e[34mInstalling JetBrainsMono NFP font using oh-my-posh...\e[0m"
    oh-my-posh font install
    FONT_PATH="$HOME/.local/share/fonts/jetbrainsmono-nfp/JetBrainsMonoNerdFontPropo-Regular.ttf"
    TERMUX_FONT_DIR="$HOME/.termux"
    # Check if the font is installed
    if [ -f "$FONT_PATH" ]; then
        echo -e "\e[32mJetBrainsMono NFP font found. Setting it as the default...\e[0m"
        # Create .termux directory if it doesn't exist
        mkdir -p "$TERMUX_FONT_DIR"
        # Copy the font file to the .termux directory as font.ttf
        cp "$FONT_PATH" "$TERMUX_FONT_DIR/font.ttf"
        # Reload Termux settings to apply the font
        termux-reload-settings
        echo -e "\e[32mFont has been set as default and Termux settings reloaded.\e[0m"
    else
        echo -e "\e[31mJetBrainsMono NFP font not found after installation. Please ensure it is installed at $FONT_PATH\e[0m"
    fi
}

# Copy .bashrc and termux.properties
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

# Neovim setup function
nvim_setup() {
    echo -e "${BLUE}Setting up Neovim configuration...${NC}"
    # Create the Neovim config directory if it doesn't exist
    mkdir -p "$NVIM_CONFIG_DEST"
    # Copy the init.lua file to the Neovim config directory
    cp "$NVIM_INIT_SOURCE" "$NVIM_CONFIG_DEST/init.lua"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Neovim configuration setup successfully.${NC}"
    else
        echo -e "${RED}Failed to set up Neovim configuration.${NC}"
    fi
}

# Git push repository function
git_push_repo() {
    echo -e "${BLUE}Pushing the repository to the remote...${NC}"
    cd "$REPO_DIR"
    git add .
    echo -e "${CYAN}Enter commit message:${NC}"
    read commit_message
    git commit -m "$commit_message"
    git push
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Repository pushed successfully.${NC}"
    else
        echo -e "${RED}Failed to push the repository. Please check your Git configuration.${NC}"
    fi
}

# Menu options
declare -A menu_options=(
    ["Install Necessary Packages"]="install_packages setup_storage_passwd copy_files"
    ["Font Setup"]="install_font_with_oh_my_posh"
    ["Neovim Setup"]="nvim_setup"
    ["Copy Files"]="copy_files"
    ["Git Push"]="git_push_repo"
    ["Remove Folder"]="remove_repo"
    ["Exit"]="exit 0"
)

# Display the menu
while true; do
    echo ""
    echo -e "${YELLOW}Select an option:${NC}"
    i=1
    for key in "${!menu_options[@]}"; do
        echo -e "${BLUE}$i. $key${NC}"
        options[$i]="$key"
        ((i++))
    done
    echo ""

    read -p "Enter choice: " choice

    selected="${options[$choice]}"
    if [[ -n "$selected" ]]; then
        echo -e "${MAGENTA}Starting $selected...${NC}"
        eval "${menu_options[$selected]}"
    else
        echo -e "${RED}Invalid option. Please try again.${NC}"
    fi
done