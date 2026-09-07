#!/usr/bin/env bash
set -euo pipefail

## Installs the packages this sway config depends on, then tells you what
## still needs manual attention (monitor-specific config, session restart).
##
## Assumes Arch/Archcraft, this directory is already at ~/.config/sway, and
## yay is available for the handful of AUR packages. Safe to re-run --
## pacman/yay skip anything already installed.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [[ "$DIR" != "$HOME/.config/sway" ]]; then
	echo "This script expects to be run from ~/.config/sway (found it at $DIR)." >&2
	echo "Copy/clone this whole directory to ~/.config/sway on the new machine first." >&2
	exit 1
fi

if ! command -v pacman >/dev/null 2>&1; then
	echo "pacman not found -- this install script only supports Arch/Archcraft." >&2
	exit 1
fi

if ! command -v yay >/dev/null 2>&1; then
	echo "yay not found -- needed for the AUR packages below (swayfx, rofi-greenclip, python-pywal)." >&2
	echo "Install yay first, then re-run this script." >&2
	exit 1
fi

## Official repos (core/extra + Archcraft's own [archcraft] repo, which
## ships the GTK/icon/cursor/font packages -- already configured by
## default on any Archcraft install).
PACMAN_PKGS=(
	# Core UI
	waybar mako rofi
	# Terminals (config supports all three; only alacritty is bound by default)
	kitty alacritty foot
	# Lock/idle/screenshot/color-pick
	swaylock swayidle hyprlock hyprpicker grim slurp
	# Bar/theme tooling
	pastel autotiling-rs jq bc
	# Media / clipboard / misc panel bits
	playerctl mpd mpc wl-clipboard xdg-user-dirs
	network-manager-applet blueman pulsemixer pavucontrol
	xfce-polkit imagemagick viewnior light
	# Apps referenced by keybindings
	geany thunar firefox
	# Archcraft-branded theme/icon/cursor/font assets used by the theme system
	archcraft-gtk-theme-everforest archcraft-gtk-theme-sweet
	archcraft-icons-zafiro archcraft-cursor-qogirr archcraft-fonts
)

## AUR
AUR_PKGS=(
	swayfx        # replaces the official `sway` package in place -- see README
	rofi-greenclip
	python-pywal  # theme.sh --pywal
)

echo "==> Installing/checking ${#PACMAN_PKGS[@]} official-repo packages..."
sudo pacman -S --needed "${PACMAN_PKGS[@]}"

echo "==> Installing/checking ${#AUR_PKGS[@]} AUR packages..."
yay -S --needed "${AUR_PKGS[@]}"

cat <<'EOF'

==> Package install done. Two things still need your attention:

1. Monitor-specific config -- this repo was tuned for one specific
   machine's screens (make/model/serial identifiers, an exact Y-shape
   layout with one display at 1.5x scale). None of that will match a
   different machine. Log into sway once first (a default/unconfigured
   layout is fine), run:

       swaymsg -t get_outputs

   then edit, for each of your own monitors:
     - config              -- the $laptop / $dell / $lg identifiers
                               (search for "workspace-output bindings")
     - sway-output          -- the three `output "..." mode ... position
                               ... scale ...` lines at the bottom
                               (search for "Persistent monitor layout")

2. SwayFX needs a fresh login -- installing it replaces the `sway`
   binary on disk, but your *running* compositor (if you're already in a
   session) won't pick that up until you log out and back in.

Everything else (theme, waybar layout, keybindings, autotiling, clipboard
history, wallpaper shuffle) works as-is with no editing required.
EOF
