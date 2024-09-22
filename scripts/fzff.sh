# Fuzzy Finder setup
if command -v fzf >/dev/null 2>&1; then
    # Function to fuzzy find files, including hidden files
    fzff() {
        local file
        file=$(find . -type f -name '.*' -o -type f | fzf --bind 'alt-c:execute-silent(echo -n {} | termux-clipboard-set)+abort')

        if [[ -n $file ]]; then
            nano "$file"  # Open the file with nano
        fi
    }

    # Bind the function to a shortcut, for example, Ctrl+F
    bind -x '"\C-f": fzff'
fi
