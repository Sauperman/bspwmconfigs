# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ===== NORD COLOR THEME =====
# Nord color palette
NORD_POLAR_NIGHT_DARKEST='\[\033[38;5;236m\]'   # #2E3440
NORD_POLAR_NIGHT_DARKER='\[\033[38;5;238m\]'    # #3B4252
NORD_POLAR_NIGHT_DARK='\[\033[38;5;240m\]'      # #4C566A
NORD_SNOW_STORM_LIGHTEST='\[\033[38;5;255m\]'   # #ECEFF4
NORD_SNOW_STORM_LIGHTER='\[\033[38;5;254m\]'    # #E5E9F0
NORD_SNOW_STORM_LIGHT='\[\033[38;5;253m\]'      # #D8DEE9
NORD_FROST_BLUE='\[\033[38;5;110m\]'            # #5E81AC
NORD_FROST_LIGHT_BLUE='\[\033[38;5;109m\]'      # #81A1C1
NORD_FROST_CYAN='\[\033[38;5;116m\]'            # #88C0D0
NORD_FROST_MUTED_CYAN='\[\033[38;5;152m\]'      # #8FBCBB
NORD_AURORA_RED='\[\033[38;5;174m\]'            # #BF616A
NORD_AURORA_ORANGE='\[\033[38;5;216m\]'         # #D08770
NORD_AURORA_YELLOW='\[\033[38;5;223m\]'         # #EBCB8B
NORD_AURORA_GREEN='\[\033[38;5;150m\]'          # #A3BE8C
NORD_AURORA_PURPLE='\[\033[38;5;182m\]'         # #B48EAD

# Assign semantic names for consistency
DARKEST=$NORD_POLAR_NIGHT_DARKEST
DARK=$NORD_POLAR_NIGHT_DARKER
MEDIUM=$NORD_POLAR_NIGHT_DARK
LIGHT=$NORD_SNOW_STORM_LIGHT
BRIGHT=$NORD_FROST_BLUE
BRIGHTEST=$NORD_SNOW_STORM_LIGHTEST

# Formatting
BOLD='\[\033[1m\]'
DIM='\[\033[2m\]'
RESET='\[\033[0m\]'

# ===== ENHANCED PROMPT =====
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/  \1/'
}

git_status() {
    local status=$(git status --porcelain 2>/dev/null)
    if [ -n "$status" ]; then
        echo " ${NORD_AURORA_ORANGE}●"  # Orange dot for changes
    else
        echo " ${NORD_AURORA_GREEN}●"   # Green dot for clean
    fi
}

git_status_detailed() {
    local changes=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    local ahead=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
    local behind=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo "0")

    local status_parts=()
    [ "$changes" -gt 0 ] 2>/dev/null && status_parts+=("${NORD_AURORA_ORANGE}${changes}±")
    [ "$ahead" -gt 0 ] 2>/dev/null && status_parts+=("${NORD_AURORA_GREEN}↑${ahead}")
    [ "$behind" -gt 0 ] 2>/dev/null && status_parts+=("${NORD_AURORA_RED}↓${behind}")

    if [ ${#status_parts[@]} -gt 0 ]; then
        echo " ${NORD_POLAR_NIGHT_DARK}($(IFS=,; echo "${status_parts[*]}")${NORD_POLAR_NIGHT_DARK})"
    fi
}

exit_status() {
    if [ $? -eq 0 ]; then
        echo "${NORD_AURORA_GREEN}✓"
    else
        echo "${NORD_AURORA_RED}✗"
    fi
}

# Show current Python virtual environment
show_venv() {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo " ${NORD_AURORA_YELLOW}($(basename "$VIRTUAL_ENV"))"
    fi
}

# Show Kubernetes context if available
show_k8s() {
    if command -v kubectl &> /dev/null; then
        local context=$(kubectl config current-context 2>/dev/null)
        local namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
        if [ -n "$context" ]; then
            local k8s_info="$context"
            [ -n "$namespace" ] && k8s_info+="/$namespace"
            echo " ${NORD_FROST_CYAN}⎈ ${k8s_info}"
        fi
    fi
}

set_prompt() {
    local exit_code="$(exit_status)"
    local git_branch="$(parse_git_branch)"
    local git_status_indicator="$(git_status)"
    local git_details="$(git_status_detailed)"
    local venv_info="$(show_venv)"
    local k8s_info="$(show_k8s)"

    # Clear previous prompt
    PS1=""

    # Exit status and time
    PS1+="${BOLD}${NORD_FROST_BLUE}[${exit_code}${NORD_FROST_BLUE}]${RESET}"
    PS1+="${BOLD}${NORD_POLAR_NIGHT_DARKER}[${NORD_FROST_CYAN}\t${NORD_POLAR_NIGHT_DARKER}]${RESET}"

    # User@Host and directory
    PS1+="${BOLD}${NORD_FROST_BLUE} ${NORD_SNOW_STORM_LIGHTER}\u${NORD_POLAR_NIGHT_DARK}@${NORD_AURORA_GREEN}\h${RESET}"
    PS1+="${BOLD}${NORD_FROST_BLUE} ${NORD_FROST_LIGHT_BLUE}[\w]${RESET}"

    # Virtual environment
    PS1+="${venv_info}"

    # Git info if in repo
    if [ -n "$git_branch" ]; then
        PS1+="${BOLD}${NORD_FROST_BLUE} ${NORD_FROST_CYAN}${git_branch}${git_status_indicator}${git_details}${RESET}"
    fi

    # Kubernetes context
    PS1+="${k8s_info}"

    # New line for better readability
    PS1+="\n"

    # Nord mountain indicator
    PS1+="${BOLD}${NORD_FROST_BLUE}❄${NORD_FROST_CYAN}❄❄${NORD_AURORA_GREEN}❄❄${NORD_FROST_LIGHT_BLUE}❄❄${NORD_AURORA_PURPLE}❄${RESET}"

    # Prompt character (gradient effect)
    PS1+="${BOLD}${NORD_FROST_BLUE}❯${NORD_FROST_CYAN}❯${NORD_AURORA_GREEN}❯${RESET} "
}

PROMPT_COMMAND=set_prompt

# ===== ENHANCED ALIASES =====
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# Colorized commands
alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'

# LS variations
alias ll='ls -lh --color=auto --group-directories-first'
alias la='ls -lAh --color=auto --group-directories-first'
alias l='ls -CF --color=auto --group-directories-first'
alias l.='ls -d .* --color=auto --group-directories-first'
alias lt='ls -lth --color=auto --group-directories-first'
alias ltr='ls -ltrh --color=auto --group-directories-first'
alias tree='tree -C'
alias treed='tree -d'

# Safety
alias rm='rm -I --preserve-root'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'

# Arch Linux
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias remove='sudo pacman -Rns'
alias search='pacman -Ss'
alias orphans='pacman -Qtdq'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq) 2>/dev/null || echo "No orphans to remove"'
alias pkg-info='pacman -Qi'
alias pkg-list='pacman -Qqe'
alias pkg-files='pacman -Ql'
alias mirrors='sudo reflector --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'

