# ============================================================================
# Aliases Module
# ============================================================================

# --- System ---
alias c="clear"
alias reload="source ~/.zshrc"

# Modern replacements (only if installed)
command -v exa &> /dev/null && alias ls="exa --icons" || alias ls="ls --color=auto"
command -v bat &> /dev/null && alias cat="bat"

# --- Git ---
alias ga="git add ."
alias gs="git status"
alias gc="git commit -m"
alias gp="git push"
alias gpoh="git push origin HEAD"
alias gpl="git pull"
alias gco="git checkout"
alias gcb="git checkout -b"
alias glog="git log --oneline --graph --decorate"

# Git helper: add, commit, and push with message
gh() {
  local msg="$*"
  if [ -z "$msg" ]; then
    echo "❌ Por favor, forneça uma mensagem de commit."
    echo "Uso: gh <mensagem do commit>"
    return 1
  else
    echo "📦 Adicionando arquivos..."
    ga && \
    echo "💬 Commitando: $msg" && \
    gc "$msg" && \
    echo "🚀 Fazendo push..." && \
    gpoh && \
    echo "✅ Concluído!"
  fi
}

# --- Navigation ---
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# --- Utils ---
alias h="history"
alias grep="grep --color=auto"

# Platform-specific aliases
if [[ "$IS_MAC" == true ]]; then
  alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
  alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"
fi
