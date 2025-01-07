#!/bin/bash

# Define the remote file path
REMOTE_FILE="g00:/Remote_Control/Command.txt"

# Check if a command was passed as an argument
if [ -z "$1" ]; then
    echo "Usage: remote_cc <command>"
    exit 1
fi

# Combine all arguments into a single command
user_command="$*"

# Write the command to the remote file using rclone rcat
echo "$user_command" | rclone rcat "$REMOTE_FILE"

# Provide feedback to the user
if [ $? -eq 0 ]; then
    echo "Command successfully sent to $REMOTE_FILE."
else
    echo "Failed to send command. Check your rclone setup."
fi
