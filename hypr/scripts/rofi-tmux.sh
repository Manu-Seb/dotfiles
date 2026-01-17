#!/usr/bin/env bash

PROJECT_FILE="$HOME/.config/rofi/tmux_templates.txt"

# Choose project from rofi
CHOICE=$(cut -d'|' -f1 "$PROJECT_FILE" | rofi -dmenu -p "TMUX Helper")
[ -z "$CHOICE" ] && exit

# Resolve directory
DIR=$(grep "^$CHOICE|" "$PROJECT_FILE" | cut -d'|' -f2 | xargs)
DIR=$(realpath "$DIR")
SESSION="$CHOICE"

# Get active Hyprland window
ACTIVE_WIN=$(hyprctl -j activewindow)
ACTIVE_CLASS=$(echo "$ACTIVE_WIN" | jq -r '.class')
ACTIVE_PID=$(echo "$ACTIVE_WIN" | jq -r '.pid')

# If focused window is kitty
# If focused window is kitty
if [[ "$ACTIVE_CLASS" == "kitty" ]]; then
    KITTY_SOCKET="unix:/tmp/kitty.sock-$ACTIVE_PID"

    # Create tmux session in background if not exists
    if ! tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux new-session -ds "$SESSION" -c "$DIR" "nvim .; exec zsh"
    fi

    # Just print message inside kitty
    kitty @ --to "$KITTY_SOCKET" send-text "echo \"tmux session '$SESSION' is ready.\"; echo\n"

    exit
fi

# If not in kitty → launch new kitty instance
if tmux has-session -t "$SESSION" 2>/dev/null; then
    kitty --single-instance -d "$DIR" tmux attach -t "$SESSION"
else
    kitty --single-instance -d "$DIR" zsh -c \
        "tmux new-session -A -s '$SESSION' -c '$DIR' 'nvim . && exec zsh'"
fi
