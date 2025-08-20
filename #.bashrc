BRIGHT_TEAL='\[\033[38;5;36m\]'
COFFEE_BROWN='\[\033[38;5;94m\]'
CREAM='\[\033[38;5;187m\]'
ACCENT_COLOR='\[\033[38;5;75m\]'
RESET_COLOR='\[\033[0m\]'

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/  \1/'
}

export PS1="\n${COFFEE_BROWN}╭─${CREAM}[\A]${RESET_COLOR}\n${COFFEE_BROWN}╰─${BRIGHT_TEAL}[\u@\h] ${COFFEE_BROWN}[${ACCENT_COLOR}🐧 ${BRIGHT_TEAL}\w${COFFEE_BROWN}]${CREAM}\$(parse_git_branch)${RESET_COLOR}\n${COFFEE_BROWN}➜ ${RESET_COLOR}"
