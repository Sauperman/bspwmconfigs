#!/bin/bash

# Colors
PACMAN_COLOR="#ff7300"
DOT_COLOR="#00aaff"

# Different colors for each eaten dot
EATEN_COLORS=("#00ff08" "#ff6b6b" "#feca57" "#96ceb4" "#4ecdc4")  # Green, Red, Yellow, Green, Teal

# Pacman frames (Font Awesome icons)
PACMAN_FRAMES=("" "" "" "")
DOT=""
EATEN_DOT=""  # Keep as solid circle but change color

# Animation states
DOTS_COUNT=5
current_frame=0
dots_eaten=0
direction=1

# Main animation loop
while true; do
    # Build the animation string
    output="%{F$PACMAN_COLOR}${PACMAN_FRAMES[$current_frame]}%{F-} "

    # Add dots
    for ((i=0; i<$DOTS_COUNT; i++)); do
        if [ $i -lt $dots_eaten ]; then
            # Each eaten dot gets a different color
            color_index=$((i % ${#EATEN_COLORS[@]}))
            output+="%{F${EATEN_COLORS[$color_index]}}$EATEN_DOT%{F-}"
        else
            output+="%{F$DOT_COLOR}$DOT%{F-}"
        fi
        output+=" "
    done

    echo "$output"

    # Update animation state
    ((current_frame = (current_frame + 1) % ${#PACMAN_FRAMES[@]}))

    # Move pacman and eat dots
    if [ $current_frame -eq 0 ]; then
        ((dots_eaten = (dots_eaten + 1) % (DOTS_COUNT + 1)))

        # Reverse direction when reaching end
        if [ $dots_eaten -eq $DOTS_COUNT ] || [ $dots_eaten -eq 0 ]; then
            direction=$((direction * -1))
            if [ $direction -eq -1 ]; then
                PACMAN_FRAMES=("" "" "" "")
            else
                PACMAN_FRAMES=("" "" "" "")
            fi
        fi
    fi

    sleep 0.3
done
