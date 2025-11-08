# ~/.bashrc

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Puccin Mocha Color Theme
PUCCIN_BG="#1e1e2e"
PUCCIN_TEXT="#cdd6f4"
PUCCIN_SUBTEXT="#bac2de"
PUCCIN_OVERLAY="#6c7086"
PUCCIN_SURFACE="#313244"
PUCCIN_BLUE="#89b4fa"
PUCCIN_LAVENDER="#b4befe"
PUCCIN_SAPPHIRE="#74c7ec"
PUCCIN_SKY="#89dceb"
PUCCIN_TEAL="#94e2d5"
PUCCIN_GREEN="#a6e3a1"
PUCCIN_YELLOW="#f9e2af"
PUCCIN_PEACH="#fab387"
PUCCIN_MAROON="#eba0ac"
PUCCIN_RED="#f38ba8"
PUCCIN_MAUVE="#cba6f7"
PUCCIN_PINK="#f5c2e7"
PUCCIN_FLAMINGO="#f2cdcd"
PUCCIN_ROSEWATER="#f5e0dc"

# Nerd Font icons with Puccin Mocha colors
ARCH_ICON=""
FOLDER_ICON="󰉋"
USER_ICON="󰀂"
HOST_ICON="󰌓"
CPU_ICON="󰍛"
RAM_ICON="󰓅"
LOAD_ICON="󰊚"
BATTERY_ICON="󰂎"
CHARGING_ICON="󰂄"
NETWORK_UP_ICON="󰤨"
NETWORK_DOWN_ICON="󰤭"
WORKSPACE_ICON="󰇉"
TIME_ICON="󰥔"
STORAGE_ICON="󰋊"
EXIT_ICON="󰗼"
GIT_BRANCH_ICON=""
GIT_COMMIT_ICON=""
PYTHON_ICON=""
NODE_ICON=""
DOCKER_ICON=""
VOLUME_ICON="󰕾"
VOLUME_MUTE_ICON="󰖁"
BRIGHTNESS_ICON="󰃟"

# Color definitions using Puccin Mocha
RED='\[\033[38;2;243;139;168m\]'        # PUCCIN_RED
GREEN='\[\033[38;2;166;227;161m\]'      # PUCCIN_GREEN
YELLOW='\[\033[38;2;249;226;175m\]'     # PUCCIN_YELLOW
BLUE='\[\033[38;2;137;180;250m\]'       # PUCCIN_BLUE
PURPLE='\[\033[38;2;203;166;247m\]'     # PUCCIN_MAUVE
CYAN='\[\033[38;2;148;226;213m\]'       # PUCCIN_TEAL
PEACH='\[\033[38;2;250;179;135m\]'      # PUCCIN_PEACH
PINK='\[\033[38;2;245;194;231m\]'       # PUCCIN_PINK
LAVENDER='\[\033[38;2;180;190;254m\]'   # PUCCIN_LAVENDER
WHITE='\[\033[38;2;205;214;244m\]'      # PUCCIN_TEXT
RESET='\[\033[00m\]'

# Separator icons
SEP_LEFT=""
SEP_RIGHT=""
SEP_CORNER_TOP_LEFT=""
SEP_CORNER_TOP_RIGHT=""
SEP_CORNER_BOTTOM_LEFT=""
SEP_CORNER_BOTTOM_RIGHT=""
SEP_VERTICAL="│"

# History settings
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

# Check the window size after each command and update LINES and COLUMNS
shopt -s checkwinsize

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Function to get CPU usage
get_cpu_usage() {
    local cpu_usage
    if command -v mpstat >/dev/null 2>&1; then
        cpu_usage=$(mpstat 1 1 | awk '/Average:/ {printf "%.1f%%", 100 - $12}')
    else
        cpu_usage=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.1f%%", usage}')
    fi
    echo "$cpu_usage"
}

