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
random_number=$(shuf -i 1000-9999 -n 1)

# Combine all arguments into a single command and append the random number
user_command="$*"
command_with_random="$user_command; #$random_number"

# Write the command with random number to the remote file using rclone rcat
echo "$command_with_random" | rclone rcat "$REMOTE_COMMAND_FILE"

if [ $? -ne 0 ]; then
    echo "Failed to send command. Check your rclone setup."
    exit 1
fi

echo "Command sent. Waiting for output..."

# Wait for 5 seconds before retrieving the output
sleep 5

# Retrieve the output from the remote file
output=$(rclone cat "$REMOTE_OUTPUT_FILE")

# Check if the output contains the random number to verify it's the correct response
if [[ "$output" == *"$random_number"* ]]; then
    echo "Output received for the command with number $random_number:"
    echo "$output"
else
    echo "No matching output found. Retrying..."
    sleep 5
    output=$(rclone cat "$REMOTE_OUTPUT_FILE")
    
    # Check again for the matching random number
    if [[ "$output" == *"$random_number"* ]]; then
        echo "Output received for the command with number $random_number:"
        echo "$output"
    else
        echo "Still no matching output found. Exiting."
    fi
fi
