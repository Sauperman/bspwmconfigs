#!/bin/bash

# Color definitions (match these with your polybar config)
DAY_COLOR="#ff6b6b"
MONTH_COLOR="#4ecdc4"
DATE_COLOR="#45b7d1"
YEAR_COLOR="#96ceb4"
TIME_COLOR="#c7caff"

# Font Awesome icons
DAY_ICON=""      # fa-calendar
MONTH_ICON=""    # fa-calendar-o
DATE_ICON=""     # fa-calendar-day
YEAR_ICON=""     # fa-calendar-alt
TIME_ICON=""     # fa-clock

# Get current date and time components
DAY=$(date +"%A")
MONTH=$(date +"%B")
DATE=$(date +"%d")
YEAR=$(date +"%Y")
TIME=$(date +"%H:%M:%S")

# Format with icons and colors
echo "%{F$DAY_COLOR}$DAY_ICON $DAY%{F-} %{F$MONTH_COLOR}$MONTH_ICON $MONTH%{F-} %{F$DATE_COLOR}$DATE_ICON $DATE%{F-} %{F$YEAR_COLOR}$YEAR_ICON $YEAR%{F-} | %{F$TIME_COLOR}$TIME_ICON $TIME%{F-}"
