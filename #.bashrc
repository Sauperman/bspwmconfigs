# ~/.bashrc - RETRO TOKYO NIGHTS EDITION

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ===== RETRO TOKYO COLOR PALETTE =====
TOKYO_BLACK='\033[38;5;232m'
TOKYO_DARK_BLUE='\033[38;5;17m'
TOKYO_BLUE='\033[38;5;27m'
TOKYO_CYAN='\033[38;5;45m'
TOKYO_PINK='\033[38;5;199m'
TOKYO_PURPLE='\033[38;5;93m'
TOKYO_MAGENTA='\033[38;5;163m'
TOKYO_ORANGE='\033[38;5;208m'
TOKYO_YELLOW='\033[38;5;226m'
TOKYO_GREEN='\033[38;5;46m'
TOKYO_WHITE='\033[38;5;255m'
TOKYO_GRAY='\033[38;5;245m'

BG_BLACK='\033[48;5;232m'
BG_DARK_BLUE='\033[48;5;17m'
BG_PURPLE='\033[48;5;93m'
BG_PINK='\033[48;5;199m'

BOLD='\033[1m'
RESET='\033[0m'

# ===== CYBERPUNK PROMPT COMPONENTS =====
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/  \1/'
}

git_status_icons() {
    local status=$(git status --porcelain 2>/dev/null)
    local icons=""

    if [ -n "$status" ]; then
        local unstaged=$(echo "$status" | grep -c '^ M\|^ D\|^??' 2>/dev/null)
        local staged=$(echo "$status" | grep -c '^M \|^A \|^D ' 2>/dev/null)

        [ "$unstaged" -gt 0 ] && icons+=" ${TOKYO_ORANGE}${unstaged}"
        [ "$staged" -gt 0 ] && icons+=" ${TOKYO_GREEN}${staged}"
        echo "$status" | grep -q '^UU' && icons+=" ${TOKYO_PINK}"
        echo "$status" | grep -q '^??' && icons+=" ${TOKYO_YELLOW}"
    fi

    echo "$icons"
}

git_remote_status() {
    local ahead=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo "0")
    local behind=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo "0")

    local remote_status=""
    [ "$ahead" -gt 0 ] && remote_status+=" ${TOKYO_GREEN}↑${ahead}"
    [ "$behind" -gt 0 ] && remote_status+=" ${TOKYO_PINK}↓${behind}"

    echo "$remote_status"
}

exit_status_icon() {
    if [ $? -eq 0 ]; then
        echo "${TOKYO_GREEN}"
    else
        echo "${TOKYO_PINK}"
    fi
}

show_venv() {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo " ${TOKYO_YELLOW}🐍 $(basename "$VIRTUAL_ENV")"
    fi
}

show_k8s() {
    if command -v kubectl &> /dev/null; then
        local context=$(kubectl config current-context 2>/dev/null)
        local namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
        if [ -n "$context" ]; then
            echo " ${TOKYO_CYAN}☸ ${context}${TOKYO_GRAY}:${TOKYO_WHITE}${namespace:-default}"
        fi
    fi
}

# ===== NEO-TOKYO PROMPT DESIGN =====
set_prompt() {
    local exit_icon="$(exit_status_icon)"
    local git_branch="$(parse_git_branch)"
    local git_icons="$(git_status_icons)"
    local git_remote="$(git_remote_status)"
    local venv_info="$(show_venv)"
    local k8s_info="$(show_k8s)"

    PS1=""

    # First line: Status bar
    PS1+="${BOLD}${BG_DARK_BLUE}${TOKYO_WHITE} 󰣇 ${RESET}${BOLD}${TOKYO_DARK_BLUE}"
    PS1+="${TOKYO_PURPLE}[${exit_icon}${TOKYO_PURPLE}]"
    PS1+="${TOKYO_DARK_BLUE}[${TOKYO_CYAN}󰥔 \t${TOKYO_DARK_BLUE}]"

    # User and host
    if [ -n "$SSH_CONNECTION" ]; then
        PS1+="${TOKYO_ORANGE} 󰣀 ${TOKYO_CYAN}\u${TOKYO_GRAY}@${TOKYO_GREEN}\h"
    else
        PS1+="${TOKYO_PINK}  ${TOKYO_CYAN}\u${TOKYO_GRAY}@${TOKYO_GREEN}\h"
    fi

    # Current directory
    PS1+="${TOKYO_PURPLE}  \w"

    # Second line: Context information
    local context_line=""
    [ -n "$venv_info" ] && context_line+="${venv_info}"
    [ -n "$k8s_info" ] && context_line+="${k8s_info}"

    if [ -n "$git_branch" ]; then
        context_line+="${TOKYO_PINK}  ${TOKYO_CYAN}${git_branch# }${git_icons}${git_remote}"
    fi

    if [ -n "$context_line" ]; then
        PS1+="\n${BOLD}${BG_PURPLE}${TOKYO_WHITE} 󰘧 ${RESET}${BOLD}${TOKYO_PURPLE}${context_line}"
    fi

    # Final line: Input prompt
    PS1+="\n"
    PS1+="${BOLD}${TOKYO_PINK}❯${TOKYO_PURPLE}❯${TOKYO_CYAN}❯${TOKYO_GREEN}❯${TOKYO_YELLOW}❯${RESET} "
}

PROMPT_COMMAND=set_prompt

# ===== ENHANCED ALIAS COLLECTION =====
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

alias ls='exa --icons --group-directories-first'
alias ll='exa -l --icons --group-directories-first --git'
alias la='exa -la --icons --group-directories-first --git'
alias lt='exa --tree --icons --level=2'

if ! command -v exa &> /dev/null; then
    alias ls='ls --color=auto --group-directories-first'
    alias ll='ls -lh --color=auto --group-directories-first'
    alias la='ls -lAh --color=auto --group-directories-first'
fi

alias rm='rm -Iv --preserve-root'
alias mv='mv -iv'
alias cp='cp -iv'

alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias remove='sudo pacman -Rns'
alias search='pacman -Ss'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq) 2>/dev/null'

alias bashrc='nvim ~/.bashrc && source ~/.bashrc'
alias reload='source ~/.bashrc'

alias df='df -h'
alias du='du -h'
alias free='free -h'
alias top='htop'

alias py='python'
alias py3='python3'
alias venv='python -m venv .venv && source .venv/bin/activate'
alias activate='source .venv/bin/activate'

alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias gl='git log --oneline --graph -n 20'

# ===== CYBERPUNK FUNCTIONS =====
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
            *.zip)     unzip "$1" ;;
            *.7z)      7z x "$1" ;;
            *)         echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

calc() { echo "$*" | bc -l; }

weather() {
    local city="${1:-}"
    if [ -z "$city" ]; then
        curl -s "wttr.in?F&m" | head -7
    else
        curl -s "wttr.in/$city?F&m" | head -7
    fi
}

ff() { find . -type f -iname "*$*" 2>/dev/null; }
fd() { find . -type d -iname "*$*" 2>/dev/null; }

# ===== ENVIRONMENT =====
export EDITOR=nvim
export VISUAL=nvim

export HISTSIZE=100000
export HISTFILESIZE=200000
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S - "

shopt -s histappend

export LS_COLORS="di=1;36:ln=1;35:so=1;32:pi=1;33:ex=1;31:bd=34;46:cd=34;43:*.py=38;5;45:*.js=38;5;226:*.html=38;5;208:*.css=38;5;199:*.json=38;5;93"

# ===== COMPLETION =====
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

# ===== TERMINAL BEHAVIOR =====
set -o vi
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
