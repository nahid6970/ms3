#!/bin/bash

# Define the remote file path
REMOTE_COMMAND_FILE="g00:/Remote_Control/Command.txt"
REMOTE_OUTPUT_FILE="g00:/Remote_Control/output.txt"

# Check if a command was passed as an argument
if [ -z "$1" ]; then
    echo "Usage: rc <command>"
    exit 1
fi

# Generate a random number
random_number=$RANDOM

# Combine the command and the random number
user_command="$* #$random_number"

# Write the command to the remote file using rclone rcat
echo "$user_command" | rclone rcat "$REMOTE_COMMAND_FILE"

if [ $? -ne 0 ]; then
    echo "Failed to send command. Check your rclone setup."
    exit 1
fi

echo "Command sent. Waiting for output..."

# Wait for 5 seconds before retrieving the output
sleep 5

# Get the output from the remote file
output=$(rclone cat "$REMOTE_OUTPUT_FILE")

# Check if the output contains the expected random number
if [[ "$output" == *"$random_number"* ]]; then
    echo "Output received: $output"
else
    echo "Output does not match the expected random number. Waiting for 5 more seconds..."
    sleep 5
    # Try getting the output again
    output=$(rclone cat "$REMOTE_OUTPUT_FILE")
    if [[ "$output" == *"$random_number"* ]]; then
        echo "Output received: $output"
    else
        echo "Still no matching output. Exiting."
    fi
fi
