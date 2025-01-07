#!/bin/bash

# Define the remote file paths
REMOTE_COMMAND_FILE="g00:/Remote_Control/Command.txt"
REMOTE_OUTPUT_FILE="g00:/Remote_Control/output.txt"

# Check if a command was passed as an argument
if [ -z "$1" ]; then
    echo "Usage: rc <command>"
    exit 1
fi

# Combine all arguments into a single command
user_command="$*"

# Write the command to the remote file using rclone rcat
echo "$user_command" | rclone rcat "$REMOTE_COMMAND_FILE"

if [ $? -ne 0 ]; then
    echo "Failed to send command. Check your rclone setup."
    exit 1
fi

echo "Command sent. Waiting for output..."

# Poll the remote output file until it has content
while :; do
    output=$(rclone cat "$REMOTE_OUTPUT_FILE" 2>/dev/null)
    if [ -n "$output" ]; then
        # Interpret escaped characters like \n properly
        echo -e "\n--- Command Output ---\n$output\n--- End of Output ---"
        break
    fi
    sleep 1
done
