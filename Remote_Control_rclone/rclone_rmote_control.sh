#!/bin/bash

# Define the remote file paths
REMOTE_COMMAND_FILE="g00:/Remote_Control/Command.txt"
REMOTE_OUTPUT_FILE="g00:/Remote_Control/output.txt"

# Check if a command was passed as an argument
if [ -z "$1" ]; then
    echo "Usage: rc <command>"
    exit 1
fi

# Generate a unique ID for this request (e.g., timestamp or random number)
unique_id=$(date +%s)  # You can use a random number here if needed

# Combine the unique ID with the command
user_command="$unique_id: $*"

# Write the command to the remote file using rclone rcat
echo "$user_command" | rclone rcat "$REMOTE_COMMAND_FILE"

if [ $? -ne 0 ]; then
    echo "Failed to send command. Check your rclone setup."
    exit 1
fi

echo "Command sent with ID: $unique_id. Waiting for output..."

# Wait for 5 seconds before retrieving the output
sleep 5

# Retrieve and check the output from the remote file
output=$(rclone cat "$REMOTE_OUTPUT_FILE")

# Check if the output contains the unique ID to validate the command
if [[ "$output" == *"$unique_id"* ]]; then
    echo "Output for command ID $unique_id received:"
    echo "$output"
else
    echo "Output mismatch. Command ID not found in output. Retrying..."
    # Optionally, you could loop and keep checking until the output matches
fi
