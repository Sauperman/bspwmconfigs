#!/bin/bash

# Simple screen resolution configurator
CONFIG_FILE="/tmp/screen_config_temp"
TIMEOUT=10

# Function to get connected displays
get_displays() {
    xrandr | grep " connected" | awk '{print $1}'
}

# Function to get current resolution
get_current_res() {
    local display=$1
    xrandr | grep "^$display" -A 1 | grep "*" | awk '{print $1}' | head -n1
}

# Function to get available resolutions
get_resolutions() {
    local display=$1
    xrandr | sed -n "/^$display connected/,/^[^ ]/p" | grep -E " [0-9]+x[0-9]+" | awk '{print $1}' | sort -u
}

# Function to apply resolution
apply_resolution() {
    local display=$1
    local resolution=$2
    local stretch=$3

    echo "Applying: $display -> $resolution (stretch: $stretch)"

    # First try to set the mode
    if ! xrandr --output "$display" --mode "$resolution"; then
        echo "Failed to set mode, trying with auto..."
        xrandr --output "$display" --mode "$resolution" --auto
    fi

    # Apply aspect ratio if stretched
    if [ "$stretch" = "yes" ]; then
        # Get the actual resolution after setting it
        actual_res=$(get_current_res "$display")
        if [ "$actual_res" = "$resolution" ]; then
            # Try different methods for stretching
            xrandr --output "$display" --set "scaling mode" Full 2>/dev/null || \
            xrandr --output "$display" --transform 1,0,0,0,1,0,0,0,1 2>/dev/null
            echo "Applied stretched mode"
        fi
    else
        # Try to reset to normal scaling
        xrandr --output "$display" --set "scaling mode" None 2>/dev/null || \
        xrandr --output "$display" --transform 1,0,0,0,1,0,0,0,1 2>/dev/null
        echo "Applied native aspect ratio"
    fi
}

# Main function
main() {
    # Check if xrandr is available
    if ! command -v xrandr >/dev/null 2>&1; then
        echo "Error: xrandr is not installed!"
        exit 1
    fi

    # Get displays
    displays=($(get_displays))
    if [ ${#displays[@]} -eq 0 ]; then
        echo "No displays found!"
        exit 1
    fi

    # Select display
    echo "Available displays:"
    for i in "${!displays[@]}"; do
        current_res=$(get_current_res "${displays[$i]}")
        echo "$(($i+1)). ${displays[$i]} (Current: $current_res)"
    done

    read -p "Select display (1-${#displays[@]}): " choice
    if [[ ! $choice =~ ^[0-9]+$ ]] || [ $choice -lt 1 ] || [ $choice -gt ${#displays[@]} ]; then
        echo "Invalid choice, using first display"
        choice=1
    fi
    display="${displays[$(($choice-1))]}"

    # Get available resolutions
    resolutions=($(get_resolutions "$display"))
    if [ ${#resolutions[@]} -eq 0 ]; then
        echo "No resolutions found for $display!"
        exit 1
    fi

    # Show resolutions
    echo ""
    echo "Available resolutions for $display:"
    for i in "${!resolutions[@]}"; do
        current=$(get_current_res "$display")
        if [ "${resolutions[$i]}" = "$current" ]; then
            echo "$(($i+1)). ${resolutions[$i]} (CURRENT)"
        else
            echo "$(($i+1)). ${resolutions[$i]}"
        fi
    done

    # Select resolution
    read -p "Choose resolution (1-${#resolutions[@]}): " res_choice
    if [[ ! $res_choice =~ ^[0-9]+$ ]] || [ $res_choice -lt 1 ] || [ $res_choice -gt ${#resolutions[@]} ]; then
        echo "Invalid choice, using current resolution"
        resolution=$(get_current_res "$display")
    else
        resolution="${resolutions[$(($res_choice-1))]}"
    fi

    # Ask for stretch
    echo ""
    read -p "Stretch to 16:9? (y/N): " stretch
    if [[ $stretch =~ ^[Yy]$ ]]; then
        stretch="yes"
    else
        stretch="no"
    fi

    # Save current resolution for revert
    current_res=$(get_current_res "$display")
    echo "$display:$current_res" > "$CONFIG_FILE"

    # Apply changes
    echo ""
    echo "Applying changes..."
    apply_resolution "$display" "$resolution" "$stretch"

    # Test period
    echo ""
    echo "You have $TIMEOUT seconds to test. Press Ctrl+C to keep changes now."
    echo "The resolution will revert automatically if not confirmed."

    for i in $(seq $TIMEOUT -1 1); do
        echo -ne "\rReverting in $i seconds... "
        sleep 1
    done
    echo ""

    # Revert or keep
    read -p "Keep this resolution? (y/N): " keep
    if [[ $keep =~ ^[Yy]$ ]]; then
        echo "Resolution kept!"
        rm -f "$CONFIG_FILE"
    else
        echo "Reverting..."
        if [ -f "$CONFIG_FILE" ]; then
            while IFS=: read -r disp old_res; do
                xrandr --output "$disp" --mode "$old_res" --auto
            done < "$CONFIG_FILE"
            rm -f "$CONFIG_FILE"
        fi
    fi
}

# Cleanup on exit
cleanup() {
    if [ -f "$CONFIG_FILE" ]; then
        while IFS=: read -r disp old_res; do
            xrandr --output "$disp" --mode "$old_res" --auto 2>/dev/null
        done < "$CONFIG_FILE"
        rm -f "$CONFIG_FILE"
    fi
}

trap cleanup EXIT INT TERM

# Run the script
main "$@"

# Keep terminal open to see results
echo ""
read -p "Press Enter to close..."
