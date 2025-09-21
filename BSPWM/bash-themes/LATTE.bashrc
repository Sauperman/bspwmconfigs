# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ===== BLUE TO DARK GRADIENT THEME =====
# Gradient colors from #def4ff to darkest
LIGHT_BLUE='\[\033[38;5;195m\]'    # #def4ff (lightest blue)
BLUE_2='\[\033[38;5;153m\]'        # #c9e6ff
BLUE_3='\[\033[38;5;111m\]'        # #a8d8ff
BLUE_4='\[\033[38;5;75m\]'         # #7ebfff
BLUE_5='\[\033[38;5;69m\]'         # #5f9eff
BLUE_6='\[\033[38;5;63m\]'         # #4a7bff
BLUE_7='\[\033[38;5;57m\]'         # #3a5feb
BLUE_8='\[\033[38;5;55m\]'         # #2a45d1
BLUE_9='\[\033[38;5;54m\]'         # #1e32b8
DARK_BLUE='\[\033[38;5;53m\]'      # #0f1f9c
DARKER_BLUE='\[\033[38;5;52m\]'    # #08156e
DARKEST='\[\033[38;5;17m\]'        # #00002a (almost black with blue tint)

# Accent colors that work with the gradient
CYAN='\[\033[38;5;87m\]'          # #5fffff (bright cyan)
TEAL='\[\033[38;5;43m\]'          # #00d7d7 (vibrant teal)
PURPLE='\[\033[38;5;141m\]'       # #a873ff (soft purple)
PINK='\[\033[38;5;213m\]'         # #ff7aff (bright pink)
RED='\[\033[38;5;203m\]'          # #ff5f5f (coral red)
GREEN='\[\033[38;5;84m\]'         # #5fff87 (mint green)
YELLOW='\[\033[38;5;227m\]'       # #ffff5f (lemon yellow)
ORANGE='\[\033[38;5;215m\]'       # #ffaf5f (warm orange)

# Text colors for different background intensities
TEXT_LIGHT='\[\033[38;5;234m\]'   # #1c1c1c (dark gray for light backgrounds)
TEXT_MEDIUM='\[\033[38;5;250m\]'  # #bcbcbc (light gray for medium backgrounds)
TEXT_DARK='\[\033[38;5;255m\]'    # #ffffff (white for dark backgrounds)

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

    # Gradient prompt that transitions from light to dark
    PS1="${BOLD}${BLUE_4}[${exit_code}${BLUE_4}]${RESET}"
    PS1+="${BOLD}${BLUE_6} ${BLUE_3}\u${BLUE_5}@${BLUE_7}\h${RESET}"
    PS1+="${BOLD}${BLUE_10} [${TEXT_DARK}\w${BLUE_8}]${RESET}"

    # Git info if in repo
    if [ -n "$git_branch" ]; then
        PS1+="${BOLD}${BLUE_9} ${PURPLE}${git_branch}${git_status_indicator}${RESET}"
    fi

    # Gradient dots showing the color progression
    PS1+="${BOLD}${BLUE_10}•${BLUE_10}•${BLUE_7}•${BLUE_9}•${DARKEST}•${RESET}"

    # Gradient prompt character
    PS1+="${BOLD}${BLUE_5}❯${BLUE_7}❯${BLUE_9}❯${RESET} "
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

# Weather
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

# Color for man pages using blue gradient
export LESS_TERMCAP_mb=$'\e[1;38;5;213m'    # Pink
export LESS_TERMCAP_md=$'\e[1;38;5;75m'     # Medium blue
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;38;5;227m'    # Yellow
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;38;5;87m'   # Cyan underline

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

# Custom LS_COLORS for blue gradient theme
export LS_COLORS="di=38;5;75:ln=38;5;111:so=38;5;213:pi=38;5;215:ex=38;5;84:bd=38;5;69:cd=38;5;63:su=38;5;203:sg=38;5;84:tw=38;5;43:ow=38;5;141"

# FZF integration if available
if [ -f /usr/share/fzf/key-bindings.bash ]; then
    source /usr/share/fzf/key-bindings.bash
    source /usr/share/fzf/completion.bash
    export FZF_DEFAULT_OPTS='--color=bg+:#1e32b8,bg:#00002a,spinner:#7ebfff,hl:#ff5f5f --color=fg:#ffffff,header:#ff5f5f,info:#a873ff,pointer:#7ebfff --color=marker:#7ebfff,fg+:#ffffff,prompt:#a873ff,hl+:#ff5f5f'
fi

# Set terminal background gradient (optional - may not work in all terminals)
# echo -ne '\033]11;#00002a\007'  # Sets background to darkest blue
