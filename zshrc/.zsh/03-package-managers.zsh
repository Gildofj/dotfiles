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
    unset -f nvm node npm npx pnpm 2>/dev/null
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm "$@"
  }
  
  # Lazy load node/npm/npx/pnpm
  node() { unset -f nvm node npm npx pnpm 2>/dev/null; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; node "$@" }
  npm()  { unset -f nvm node npm npx pnpm 2>/dev/null; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; npm "$@" }
  npx()  { unset -f nvm node npm npx pnpm 2>/dev/null; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; npx "$@" }
  pnpm() { unset -f nvm node npm npx pnpm 2>/dev/null; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; pnpm "$@" }

  # Prepara o PATH com o diretório 'bin' da última versão instalada do Node no NVM.
  # Isso torna todos os pacotes globais (ex: gemini, eslint, tsc) imediatamente disponíveis
  # no startup do shell, sem precisar carregar o NVM (que leva >0.5s).
  local DEFAULT_NODE_DIR=( $NVM_DIR/versions/node/v*(-/N) )
  if (( ${#DEFAULT_NODE_DIR} )); then
    export PATH="${DEFAULT_NODE_DIR[-1]}/bin:$PATH"
  fi
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
