# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ===== GRUVBOX COLOR THEME =====
# Base colors
GRUVBOX_BRIGHT_RED='\[\033[38;5;167m\]'    # #fb4934
GRUVBOX_BRIGHT_GREEN='\[\033[38;5;142m\]'  # #b8bb26
GRUVBOX_BRIGHT_YELLOW='\[\033[38;5;214m\]' # #fabd2f
GRUVBOX_BRIGHT_BLUE='\[\033[38;5;109m\]'   # #83a598
GRUVBOX_BRIGHT_PURPLE='\[\033[38;5;175m\]' # #d3869b
GRUVBOX_BRIGHT_AQUA='\[\033[38;5;108m\]'   # #8ec07c
GRUVBOX_BRIGHT_ORANGE='\[\033[38;5;208m\]' # #fe8019

# Neutral colors
GRUVBOX_LIGHT0='\[\033[38;5;229m\]'        # #fbf1c7
GRUVBOX_LIGHT1='\[\033[38;5;223m\]'        # #ebdbb2
GRUVBOX_LIGHT2='\[\033[38;5;250m\]'        # #d5c4a1
GRUVBOX_LIGHT3='\[\033[38;5;246m\]'        # #bdae93
GRUVBOX_LIGHT4='\[\033[38;5;244m\]'        # #a89984

GRUVBOX_DARK0='\[\033[38;5;234m\]'         # #1d2021
GRUVBOX_DARK1='\[\033[38;5;235m\]'         # #282828
GRUVBOX_DARK2='\[\033[38;5;236m\]'         # #32302f
GRUVBOX_DARK3='\[\033[38;5;237m\]'         # #3c3836
GRUVBOX_DARK4='\[\033[38;5;239m\]'         # #504945

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
        echo " ${GRUVBOX_BRIGHT_RED}●"  # Red dot for changes
    else
        echo " ${GRUVBOX_BRIGHT_GREEN}●"    # Green dot for clean
    fi
}

exit_status() {
    if [ $? -eq 0 ]; then
        echo "${GRUVBOX_BRIGHT_GREEN}✓"
    else
        echo "${GRUVBOX_BRIGHT_RED}✗"
    fi
}

set_prompt() {
    local exit_code="$(exit_status)"
    local git_branch="$(parse_git_branch)"
    local git_status_indicator="$(git_status)"

    # Single line prompt with brackets
    PS1="${BOLD}${GRUVBOX_BRIGHT_BLUE}[${exit_code}${GRUVBOX_BRIGHT_BLUE}]${RESET}"
    PS1+="${BOLD}${GRUVBOX_BRIGHT_PURPLE} ${GRUVBOX_BRIGHT_AQUA}\u${GRUVBOX_LIGHT4}@${GRUVBOX_BRIGHT_AQUA}\h${RESET}"
    PS1+="${BOLD}${GRUVBOX_BRIGHT_PURPLE} ${GRUVBOX_BRIGHT_BLUE}[\w]${RESET}"

    # Git info if in repo
    if [ -n "$git_branch" ]; then
        PS1+="${BOLD}${GRUVBOX_BRIGHT_PURPLE} ${GRUVBOX_BRIGHT_PURPLE}${git_branch}${git_status_indicator}${RESET}"
    fi

    # Prompt character (gradient effect)
    PS1+="${BOLD}${GRUVBOX_BRIGHT_PURPLE}❯${GRUVBOX_BRIGHT_BLUE}❯${GRUVBOX_BRIGHT_AQUA}❯${RESET} "
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

# Weather with gruvbox colors
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

# Color for man pages using Gruvbox colors
export LESS_TERMCAP_mb=$'\e[1;35m'    # Purple
export LESS_TERMCAP_md=$'\e[1;34m'    # Blue
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'   # Yellow
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;36m'  # Aqua underline

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

# Custom LS_COLORS for Gruvbox theme
export LS_COLORS="di=1;35:ln=38;5;109:so=38;5;208:pi=38;5;214:ex=1;32:bd=38;5;109:cd=38;5;108:su=38;5;167:sg=38;5;142:tw=38;5;108:ow=38;5;175"

# FZF integration if available
if [ -f /usr/share/fzf/key-bindings.bash ]; then
    source /usr/share/fzf/key-bindings.bash
    source /usr/share/fzf/completion.bash
    export FZF_DEFAULT_OPTS='--color=bg+:#3c3836,bg:#282828,spinner:#fabd2f,hl:#fb4934 --color=fg:#ebdbb2,header:#fb4934,info:#d3869b,pointer:#fabd2f --color=marker:#fabd2f,fg+:#ebdbb2,prompt:#d3869b,hl+:#fb4934'
fi
