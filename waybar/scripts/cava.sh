#!/usr/bin/env zsh

# Number of bars you want in waybar (match cava config)
BARS=20

# Run cava in raw mode
cava -p /home/allwyn/.config/cava/config | while read -r line; do
    # Each line contains bar heights
    bars=$(echo "$line" | tr ' ' '\n')

    output=""
    for b in $bars; do
        # scale 0–100 into blocks ▏ ▎ ▍ ▌ ▋ ▊ ▉ █
        case $b in
            0)   output+=" " ;;
            [1-12]) output+="▏" ;;
            [13-25]) output+="▎" ;;
            [26-38]) output+="▍" ;;
            [39-50]) output+="▌" ;;
            [51-63]) output+="▋" ;;
            [64-76]) output+="▊" ;;
            [77-89]) output+="▉" ;;
            *)   output+="█" ;;
        esac
    done

    echo "{\"text\":\"$output\",\"class\":\"cava\"}" || break
done

