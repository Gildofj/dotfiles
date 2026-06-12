#!/bin/zsh

# Adopted: boy-scout (Specialist in code modernization and setup scripts)

# Configuration
USER_HOME="$HOME"
DOTFILES_PATH="$USER_HOME/dotfiles"
ZSH_PATH="$USER_HOME/.zshrc"
LOG_FILE="$USER_HOME/setup.log"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Error handling
set -e
trap 'log "Error occurred at line $LINENO"' ERR

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    log "This script is meant for macOS only"
    exit 1
fi

# Xcode Command Line Tools
log "Checking Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
    log "Installing Xcode Command Line Tools..."
    xcode-select --install
    # Wait for installation to complete
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
fi

# Package managers
install_homebrew() {
    if ! command -v brew &>/dev/null; then
        log "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Add Homebrew to PATH
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

# Core packages
BREW_PACKAGES=(
    stow
    nvim
    tmux
    nvm
    fzf
    thefuck
    ripgrep   # Moving from cargo to brew for better management
    bat       # Moving from cargo to brew
    eza       # Replacing exa with modern/active fork eza
    fd        # Moving from cargo to brew
    git-delta # Moving from cargo to brew
    zoxide    # Moved from additional tools for unified management
)

# Install packages
install_packages() {
    log "Installing Homebrew packages in batch..."
    # Batch installation drastically improves performance compared to loop installs
    brew install "${BREW_PACKAGES[@]}" || log "Some Homebrew packages failed to install, but proceeding..."
}

# ZSH plugins and themes
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
ZSH_PLUGINS=(
    "zsh-users/zsh-syntax-highlighting"
    "zsh-users/zsh-autosuggestions"
    "spaceship-prompt/spaceship-prompt"
    "larkery/zsh-histdb"
    "TamCore/autoupdate-oh-my-zsh-plugins"  # Added autoupdate plugin
)

install_zsh_plugins() {
    log "Installing ZSH plugins in parallel..."
    for plugin in "${ZSH_PLUGINS[@]}"; do
        local plugin_name=$(basename "$plugin")
        local clone_target="$ZSH_CUSTOM/plugins/$plugin_name"

        if [ "$plugin_name" = "spaceship-prompt" ]; then
            clone_target="$ZSH_CUSTOM/themes/$plugin_name"
        elif [ "$plugin_name" = "autoupdate-oh-my-zsh-plugins" ]; then
            clone_target="$ZSH_CUSTOM/plugins/autoupdate"
        fi

        if [ ! -d "$clone_target" ]; then
            (git clone "https://github.com/$plugin" "$clone_target" || log "Failed to clone $plugin") &
        fi
    done

    # Wait for all background clones to complete in parallel
    wait

    # Create symlink for spaceship-prompt if it was installed
    if [ -d "$ZSH_CUSTOM/themes/spaceship-prompt" ]; then
        ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
    fi
}

# Development tools
install_dev_tools() {
    # Oh My Zsh
    if [ ! -d "$USER_HOME/.oh-my-zsh" ]; then
        log "Installing Oh My Zsh..."
        zsh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Rust
    if ! command -v rustc &>/dev/null; then
        log "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$USER_HOME/.cargo/env"
    fi

    # Install Node.js via nvm
    if [ ! -d "$HOME/.nvm" ]; then
        log "Installing nvm and Node.js..."
        mkdir -p "$HOME/.nvm"
        export NVM_DIR="$HOME/.nvm"
        source $(brew --prefix nvm)/nvm.sh
        nvm install --lts
        nvm use --lts
    fi
}

# Stow packages list matching the workspace structure
STOW_PACKAGES=(
    alacritty
    nvim
    tmux
    vim
    wezterm
    zshrc
)

# Dotfiles setup
setup_dotfiles() {
    log "Setting up dotfiles..."
    cd "$DOTFILES_PATH" || exit 1

    # Remove existing real configs/symlinks before stowing to prevent conflicts
    local targets=(
        "$HOME/.wezterm.lua"
        "$HOME/.tmux.conf"
        "$HOME/.zshrc"
        "$HOME/.vimrc"
        "$HOME/.ideavimrc"
    )
    for target in "${targets[@]}"; do
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            log "Removing existing real file $target..."
            rm -rf "$target"
        fi
    done

    local target_dirs=(
        "$HOME/.config/nvim"
        "$HOME/.config/envman"
        "$HOME/.config/alacritty"
        "$HOME/.zsh"
    )
    for target_dir in "${target_dirs[@]}"; do
        if [ -d "$target_dir" ] && [ ! -L "$target_dir" ]; then
            log "Removing existing real directory $target_dir..."
            rm -rf "$target_dir"
        fi
    done

    # Stow new configs
    for config in "${STOW_PACKAGES[@]}"; do
        log "Stowing ${config}..."
        stow -v --restow "$config" || log "Failed to stow $config"
    done

    cd "$USER_HOME" || exit 1
}

# Main installation flow
main() {
    log "Starting setup..."
    install_homebrew
    install_packages
    install_dev_tools
    install_zsh_plugins
    setup_dotfiles

    # Create secrets file if it doesn't exist
    if [ ! -f "$HOME/.secrets.zsh" ]; then
        touch "$HOME/.secrets.zsh"
    fi

    log "Setup completed successfully!"

    # Print final instructions
    cat << EOF
==============================================
Setup completed! Please do the following:
1. Restart your terminal
2. Run 'source ~/.zshrc'
3. Run 'brew cleanup'
4. Add any sensitive environment variables to ~/.secrets.zsh
==============================================
EOF
}

# Run the script
main
