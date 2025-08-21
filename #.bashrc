# Clean Bash Prompt with Live System Monitoring with Emoji

# Modern Color Theme - Professional and easy on the eyes
USER_COLOR='\[\033[38;5;114m\]'      # Soft green for username
HOST_COLOR='\[\033[38;5;180m\]'      # Warm tan for hostname
TIME_COLOR='\[\033[38;5;183m\]'      # Lavender for time
DIR_COLOR='\[\033[38;5;223m\]'       # Cream for directory
TEAL_COLOR='\[\033[38;5;30m\]'       # Dark teal for </> text and brackets
CPU_COLOR='\[\033[38;5;117m\]'       # Light blue for CPU
RAM_COLOR='\[\033[38;5;218m\]'       # Pink for RAM
GIT_COLOR='\[\033[38;5;219m\]'       # Light purple for git
SUCCESS_COLOR='\[\033[38;5;120m\]'   # Bright green for success
ERROR_COLOR='\[\033[38;5;203m\]'     # Soft red for error
ACCENT_COLOR='\[\033[38;5;245m\]'    # Gray for separators
RESET='\[\033[0m\]'

# Function to get CPU usage (cached for performance)
get_cpu_usage() {
    # Cache result for 2 seconds to prevent slowdown
    local cache_file="/tmp/cpu_usage_cache"
    local current_time=$(date +%s)
    local cache_time=0
    local cached_value=""

    if [ -f "$cache_file" ]; then
        cache_time=$(stat -c %Y "$cache_file" 2>/dev/null || stat -f %m "$cache_file")
        cached_value=$(cat "$cache_file")
    fi

    if [ $((current_time - cache_time)) -lt 2 ]; then
        echo "$cached_value"
        return
    fi

    # Calculate fresh CPU usage
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    local rounded_usage=$(printf "%.0f" "$cpu_usage")
    echo "$rounded_usage" > "$cache_file"
    echo "$rounded_usage"
}

# Function to get RAM usage (cached for performance)
get_ram_usage() {
    # Cache result for 2 seconds
    local cache_file="/tmp/ram_usage_cache"
    local current_time=$(date +%s)
    local cache_time=0
    local cached_value=""

    if [ -f "$cache_file" ]; then
        cache_time=$(stat -c %Y "$cache_file" 2>/dev/null || stat -f %m "$cache_file")
        cached_value=$(cat "$cache_file")
    fi

    if [ $((current_time - cache_time)) -lt 2 ]; then
        echo "$cached_value"
        return
    fi

    # Calculate fresh RAM usage
    local total_mem=$(free -m | awk '/Mem:/ {print $2}')
    local used_mem=$(free -m | awk '/Mem:/ {print $3}')
    local ram_usage=$(( (used_mem * 100) / total_mem ))
    echo "$ram_usage" > "$cache_file"
    echo "$ram_usage"
}

# Function to format system info with color coding
system_info() {
    local cpu=$(get_cpu_usage)
    local ram=$(get_ram_usage)

    # Color code based on usage levels
    local cpu_color=$CPU_COLOR
    [ "$cpu" -gt 70 ] && cpu_color='\[\033[38;5;221m\]'  # Yellow for high usage
    [ "$cpu" -gt 90 ] && cpu_color='\[\033[38;5;203m\]'  # Red for very high usage

    local ram_color=$RAM_COLOR
    [ "$ram" -gt 70 ] && ram_color='\[\033[38;5;221m\]'  # Yellow for high usage
    [ "$ram" -gt 90 ] && ram_color='\[\033[38;5;203m\]'  # Red for very high usage

    echo -e "${cpu_color}🧠 CPU:${cpu}%${ACCENT_COLOR}|${ram_color}💾 RAM:${ram}%${RESET}"
}

# Git branch info
git_branch() {
    local branch=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
    if [ -n "$branch" ]; then
        echo -e "${GIT_COLOR}🌿 ${branch}${RESET}"
    fi
}

# Main prompt function
set_bash_prompt() {
    local exit_code=$?
    local exit_color=$SUCCESS_COLOR
    [ $exit_code -ne 0 ] && exit_color=$ERROR_COLOR

    PS1="${ACCENT_COLOR}╭─${RESET} ${USER_COLOR}\u${RESET}${ACCENT_COLOR}@${HOST_COLOR}🐧 \h${RESET} ${ACCENT_COLOR}∙${RESET} ${TIME_COLOR}🕒 \t${RESET} ${ACCENT_COLOR}∙${RESET} ${TEAL_COLOR}</>${RESET}"
    PS1+="\n${ACCENT_COLOR}╰─${RESET}${TEAL_COLOR}[${RESET} ${DIR_COLOR}📁 \w${RESET} ${TEAL_COLOR}]${RESET} \$(git_branch)"
    PS1+="\n${exit_color}➜ ${RESET}"
}

PROMPT_COMMAND='set_bash_prompt'

# Set window title
case "$TERM" in
    xterm*|rxvt*|alacritty*|kitty*)
        PROMPT_COMMAND="$PROMPT_COMMAND; echo -ne '\033]0;${USER}@${HOSTNAME%%.*}: ${PWD/#$HOME/\~}\007'"
        ;;
esac

# System monitoring aliases
alias cpuwatch='watch -n 1 "echo \\\"🧠 CPU: \$(get_cpu_usage)%\\\"; echo \\\"💾 RAM: \$(get_ram_usage)%\\\""'
alias sysstats='echo -e "🧠 CPU: $(get_cpu_usage)%\\n💾 RAM: $(get_ram_usage)%"'

# Enhanced ls colors
export LS_COLORS='di=1;36:ln=1;35:so=1;32:pi=1;33:ex=1;31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
alias ls='ls --color=auto'
alias ll='ls -lha --group-directories-first'
alias lt='ls -lhat --group-directories-first'

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
