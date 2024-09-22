# Fuzzy Finder for navigating directories, opening files, going back, and deleting
if command -v fzf >/dev/null 2>&1; then
    fe() {
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
                nvim "$selection"  # Or replace with your preferred editor
                break
            fi
        done
    }
    # Bind the function to a shortcut, for example Ctrl+O
    bind -x '"\C-o": fe'
fi
