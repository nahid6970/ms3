#!/bin/bash

# Check if "ntfy" exists in the output
if rclone ls g00: | grep -iq "ntfy"; then
    # Play the music file if "ntfy" is found
    mpv  /storage/emulated/0/song/wwe/ww.mp3
else
    echo "No 'ntfy' found in the output."
fi
