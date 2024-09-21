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

# Fuzzy Finder for navigating directories and opening files
# Fuzzy Finder for navigating directories and opening files in two steps
# Fuzzy Finder for navigating directories, opening files, going back, and deleting files/directories
# Fuzzy Finder for navigating directories, opening files, going back, and deleting files/directories
if command -v fzf >/dev/null 2>&1; then
    fzfe() {
        local selection
        local preview_cmd='[[ -d {} ]] && echo Directory || (bat --color=always {} 2> /dev/null || cat {})'
        
        while true; do
            # List directories and files with a preview
            selection=$(find . -maxdepth 1 \( -type d -o -type f \) \
                | fzf --preview "$preview_cmd" \
                      --prompt="Select (Backspace=back, d=delete): " \
                      --bind 'backspace:execute(cd ..; $0)&abort' \
                      --bind 'd:execute-silent(echo {} && rm -rf {} && echo Deleted!)+abort')

            # If nothing is selected, break the loop
            [[ -z $selection ]] && break

            # If a directory is selected, enter that directory
            if [[ -d $selection ]]; then
                cd "$selection" || return
            elif [[ -f $selection ]]; then
                # If a file is selected, open it with the default editor
                vim "$selection"  # Or replace with your preferred editor
                return  # Exit after opening a file
            fi
        done
    }

    # Bind the function to a shortcut, for example Ctrl+O
    bind -x '"\C-o": fzf_cd_or_open'
fi

# Enable reverse search with Up/Down keys for partially typed commands
# This will use arrow keys to search through history based on the typed prefix
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Export paths (if necessary)
# export PATH="$HOME/bin:$PATH"

# History settings
HISTSIZE=1000      # Number of commands to remember in the command history
HISTFILESIZE=2000  # Maximum number of lines in the history file
HISTCONTROL=ignoredups:erasedups  # Don't store duplicate commands in history
shopt -s histappend  # Append to the history file, don't overwrite it

# Enable auto-completion for partially typed commands
shopt -s histreedit
shopt -s histverify

# Ignore some commands from history
export HISTIGNORE="ls:ll:cd:cd -:pwd:exit:clear"

