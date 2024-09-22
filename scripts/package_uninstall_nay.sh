# Function to search and uninstall Termux packages using fzf
nay() {
    # Fetch the list of installed packages and remove the ',now' suffix
    local package
    package=$(pkg list-installed | awk '{print $1}' | sed 's/,now$//' | fzf --prompt="Select a package to uninstall: ")
    
    # If a package is selected, uninstall it
    if [[ -n "$package" ]]; then
        echo "Uninstalling package: $package"
        pkg uninstall "$package" -y
    else
        echo "No package selected."
    fi
}

# Bind the function to a shortcut (optional)
bind -x '"\C-u": nay'
