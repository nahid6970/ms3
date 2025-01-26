#!/bin/bash

# Enable command history using readline
HISTFILE="$HOME/.bash_history"
HISTSIZE=1000
HISTCONTROL=ignoredups  # Avoid duplicates in history
shopt -s histappend  # Append to the history file rather than overwrite it

# Define the remote file paths
REMOTE_COMMAND_FILE="g00:/Remote_Control/Command.txt"
REMOTE_OUTPUT_FILE="g00:/Remote_Control/output.txt"

# Function to send a command and wait for its output
function send_command() {
    local user_command=$1
    local unique_id=$(date +%s)  # Generate a unique ID (timestamp)

    # Combine the unique ID with the command
    remote_command="$unique_id: $user_command"

    # Write the command to the remote file using rclone rcat
    echo "$remote_command" | rclone rcat "$REMOTE_COMMAND_FILE"

    if [ $? -ne 0 ]; then
        echo "Failed to send command. Check your rclone setup."
        return 1
    fi

    echo "Command sent with ID: $unique_id."

    # Maximum number of attempts to get the output
    MAX_ATTEMPTS=5
    attempt=0

    # Wait for the output
    while [ $attempt -lt $MAX_ATTEMPTS ]; do
        attempt=$((attempt + 1))
        sleep 3  # Wait 3 seconds before checking output

        # Retrieve the output from the remote file
        output=$(rclone cat "$REMOTE_OUTPUT_FILE")

        # Check if the output contains the unique ID to validate the command
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

# Interactive mode for remote command entry
function interactive_mode() {
    echo "Entering interactive mode. Type your remote commands."
    echo "Type 'exit' to quit interactive mode."

    full_command=""

    while true; do
        # Read user input into full_command variable, supporting multiline input
        read -e -p "" user_command  # No prompt, just input

        # Append the user_command to the full_command
        full_command="$full_command $user_command"

        # Exit the interactive mode if 'exit' is typed
        if [ "$user_command" == "exit" ]; then
            echo "Exiting interactive mode."
            break
        elif [ -n "$user_command" ]; then
            # Send the full command to the remote system
            send_command "$full_command"

            # Append the command to the history
            history -s "$full_command"
            # Write the updated history to the history file
            history -a

            # Reset full_command for the next command
            full_command=""
        else
            echo "No command entered. Please try again."
        fi
    done
}

# Check if a command was passed as an argument
if [ -z "$1" ]; then
    # Start interactive mode if no command is provided
    interactive_mode
else
    # Otherwise, send the provided command
    send_command "$*"
fi
