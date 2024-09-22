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