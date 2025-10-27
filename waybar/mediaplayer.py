#!/usr/bin/env python3
import subprocess
import json

def get_output(cmd):
    try:
        return subprocess.check_output(cmd, shell=True, text=True).strip()
    except subprocess.CalledProcessError:
        return None

player = get_output("playerctl metadata --format '{{playerName}}'")
title = get_output("playerctl metadata --format '{{title}}'")
artist = get_output("playerctl metadata --format '{{artist}}'")

if not title:
    print(json.dumps({"text": " No media", "tooltip": "Nothing playing"}))
else:
    icon = "" if get_output("playerctl status") == "Playing" else ""
    text = f"{icon} {artist} - {title}" if artist else f"{icon} {title}"
    print(json.dumps({"text": text, "tooltip": text}))
