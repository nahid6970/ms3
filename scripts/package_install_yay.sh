# Function to search and install Termux packages using fzf
yay() {
    # Fetch the list of available packages
    local package
    package=$(pkg list-all | awk '{print $1}' | fzf --prompt="Search for a package: ")
    # If a package is selected, install it
    if [[ -n "$package" ]]; then
        echo "Installing package: $package"
        pkg install "$package" -y
    else
        echo "No package selected."
    fi
}
# Bind the function to a shortcut (optional)
bind -x '"\C-p": yay'