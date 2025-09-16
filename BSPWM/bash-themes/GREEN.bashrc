# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ===== GREEN COLOR THEME =====
# Green shades
GREEN_LIGHT='\[\033[38;5;114m\]'   # Bright green
GREEN_MEDIUM='\[\033[38;5;70m\]'   # Medium green
GREEN_DARK='\[\033[38;5;28m\]'     # Dark green
GREEN_NEON='\[\033[38;5;82m\]'     # Neon green
GREEN_FOREST='\[\033[38;5;22m\]'   # Forest green
GREEN_MINT='\[\033[38;5;121m\]'    # Mint green
GREEN_OLIVE='\[\033[38;5;64m\]'    # Olive green
GREEN_LIME='\[\033[38;5;148m\]'    # Lime green
GREEN_EMERALD='\[\033[38;5;35m\]'  # Emerald green
GREEN_SEA='\[\033[38;5;29m\]'      # Sea green
GREEN_SPRING='\[\033[38;5;48m\]'   # Spring green
GREEN_TEAL='\[\033[38;5;30m\]'     # Teal green

# Complementary colors (for contrast)
GRAY_LIGHT='\[\033[38;5;250m\]'    # Light gray
GRAY_MEDIUM='\[\033[38;5;245m\]'   # Medium gray
GRAY_DARK='\[\033[38;5;240m\]'     # Dark gray
WHITE='\[\033[38;5;255m\]'         # White
BLACK='\[\033[38;5;232m\]'         # Black

# Accent colors (minimal use)
YELLOW_GREEN='\[\033[38;5;148m\]'  # Yellow-green
BLUE_GREEN='\[\033[38;5;37m\]'     # Blue-green

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
        echo " ${GREEN_FOREST}●"  # Dark green dot for changes
    else
        echo " ${GREEN_LIGHT}●"    # Bright green dot for clean
    fi
}

exit_status() {
    if [ $? -eq 0 ]; then
        echo "${GREEN_LIGHT}✓"
    else
        echo "${GREEN_FOREST}✗"
    fi
}

set_prompt() {
    local exit_code="$(exit_status)"
    local git_branch="$(parse_git_branch)"
    local git_status_indicator="$(git_status)"

    # Single line prompt with green theme
    PS1="${BOLD}${GREEN_MEDIUM}[${exit_code}${GREEN_MEDIUM}]${RESET}"
    PS1+="${BOLD}${GREEN_EMERALD} ${GREEN_LIME}\u${GRAY_MEDIUM}@${GREEN_TEAL}\h${RESET}"
    PS1+="${BOLD}${GREEN_SEA} ${GREEN_MEDIUM}[\w]${RESET}"

    # Git info if in repo
    if [ -n "$git_branch" ]; then
        PS1+="${BOLD}${GREEN_EMERALD} ${GREEN_SPRING}${git_branch}${git_status_indicator}${RESET}"
    fi

    # 4-color green dots indicator
    PS1+="${BOLD}${GREEN_EMERALD}•${GREEN_MEDIUM}•${GREEN_LIME}•${GREEN_TEAL}•${RESET}"

    # Prompt character (green gradient effect)
    PS1+="${BOLD}${GREEN_EMERALD}❯${GREEN_MEDIUM}❯${GREEN_LIME}❯${RESET} "
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

# Green-themed aliases
alias plant='echo "🌱 Your system is growing beautifully!"'
alias garden='echo "🌸 Digital garden well maintained!"'
alias grow='echo "📈 Growing stronger every day!"'

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

# Weather with green colors
weather() { curl -s "wttr.in/${1:-}?F" | head -7; }

# Directory size
dsize() { du -h --max-depth=1 "$@" | sort -h; }

# Create backup
backup() { cp -r "$1" "$1.bak"; }

# Green-themed function
eco() {
    echo "${GREEN_LIGHT}♻️  Eco-friendly computing tips:"
    echo "  • Use 'powerprofilesctl set power-saver' for battery life"
    echo "  • Close unused applications to save resources"
    echo "  • Consider using lightweight alternatives${RESET}"
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

# Color for man pages using green theme
export LESS_TERMCAP_mb=$'\e[1;32m'    # Green
export LESS_TERMCAP_md=$'\e[1;32m'    # Green
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'   # Yellow (for contrast)
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

# Custom LS_COLORS for green theme
export LS_COLORS="di=1;32:ln=38;5;30:so=38;5;35:pi=38;5;148:ex=1;32:bd=38;5;70:cd=38;5;37:su=38;5;28:sg=38;5;64:tw=38;5;29:ow=38;5;35"

# FZF integration if available
if [ -f /usr/share/fzf/key-bindings.bash ]; then
    source /usr/share/fzf/key-bindings.bash
    source /usr/share/fzf/completion.bash
    export FZF_DEFAULT_OPTS='--color=bg+:#e8f5e8,bg:#f5fff5,spinner:#40a02b,hl:#179299 --color=fg:#4c4f69,header:#179299,info:#40a02b,pointer:#40a02b --color=marker:#40a02b,fg+:#4c4f69,prompt:#40a02b,hl+:#179299'
fi
