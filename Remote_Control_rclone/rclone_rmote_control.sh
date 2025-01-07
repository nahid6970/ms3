#!/bin/bash

# Define the remote file paths
REMOTE_COMMAND_FILE="g00:/Remote_Control/Command.txt"
REMOTE_OUTPUT_FILE="g00:/Remote_Control/output.txt"

# Check if both command and number are passed as arguments
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: rc <command> <unique_number>"
    exit 1
fi

# Combine the command and the unique number into one string
user_command="$1"
unique_number="$2"

# Send the command and the number to the remote file using rclone rcat
echo "$user_command $unique_number" | rclone rcat "$REMOTE_COMMAND_FILE"

if [ $? -ne 0 ]; then
    echo "Failed to send command. Check your rclone setup."
    exit 1
fi

echo "Command sent. Waiting for output..."

# Wait for 5 seconds before retrieving the output
sleep 5

# Retrieve the output from the remote file and store it in a variable
output=$(rclone cat "$REMOTE_OUTPUT_FILE")

# Extract the unique number from the output
output_number=$(echo "$output" | awk '{print $NF}')  # Assumes the unique number is the last word in the output

# Check if the output number matches the sent number
if [ "$unique_number" != "$output_number" ]; then
    echo "Mismatch in output number. Waiting for correct output..."
    exit 1
fi

# Display the output
echo "$output"
