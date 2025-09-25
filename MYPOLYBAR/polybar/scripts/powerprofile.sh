#!/bin/bash

# Power profile monitor script for Polybar
# Shows current power profile with Font Awesome icons only
# Using Catppuccin Mocha color scheme

# Font Awesome icons
ICON_POWER_SAVER=""    # fa-battery-quarter
ICON_BALANCED=""       # fa-battery-full (balanced)
ICON_PERFORMANCE=""    # fa-bolt (performance)
ICON_UNKNOWN=""        # fa-question

# Catppuccin Mocha colors
COLOR_POWER_SAVER="#a6e3a1"    # Green
COLOR_BALANCED="#f9e2af"       # Yellow
COLOR_PERFORMANCE="#f38ba8"    # Red
COLOR_UNKNOWN="#6c7086"        # Gray (surface2)
COLOR_TEXT="#cdd6f4"           # Text color (optional)

get_power_profile() {
    current_profile=$(powerprofilesctl get 2>/dev/null)

    case "$current_profile" in
        "power-saver")
            echo "%{F$COLOR_POWER_SAVER}$ICON_POWER_SAVER%{F-}"
            ;;
        "balanced")
            echo "%{F$COLOR_BALANCED}$ICON_BALANCED%{F-}"
            ;;
        "performance")
            echo "%{F$COLOR_PERFORMANCE}$ICON_PERFORMANCE%{F-}"
            ;;
        *)
            echo "%{F$COLOR_UNKNOWN}$ICON_UNKNOWN%{F-}"
            ;;
    esac
}

# Handle click events
case "${1:-}" in
    "toggle")
        # Toggle between profiles
        current=$(powerprofilesctl get)
        case "$current" in
            "power-saver")
                powerprofilesctl set balanced
                notify-send "Power Profile" "Switched to Balanced Mode $ICON_BALANCED" -i battery-full
                ;;
            "balanced")
                powerprofilesctl set performance
                notify-send "Power Profile" "Switched to Performance Mode $ICON_PERFORMANCE" -i bolt
                ;;
            "performance"|*)
                powerprofilesctl set power-saver
                notify-send "Power Profile" "Switched to Power Saver Mode $ICON_POWER_SAVER" -i battery-quarter
                ;;
        esac
        ;;
    "next")
        # Cycle to next profile
        current=$(powerprofilesctl get)
        case "$current" in
            "power-saver")
                powerprofilesctl set balanced
                notify-send "Power Profile" "Switched to Balanced Mode $ICON_BALANCED" -i battery-full
                ;;
            "balanced")
                powerprofilesctl set performance
                notify-send "Power Profile" "Switched to Performance Mode $ICON_PERFORMANCE" -i bolt
                ;;
            "performance")
                powerprofilesctl set power-saver
                notify-send "Power Profile" "Switched to Power Saver Mode $ICON_POWER_SAVER" -i battery-quarter
                ;;
        esac
        ;;
    "prev")
        # Cycle to previous profile
        current=$(powerprofilesctl get)
        case "$current" in
            "power-saver")
                powerprofilesctl set performance
                notify-send "Power Profile" "Switched to Performance Mode $ICON_PERFORMANCE" -i bolt
                ;;
            "balanced")
                powerprofilesctl set power-saver
                notify-send "Power Profile" "Switched to Power Saver Mode $ICON_POWER_SAVER" -i battery-quarter
                ;;
            "performance")
                powerprofilesctl set balanced
                notify-send "Power Profile" "Switched to Balanced Mode $ICON_BALANCED" -i battery-full
                ;;
        esac
        ;;
    "info")
        # Show detailed info in notification
        current=$(powerprofilesctl get)
        details=$(powerprofilesctl list | grep -A 10 "Profile:" | head -5)

        case "$current" in
            "power-saver") icon=$ICON_POWER_SAVER ;;
            "balanced") icon=$ICON_BALANCED ;;
            "performance") icon=$ICON_PERFORMANCE ;;
            *) icon=$ICON_UNKNOWN ;;
        esac

        notify-send "Power Profile: $current $icon" "$details" -t 5000
        ;;
    "notify")
        # Simple notification with current profile
        current=$(powerprofilesctl get)
        case "$current" in
            "power-saver")
                notify-send "Power Profile" "Power Saver Mode $ICON_POWER_SAVER" -t 2000 -i battery-quarter
                ;;
            "balanced")
                notify-send "Power Profile" "Balanced Mode $ICON_BALANCED" -t 2000 -i battery-full
                ;;
            "performance")
                notify-send "Power Profile" "Performance Mode $ICON_PERFORMANCE" -t 2000 -i bolt
                ;;
        esac
        ;;
    *)
        # Default: just output current profile icon
        get_power_profile
        ;;
esac
