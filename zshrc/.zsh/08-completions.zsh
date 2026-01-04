# ============================================================================
# Completions Module
# ============================================================================

# Add completion directories
fpath+=("/usr/local/share/zsh/site-functions")
fpath+=${ZDOTDIR:-~}/.zsh_functions

# Initialize completions
autoload -Uz compinit
compinit

# Completion styling (opcional)
# Case-insensitive completion
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Colorful completion
# zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Menu selection
# zstyle ':completion:*' menu select