# Quick edits
alias bashrc='nvim ~/.bashrc && source ~/.bashrc'
alias vimrc='nvim ~/.vimrc'
alias nvimrc='nvim ~/.config/nvim/init.vim'
alias reload='source ~/.bashrc'

# System monitoring
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias psgrep='ps aux | grep -v grep | grep -i'
alias mkdir='mkdir -pv'
alias top='htop'
alias meminfo='free -mlt'
alias cpuinfo='lscpu'
alias diskusage='ncdu'

# Network
alias ports='netstat -tulanp'
alias myip='curl ifconfig.me && echo'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'
alias ssh-list='tail -n 20 ~/.ssh/config'

# Development
alias py='python'
alias py3='python3'
alias pip-upgrade='pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U'
alias venv='python -m venv .venv && source .venv/bin/activate'
alias activate='source .venv/bin/activate'

# Docker
alias docker-ps='docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
alias docker-clean='docker system prune -af'
alias docker-compose='docker compose'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias gl='git log --oneline --graph -n 20'
alias gco='git checkout'
alias gb='git branch'

# ===== ENHANCED FUNCTIONS =====
mkcd() { mkdir -p "$1" && cd "$1"; }

extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz)  tar xzf "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *.rar)     unrar x "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.tbz2)    tar xjf "$1" ;;
            *.tgz)     tar xzf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.Z)       uncompress "$1" ;;
            *.7z)      7z x "$1" ;;
            *.deb)     ar x "$1" ;;
            *.xz)      unxz "$1" ;;
            *.tar.xz)  tar xf "$1" ;;
            *)         echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Calculator
calc() { echo "$*" | bc -l; }

# Weather with options
weather() {
    if [ -z "$1" ]; then
        curl -s "wttr.in?F" | head -7
    else
        curl -s "wttr.in/$1?F" | head -7
    fi
}

# Directory size with better formatting
dsize() {
    if command -v duf &> /dev/null; then
        duf "$@"
    else
        du -h --max-depth=1 "$@" | sort -h
    fi
}

# Create backup with timestamp
backup() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    cp -r "$1" "${1}.backup_${timestamp}"
    echo "Backup created: ${1}.backup_${timestamp}"
}

# Find files and directories
ff() { find . -type f -iname "*$*" 2>/dev/null; }
fd() { find . -type d -iname "*$*" 2>/dev/null; }

# Count code lines in directory
cloc() {
    if command -v tokei &> /dev/null; then
        tokei "$@"
    else
        find . -name "*.py" -o -name "*.js" -o -name "*.html" -o -name "*.css" -o -name "*.java" -o -name "*.c" -o -name "*.cpp" -o -name "*.rs" | xargs wc -l
    fi
}

