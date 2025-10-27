#!/bin/bash
#  ██╗    ██╗ █████╗ ██╗     ██╗     ██████╗  █████╗ ██████╗ ███████╗██████╗
#  ██║    ██║██╔══██╗██║     ██║     ██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗
#  ██║ █╗ ██║███████║██║     ██║     ██████╔╝███████║██████╔╝█████╗  ██████╔╝
#  ██║███╗██║██╔══██║██║     ██║     ██╔═══╝ ██╔══██║██╔═══╝ ██╔══╝  ██╔══██╗
#  ╚███╔███╔╝██║  ██║███████╗███████╗██║     ██║  ██║██║     ███████╗██║  ██║
#   ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝
#
#  ██╗      █████╗ ██╗   ██╗███╗   ██╗ ██████╗██╗  ██╗███████╗██████╗
#  ██║     ██╔══██╗██║   ██║████╗  ██║██╔════╝██║  ██║██╔════╝██╔══██╗
#  ██║     ███████║██║   ██║██╔██╗ ██║██║     ███████║█████╗  ██████╔╝
#  ██║     ██╔══██║██║   ██║██║╚██╗██║██║     ██╔══██║██╔══╝  ██╔══██╗
#  ███████╗██║  ██║╚██████╔╝██║ ╚████║╚██████╗██║  ██║███████╗██║  ██║
#  ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝

wall_dir="${HOME}/Pictures/Wallpapers/"
cacheDir="${HOME}/.cache/jp/${theme}"
physical_monitor_size=24

# Create cache dir if not exists
if [ ! -d "${cacheDir}" ]; then
    mkdir -p "${cacheDir}"
fi

# Get monitor resolution
monitor_res=$(hyprctl monitors | grep -A2 "Monitor" | head -n 2 | awk '{print $1}' | grep -oE '^[0-9]+')

# Calculate DPI and adjusted resolution
if [ -n "$monitor_res" ] && [ "$monitor_res" -gt 0 ] && [ "$physical_monitor_size" -gt 0 ]; then
    # Use awk instead of bc for calculation (more portable)
    dotsperinch=$(awk "BEGIN {printf \"%.0f\", $monitor_res / $physical_monitor_size}")
    if [ "$dotsperinch" -gt 0 ]; then
        monitor_res=$(( monitor_res * physical_monitor_size / dotsperinch ))
    else
        monitor_res=500
    fi
else
    # Fallback if monitor resolution detection fails
    monitor_res=500
fi

# Rofi configuration - simplified version
rofi_override="element-icon { size: ${monitor_res}px; }"
rofi_command="rofi -x11 -dmenu -theme ${HOME}/.config/rofi/wallSelect.rasi -theme-str '${rofi_override}'"

# Check if wallpaper directory exists
if [ ! -d "$wall_dir" ]; then
    echo "Error: Wallpaper directory '$wall_dir' does not exist"
    exit 1
fi

# Convert images in directory and save to cache dir
for imagen in "${wall_dir}"*.{jpg,jpeg,png,webp}; do
    # Check if the glob matched actual files (not literal string)
    if [ -f "$imagen" ]; then
        nombre_archivo=$(basename "$imagen")
        if [ ! -f "${cacheDir}/${nombre_archivo}" ]; then
            # Check if magick command exists (preferred) or fallback to convert
            if command -v magick >/dev/null 2>&1; then
                magick "$imagen" -strip -thumbnail 500x500^ -gravity center -extent 500x500 "${cacheDir}/${nombre_archivo}"
            elif command -v convert >/dev/null 2>&1; then
                convert -strip "$imagen" -thumbnail 500x500^ -gravity center -extent 500x500 "${cacheDir}/${nombre_archivo}" 2>/dev/null
            else
                echo "Warning: ImageMagick not found. Skipping thumbnail generation."
                # Copy original file as fallback
                cp "$imagen" "${cacheDir}/${nombre_archivo}"
            fi
        fi
    fi
done

# Select a picture with rofi
wall_selection=$(find "${wall_dir}" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -exec basename {} \; | sort | while read -r A; do
    echo -en "$A\x00icon\x1f${cacheDir}/$A\n"
done | eval "$rofi_command")

# Check if a selection was made
if [ -z "$wall_selection" ]; then
    echo "No wallpaper selected"
    exit 1
fi

# Check if swww command exists
if ! command -v swww >/dev/null 2>&1; then
    echo "Error: 'swww' command not found"
    exit 1
fi

# Set the wallpaper
if [ -f "${wall_dir}/${wall_selection}" ]; then
    # swww img "${wall_dir}/${wall_selection}"
    # echo "Wallpaper set to: $wall_selection"

    matugen image "${wall_dir}/${wall_selection}"
    notify-send "Wallpaper Updated" "Wallpaper and new color scheme applied"

else
    notify-send "Error" "Selected wallpaper file does not exist" 
    exit 1
fi

exit 0

