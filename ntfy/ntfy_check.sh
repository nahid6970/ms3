#!/bin/bash

# Infinite loop to check continuously
while true; do
    # Check if "ntfy" exists in the output
    if rclone ls g00: | grep -i ntfy; then
        # Play the music file using mpv if "ntfy" is found
        mpv /storage/emulated/0/song/wwe/ww.mp3
    else
        echo "No 'ntfy' found in the output."
    fi
    
    # Wait for 20 seconds before checking again
    sleep 5
done
