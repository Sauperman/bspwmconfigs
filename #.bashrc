# Custom Color Definitions (ANSI Escape Codes)
TEA_GREEN='\[\e[38;5;156m\]'    # Soft tea green
COFFEE_WOOD='\[\e[38;5;130m\]'  # Warm coffee brown
BRIGHT_ACCENT='\[\e[38;5;214m\]' # Bright orange/yellow
SOFT_CONTRAST='\[\e[38;5;189m\]' # Light lavender

# Git Branch Function (Optional)
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ ( \1)/'
}

# Set PS1 with 4-Color Scheme
PS1="${LATTE}╭──($ ${WHISKERS}\u${LATTE})${MOCHA}@[${LAVENDER}\h${MOCHA}]──[${WHISKERS}\w${MOCHA}]\n${LATTE}╰─${LAVENDER}$ "
