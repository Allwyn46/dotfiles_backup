#!/usr/bin/env zsh

dir="$HOME/.config/rofi/launchers/type-1"
theme='style-14'

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
