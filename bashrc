# ~/.bashrc

# Custom PS1 prompt
PS1='\[\e[32m\]\u@\h \[\e[34m\]\w\[\e[0m\] $ '

# Aliases for convenience
alias ll='ls -la'
alias la='ls -a'
alias update='pkg update && pkg upgrade -y'
alias cls='clear'
alias rm='rm -f -r'
alias playwwe='echo "playwwe" && mpv /storage/emulated/0/song/wwe/ww.mp3'

# Enable bash completion if available
if [ -f /data/data/com.termux/files/usr/etc/bash_completion ]; then
    . /data/data/com.termux/files/usr/etc/bash_completion
fi

# Fuzzy Finder setup
if command -v fzf >/dev/null 2>&1; then
    # Function to fuzzy find files, including hidden files
    fzff() {
        local file
        file=$(find . -type f -name '.*' -o -type f | fzf)
        if [[ -n $file ]]; then
            nano "$file"  # Or any other command you prefer to open the file
        fi
    }
    # Bind the function to a shortcut, for example Ctrl+F
    bind -x '"\C-f": fzf_find'
fi

# Fuzzy Finder for navigating directories, opening files, going back, and deleting
if command -v fzf >/dev/null 2>&1; then
    fzfe() {
        local current_dir="$PWD"
        while true; do
            # Step 1: Navigate or delete with prompt
            local selection
            selection=$(find . -mindepth 1 -maxdepth 1 \( -type d -o -type f \) | fzf --prompt="Navigate or select file (DEL to delete, BKSP to go up): " --expect=ctrl-d,backspace)
            if [[ -z $selection ]]; then
                break  # Exit if no selection
            fi
            key=$(head -n1 <<< "$selection")
            selection=$(tail -n+2 <<< "$selection")
            # If Ctrl+D is pressed, delete the selected file or directory
            if [[ $key == "ctrl-d" ]]; then
                rm -rf "$selection" && echo "Deleted $selection"
                continue
            fi
            # If Backspace is pressed, go back to the previous directory
            if [[ $key == "backspace" ]]; then
                cd .. || break
                continue
            fi
            # If a directory is selected, navigate into it
            if [[ -d $selection ]]; then
                cd "$selection" || break
                current_dir="$PWD"
                continue
            fi
            # If a file is selected, open it
            if [[ -f $selection ]]; then
                nano "$selection"  # Or replace with your preferred editor
                break
            fi
        done
    }
    # Bind the function to a shortcut, for example Ctrl+O
    bind -x '"\C-o": fzfe'
fi

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
bind -x '"\C-p": pkg_search_install'


# Enable reverse search with Up/Down keys for partially typed commands
# This will use arrow keys to search through history based on the typed prefix
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Export paths (if necessary)
# export PATH="$HOME/bin:$PATH"

# History settings
# History Managemenst Using .bashrc
# Enable appending to the history file
shopt -s histappend
export HISTCONTROL=ignoreboth:erasedups
export PROMPT_COMMAND="history -n; history -w; history -c; history -r"

# Function to clean up the history
cleanup_history() {
    local tmpfile="$HOME/.bash_history_tmp"
    # Create a temporary file in the home directory
    tac "$HISTFILE" | awk '!x[$0]++' > "$tmpfile" &&
    tac "$tmpfile" > "$HISTFILE"
    # Remove the temporary file
    rm "$tmpfile"
}
# Call the cleanup function
cleanup_history

# Ignore some commands from history
export HISTIGNORE="ls:ll:cd:cd -:pwd:exit:clear"

