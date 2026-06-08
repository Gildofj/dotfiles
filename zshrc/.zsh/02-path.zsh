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
export PATH="$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# Custom tools & scripts
add_to_path "$HOME/dotfiles/zshrc/bin"
add_to_path "$HOME/.antigravity/antigravity/bin"
add_to_path "$HOME/.local/bin"

# Development environments
add_to_path "$HOME/.cargo/bin"                          # Rust
add_to_path "$HOME/.local/share/bob/nvim-bin"           # Neovim
add_to_path "$HOME/.jbang/bin"                         # JBang

# Platform-specific paths
if [[ "$IS_MAC" == true ]]; then
  add_to_path "$HOME/Library/Android/sdk/cmdline-tools/latest/bin"
  
  # Android NDK
  export ANDROID_NDK_ROOT="/Users/gildojunior/Library/Android/sdk/ndk/29.0.14206865"
  if [[ -d "$ANDROID_NDK_ROOT" ]]; then
    export TOOLCHAIN="$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/darwin-x86_64"
    add_to_path "$TOOLCHAIN/bin"
    
    export CC="$TOOLCHAIN/bin/aarch64-linux-android29-clang"
    export CXX="$TOOLCHAIN/bin/aarch64-linux-android29-clang++"
  fi

  # Java
  if [[ -x "/usr/libexec/java_home" ]]; then
    export JAVA_HOME=$(/usr/libexec/java_home -v 21 2>/dev/null)
  fi
fi
