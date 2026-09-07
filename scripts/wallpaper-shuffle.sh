#!/usr/bin/env bash

## Wallpaper shuffler for sway, ported from bspwm's version
## (~/.config/bspwm/scripts/wallpaper-shuffle.sh). Cycles through images in
## a directory at a fixed interval, the same image cropped/filled onto
## every active output.
##
## Unlike the bspwm/nitrogen version, this doesn't need to loop over
## individual monitor heads: `swaymsg output "*" bg <path> fill` is sway's
## own IPC command for (re)painting a wallpaper, and it fans out to every
## connected output (each independently cropped-to-fill) in one call --
## sway manages the underlying swaybg process(es) itself.

WALLPAPER_DIR="/home/anthony/Pictures/wallpapers/Woods/"
INTERVAL=300   # seconds between changes (5 minutes) -- change as you like

paint_random() {
	local img
	img=$(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) | shuf -n 1)
	[[ -z "$img" ]] && return
	swaymsg output "*" bg "$img" fill >/dev/null 2>&1
}

if [[ "$1" == "--once" ]]; then
	paint_random
	exit 0
fi

while true; do
	paint_random
	sleep "$INTERVAL"
done
