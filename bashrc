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


# Enable reverse search with Up/Down keys for partially typed commands
# This will use arrow keys to search through history based on the typed prefix
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Export paths (if necessary)
# export PATH="$HOME/bin:$PATH"

# History settings
# History Managemenst Using .bashrc
shopt -s histappend
export HISTCONTROL=ignoreboth:erasedups
export PROMPT_COMMAND="history -n; history -w; history -c; history -r"
tac "$HISTFILE" | awk '!x[$0]++' > /tmp/tmpfile  &&
                tac /tmp/tmpfile > "$HISTFILE"
rm /tmp/tmpfile

# Ignore some commands from history
export HISTIGNORE="ls:ll:cd:cd -:pwd:exit:clear"

