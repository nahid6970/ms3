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

echo "Command sent with ID: $unique_id."

# Maximum number of attempts to get the output
MAX_ATTEMPTS=5
attempt=0

# Wait for the output to be valid
while [ $attempt -lt $MAX_ATTEMPTS ]; do
    attempt=$((attempt + 1))
    echo -n "Waiting for output... ($attempt/$MAX_ATTEMPTS) countdown timer"

    # Countdown timer for this attempt
    for countdown in {3..1}; do
        echo -ne " $countdown\r"
        sleep 1
    done

    # Retrieve the output from the remote file
    output=$(rclone cat "$REMOTE_OUTPUT_FILE")

    # Check if the output contains the unique ID to validate the command
    if [[ "$output" == *"$unique_id"* ]]; then
        echo -e "\nOutput for command ID $unique_id received:"
        echo "$output"
        exit 0
    else
        echo -e "\nOutput ID mismatch. Retrying... ($attempt/$MAX_ATTEMPTS)"
    fi
done

echo "Max attempts reached."
