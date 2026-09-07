# sway config

Personal sway config, ported over from a bspwm+polybar setup. Tracked in
git ([github.com/ALangford98/sway-everforest-config](https://github.com/ALangford98/sway-everforest-config))
so it can be carried to another machine and so today's fully-tuned state
("everforest-baseline") is always a checkout away, even after tinkering
with themes.

## Porting to a new machine

Only tested for Arch/Archcraft-to-Arch/Archcraft moves.

1. Clone this repo to `~/.config/sway` on the new machine:

       git clone https://github.com/ALangford98/sway-everforest-config.git ~/.config/sway

   (No GitHub access on that machine? Copying the directory over some
   other way -- USB, `scp`, `rsync` -- works too; it just won't be a git
   checkout, so `git pull` and `scripts/restore-baseline` won't apply
   until you `git init` and point it at the remote yourself.)
2. Run `~/.config/sway/install.sh`. It installs every package this setup
   depends on (waybar, mako, rofi, the terminals, greenclip, autotiling-rs,
   swayfx, the Archcraft GTK/icon/cursor/font packages, etc.) via
   `pacman`/`yay`, then prints what's left to do by hand.
3. The two things `install.sh` can't do for you, because they're specific
   to *this* machine's screens:
   - **`config`** -- search for "workspace-output bindings". The
     `$laptop` / `$dell` / `$lg` variables identify monitors by
     make/model/serial (from `swaymsg -t get_outputs`), not port name, so
     they survive dock/dongle port shuffling -- but they obviously need
     to be your new machine's own monitors.
   - **`sway-output`** -- search for "Persistent monitor layout". Three
     `output "..." mode ... position ... scale ...` lines pin an exact
     Y-shape, 3-monitor arrangement (one display at 1.5x scale to match
     another's logical resolution). Replace with whatever layout suits
     the new machine, or delete them if you'd rather just use whatever
     the Displays app gives you (see the comment there for *why* they
     exist -- without them, a `swaymsg reload`, which happens on every
     theme switch, resets your display layout to an auto-negotiated
     default).
4. **SwayFX** (rounded corners) replaces the `sway` binary in place, but
   a *running* session won't pick that up until you log out and back in.

Everything else -- theme colors, waybar's module layout and workspace
icons, keybindings, autotiling, clipboard history, the wallpaper
shuffle -- works unmodified on any machine.

## Theme system

`theme/theme.sh --default|--light|--everforest|--pywal` is the single
entry point; it sources the matching `theme/<name>.bash` palette and
regenerates colors for waybar, sway's own window borders, kitty, foot,
alacritty, rofi, mako, and hyprlock, then reloads everything live. Which
theme is active is recorded in `theme/.theme_name`.

Two waybar buttons drive it day-to-day:
- **`custom/themes`** (left-click) cycles `default -> light -> everforest
  -> default` via `scripts/theme-cycle`. Right-click jumps straight to
  `--pywal` (a random palette derived from whatever's in
  `~/Pictures/wallpapers/`) -- deliberately not part of the left-click
  cycle, since a random result is the last thing you want from a routine
  click.
- **`custom/lightmode`** toggles `--everforest` (dark) / `--light`,
  independent of the cycle button above.

## Coming back to today's setup

`everforest-baseline` is a git tag pointing at the commit this README was
added in -- colors, waybar's layout, keybindings, `corner_radius`,
workspace/output bindings, all of it, as they stand today. After
tinkering (theme-cycle clicks, manual edits, whatever), run:

    ~/.config/sway/scripts/restore-baseline

It checks out every tracked file back to that commit, then re-applies
whichever theme the restored state names -- so the restore is visible
immediately (colors, bar, wallpaper, borders), not just written to disk.

To make a *new* baseline once you're happy with a further change:

    cd ~/.config/sway
    git add -A && git commit -m "..."
    git tag -f everforest-baseline

## Desktop presets

Nine named workspaces, three per monitor, ported from the bspwm+polybar
setup this was migrated from (`term`/`chat`/`media` on the laptop,
`pm`/`office`/`settings` on one external, `ide1`/`ide2`/`term2` on the
other), each with an icon in waybar copied byte-for-byte from the
original polybar config. `mod+1..9` jumps to them in that fixed order;
`mod+shift+1..9` moves the focused window to one. See the
"workspace-output bindings" section of `config` for how they're pinned
to specific monitors.
