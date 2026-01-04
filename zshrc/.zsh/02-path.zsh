# ============================================================================
# PATH Configuration Module
# ============================================================================
# Configura todos os PATHs necessários de forma organizada

# Função helper para adicionar ao PATH apenas se o diretório existir
add_to_path() {
  if [[ -d "$1" ]]; then
    export PATH="$1:$PATH"
  fi
}

# Path base
export PATH="$HOME/bin:/usr/local/bin:/sbin:$PATH"

# User directories
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/.local/share"

# Development tools
add_to_path "$HOME/.cargo/bin"                          # Rust
add_to_path "$HOME/.local/share/bob/nvim-bin"           # Neovim
add_to_path "/usr/local/opt/rustup/bin"                 # Rustup

# Platform-specific paths
if [[ "$IS_MAC" == true ]]; then
  add_to_path "$HOME/Library/Android/sdk/cmdline-tools/latest/bin"  # Android SDK
fi
