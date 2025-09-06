#!/bin/bash

# Kill existing eww
eww kill 2>/dev/null

# Wait a moment
sleep 0.3

# Start eww daemon
eww daemon

# Wait for daemon to start
sleep 0.7

# Open the bar
eww open bar --screen eDP1

echo "Perfect rice bar launched! 🍚"
