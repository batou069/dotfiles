#!/bin/bash
notif="$HOME/.config/swaync/images"

CURRENT_OPACITY=$(hyprctl -j getoption decoration:active_opacity | jq ".float")
NEW_OPACITY=$(echo "$CURRENT_OPACITY + 0.1" | bc)

if (($(echo "$NEW_OPACITY > 1.4" | bc -l))); then
    NEW_OPACITY=0.0
fi

hyprctl keyword decoration:active_opacity "$NEW_OPACITY"
hyprctl keyword decoration:inactive_opacity "(echo "$NEW_OPACITY * 0.8" | bc)"
notify-send -e -u low -i "$notif/note.png" "Opacity: $NEW_OPACITY"
