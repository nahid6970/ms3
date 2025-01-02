#!/bin/bash

while true; do
    if rclone ls g00: | grep -iq "ntfy"; then
        mpv /storage/emulated/0/song/wwe/ww.mp3
        # Break the loop after finding "ntfy"
        break
    fi
    # Wait for 15 seconds before checking again
    sleep 30
done
