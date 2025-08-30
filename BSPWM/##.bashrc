# Add to your ~/.bashrc file

# Gruvbox color definitions (no grey)
GRUVBG="48;5;235"      # Dark background (bg0_h)
GRUVFG="38;5;229"      # Light foreground (fg)

GRUVRED="48;5;124"     # Red
GRUVGREEN="48;5;106"   # Green
GRUVYELLOW="48;5;172"  # Yellow
GRUVBLUE="48;5;66"     # Blue
GRUVPURPLE="48;5;132"  # Purple
GRUVAQUA="48;5;72"     # Aqua/Teal
GRUVORANGE="48;5;166"  # Orange

# XTerm compatible ribbon prompt with TEAL starting ❯ background
export PS1="\
\[\033[${GRUVAQUA}m\]\[\033[${GRUVFG}m\]❯\
\[\033[${GRUVBG}m\]\[\033[${GRUVAQUA}m\]{\[\033[${GRUVPURPLE}m\]\[\033[${GRUVFG}m\]\u@\h\[\033[${GRUVBG}m\]\[\033[${GRUVAQUA}m\]}\
\[\033[${GRUVGREEN}m\]\[\033[${GRUVAQUA}m\]❯\
\[\033[${GRUVBG}m\]\[\033[${GRUVGREEN}m\][\w]\
\[\033[${GRUVYELLOW}m\]\[\033[${GRUVGREEN}m\]❯\
\[\033[${GRUVBG}m\]\[\033[${GRUVYELLOW}m\]{\t}\
\[\033[${GRUVBLUE}m\]\[\033[${GRUVYELLOW}m\]❯\
\[\033[${GRUVBG}m\]\[\033[${GRUVBLUE}m\]{\$}\
\[\033[${GRUVRED}m\]\[\033[${GRUVBLUE}m\][ ➤ ]\[\033[0m\] "