# Create and enter temp directory
tmpdir() {
    local dirname=$(mktemp -d)
    cd "$dirname" || return
    echo "Created temp directory: $dirname"
}

# Pretty print path
path() {
    echo $PATH | tr ':' '\n' | nl
}

# ===== ENVIRONMENT =====
export EDITOR=nvim
export VISUAL=nvim
export BROWSER=firefox
export TERMINAL=alacritty

export HISTSIZE=100000
export HISTFILESIZE=200000
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="ls:ll:la:l:cd:pwd:exit:clear:history"
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S - "

# Append to history file instead of overwriting
shopt -s histappend

# Nord colors for man pages
export LESS_TERMCAP_mb=$'\e[1;35m'    # Magenta
export LESS_TERMCAP_md=$'\e[1;34m'    # Blue
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;37m' # White on blue
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;36m'  # Cyan underline

# ===== COMPLETION =====
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Enable git completion
if [ -f /usr/share/git/completion/git-completion.bash ]; then
    . /usr/share/git/completion/git-completion.bash
fi

# ===== TERMINAL BEHAVIOR =====
set -o vi
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind 'set menu-complete-display-prefix on'
bind 'set colored-completion-prefix on'
bind 'set colored-stats on'

# Enable color support for ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Nord LS_COLORS
export LS_COLORS="di=1;34:ln=1;36:so=1;35:pi=1;33:ex=1;31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43:*.txt=38;5;250:*.md=38;5;250:*.py=38;5;75:*.js=38;5;220:*.html=38;5;208:*.css=38;5;199:*.json=38;5;93"

# FZF integration if available
if [ -f /usr/share/fzf/key-bindings.bash ]; then
    source /usr/share/fzf/key-bindings.bash
    source /usr/share/fzf/completion.bash
    export FZF_DEFAULT_OPTS='--color=bg+:#3B4252,bg:#2E3440,spinner:#81A1C1,hl:#88C0D0 --color=fg:#D8DEE9,header:#88C0D0,info:#81A1C1,pointer:#81A1C1 --color=marker:#81A1C1,fg+:#D8DEE9,prompt:#81A1C1,hl+:#88C0D0 --height 60% --layout=reverse --border'
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers {} 2>/dev/null || tree -C {} 2>/dev/null | head -200'"
fi

# ===== WELCOME MESSAGE =====
# Use raw escape codes for welcome message
welcome_bold='\033[1m'
welcome_blue='\033[38;5;110m'
welcome_cyan='\033[38;5;116m'
welcome_green='\033[38;5;150m'
welcome_yellow='\033[38;5;223m'
welcome_red='\033[38;5;174m'
welcome_reset='\033[0m'

# ===== CUSTOM UTILITIES =====
# Quick note taking
notes() {
    if [ "$1" = "list" ]; then
        find ~/notes -name "*.md" -type f 2>/dev/null | while read -r note; do
            echo -e "${welcome_blue}$(basename "$note" .md)${welcome_reset} - ${welcome_cyan}$(head -1 "$note" | cut -c1-60)${welcome_reset}"
        done
    elif [ -n "$1" ]; then
        nvim ~/notes/"$1".md
    else
        nvim ~/notes/quicknote_$(date +%Y%m%d_%H%M%S).md
    fi
}

# Create notes directory if it doesn't exist
mkdir -p ~/notes

# Quick screenshot
screenshot() {
    local filename="screenshot_$(date +%Y%m%d_%H%M%S).png"
    if command -v grim &> /dev/null; then
        # Wayland
        grim "$filename"
    elif command -v scrot &> /dev/null; then
        # X11
        scrot "$filename"
    else
        echo "No screenshot tool found. Install grim (Wayland) or scrot (X11)."
        return 1
    fi
    echo "Screenshot saved: $filename"
}

# Nord-themed system info
nord-info() {
    echo -e "${welcome_bold}${welcome_blue}╔══════════════════════════════════════════╗${welcome_reset}"
    echo -e "${welcome_bold}${welcome_blue}║           ${welcome_cyan}❄ NORD SYSTEM INFO ${welcome_blue}            ║${welcome_reset}"
    echo -e "${welcome_bold}${welcome_blue}╚══════════════════════════════════════════╝${welcome_reset}"
    echo -e "${welcome_green}OS:${welcome_cyan} $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '\"')"
    echo -e "${welcome_green}Uptime:${welcome_cyan} $(uptime -p)"
    echo -e "${welcome_green}Shell:${welcome_cyan} $SHELL"
    echo -e "${welcome_green}Theme:${welcome_blue} Nord Polar Night${welcome_reset}"
}

# ===== FINAL SETUP =====
# Source local bashrc if exists
if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi

# Display Nord info on startup
#nord-info
