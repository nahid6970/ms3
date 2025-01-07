#!/bin/bash

# Define the remote file path
REMOTE_FILE="g00:/Remote_Control/Command.txt"
OUTPUT_FILE="g00:/Remote_Control/output.txt"

# Check if a command was passed as an argument
if [ -z "$1" ]; then
    echo "Usage: remote_cc <command>"
    exit 1
fi

# Combine all arguments into a single command
user_command="$*"
command_id=$(date +%s)  # Unique ID based on the current timestamp

# Send the command to the remote file along with the unique command ID
echo "$command_id:$user_command" | rclone rcat "$REMOTE_FILE"

# Provide feedback to the user
if [ $? -eq 0 ]; then
    echo "Command successfully sent to $REMOTE_FILE. Command ID: $command_id"
else
    echo "Failed to send command. Check your rclone setup."
    exit 1
fi

# Wait for the output and display countdown for retries
timeout=60  # Set a maximum wait time for retries (e.g., 1 minute)
attempts=0
while true; do
    # Get the output and command ID
    output=$(rclone cat "$OUTPUT_FILE")
    output_id=$(echo "$output" | awk -F: '{print $1}')

    # Check if the command ID in the output matches the sent one
    if [ "$output_id" == "$command_id" ]; then
        # Output found, print and exit
        echo "Output received: $output"
        break
    else
        # Command ID doesn't match, retry with countdown
        attempts=$((attempts + 1))
        remaining=$((timeout - attempts * 5))
        
        if [ "$remaining" -le 0 ]; then
            echo "Timed out waiting for the correct output. Exiting."
            break
        fi

        echo "Output not ready. Retrying in 5 seconds... ($remaining seconds left)"
        sleep 5  # Retry after 5 seconds
    fi
done