# Function to get RAM usage
get_ram_usage() {
    local ram_usage
    if command -v free >/dev/null 2>&1; then
        ram_usage=$(free | awk '/Mem:/ {printf "%.1f%%", $3/$2 * 100.0}')
    else
        ram_usage="N/A"
    fi
    echo "$ram_usage"
}

# Function to get storage usage of current partition
get_storage_usage() {
    local storage_usage
    if command -v df >/dev/null 2>&1; then
        storage_usage=$(df -h . | awk 'NR==2 {printf "%s/%s (%s)", $3, $2, $5}')
    else
        storage_usage="N/A"
    fi
    echo "$storage_usage"
}

# Function to get battery status with appropriate icons
get_battery_status() {
    local battery_status
    if [ -d /sys/class/power_supply/BAT0 ] || [ -d /sys/class/power_supply/BAT1 ]; then
        local bat_path
        if [ -d /sys/class/power_supply/BAT0 ]; then
            bat_path="/sys/class/power_supply/BAT0"
        else
            bat_path="/sys/class/power_supply/BAT1"
        fi

        local capacity=$(cat ${bat_path}/capacity 2>/dev/null)
        local status=$(cat ${bat_path}/status 2>/dev/null)

        if [ -n "$capacity" ]; then
            # Choose battery icon based on capacity
            local bat_icon="$BATTERY_ICON"
            if [ "$capacity" -ge 90 ]; then
                bat_icon="󰁹"
            elif [ "$capacity" -ge 70 ]; then
                bat_icon="󰂀"
            elif [ "$capacity" -ge 50 ]; then
                bat_icon="󰁾"
            elif [ "$capacity" -ge 30 ]; then
                bat_icon="󰁼"
            elif [ "$capacity" -ge 10 ]; then
                bat_icon="󰁺"
            else
                bat_icon="󰂎"
            fi

            case "$status" in
                "Charging") battery_status="${CHARGING_ICON} ${capacity}%" ;;
                "Discharging") battery_status="${bat_icon} ${capacity}%" ;;
                "Full") battery_status="󰂅 ${capacity}%" ;;
                *) battery_status="${bat_icon} ${capacity}%" ;;
            esac
        else
            battery_status=""
        fi
    else
        battery_status=""
    fi
    echo "$battery_status"
}

# Function to check network connectivity
get_network_status() {
    if ping -c 1 -W 1 8.8.8.8 >/dev/null 2>&1 || ping -c 1 -W 1 1.1.1.1 >/dev/null 2>&1; then
        echo "${NETWORK_UP_ICON} UP"
    else
        echo "${NETWORK_DOWN_ICON} DOWN"
    fi
}

# Function to get current workspace (for GNOME/XFCE)
get_workspace() {
    if command -v wmctrl >/dev/null 2>&1; then
        local workspace=$(wmctrl -d | awk '/\*/ {print $1 + 1}')
        echo "${WORKSPACE_ICON} $workspace"
    elif [ -n "$XDG_CURRENT_DESKTOP" ]; then
        echo "${WORKSPACE_ICON} $(echo $XDG_CURRENT_DESKTOP | cut -d: -f1)"
    else
        echo "${WORKSPACE_ICON} 1"
    fi
}

# Function to get current time
get_time() {
    echo "${TIME_ICON} $(date +%H:%M)"
}

# Function to get system load
get_load() {
    if command -v uptime >/dev/null 2>&1; then
        uptime | awk -F'load average:' '{print $2}' | awk '{printf "%s %s", "'$LOAD_ICON'", $1}'
    else
        echo "${LOAD_ICON} N/A"
    fi
}

