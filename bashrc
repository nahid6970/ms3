# ~/.bashrc

# Custom PS1 prompt
PS1='\[\e[32m\]\u@\h \[\e[34m\]\w\[\e[0m\] $ '

# Aliases for convenience
alias ll='ls -la'
alias update='pkg update && pkg upgrade -y'

# Enable bash completion if available
if [ -f /data/data/com.termux/files/usr/etc/bash_completion ]; then
    . /data/data/com.termux/files/usr/etc/bash_completion
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
