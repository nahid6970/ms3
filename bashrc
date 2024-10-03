# ~/.bashrc

# Custom PS1 prompt
# PS1='\[\e[32m\]\u@\h \[\e[34m\]\w\[\e[0m\] $ '

# Aliases for convenience
alias cls='clear'
alias la='ls -a'
alias ll='ls -la'
alias os='bash ms3/os.sh'
alias playwwe='echo "playwwe" && mpv /storage/emulated/0/song/wwe/ww.mp3'
alias rb='termux-reload-settings'
alias rm='rm -f -r'
alias update='pkg update && pkg upgrade -y'

# Enable bash completion if available
if [ -f /data/data/com.termux/files/usr/etc/bash_completion ]; then
    . /data/data/com.termux/files/usr/etc/bash_completion
fi

# ~/.bashrc

# Source custom scripts from the ms3/scripts directory
SCRIPTS_DIR="$HOME/ms3/scripts"
# Check if the scripts directory exists
if [ -d "$SCRIPTS_DIR" ]; then
    # Source each script file
    for script in "$SCRIPTS_DIR"/*.sh; do
        [ -r "$script" ] && . "$script"
    done
fi

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

# Function to clone or update a Git repository
git_clone() {
    local repo_url=$1
    local repo_name=$(basename "$repo_url" .git)
    # Check if the repository already exists
    if [ -d "$repo_name/.git" ]; then
        echo "Repository '$repo_name' already exists. Updating..."
        cd "$repo_name" || exit
        git pull
        cd - || exit
    else
        # Clone the repository if it doesn't exist
        echo "Cloning repository '$repo_name'..."
        git clone "$repo_url"
    fi
}

# Add this to the end of your ~/.bashrc file
# eval "$(oh-my-posh init bash)"