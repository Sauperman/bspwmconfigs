# ~/.bashrc - Compact Catppuccin Mocha Ribbon Prompt (Vibrant)

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ===== CATPPUCCIN MOCHA COLOR SCHEME (VIBRANT) =====
# Background colors
USER_BG="48;5;221"      # catppuccin-yellow (#f9e2af) -> brighter yellow (#f5c2e7)
DIR_BG="48;5;75"        # catppuccin-blue (#89b4fa) -> brighter blue (#74c7ec)
TIME_BG="48;5;171"      # catppuccin-mauve (#cba6f7) -> brighter mauve (#b4befe)
EXIT_BG="48;5;84"       # catppuccin-green (#a6e3a1) -> brighter green (#a6e3a1)
PROMPT_BG="48;5;86"     # catppuccin-teal (#94e2d5) -> brighter teal (#94e2d5)

# Foreground colors
FG_DARK="38;5;233"      # catppuccin-crust (#11111b) -> darker (#0f0f17)
FG_LIGHT="38;5;255"     # catppuccin-text (#cdd6f4) -> brighter (#ffffff)

# Error colors (more vibrant red)
ERROR_BG="48;5;203"     # catppuccin-red (#f38ba8) -> brighter red (#f38ba8)
ERROR_FG="38;5;231"     # white text

# ===== PROMPT FUNCTIONS =====
# Git status function
git_status() {
    local git_branch=$(git branch 2>/dev/null | sed -n '/^\*/s/^\* //p')
    if [ -n "$git_branch" ]; then
        if git diff --quiet 2>/dev/null; then
            echo "\[\033[48;5;84m\]\[\033[38;5;233m\]  $git_branch \[\033[0m\]"
        else
            echo "\[\033[${ERROR_BG}m\]\[\033[${ERROR_FG}m\]  $git_branch ● \[\033[0m\]"
        fi
    fi
}

# Exit status function
exit_status() {
    if [ $? -eq 0 ]; then
        echo "\[\033[${EXIT_BG}m\]\[\033[${FG_DARK}m\] ✓ \[\033[0m\]"
    else
        echo "\[\033[${ERROR_BG}m\]\[\033[${ERROR_FG}m\] ✗ \[\033[0m\]"
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

# Enhanced ls colors for better visibility
export LS_COLORS='rs=0:di=01;94:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;92:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:'

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

# Colorful man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'
