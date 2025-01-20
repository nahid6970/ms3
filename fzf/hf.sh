# Search history with fzf and execute the selected command
search_history() {
    local cmd
    # Use `fzf` to interactively search through command history
    cmd=$(history | awk '{$1=""; print substr($0,2)}' | fzf --height=40% --reverse --prompt="Search History: " --ansi)

    # If a command is selected, execute it
    if [ -n "$cmd" ]; then
        echo "Executing: $cmd"
        eval "$cmd"
    fi
}

search_history

