
#!/bin/bash
# toggle-menu.sh

# Check if rofi is already running
if pgrep -x "rofi" > /dev/null; then
    # If running, kill it
    pkill -x "rofi"
else
    # If not running, launch it
    rofi -show drun
fi
