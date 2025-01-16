#!/bin/bash

# Define the remote file paths
REMOTE_COMMAND_FILE="g00:/Remote_Control/Command.txt"
REMOTE_OUTPUT_FILE="g00:/Remote_Control/output.txt"

# Check if a command was passed as an argument
if [ -z "$1" ]; then
    echo "Usage: rc <command>"
    exit 1
fi

# Debug: Log the original input command
echo "Original input command: $*" >> debug.log

# Replace "cc" with "&&" as a whole word
parsed_command=$(echo "$*" | sed -E 's/\bcc\b/&&/g')

# Debug: Log the parsed command after replacement
echo "Parsed command after cc substitution: $parsed_command" >> debug.log

# Generate a unique ID for this request
unique_id=$(date +%s)

# Combine the unique ID with the parsed command
user_command="$unique_id: $parsed_command"

# Debug: Log the final command to be sent
echo "Final command to send: $user_command" >> debug.log

# Write the command to the remote file using rclone rcat
echo "$user_command" | rclone rcat "$REMOTE_COMMAND_FILE"

if [ $? -ne 0 ]; then
    echo "Failed to send command. Check your rclone setup."
    exit 1
fi

echo "Command sent with ID: $unique_id."

# Maximum number of attempts to get the output
MAX_ATTEMPTS=5
attempt=0

# Wait for the output to be valid
while [ $attempt -lt $MAX_ATTEMPTS ]; do
    attempt=$((attempt + 1))

    countdown=3
    echo -n "Waiting for output... ($attempt/$MAX_ATTEMPTS) "
    while [ $countdown -gt 0 ]; do
        echo -n "$countdown "
        sleep 1
        countdown=$((countdown - 1))
    done
    echo -ne "\r\033[0K"

    # Retrieve the output from the remote file
    output=$(rclone cat "$REMOTE_OUTPUT_FILE")

    # Debug: Log the output received
    echo "Output received: $output" >> debug.log

    # Check if the output contains the unique ID to validate the command
    if [[ "$output" == *"$unique_id"* ]]; then
        echo -e "Output for command ID $unique_id received:"
        echo "$output"
        exit 0
    else
        echo -e "Output ID mismatch. Retrying... ($attempt/$MAX_ATTEMPTS)"
    fi
done

echo "Max attempts reached."
