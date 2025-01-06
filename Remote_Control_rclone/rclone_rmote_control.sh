#!/bin/bash

# Define the remote file path
REMOTE_FILE="g00:/Remote_Control/Command.txt"

# Prompt for user input
echo -n "Enter command to send remotely: "
read user_command

# Check if the input is not empty
if [ -z "$user_command" ]; then
    echo "No command entered. Exiting."
    exit 1
fi

# Write the command to the remote file using rclone rcat
echo "$user_command" | rclone rcat "$REMOTE_FILE"

# Provide feedback to the user
if [ $? -eq 0 ]; then
    echo "Command successfully sent to $REMOTE_FILE."
else
    echo "Failed to send command. Check your rclone setup."
fi
