# ~/.bashrc - Minimal Catppuccin Edition
[[ $- != *i* ]] && return

# ===== CATPPUCCIN COLORS (Minimal Set) =====
PINK='\[\033[38;5;212m\]'
MAUVE='\[\033[38;5;183m\]'
RED='\[\033[38;5;203m\]'
GREEN='\[\033[38;5;150m\]'
TEAL='\[\033[38;5;115m\]'
SKY='\[\033[38;5;117m\]'
BLUE='\[\033[38;5;105m\]'
LAVENDER='\[\033[38;5;183m\]'
BASE='\[\033[38;5;234m\]'
BOLD='\[\033[1m\]'
RESET='\[\033[0m\]'

# ===== ULTRA-MINIMAL PROMPT =====
set_prompt() {
    local exit_icon=$([ $? -eq 0 ] && echo "${GREEN}λ" || echo "${RED}λ")
    local git_info=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/  \1/')

    PS1="${BOLD}${exit_icon} ${BLUE}\W"
    [ -n "$git_info" ] && PS1+="${MAUVE}${git_info}"
    PS1+="${RESET} ${LAVENDER}❯${RESET} "
}
PROMPT_COMMAND=set_prompt

# ===== ESSENTIAL ALIASES =====
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lh'
alias la='ls -lAh'
alias grep='grep --color=auto'
alias rm='rm -I'
alias cp='cp -i'
alias mv='mv -i'
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'
alias c='clear'
alias h='history'

# Quick edits
alias v='nvim'
alias brc='nvim ~/.bashrc && source ~/.bashrc'

# Arch shortcuts
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'
alias remove='sudo pacman -Rns'

# ===== KEY FUNCTIONS =====
mkcd() { mkdir -p "$1" && cd "$1"; }
cl() { cd "$1" && ls; }
g() { grep -i "$1" *; }

# ===== ENVIRONMENT =====
export EDITOR=nvim
export VISUAL=nvim
export HISTSIZE=5000
export HISTFILESIZE=10000
export HISTCONTROL=ignoreboth:erasedups

# Vi mode with quick escape
set -o vi
bind 'set show-mode-in-prompt on'
bind 'set vi-cmd-mode-string "\1\033[2;35m\2[N]\1\033[0m\2 "'
bind 'set vi-ins-mode-string "\1\033[2;36m\2[I]\1\033[0m\2 "'

# FZF if available
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
