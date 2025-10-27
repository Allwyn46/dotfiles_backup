#!/usr/bin/env bash

# Use the absolute path to Cava
CAVA_BIN=$(which cava)   # This should output /usr/bin/cava or similar
CAVA_CONFIG="/home/allwyn/.config/cava/config"

if [ ! -x "$CAVA_BIN" ]; then
    echo "{\"text\":\"Cava not found\"}"
    exit 1
fi

# Run Cava in block mode and output JSON for Waybar
$CAVA_BIN -p "$CAVA_CONFIG" -b 2> /dev/null | while read -r line; do
    clean=$(echo "$line" | sed 's/\x1b\[[0-9;]*m//g')
    echo "{\"text\":\"$clean\"}"
done