# Function to get volume information
get_volume() {
    local volume_info
    if command -v pamixer >/dev/null 2>&1; then
        local volume=$(pamixer --get-volume 2>/dev/null)
        local muted=$(pamixer --get-mute 2>/dev/null)
        if [ "$muted" = "true" ]; then
            volume_info="${VOLUME_MUTE_ICON} MUTED"
        else
            volume_info="${VOLUME_ICON} ${volume}%"
        fi
    elif command -v amixer >/dev/null 2>&1; then
        local volume_output=$(amixer sget Master 2>/dev/null | grep -Eo '[0-9]+%|\[on\]|\[off\]')
        local volume=$(echo "$volume_output" | grep -Eo '[0-9]+%' | head -1)
        local status=$(echo "$volume_output" | grep -Eo '\[on\]|\[off\]' | head -1)
        if [ "$status" = "[off]" ]; then
            volume_info="${VOLUME_MUTE_ICON} MUTED"
        else
            volume_info="${VOLUME_ICON} ${volume}"
        fi
    elif command -v pactl >/dev/null 2>&1; then
        local volume=$(pactl list sinks | grep 'Volume:' | head -1 | grep -Eo '[0-9]+%' | head -1)
        local muted=$(pactl list sinks | grep 'Mute:' | head -1 | awk '{print $2}')
        if [ "$muted" = "yes" ]; then
            volume_info="${VOLUME_MUTE_ICON} MUTED"
        else
            volume_info="${VOLUME_ICON} ${volume}"
        fi
    else
        volume_info=""
    fi
    echo "$volume_info"
}

