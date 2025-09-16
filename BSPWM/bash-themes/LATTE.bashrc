# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ===== CATPPUCCIN LATTE LIGHT THEME =====
# Base colors (Catppuccin Latte)
ROSEWATER='\[\033[38;5;217m\]'   # #dc8a78
FLAMINGO='\[\033[38;5;216m\]'    # #dd7878
PINK='\[\033[38;5;212m\]'        # #ea76cb
MAUVE='\[\033[38;5;141m\]'       # #8839ef
RED='\[\033[38;5;203m\]'         # #d20f39
MAROON='\[\033[38;5;167m\]'      # #e64553
PEACH='\[\033[38;5;215m\]'       # #fe640b
YELLOW='\[\033[38;5;221m\]'      # #df8e1d
GREEN='\[\033[38;5;114m\]'       # #40a02b
TEAL='\[\033[38;5;79m\]'         # #179299
SKY='\[\033[38;5;74m\]'          # #04a5e5
SAPPHIRE='\[\033[38;5;68m\]'     # #209fb5
BLUE='\[\033[38;5;69m\]'         # #1e66f5
LAVENDER='\[\033[38;5;141m\]'    # #7287fd'

# Text colors
TEXT='\[\033[38;5;239m\]'        # #4c4f69 (dark gray)
SUBTEXT1='\[\033[38;5;245m\]'    # #5c5f77 (medium gray)
SUBTEXT0='\[\033[38;5;247m\]'    # #6c6f85 (light gray)

# Surface colors (light backgrounds)
SURFACE2='\[\033[38;5;251m\]'    # #9ca0b0 (very light gray)
SURFACE1='\[\033[38;5;253m\]'    # #acb0be (off-white)
SURFACE0='\[\033[38;5;255m\]'    # #ccd0da (white)

# Base colors (light backgrounds)
BASE='\[\033[38;5;231m\]'        # #eff1f5 (bright white)
MANTLE='\[\033[38;5;255m\]'      # #e6e9ef (white)
CRUST='\[\033[38;5;254m\]'       # #dce0e8 (pale white)

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
        echo " ${RED}●"  # Red dot for changes
    else
        echo " ${GREEN}●"    # Green dot for clean
    fi
}

exit_status() {
    if [ $? -eq 0 ]; then
        echo "${GREEN}✓"
    else
        echo "${RED}✗"
    fi
}

set_prompt() {
    local exit_code="$(exit_status)"
    local git_branch="$(parse_git_branch)"
    local git_status_indicator="$(git_status)"

    # Single line prompt with brackets - optimized for light background
    PS1="${BOLD}${BLUE}[${exit_code}${BLUE}]${RESET}"
    PS1+="${BOLD}${MAUVE} ${SKY}\u${SURFACE2}@${TEAL}\h${RESET}"
    PS1+="${BOLD}${LAVENDER} ${BLUE}[\w]${RESET}"

    # Git info if in repo
    if [ -n "$git_branch" ]; then
        PS1+="${BOLD}${MAUVE} ${PINK}${git_branch}${git_status_indicator}${RESET}"
    fi

    # 4-color dots indicator
    PS1+="${BOLD}${MAUVE}•${BLUE}•${SKY}•${TEAL}•${RESET}"

    # Prompt character (gradient effect)
    PS1+="${BOLD}${MAUVE}❯${BLUE}❯${SKY}❯${RESET} "
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

# Weather with catppuccin colors
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

# Color for man pages using Catppuccin Latte colors
export LESS_TERMCAP_mb=$'\e[1;35m'    # Pink
export LESS_TERMCAP_md=$'\e[1;34m'    # Blue
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'   # Yellow
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

# Custom LS_COLORS for Catppuccin Latte light theme
export LS_COLORS="di=1;34:ln=38;5;68:so=38;5;212:pi=38;5;215:ex=1;32:bd=38;5;69:cd=38;5;74:su=38;5;203:sg=38;5;114:tw=38;5;79:ow=38;5;141"

# FZF integration if available
if [ -f /usr/share/fzf/key-bindings.bash ]; then
    source /usr/share/fzf/key-bindings.bash
    source /usr/share/fzf/completion.bash
    export FZF_DEFAULT_OPTS='--color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 --color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39'
fi

# Set terminal background to light (optional - depends on terminal)
# echo -ne '\033]11;#eff1f5\007'  # Sets background to Latte base color
