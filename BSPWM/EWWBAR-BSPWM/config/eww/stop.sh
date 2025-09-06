#!/bin/bash

# Close the bar window
eww close bar 2>/dev/null

# Wait a moment for the window to close
sleep 0.3

# Stop the eww daemon
eww daemon --stop 2>/dev/null

# Additional cleanup - kill any remaining eww processes
pkill -f "eww daemon" 2>/dev/null
pkill -f "eww-bar" 2>/dev/null

echo "EWW bar completely closed! ✅"
