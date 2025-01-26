#!/bin/bash

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

# Interactive mode with history support
function interactive_mode() {
    echo "Entering interactive mode. Type your remote commands."
    echo "Type 'exit' to quit interactive mode."

    # Enable history for the session (Arrow keys functionality)
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'
    bind '"\e[C": forward-char'
    bind '"\e[D": backward-char'

    while true; do
        # Display prompt
        echo -n "rc> "

        # Enable history navigation with arrow keys
        read -e -r user_command  # '-e' enables readline (history)

        if [ "$user_command" == "exit" ]; then
            echo "Exiting interactive mode."
            break
        elif [ -n "$user_command" ]; then
            # Save to history
            history -s "$user_command"
            send_command "$user_command"
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
