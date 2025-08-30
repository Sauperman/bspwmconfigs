# Gruvbox color scheme (actual color codes)
START_BG="48;5;142"     # gruvbox-green (#b8bb26)
USER_BG="48;5;214"      # gruvbox-yellow (#fabd2f)
PATH_BG="48;5;208"      # gruvbox-orange (#fe8019)
TIME_BG="48;5;167"      # gruvbox-red (#fb4934)
PROMPT_BG="48;5;175"    # gruvbox-purple (#d3869b)
END_BG="48;5;109"       # gruvbox-blue (#83a598)

# Gruvbox foreground colors
FG_DARK="38;5;235"      # gruvbox-bg0 (#282828)
FG_LIGHT="38;5;229"     # gruvbox-bg2 (#f9f5d7)

# Gruvbox retro theme ribbon prompt
export PS1="\
\[\033[${START_BG}m\]\[\033[${FG_DARK}m\]❯\
\[\033[${USER_BG}m\]\[\033[${FG_DARK}m\]{\u@\h}\
\[\033[${PATH_BG}m\]\[\033[${FG_DARK}m\]❯\
\[\033[${PATH_BG}m\]\[\033[${FG_DARK}m\][\w]\
\[\033[${TIME_BG}m\]\[\033[${FG_LIGHT}m\]❯\
\[\033[${TIME_BG}m\]\[\033[${FG_LIGHT}m\]{\t}\
\[\033[${PROMPT_BG}m\]\[\033[${FG_DARK}m\]❯\
\[\033[${PROMPT_BG}m\]\[\033[${FG_DARK}m\]{\$}\
\[\033[${END_BG}m\]\[\033[${FG_DARK}m\][ ➤ ]\[\033[0m\] "
