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
# storage="$HOME/storage/shared"

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

update_ms3_repo() {
    local ms3_folder="$HOME/ms3"

    if [ -d "$ms3_folder" ]; then
        echo "Changing directory to $ms3_folder..."
        cd "$ms3_folder" || {
            echo "Failed to change directory to $ms3_folder."
            return 1
        }

        echo "Pulling latest changes from the repository..."
        git pull || {
            echo "Failed to pull changes. Please check your repository setup."
            return 1
        }

        echo "Repository updated successfully."
    else
        echo "The folder $ms3_folder does not exist."
        return 1
    fi
}



# Function to create an rclone folder and copy rclone.conf file
rclone_setup() {
    RCLONE_CONFIG_DIR="$HOME/.config/rclone"
    SOURCE_CONF_FILE="$HOME/storage/shared/rclone.conf"

    # Create the rclone folder if it doesn't exist
    echo -e "Creating rclone configuration directory at $RCLONE_CONFIG_DIR..."
    mkdir -p "$RCLONE_CONFIG_DIR" || {
        echo -e "Failed to create rclone directory. Please check permissions."
        return 1
    }
    echo -e "Directory created or already exists: $RCLONE_CONFIG_DIR"

    # Copy rclone.conf to the new directory
    echo -e "Copying rclone.conf from $SOURCE_CONF_FILE to $RCLONE_CONFIG_DIR..."
    if [ -f "$SOURCE_CONF_FILE" ]; then
        cp "$SOURCE_CONF_FILE" "$RCLONE_CONFIG_DIR/" || {
            echo -e "Failed to copy rclone.conf. Please check permissions or the file path."
            return 1
        }
        echo -e "rclone.conf copied successfully to $RCLONE_CONFIG_DIR"
    else
        echo -e "Source file $SOURCE_CONF_FILE does not exist. Please ensure the file exists."
        return 1
    fi
}


# Function to restore songs from the web using rclone
Restore_Songs() {
    DEST_DIR="$HOME/storage/shared/song"
    REMOTE="gu:/song"
    
    # Sync the songs from the remote to the destination directory
    echo -e "Starting rclone sync from $REMOTE to $DEST_DIR..."

    rclone sync "$REMOTE" "$DEST_DIR" -P --check-first --transfers=1 --track-renames --fast-list || {
        echo -e "Failed to sync songs from $REMOTE to $DEST_DIR. Please check your rclone configuration."
        return 1
    }
    
    echo -e "Songs restored successfully from $REMOTE to $DEST_DIR"
}

# Function to handle exit
exit_script() {
    echo -e "${GREEN}Exiting the script. Goodbye!${NC}"
    exit 0
}

quick_file_search() {
    local file_name=$1
    local search_dir=${2:-$PWD}

    if [ -z "$file_name" ]; then
        echo "Usage: quick_file_search <file_name> [directory]"
        return 1
    fi

    echo "Searching for $file_name in $search_dir..."
    find "$search_dir" -type f -name "$file_name"
}

network_speed_test() {
    echo "Testing network speed..."
    if command -v speedtest &> /dev/null; then
        speedtest
    else
        echo "speedtest-cli not installed. Installing now..."
        sudo apt install -y speedtest-cli
        speedtest
    fi
}

list_large_files() {
    local target_dir=${1:-$PWD}

    echo "Finding large files in $target_dir..."
    find "$target_dir" -type f -exec du -h {} + | sort -rh | head -n 10
}

# Function to SSH into a remote server and run a local AutoHotkey script
remote_access() {
    local remote_password="1823"
    local remote_user="nahid"
    local remote_host="192.168.0.101"
    local ahk_script_path="C:\\ms1\\scripts\\ahk\\remote_access\\rrr_access_2nd.ahk"

    echo -e "Connecting to remote server via SSH..."
    sshpass -p "$remote_password" ssh "$remote_user@$remote_host" || {
        echo -e "${RED}Failed to connect to remote server.${NC}"
        return 1
    }

    echo -e "Running AutoHotkey script..."
    start "" "$ahk_script_path" || {
        echo -e "${RED}Failed to run AutoHotkey script.${NC}"
        return 1
    }

    echo -e "${GREEN}Remote access and script execution completed successfully.${NC}"
}


# Declare a combined array of menu options and function bindings
menu_items=(
    "1 :Copy Files:                     copy_files                              :$BLUE"
    "2 :Install Necessary Packages:     install_packages    setup_storage_passwd:$BLUE"
    "3 :Font Setup:                     install_font_with_oh_my_posh            :$BLUE"
    "4 :Git Pull [ms3]:                 update_ms3_repo                         :$BLUE"
    "5 :Rclone Setup:                   rclone_setup                            :$BLUE"
    "6 :Song [rs]:                      Restore_Songs                           :$BLUE"
    "7 :Neovim Setup:                   nvim_setup                              :$BLUE"
    "8 :Git Push:                       git_push_repo                           :$BLUE"
    "9 :Remove Folder [ms3]:            remove_repo                             :$RED"
    "10:Exit:                           exit_script                             :$RED"
    "11:Remote Access:                  remote_access                           :$BLUE"
)

# Display the menu and handle user input
while true; do
    echo ""
    echo -e "${YELLOW}Select an option:${NC}"

    # Display menu options dynamically with assigned colors
    for item in "${menu_items[@]}"; do
        IFS=":" read -r number description functions color <<< "$item"
        echo -e "${color}$number. $description${NC}"
    done

    echo ""
    read -p "Enter choice: " choice

    # Check if the choice is valid before executing the functions
    valid_choice=false
    for item in "${menu_items[@]}"; do
        IFS=":" read -r number description functions color <<< "$item"
        if [ "$choice" -eq "$number" ]; then
            valid_choice=true
            IFS=" " read -r -a function_array <<< "$functions"
            for function in "${function_array[@]}"; do
                $function
            done
            break
        fi
    done

    # If the choice is invalid, show an error message
    if [ "$valid_choice" = false ]; then
        echo -e "${RED}Invalid option. Please try again.${NC}"
    fi
done
