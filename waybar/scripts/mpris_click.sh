#!/usr/bin/env bash
# ~/.config/hypr/scripts/mpris_doubleclick.sh

CLICK_FILE="/tmp/waybar_click_timestamp"

if [ -f "$CLICK_FILE" ] && [ $(($(date +%s%3N) - $(cat "$CLICK_FILE"))) -lt 300 ]; then
    playerctl next
else
    date +%s%3N > "$CLICK_FILE"
    playerctl play-pause
fi

