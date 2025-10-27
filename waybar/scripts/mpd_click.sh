#!/usr/bin/env zsh

btn=$1
cache="/tmp/mpd_lastclick"

# Detect double-click (within 0.3s)
now=$(date +%s%3N) # ms timestamp
last=$(cat "$cache" 2>/dev/null || echo 0)
echo "$now" > "$cache"

delta=$((now - last))

if [ "$delta" -lt 300 ]; then
    # Double click
    if [ "$btn" = "left" ]; then
        mpc next
    elif [ "$btn" = "right" ]; then
        mpc prev
    fi
    exit 0
fi

# Single click
if [ "$btn" = "left" ]; then
    mpc toggle
elif [ "$btn" = "right" ]; then
    mpc toggle
fi

