#!/bin/bash

# Define the remote file path
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

# Wait for 5 seconds before retrieving the output
sleep 5

# Fetch and display the output with markers and in green color
echo -e "${GREEN}--Start-Output--${NC}"
rclone cat "$REMOTE_OUTPUT_FILE"
echo -e "${GREEN}--End-Output--${NC}"
