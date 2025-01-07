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

# Generate a random number
random_number=$(shuf -i 1000-9999 -n 1)

# Append the random number to the command
command_with_random="$user_command #$random_number"

# Write the command with the random number to the remote file using rclone rcat
echo "$command_with_random" | rclone rcat "$REMOTE_COMMAND_FILE"

if [ $? -ne 0 ]; then
    echo "Failed to send command. Check your rclone setup."
    exit 1
fi

echo "Command sent. Waiting for output..."

# Wait for 5 seconds before retrieving the output
sleep 5

# Fetch the output from the remote file
output=$(rclone cat "$REMOTE_OUTPUT_FILE")

# Check if the output contains the random number
if [[ "$output" == *"$random_number"* ]]; then
    echo "Output received as expected:"
    echo "$output"
else
    echo "Output does not match expected output. Waiting for more time..."
    
    # Wait for another 5 seconds and try again
    sleep 5
    output=$(rclone cat "$REMOTE_OUTPUT_FILE")
    
    # Check again
    if [[ "$output" == *"$random_number"* ]]; then
        echo "Output received as expected:"
        echo "$output"
    else
        echo "Output still does not match expected output. Exiting."
        exit 1
    fi
fi
