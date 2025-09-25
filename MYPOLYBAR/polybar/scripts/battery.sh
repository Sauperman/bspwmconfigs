#!/bin/bash

# Simple battery script
BATTERY=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || cat /sys/class/power_supply/BAT1/capacity 2>/dev/null)
STATUS=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || cat /sys/class/power_supply/BAT1/status 2>/dev/null)

if [ -z "$BATTERY" ]; then
    echo " N/A"
    exit 0
fi

if [ "$STATUS" = "Charging" ]; then
    echo " $BATTERY%"
elif [ "$STATUS" = "Full" ]; then
    echo " $BATTERY%"
else
    if [ "$BATTERY" -ge 90 ]; then
        echo " $BATTERY%"
    elif [ "$BATTERY" -ge 70 ]; then
        echo " $BATTERY%"
    elif [ "$BATTERY" -ge 50 ]; then
        echo " $BATTERY%"
    elif [ "$BATTERY" -ge 20 ]; then
        echo " $BATTERY%"
    else
        echo " $BATTERY%"
    fi
fi
