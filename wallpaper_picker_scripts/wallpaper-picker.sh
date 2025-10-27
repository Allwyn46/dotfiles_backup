#!/bin/bash

#WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Use rofi to pick an image
#FILE=$(find "$WALLPAPER_DIR" -type f | rofi -dmenu -i -p "Choose Wallpaper")

# If a file was selected, set it with swww
#if [ -n "$FILE" ]; then
#  swww img "$FILE" --transition-type any --transition-duration 1
#fi

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

FILE=$(zenity --file-selection --filename="$WALLPAPER_DIR/" --file-filter="Images | *.png *.jpg *.jpeg *.webp")

if [ -n "$FILE" ]; then
    #swww img "$FILE" --transition-type any --transition-duration 1
    matugen image "$FILE"
    notify-send "Wallpaper Updated" "Wallpaper and new color scheme applied"
fi





