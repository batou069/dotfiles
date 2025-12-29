#!/usr/bin/env bash
     CONFIG="$HOME/.config/ghostty/config"
     CURRENT_OPACITY=$(grep '^background-opacity' "$CONFIG" | cut -d'=' -f2 | tr -d ' ')
     CURRENT_BLUR=$(grep '^background-blur-radius' "$CONFIG" | cut -d'=' -f2 | tr -d ' ')

     case "$1" in
       opacity_up)
         NEW_OPACITY=$(echo "$CURRENT_OPACITY + 0.1" | bc | awk '{printf "%.1f", $0}')
         if [ $(echo "$NEW_OPACITY <= 1.0" | bc) -eq 1 ]; then
           sed -i "s/^background-opacity.*/background-opacity = $NEW_OPACITY/" "$CONFIG"
           echo "Opacity set to $NEW_OPACITY"
         fi
         ;;
       opacity_down)
         NEW_OPACITY=$(echo "$CURRENT_OPACITY - 0.1" | bc | awk '{printf "%.1f", $0}')
         if [ $(echo "$NEW_OPACITY >= 0.0" | bc) -eq 1 ]; then
           sed -i "s/^background-opacity.*/background-opacity = $NEW_OPACITY/" "$CONFIG"
           echo "Opacity set to $NEW_OPACITY"
         fi
         ;;
       blur_on)
         sed -i "s/^background-blur-radius.*/background-blur-radius = 20/" "$CONFIG"
         echo "Blur enabled"
         ;;
       blur_off)
         sed -i "s/^background-blur-radius.*/background-blur-radius = 0/" "$CONFIG"
         echo "Blur disabled"
         ;;
     esac

     # Reload Ghostty config
     ghostty +reload-config
