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
fzfm () {
    while true; do
        selection="$(lsd -a -1 | fzf \
            --bind "left:pos(2)+accept" \
            --bind "right:accept" \
            --bind "shift-up:preview-up" \
            --bind "shift-down:preview-down" \
            --bind "ctrl-d:execute(bash -e ~/.local/fzfm/create_dir.sh)+reload(lsd -a -1)" \
            --bind "ctrl-f:execute(bash -e ~/.local/fzfm/create_file.sh)+reload(lsd -a -1)" \
            --bind "ctrl-t:execute(trash {+})+reload(lsd -a -1)" \
            --bind "ctrl-c:execute(cp -R {} /tmp/copied/$(basename {}).copy)" \
            --bind "ctrl-m:execute(mv -n {} /tmp/copied/$(basename {}).copy)+reload(lsd -a -1)" \
            --bind "ctrl-g:execute(mv -n /tmp/copied/* . && rm -rf /tmp/copied/*)+reload(lsd -a -1)" \
            --bind "esc:execute(rm /tmp/copied/*)+abort" \
            --bind "space:toggle" \
            --color=fg:#d0d0d0,fg+:#d0d0d0,bg+:#262626 \
            --color=hl:#5f87af,hl+:#487caf,info:#afaf87,marker:#274a37 \
            --color=pointer:#a62b2b,spinner:#af5fff,prompt:#876253,header:#87afaf \
            --height 95% \
            --pointer  \
            --reverse \
            --multi \
            --info inline-right \
            --prompt "Search: " \
            --border "bold" \
            --border-label "$(pwd)/" \
            --preview-window=right:65% \
            --preview 'sel=$(echo {} | cut -d " " -f 2); cd_pre="$(echo $(pwd)/$(echo {}))";
                    echo "Folder: " $cd_pre;
                    lsd -a --icon=always --color=always "${cd_pre}";
                    cur_file="$(file $(echo $sel) | grep [Tt]ext | wc -l)";
                    if [[ "${cur_file}" -eq 1 ]]; then
                        bat --style=numbers --theme=ansi --color=always $sel 2>/dev/null
                    else
                        chafa -c full --color-space rgb --dither none -p on -w 9 2>/dev/null {}
                        fi')"
                        if [[ -d ${selection} ]]; then
                            >/dev/null cd "${selection}"
                        elif [[ -f "${selection}" ]]; then
                            file_type=$(file -b --mime-type "${selection}" | cut -d'/' -f1)
                            case $file_type in
                                "text")
                                    nvim -u $HOME/.config/nvim/init.lua "${selection}"
                                    ;;
                                "image")
                                    for fType in ${selection}
                                    do 
                                        if [[ "${fType}" == *.xcf ]]; then
                                            gimp 2>/dev/null "${selection}"
                                        else
                                            sxiv "${selection}"
                                        fi
                                    done
                                    ;;
                                "video")
                                    mpv -fs "${selection}" > /dev/null
                                    ;;
                                "application")
                                    for fType in ${selection}
                                    do
                                        if [[ "${fType}" == *.docx ]] || [[ "${fType}" == *.odt ]]; then
                                            libreoffice "${selection}" > /dev/null
                                        elif [[ "${fType}" == *.pdf ]]; then
                                            zathura 2>/dev/null "${selection}"
                                        fi
                                    done
                                    ;;

                                "inode")
                                    nvim -u $HOME/.config/nvim/init.lua "${selection}"
                                    ;;
                            esac
                        else
                            break
                        fi
                    done
                }
                clear

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

