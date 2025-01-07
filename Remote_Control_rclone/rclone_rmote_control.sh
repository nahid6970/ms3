#!/bin/bash

# Define the remote file path
REMOTE_COMMAND_FILE="g00:/Remote_Control/Command.txt"
REMOTE_OUTPUT_FILE="g00:/Remote_Control/output.txt"

# Generate a random number for validation
RANDOM_NUMBER=$RANDOM

# Check if a command was passed as an argument
if [ -z "$1" ]; then
    echo "Usage: rc <command>"
    exit 1
fi

# Combine the random number and user command into one string
user_command="$* ; echo $RANDOM_NUMBER"

# Write the command with the random number to the remote file using rclone rcat
echo "$user_command" | rclone rcat "$REMOTE_COMMAND_FILE"

if [ $? -ne 0 ]; then
    echo "Failed to send command. Check your rclone setup."
    exit 1
fi

echo "Command sent with random number. Waiting for output..."

# Wait for 5 seconds before retrieving the output
sleep 5

# Get the exact output from the remote file
OUTPUT=$(rclone cat "$REMOTE_OUTPUT_FILE")

# Check if the output contains the expected random number
if [[ "$OUTPUT" == *"$RANDOM_NUMBER"* ]]; then
    echo "Received expected output: $OUTPUT"
else
    echo "Output does not contain the expected random number. Waiting for 5 more seconds..."
    sleep 5
    OUTPUT=$(rclone cat "$REMOTE_OUTPUT_FILE")
    echo "Received output: $OUTPUT"
fi
