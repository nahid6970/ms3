# Fuzzy Finder setup
if command -v fzf >/dev/null 2>&1; then
    # Function to fuzzy find files, including hidden files
    ff() {
        local file
        file=$(find . -type f -name '.*' -o -type f | fzf)

        if [[ -n $file ]]; then
            # Open the file with nano
            nano "$file"
        fi
    }

    # Function to copy the selected file path to the clipboard
    copy_file_path() {
        local file
        file=$(find . -type f -name '.*' -o -type f | fzf)
        
        if [[ -n $file ]]; then
            # Copy the file path to the clipboard
            echo -n "$file" | termux-clipboard-set  # Use `pbcopy` on macOS or `xclip` on Linux
            echo "Copied: $file"  # Optional: Notify that the path was copied
        fi
    }

    # Bind the function to shortcuts
    bind -x '"\C-f": ff'   # Ctrl+F to open file in nano
    bind -x '"\e[1;5;67": copy_file_path'  # Alt+C to copy the file path
fi