# Function to get brightness information
get_brightness() {
    local brightness_info
    local brightness_path=""

    # Find brightness control
    for path in /sys/class/backlight/*; do
        if [ -d "$path" ] && [ -f "$path/brightness" ] && [ -f "$path/max_brightness" ]; then
            brightness_path="$path"
            break
        fi
    done

    if [ -n "$brightness_path" ] && [ -f "$brightness_path/brightness" ] && [ -f "$brightness_path/max_brightness" ]; then
        local current=$(cat "$brightness_path/brightness")
        local max=$(cat "$brightness_path/max_brightness")
        local percentage=$(( (current * 100) / max ))
        brightness_info="${BRIGHTNESS_ICON} ${percentage}%"
    elif command -v brightnessctl >/dev/null 2>&1; then
        local brightness=$(brightnessctl info 2>/dev/null | grep -oP '\d+%' | head -1)
        if [ -n "$brightness" ]; then
            brightness_info="${BRIGHTNESS_ICON} ${brightness}"
        else
            brightness_info=""
        fi
    elif command -v xbacklight >/dev/null 2>&1; then
        local brightness=$(xbacklight -get 2>/dev/null | awk '{printf "%.0f%%", $1}')
        if [ -n "$brightness" ]; then
            brightness_info="${BRIGHTNESS_ICON} ${brightness}"
        else
            brightness_info=""
        fi
    else
        brightness_info=""
    fi
    echo "$brightness_info"
}

# Git prompt function
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ '$GIT_BRANCH_ICON' \1/'
}

parse_git_status() {
    local status=$(git status --porcelain 2> /dev/null)
    if [[ -n "$status" ]]; then
        echo " "
    else
        echo " "
    fi
}

# Dynamic PS1 function with Puccin Mocha theme
dynamic_prompt() {
    local exit_code=$?

    # Get all the information
    local cpu_usage=$(get_cpu_usage)
    local ram_usage=$(get_ram_usage)
    local storage_usage=$(get_storage_usage)
    local battery=$(get_battery_status)
    local network=$(get_network_status)
    local workspace=$(get_workspace)
    local current_time=$(get_time)
    local load=$(get_load)
    local volume=$(get_volume)
    local brightness=$(get_brightness)
    local git_info=$(parse_git_branch)$(parse_git_status)

    # Build the prompt line by line with Puccin Mocha colors
    PS1="${LAVENDER}╭──${RESET} ${USER_ICON} ${CYAN}\u${RESET}${PEACH}${RESET}${ARCH_ICON} ${GREEN}Arch${RESET} ${FOLDER_ICON} ${BLUE}\w${RESET}${git_info}"
    PS1+="${LAVENDER}${SEP_VERTICAL}${RESET}\n"
    PS1+="${LAVENDER}${SEP_VERTICAL}${RESET} ${CPU_ICON} ${PURPLE}CPU:${cpu_usage}${RESET} ${SEP_VERTICAL} ${RAM_ICON} ${PINK}RAM:${ram_usage}${RESET} ${SEP_VERTICAL} ${STORAGE_ICON} ${PEACH}STOR:${storage_usage}${RESET}\n"
    PS1+="${LAVENDER}${SEP_VERTICAL}${RESET} ${load}"

    # Only show battery if available
    if [ -n "$battery" ]; then
        PS1+=" ${SEP_VERTICAL} ${YELLOW}${battery}${RESET}"
    fi

    # Only show volume if available
    if [ -n "$volume" ]; then
        PS1+=" ${SEP_VERTICAL} ${BLUE}${volume}${RESET}"
    fi

    # Only show brightness if available
    if [ -n "$brightness" ]; then
        PS1+=" ${SEP_VERTICAL} ${CYAN}${brightness}${RESET}"
    fi

    PS1+=" ${SEP_VERTICAL} ${GREEN}${network}${RESET} ${SEP_VERTICAL} ${WHITE}${current_time}${RESET}\n"

    # Add exit code if not zero
    if [ $exit_code -ne 0 ]; then
        PS1+="${LAVENDER}${SEP_VERTICAL}${RESET} ${EXIT_ICON} ${RED}EXIT:${exit_code}${RESET}"
    fi

    PS1+="${LAVENDER}╰──${RESET} \\$ "
}

# Set PROMPT_COMMAND to update PS1 before each prompt
PROMPT_COMMAND=dynamic_prompt

# Aliases with Nerd Font icons
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls --color=auto'

# Enable color support for various commands
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add some safety to rm, cp, mv
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# System info aliases with Nerd Font icons
alias myip='echo "${NETWORK_UP_ICON} " && curl ifconfig.me'
alias diskspace='echo "${STORAGE_ICON} Disk Space:" && df -h'
alias foldersize='echo "${FOLDER_ICON} Folder Sizes:" && du -h --max-depth=1 | sort -hr'

# Enhanced storage aliases with icons
alias storagestats='echo "${STORAGE_ICON} Storage Overview:" && df -h | grep -E "^/dev/"'
alias largestfiles='echo "${STORAGE_ICON} Largest Files:" && find . -type f -exec du -h {} + 2>/dev/null | sort -rh | head -20'

# Volume and brightness control aliases
alias volup='pamixer -i 5 || amixer set Master 5%+ || pactl set-sink-volume @DEFAULT_SINK@ +5%'
alias voldown='pamixer -d 5 || amixer set Master 5%- || pactl set-sink-volume @DEFAULT_SINK@ -5%'
alias voltoggle='pamixer -t || amixer set Master toggle || pactl set-sink-mute @DEFAULT_SINK@ toggle'
alias brightnessup='brightnessctl set +5% || echo "Install brightnessctl for brightness control"'
alias brightnessdown='brightnessctl set 5%- || echo "Install brightnessctl for brightness control"'

# Git aliases with Nerd Font icons
alias gs='echo "${GIT_BRANCH_ICON} " && git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Arch Linux specific aliases
alias update='echo "${ARCH_ICON} Updating Arch..." && sudo pacman -Syu'
alias pacclean='echo "${ARCH_ICON} Cleaning package cache..." && sudo pacman -Sc'
alias pacorphans='echo "${ARCH_ICON} Removing orphans..." && sudo pacman -Rns $(pacman -Qtdq) 2>/dev/null || echo "No orphans found"'

# Source additional files if they exist
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Set terminal title
set_title() {
    echo -ne "\033]0;${USER}@Arch Linux: ${PWD}\007"
}
PROMPT_COMMAND="set_title; $PROMPT_COMMAND"
