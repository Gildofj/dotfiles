# ============================================================================
# FZF Configuration Module
# ============================================================================

# Load FZF if installed
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Configure FZF with fd if available
if command -v fd &> /dev/null; then
  export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
  
  # Use fd for path completion
  _fzf_compgen_path() {
    fd --hidden --exclude .git . "$1"
  }
  
  # Use fd for directory completion
  _fzf_compgen_dir() {
    fd --type=d --hidden --exclude .git . "$1"
  }
fi

# FZF color scheme (opcional - descomente para usar)
# export FZF_DEFAULT_OPTS="
#   --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
#   --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
#   --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
#   --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
# "
