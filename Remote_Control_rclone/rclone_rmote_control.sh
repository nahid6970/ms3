#!/bin/bash

# Define the remote file paths
REMOTE_COMMAND_FILE="g00:/Remote_Control/Command.txt"
REMOTE_OUTPUT_FILE="g00:/Remote_Control/output.txt"
REMOTE_COMMAND_HISTORY_FILE="$HOME/.remote_command_history"  # Store history here

# Enable readline to handle history in an interactive shell
export HISTFILE="$REMOTE_COMMAND_HISTORY_FILE"
export HISTSIZE=1000
export HISTCONTROL=ignoredups
shopt -s histappend  # Append to history file instead of overwriting it

# Function to send a command and wait for output
function send_command() {
    local user_command=$1
    local unique_id=$(date +%s)  # Generate a unique ID for each command

    # Combine the unique ID with the command for tracking
    remote_command="$unique_id: $user_command"

    # Write the command to the remote file using rclone rcat
    echo "$remote_command" | rclone rcat "$REMOTE_COMMAND_FILE"

    if [ $? -ne 0 ]; then
        echo "Failed to send command. Check your rclone setup."
        return 1
    fi

    echo "Command sent with ID: $unique_id."

    # Wait for the output with retries
    MAX_ATTEMPTS=5
    attempt=0

    while [ $attempt -lt $MAX_ATTEMPTS ]; do
        attempt=$((attempt + 1))
        sleep 3  # Wait 3 seconds before checking for output

        # Retrieve the output from the remote file
        output=$(rclone cat "$REMOTE_OUTPUT_FILE")

        # Check if the output matches the unique ID to validate the response
        if [[ "$output" == *"$unique_id"* ]]; then
            echo -e "Output for command ID $unique_id received:"
            echo "$output"
            return 0
        else
            echo -e "Output ID mismatch. Retrying... ($attempt/$MAX_ATTEMPTS)"
        fi
    done

    echo "Max attempts reached. Command output not received."
    return 1
}

# Interactive mode for entering commands
function interactive_mode() {
    echo "Entering interactive mode. Type your remote commands."
    echo "Type 'exit' to quit interactive mode."

    # Use a loop to handle interactive command input
    while true; do
        # Use `readline` with `read -e` for history navigation (up/down arrows)
        read -e -p "rc> " user_command

        # If the user presses Enter without typing anything, skip
        if [ -z "$user_command" ]; then
            continue
        fi

        # Exit the interactive mode if 'exit' is typed
        if [ "$user_command" == "exit" ]; then
            echo "Exiting interactive mode."
            break
        fi

        # Save the command to the history file (automatically handled by readline)
        echo "$user_command" >> "$REMOTE_COMMAND_HISTORY_FILE"

        # Send the command and wait for output
        send_command "$user_command"
    done
}

# Check if a command was provided
if [ -z "$1" ]; then
    # Start interactive mode if no command is passed
    interactive_mode
else
    # Otherwise, send the provided command immediately
    send_command "$*"
fi
