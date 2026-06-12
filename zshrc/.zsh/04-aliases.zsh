# ============================================================================
# Aliases Module
# ============================================================================

# --- System ---
alias c="clear"
alias reload="source ~/.zshrc"
alias h="history"
alias grep="grep --color=auto"

# --- Editors (Dynamic Fallback) ---
if command -v nvim &> /dev/null; then
  alias v="nvim"
  alias vim="nvim"
  alias vi="nvim"
elif command -v vim &> /dev/null; then
  alias v="vim"
  alias vi="vim"
else
  alias v="vi"
fi

# Modern replacements
command -v eza &> /dev/null && alias ls="eza --icons" || \
command -v exa &> /dev/null && alias ls="exa --icons" || \
alias ls="ls --color=auto"

command -v bat &> /dev/null && alias cat="bat"

# --- Navigation ---
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"
alias dot="cd ~/dotfiles"

# --- Git ---
alias gs="git status"
alias ga="git add"
alias gaa="git add ."
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gco="git checkout"
alias gcb="git checkout -b"
alias glog="git log --oneline --graph --decorate"

# Git Full Flow: add + commit + push
gacp() {
  local msg="$*"
  if [[ -z "$msg" ]]; then
    echo "❌ Erro: Forneça uma mensagem de commit."
    echo "Uso: gh <mensagem>"
    return 1
  fi
  
  echo "📦 Adicionando..."
  git add .
  echo "💬 Commitando: $msg"
  git commit -m "$msg"
  echo "🚀 Fazendo push..."
  git push origin HEAD
  echo "✅ Concluído!"
}

# --- Utils ---
# Mostra portas em uso
alias ports="sudo lsof -i -P -n | grep LISTEN"

if [[ "$IS_MAC" == true ]]; then
  alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
  alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"
fi
