#!/bin/bash

# Fast Rofi WiFi connection manager using nmcli
# Optimized for speed and reliability

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Cache network list to avoid multiple nmcli calls
NETWORK_CACHE=""
CACHE_TIMESTAMP=0
CACHE_VALIDITY=5 # Cache valid for 5 seconds

# Function to display messages quickly
show_message() {
    echo -e "${GREEN}$1${NC}" | rofi -dmenu -p "Info" -lines 3
}

# Function to display errors
show_error() {
    echo -e "${RED}$1${NC}" | rofi -dmenu -p "Error" -lines 3
}

# Get available WiFi networks with caching
get_networks() {
    local current_time=$(date +%s)

    # Use cache if it's still valid
    if [ $((current_time - CACHE_TIMESTAMP)) -lt $CACHE_VALIDITY ] && [ -n "$NETWORK_CACHE" ]; then
        echo "$NETWORK_CACHE"
        return
    fi

    # Get fresh network data
    NETWORK_CACHE=$(nmcli -t -f SSID,SECURITY,BARS,ACTIVE device wifi list | \
        awk -F: '{
            status = ($4 == "yes") ? "✓ " : "  ";
            # Handle SSIDs that might contain colons
            ssid = $1;
            security = $2;
            bars = $3;
            print status ssid "|" security "|" bars;
        }' | sort -u -t '|' -k 1,1)

    CACHE_TIMESTAMP=$current_time
    echo "$NETWORK_CACHE"
}

# Connect to selected network
connect_to_network() {
    local ssid="$1"
    local security="$2"

    # Check if network is already connected
    if nmcli -t -g ACTIVE,SSID device wifi | grep -q "yes:$ssid"; then
        show_message "Already connected to $ssid"
        return 0
    fi

    # Check if network is known (has a saved connection)
    if nmcli -t connection show | grep -q "$ssid"; then
        show_message "Connecting to saved network: $ssid"
        if nmcli connection up "$ssid" >/dev/null 2>&1; then
            show_message "Successfully connected to $ssid"
        else
            show_error "Failed to connect to $ssid"
            # Offer to forget the network if connection fails
            option=$(echo -e "Forget\nBack" | rofi -dmenu -p "Connection failed" -lines 2)
            case "$option" in
                "Forget")
                    nmcli connection delete "$ssid"
                    show_message "Forgot network: $ssid"
                    ;;
                "Back")
                    # Return to network selection
                    return 1
                    ;;
            esac
        fi
    else
        # New network - ask for password
        if [ "$security" != "--" ] && [ -n "$security" ]; then
            password=$(rofi -dmenu -p "Password for $ssid: " -password -lines 0)
            if [ -n "$password" ]; then
                show_message "Connecting to $ssid..."
                # Try to connect with the provided password
                if nmcli device wifi connect "$ssid" password "$password" >/dev/null 2>&1; then
                    show_message "Successfully connected to $ssid"
                else
                    show_error "Failed to connect to $ssid"
                    # Offer to retry with a new password or go back
                    option=$(echo -e "Retry\nBack" | rofi -dmenu -p "Connection failed" -lines 2)
                    case "$option" in
                        "Retry")
                            connect_to_network "$ssid" "$security"
                            ;;
                        "Back")
                            # Return to network selection
                            return 1
                            ;;
                    esac
                fi
            else
                # User pressed Escape or entered empty password
                return 1
            fi
        else
            # Open network (no security)
            option=$(echo -e "Connect\nBack" | rofi -dmenu -p "Open network $ssid" -lines 2)
            case "$option" in
                "Connect")
                    show_message "Connecting to $ssid..."
                    if nmcli device wifi connect "$ssid" >/dev/null 2>&1; then
                        show_message "Successfully connected to $ssid"
                    else
                        show_error "Failed to connect to $ssid"
                        return 1
                    fi
                    ;;
                "Back")
                    # Return to network selection
                    return 1
                    ;;
            esac
        fi
    fi
    return 0
}

# Toggle WiFi state
toggle_wifi() {
    if nmcli radio wifi | grep -q "enabled"; then
        nmcli radio wifi off
        show_message "WiFi turned off"
    else
        nmcli radio wifi on
        show_message "WiFi turned on"
        # Invalidate cache to force refresh
        CACHE_TIMESTAMP=0
    fi
}

