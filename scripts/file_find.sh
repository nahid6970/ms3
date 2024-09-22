# Fuzzy Finder setup
if command -v fzf >/dev/null 2>&1; then
    # Function to fuzzy find files, including hidden files
    ff() {
        local file
        file=$(find . -type f -name '.*' -o -type f | fzf)
        if [[ -n $file ]]; then
            vim "$file"  # Or any other command you prefer to open the file
        fi
    }
    # Bind the function to a shortcut, for example Ctrl+F
    bind -x '"\C-f": ff'
fi