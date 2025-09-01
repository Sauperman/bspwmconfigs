# ~/.bashrc - Compact Gruvbox Ribbon Prompt

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ===== GRUVBOX COLOR SCHEME =====
# Background colors
USER_BG="48;5;214"      # gruvbox-yellow (#fabd2f)
DIR_BG="48;5;109"       # gruvbox-blue (#83a598)
TIME_BG="48;5;175"      # gruvbox-purple (#d3869b)
EXIT_BG="48;5;108"      # gruvbox-bright-green (#8ec07c)
PROMPT_BG="48;5;142"    # gruvbox-green (#b8bb26)

# Foreground colors
FG_DARK="38;5;235"      # gruvbox-bg0 (#282828)
FG_LIGHT="38;5;229"     # gruvbox-bg2 (#f9f5d7)

# ===== PROMPT FUNCTIONS =====
# Git status function
git_status() {
    local git_branch=$(git branch 2>/dev/null | sed -n '/^\*/s/^\* //p')
    if [ -n "$git_branch" ]; then
        if git diff --quiet 2>/dev/null; then
            echo "\[\033[48;5;108m\]\[\033[38;5;235m\]  $git_branch \[\033[0m\]"
        else
            echo "\[\033[48;5;167m\]\[\033[38;5;229m\]  $git_branch ● \[\033[0m\]"
        fi
    fi
}

# Exit status function
exit_status() {
    if [ $? -eq 0 ]; then
        echo "\[\033[${EXIT_BG}m\]\[\033[${FG_DARK}m\] ✓ \[\033[0m\]"
    else
        echo "\[\033[48;5;167m\]\[\033[38;5;229m\] ✗ \[\033[0m\]"
    fi
}

# ===== COMPACT PROMPT =====
set_prompt() {
    local exit_status="$(exit_status)"
    local git_info="$(git_status)"

    # Build the compact prompt
    PS1="\[\033[${USER_BG}m\]\[\033[${FG_DARK}m\]{ \u@\h }\[\033[0m\]"

    if [ -n "$git_info" ]; then
        PS1+="─$git_info"
    fi

    PS1+="\[\033[${DIR_BG}m\]\[\033[${FG_DARK}m\]─[ \w ]\[\033[0m\]"
    PS1+="\[\033[${TIME_BG}m\]\[\033[${FG_LIGHT}m\]─{ \t }\[\033[0m\]"
    PS1+="$exit_status"
    PS1+="\[\033[${PROMPT_BG}m\]\[\033[${FG_DARK}m\]{ \$ }➤\[\033[0m\] "
}

PROMPT_COMMAND=set_prompt

# ===== ALIASES =====
alias ls='ls --color=auto'
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ===== TERMINAL BEHAVIOR =====
# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command
shopt -s checkwinsize

# Set history length
HISTSIZE=1000
HISTFILESIZE=2000

# Ignore duplicate commands and commands starting with space
HISTCONTROL=ignoreboth

# ===== CUSTOM FUNCTIONS =====
# Quick directory navigation with better listing
cdl() {
    cd "$@" && ll
}

# Extract various archive types
extract() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz) tar xzf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar x "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xf "$1" ;;
            *.tbz2) tar xjf "$1" ;;
            *.tgz) tar xzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

