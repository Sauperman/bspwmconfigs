# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ===== TEAL & SKY BLUE COLOR THEME =====
# Teal colors
TEAL_DARK='\[\033[38;5;23m\]'    # Dark teal
TEAL='\[\033[38;5;30m\]'         # Medium teal
TEAL_LIGHT='\[\033[38;5;36m\]'   # Light teal
TEAL_BRIGHT='\[\033[38;5;43m\]'  # Bright teal
TEAL_NEON='\[\033[38;5;50m\]'    # Neon teal

# Sky blue colors
BLUE_DARK='\[\033[38;5;24m\]'    # Dark blue
BLUE='\[\033[38;5;32m\]'         # Medium blue
BLUE_LIGHT='\[\033[38;5;39m\]'   # Light blue
BLUE_BRIGHT='\[\033[38;5;45m\]'  # Bright blue
BLUE_SKY='\[\033[38;5;87m\]'     # Sky blue

# Accent colors
CYAN='\[\033[38;5;51m\]'         # Bright cyan
AQUA='\[\033[38;5;122m\]'        # Aqua green
MINT='\[\033[38;5;121m\]'        # Mint green
SEAFOAM='\[\033[38;5;85m\]'      # Seafoam green

# Neutral colors
WHITE='\[\033[38;5;255m\]'
GRAY_LIGHT='\[\033[38;5;250m\]'
GRAY='\[\033[38;5;245m\]'
GRAY_DARK='\[\033[38;5;240m\]'

# Formatting
BOLD='\[\033[1m\]'
DIM='\[\033[2m\]'
RESET='\[\033[0m\]'

# ===== PROMPT =====
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/  \1/'
}

git_status() {
    local status=$(git status --porcelain 2>/dev/null)
    if [ -n "$status" ]; then
        echo " ${TEAL_NEON}●"  # Bright teal dot for changes
    else
        echo " ${SEAFOAM}●"    # Seafoam dot for clean
    fi
}

exit_status() {
    if [ $? -eq 0 ]; then
        echo "${SEAFOAM}✓"
    else
        echo "${TEAL_NEON}✗"
    fi
}

set_prompt() {
    local exit_code="$(exit_status)"
    local git_branch="$(parse_git_branch)"
    local git_status_indicator="$(git_status)"

    # Single line prompt with brackets
    PS1="${BOLD}${BLUE}[${exit_code}${BLUE}]${RESET}"
    PS1+="${BOLD}${TEAL} ${BLUE_SKY}\u${GRAY}@${AQUA}\h${RESET}"
    PS1+="${BOLD}${TEAL} ${BLUE}[\w]${RESET}"

    # Git info if in repo
    if [ -n "$git_branch" ]; then
        PS1+="${BOLD}${TEAL} ${CYAN}${git_branch}${git_status_indicator}${RESET}"
    fi

    # Prompt character
    PS1+="${BOLD}${TEAL}❯${BLUE_SKY}❯${AQUA}❯${RESET} "
}

PROMPT_COMMAND=set_prompt

# ===== ALIASES =====
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

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
alias tree='tree -C'

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
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'
alias pkg-info='pacman -Qi'
alias pkg-list='pacman -Qqe'

# Quick edits
alias bashrc='nvim ~/.bashrc'
alias vimrc='nvim ~/.vimrc'
alias nvimrc='nvim ~/.config/nvim/init.vim'

# System
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias psgrep='ps aux | grep -v grep | grep -i'
alias mkdir='mkdir -pv'

# Network
alias ports='netstat -tulanp'
alias myip='curl ifconfig.me && echo'

# ===== FUNCTIONS =====
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
            *)         echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Calculator
calc() { echo "$*" | bc -l; }

# Weather with teal colors
weather() { curl -s "wttr.in/${1:-}?F" | head -7; }

# Directory size
dsize() { du -h --max-depth=1 "$@" | sort -h; }

# Create backup
backup() { cp -r "$1" "$1.bak"; }

# ===== ENVIRONMENT =====
export EDITOR=nvim
export VISUAL=nvim
export BROWSER=firefox
export TERMINAL=alacritty

export HISTSIZE=100000
export HISTFILESIZE=200000
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="ls:ll:la:l:cd:pwd:exit:clear:history"

# Color for man pages
export LESS_TERMCAP_mb=$'\e[1;36m'    # Teal
export LESS_TERMCAP_md=$'\e[1;34m'    # Blue
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;36m'  # Teal underline

# ===== COMPLETION =====
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# ===== TERMINAL BEHAVIOR =====
set -o vi
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind 'set menu-complete-display-prefix on'

# Enable color support for ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Custom LS_COLORS for teal/blue theme
export LS_COLORS="di=1;36:ln=38;5;32:so=38;5;45:pi=38;5;43:ex=1;32:bd=38;5;24:cd=38;5;39:su=38;5;196:sg=38;5;46:tw=38;5;36:ow=38;5;39"

# FZF integration if available
if [ -f /usr/share/fzf/key-bindings.bash ]; then
    source /usr/share/fzf/key-bindings.bash
    source /usr/share/fzf/completion.bash
    export FZF_DEFAULT_OPTS='--color=bg+:#2d3b49,bg:#1e2a38,spinner:#6ae4b9,hl:#7dcfff --color=fg:#c8d3f5,header:#7dcfff,info:#ff9966,pointer:#6ae4b9 --color=marker:#6ae4b9,fg+:#c8d3f5,prompt:#ff9966,hl+:#7dcfff'
fi
