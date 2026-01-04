# ============================================================================
# Package Managers Module
# ============================================================================

# --- Homebrew ---
setup_homebrew() {
  local brew_path="${HOMEBREW_PREFIX}/bin/brew"
  
  if [[ -f "$brew_path" ]]; then
    eval "$($brew_path shellenv)"
    return 0
  fi
  return 1
}
setup_homebrew

# --- NVM (Node Version Manager) ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --- PNPM ---
if [[ "$IS_MAC" == true ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="$HOME/.local/share/pnpm"
fi

case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# --- .NET ---
if [[ -d "/usr/local/share/dotnet" ]]; then
  export DOTNET_ROOT=/usr/local/share/dotnet
  export PATH="$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools"
fi
