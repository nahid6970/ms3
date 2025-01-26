#!/bin/bash

# Define the remote file paths
REMOTE_COMMAND_FILE="g00:/Remote_Control/Command.txt"
REMOTE_OUTPUT_FILE="g00:/Remote_Control/output.txt"

# Function to send a command and wait for output
send_command() {
    local command="$1"
    local unique_id=$(date +%s)  # Use a timestamp as the unique ID
    local user_command="$unique_id: $command"

    # Write the command to the remote file using rclone rcat
    echo "$user_command" | rclone rcat "$REMOTE_COMMAND_FILE"

    if [ $? -ne 0 ]; then
        echo "Failed to send command. Check your rclone setup."
        return 1
    fi

    echo "Command sent with ID: $unique_id."

    # Wait for the output
    local MAX_ATTEMPTS=5
    local attempt=0
    while [ $attempt -lt $MAX_ATTEMPTS ]; do
        # Increment attempt count
        attempt=$((attempt + 1))

        # Countdown before retrieving the output
        countdown=3
        echo -n "Waiting for output... ($attempt/$MAX_ATTEMPTS) "
        while [ $countdown -gt 0 ]; do
            echo -n "$countdown "
            sleep 1
            countdown=$((countdown - 1))
        done
        echo -ne "\r\033[0K"  # Clear the line

        # Retrieve the output from the remote file
        output=$(rclone cat "$REMOTE_OUTPUT_FILE")

        # Check if the output contains the unique ID to validate the command
        if [[ "$output" == *"$unique_id"* ]]; then
            echo -e "Output for command ID $unique_id received:"
            echo "$output"
            return 0
        else
            echo -e "Output ID mismatch. Retrying... ($attempt/$MAX_ATTEMPTS)"
        fi
    done

    echo "Max attempts reached. No valid output received."
    return 1
}

# Start an interactive session
echo "Remote Command Shell (type 'exit' to quit)"
while true; do
    echo -n "> "
    read -r user_input

    # Exit the loop if the user types 'exit'
    if [ "$user_input" == "exit" ]; then
        echo "Exiting Remote Command Shell."
        break
    fi

    # Send the command and wait for output
    if [ -n "$user_input" ]; then
        send_command "$user_input"
    else
        echo "No command entered. Please try again."
    fi
done
