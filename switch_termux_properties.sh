#!/bin/bash

if [ "$1" == "nvim" ]; then
    cp ~/ms3/termux_nvim.properties ~/.termux/termux.properties
    termux-reload-settings
else
    cp ~/ms3/termux.properties ~/.termux/termux.properties
    termux-reload-settings
fi
