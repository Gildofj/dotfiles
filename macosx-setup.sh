#!/bin/zsh

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
    ripgrep  # Moving from cargo to brew for better management
    bat      # Moving from cargo to brew
    exa      # Moving from cargo to brew
    fd       # Moving from cargo to brew
    git-delta # Moving from cargo to brew
)

# Install packages
install_packages() {
    log "Installing Homebrew packages..."
    for package in "${BREW_PACKAGES[@]}"; do
        brew install "$package" || log "Failed to install $package"
    done
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
    log "Installing ZSH plugins..."
    for plugin in "${ZSH_PLUGINS[@]}"; do
        local plugin_name=$(basename "$plugin")
        local plugin_path="$ZSH_CUSTOM/plugins/$plugin_name"

        if [ ! -d "$plugin_path" ]; then
            if [ "$plugin_name" = "spaceship-prompt" ]; then
                git clone "https://github.com/$plugin" "$ZSH_CUSTOM/themes/$plugin_name" || log "Failed to clone $plugin"
                ln -sf "$ZSH_CUSTOM/themes/$plugin_name/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
            elif [ "$plugin_name" = "autoupdate-oh-my-zsh-plugins" ]; then
                git clone "https://github.com/$plugin" "$ZSH_CUSTOM/plugins/autoupdate" || log "Failed to clone $plugin"
            else
                git clone "https://github.com/$plugin" "$plugin_path" || log "Failed to clone $plugin"
            fi
        fi
    done
}

# Additional tools
install_additional_tools() {
    log "Installing additional tools..."

    # Install zoxide
    if ! command -v zoxide &>/dev/null; then
        brew install zoxide
    fi

    # Install fd-find
    if ! command -v fd &>/dev/null; then
        brew install fd
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
        brew install nvm
        export NVM_DIR="$HOME/.nvm"
        source $(brew --prefix nvm)/nvm.sh
        nvm install --lts
        nvm use --lts
    fi
}

# Dotfiles setup
setup_dotfiles() {
    log "Setting up dotfiles..."
    cd "$DOTFILES_PATH" || exit 1

    # Remove existing configs before stowing
    for config in nvim tmux zshrc; do
        if [ -e "$HOME/.${config}" ] || [ -e "$HOME/.${config}rc" ]; then
            log "Removing existing ${config} configuration..."
            rm -f "$HOME/.${config}" "$HOME/.${config}rc"
        fi
    done

    # Stow new configs
    for config in nvim tmux zshrc; do
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
    install_additional_tools
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