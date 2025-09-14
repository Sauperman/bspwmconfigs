# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ===== CATPPUCCIN MOCHA COLOR THEME =====
# Base colors
ROSEWATER='\[\033[38;5;218m\]'   # #f5e0dc
FLAMINGO='\[\033[38;5;217m\]'    # #f2cdcd'
PINK='\[\033[38;5;212m\]'        # #f5c2e7'
MAUVE='\[\033[38;5;183m\]'       # #cba6f7'
RED='\[\033[38;5;203m\]'         # #f38ba8'
MAROON='\[\033[38;5;174m\]'      # #eba0ac'
PEACH='\[\033[38;5;223m\]'       # #fab387'
YELLOW='\[\033[38;5;227m\]'      # #f9e2af'
GREEN='\[\033[38;5;150m\]'       # #a6e3a1'
TEAL='\[\033[38;5;115m\]'        # #94e2d5'
SKY='\[\033[38;5;117m\]'         # #89dceb'
SAPPHIRE='\[\033[38;5;111m']'    # #74c7ec'
BLUE='\[\033[38;5;105m\]'        # #89b4fa'
LAVENDER='\[\033[38;5;183m\]'    # #b4befe'

# Text colors
TEXT='\[\033[38;5;250m\]'        # #cdd6f4'
SUBTEXT1='\[\033[38;5;247m\]'    # #bac2de'
SUBTEXT0='\[\033[38;5;244m\]'    # #a6adc8'

# Surface colors
SURFACE2='\[\033[38;5;240m\]'    # #585b70'
SURFACE1='\[\033[38;5;238m\]'    # #45475a'
SURFACE0='\[\033[38;5;236m\]'    # #313244'

# Base colors
BASE='\[\033[38;5;234m\]'        # #1e1e2e'
MANTLE='\[\033[38;5;235m\]'      # #181825'
CRUST='\[\033[38;5;233m\]'       # #11111b'

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

    # Single line prompt with brackets
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

# Color for man pages using Catppuccin colors
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

# Custom LS_COLORS for Catppuccin Mocha theme
export LS_COLORS="di=1;35:ln=38;5;111:so=38;5;212:pi=38;5;223:ex=1;32:bd=38;5;105:cd=38;5;117:su=38;5;203:sg=38;5;150:tw=38;5;115:ow=38;5;183"

# FZF integration if available
if [ -f /usr/share/fzf/key-bindings.bash ]; then
    source /usr/share/fzf/key-bindings.bash
    source /usr/share/fzf/completion.bash
    export FZF_DEFAULT_OPTS='--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8'
fi
