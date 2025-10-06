# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ===== MONOCHROME COLOR THEME =====
# Grayscale colors - from black to white
BLACK='\[\033[38;5;232m\]'    # Darkest
GRAY10='\[\033[38;5;234m\]'   # Very dark
GRAY20='\[\033[38;5;236m\]'   # Dark
GRAY30='\[\033[38;5;238m\]'   # Medium dark
GRAY40='\[\033[38;5;240m\]'   # Medium
GRAY50='\[\033[38;5;242m\]'   # Medium light
GRAY60='\[\033[38;5;244m\]'   # Light
GRAY70='\[\033[38;5;246m\]'   # Lighter
GRAY80='\[\033[38;5;248m\]'   # Very light
GRAY90='\[\033[38;5;250m\]'   # Almost white
WHITE='\[\033[38;5;252m\]'    # Bright white

# Assign semantic names for consistency
DARKEST=$BLACK
DARK=$GRAY30
MEDIUM=$GRAY50
LIGHT=$GRAY70
BRIGHT=$GRAY90
BRIGHTEST=$WHITE

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
        echo " ${DARK}●"  # Dark dot for changes
    else
        echo " ${LIGHT}●"    # Light dot for clean
    fi
}

exit_status() {
    if [ $? -eq 0 ]; then
        echo "${LIGHT}✓"
    else
        echo "${DARK}✗"
    fi
}

set_prompt() {
    local exit_code="$(exit_status)"
    local git_branch="$(parse_git_branch)"
    local git_status_indicator="$(git_status)"

    # Single line prompt with brackets
    PS1="${BOLD}${MEDIUM}[${exit_code}${MEDIUM}]${RESET}"
    PS1+="${BOLD}${BRIGHT} ${LIGHT}\u${GRAY40}@${MEDIUM}\h${RESET}"
    PS1+="${BOLD}${BRIGHT} ${MEDIUM}[\w]${RESET}"

    # Git info if in repo
    if [ -n "$git_branch" ]; then
        PS1+="${BOLD}${BRIGHT} ${LIGHT}${git_branch}${git_status_indicator}${RESET}"
    fi

    # 4-shade dots indicator
    PS1+="${BOLD}${BRIGHT}•${MEDIUM}•${LIGHT}•${GRAY40}•${RESET}"

    # Prompt character (gradient effect)
    PS1+="${BOLD}${BRIGHT}❯${MEDIUM}❯${LIGHT}❯${RESET} "
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

# Monochrome colors for man pages
export LESS_TERMCAP_mb=$'\e[1;37m'    # Bright white
export LESS_TERMCAP_md=$'\e[1;37m'    # Bright white
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;47;30m' # Black on white
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;37m'  # Bright white underline

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

# Monochrome LS_COLORS
export LS_COLORS="di=1;37:ln=38;5;250:so=38;5;245:pi=38;5;240:ex=1;37:bd=38;5;242:cd=38;5;244:su=38;5;232:sg=38;5;232:tw=38;5;232:ow=38;5;232"

# FZF integration if available
if [ -f /usr/share/fzf/key-bindings.bash ]; then
    source /usr/share/fzf/key-bindings.bash
    source /usr/share/fzf/completion.bash
    export FZF_DEFAULT_OPTS='--color=bg+:#444444,bg:#222222,spinner:#ffffff,hl:#cccccc --color=fg:#eeeeee,header:#cccccc,info:#aaaaaa,pointer:#ffffff --color=marker:#ffffff,fg+:#ffffff,prompt:#aaaaaa,hl+:#cccccc'
fi