# Display known networks with back option
show_known_networks() {
    while true; do
        known=$(nmcli -t -f name,type connection show | grep wifi | cut -d: -f1)
        if [ -z "$known" ]; then
            option=$(echo -e "Back" | rofi -dmenu -p "No known networks" -lines 1)
            [ "$option" = "Back" ] && break
        else
            # Add Back option to the list
            options=$(echo -e "$known\nBack")
            selected=$(echo -e "$options" | rofi -dmenu -p "Known Networks" -lines 10)
        fi

        if [ -z "$selected" ] || [ "$selected" = "Back" ]; then
            break
        fi

        # Offer connection options
        option=$(echo -e "Connect\nForget\nBack" | rofi -dmenu -p "$selected" -lines 3)
        case "$option" in
            "Connect")
                nmcli connection up "$selected"
                ;;
            "Forget")
                if echo -e "Yes\nNo" | rofi -dmenu -p "Forget $selected?" -lines 2 | grep -q "Yes"; then
                    nmcli connection delete "$selected"
                    show_message "Forgot network: $selected"
                fi
                ;;
            "Back")
                # Stay in known networks menu
                ;;
        esac
    done
}

# Display network details
show_network_info() {
    current=$(nmcli -t -g ACTIVE,SSID device wifi | grep yes: | cut -d: -f2)
    if [ -n "$current" ]; then
        info=$(nmcli -t connection show "$current" | head -10)
        echo -e "Connected to: $current\n$info\n\nBack" | rofi -dmenu -p "Network Info" -lines 15
    else
        echo -e "Not connected to any network\nBack" | rofi -dmenu -p "Network Info" -lines 2
    fi
}

# Rescan for networks
rescan_networks() {
    show_message "Scanning for networks..."
    nmcli device wifi rescan
    # Invalidate cache to force refresh
    CACHE_TIMESTAMP=0
}

# Network selection menu with back option
network_selection_menu() {
    while true; do
        networks=$(get_networks)
        # Format for display
        display_list=$(echo "$networks" | awk -F'|' '{
            printf "%-1s %-30s %-10s %-4s\n", substr($0,1,1), substr($1,3), $2, $3
        }')

        # Add Back option to the network list
        options=$(echo -e "$display_list\nBack")
        selected=$(echo -e "$options" | rofi -dmenu -p "Select Network" -lines 11)

        if [ -z "$selected" ] || [ "$selected" = "Back" ]; then
            break
        fi

        # Extract SSID from the original cached data using the display position
        line_num=$(echo -e "$options" | grep -n "$selected" | cut -d: -f1)
        if [ -n "$line_num" ]; then
            # Get the original cached line
            original_line=$(echo "$networks" | sed "${line_num}q;d")
            ssid=$(echo "$original_line" | cut -d'|' -f1 | sed 's/^[✓ ] //')
            security=$(echo "$original_line" | cut -d'|' -f2)
        else
            show_error "Could not parse network selection"
            continue
        fi

        # Connect to the selected network
        connect_to_network "$ssid" "$security"

        # If connect_to_network returns 1, it means user wants to go back to network selection
        if [ $? -eq 1 ]; then
            continue
        else
            break
        fi
    done
}

# Main menu
main_menu() {
    while true; do
        wifi_state=$(nmcli radio wifi)
        if [ "$wifi_state" = "enabled" ]; then
            wifi_status="WiFi: Enabled"
        else
            wifi_status="WiFi: Disabled"
        fi

        options="Scan and Connect\nDisconnect WiFi\n$wifi_status\nKnown Networks\nNetwork Info\nRescan Networks\nExit"
        choice=$(echo -e "$options" | rofi -dmenu -p "WiFi Menu" -lines 7)

        case "$choice" in
            "Scan and Connect")
                if [ "$wifi_state" = "disabled" ]; then
                    show_error "WiFi is disabled. Enable it first."
                    continue
                fi
                network_selection_menu
                ;;
            "Disconnect WiFi")
                current=$(nmcli -t -g ACTIVE,SSID device wifi | grep yes: | cut -d: -f2)
                if [ -n "$current" ]; then
                    # Get the actual WiFi device name
                    wifi_device=$(nmcli -t device status | grep wifi | cut -d: -f1 | head -1)
                    nmcli device disconnect "$wifi_device"
                    show_message "Disconnected from $current"
                else
                    show_message "Not connected to any network"
                fi
                ;;
            "WiFi: Enabled"|"WiFi: Disabled")
                toggle_wifi
                ;;
            "Known Networks")
                show_known_networks
                ;;
            "Network Info")
                show_network_info
                ;;
            "Rescan Networks")
                rescan_networks
                ;;
            "Exit"|"")
                break
                ;;
        esac
    done
}

# Check if nmcli is available
if ! command -v nmcli &> /dev/null; then
    echo -e "${RED}Error: nmcli is not installed. Please install NetworkManager.${NC}" | \
    rofi -dmenu -p "Error" -lines 3
    exit 1
fi

# Check if rofi is available
if ! command -v rofi &> /dev/null; then
    echo -e "${RED}Error: rofi is not installed. Please install rofi.${NC}"
    exit 1
fi

# Run main menu
main_menu
