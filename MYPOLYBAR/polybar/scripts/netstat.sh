#!/bin/bash

# Netstat script with cool visual indicators
if ping -c 1 -W 1 8.8.8.8 &> /dev/null; then
    # CONNECTED - Green aesthetic
    echo "%{F#a6e3a1}%{T3}⬤%{T-}%{F-} %{F#94e2d5}Online%{F-}"
else
    # DISCONNECTED - Red aesthetic
    echo "%{F#f38ba8}%{T3}⬤%{T-}%{F-} %{F#f5c2e7}Offline%{F-}"
fi
