# ============================================================================
# Package Managers Module
# ============================================================================

# --- Homebrew ---
if [[ -f "${HOMEBREW_PREFIX}/bin/brew" ]]; then
  eval "$(${HOMEBREW_PREFIX}/bin/brew shellenv)"
fi

# --- NVM (Node Version Manager) - LAZY LOADING ---
# Melhora significativamente a velocidade de abertura do terminal
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  nvm() {
    unset -f nvm node npm npx pnpm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm "$@"
  }
  
  # Lazy load node/npm/npx/pnpm
  node() { unset -f nvm node npm npx pnpm; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; node "$@" }
  npm()  { unset -f nvm node npm npx pnpm; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; npm "$@" }
  npx()  { unset -f nvm node npm npx pnpm; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; npx "$@" }
fi

# --- PNPM ---
if [[ "$IS_MAC" == true ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="$HOME/.local/share/pnpm"
fi
[[ -d "$PNPM_HOME" ]] && export PATH="$PNPM_HOME:$PATH"

# --- .NET ---
if [[ -d "/usr/local/share/dotnet" ]]; then
  export DOTNET_ROOT=/usr/local/share/dotnet
  export PATH="$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools"
fi
