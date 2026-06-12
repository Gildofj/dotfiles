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

# Interactive confirmation helper (zsh-friendly)
ask_yes_no() {
    local prompt="$1"
    local default="$2" # 'Y' or 'N'
    local response
    
    if [ "$default" = "Y" ]; then
        echo -n "$prompt [Y/n]: "
    else
        echo -n "$prompt [y/N]: "
    fi
    
    read response
    response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
    
    if [ -z "$response" ]; then
        [ "$default" = "Y" ] && return 0
        [ "$default" = "N" ] && return 1
    fi
    
    if [[ "$response" =~ ^(y|yes)$ ]]; then
        return 0
    fi
    return 1
}

# Read 1 character cross-shell (Bash and Zsh compatible)
read_char() {
    if [ -n "$ZSH_VERSION" ]; then
        read -r -s -k 1 "$1"
    else
        read -r -s -n 1 "$1"
    fi
}

# Prints one option in the multi-select visual menu
print_option() {
    local index=$1
    local name=$2
    local is_selected=$3
    local is_highlighted=$4
    
    # Mark checkbox
    local checkbox="[ ]"
    [ "$is_selected" = "true" ] && checkbox="[\033[32m✔\033[0m]"
    
    if [ "$is_highlighted" = "true" ]; then
        printf " \033[34m➔\033[0m %b %b\n" "$checkbox" "\033[1;34m$name\033[0m"
    else
        printf "   %b %s\n" "$checkbox" "$name"
    fi
}

# Multi-select visual menu using arrows, space to toggle and enter to confirm
prompt_multi_select() {
    local title="$1"
    shift
    local -a menu_options=("$@")
    local num_options=${#menu_options[@]}
    
    # Initialize selections to true (all selected by default)
    # Zsh arrays are 1-based, so we loop from 1 to num_options
    local -a selected=()
    for ((i=1; i<=num_options; i++)); do
        selected[$i]=true
    done
    
    local cursor=1
    local ESC=$(printf '\033')
    
    # Turn off cursor blinking for smooth rendering
    printf "${ESC}[?25l"
    
    echo -e "\n$title"
    echo -e "Use [\033[34m↑/↓\033[0m] para navegar, [\033[32mEspaço\033[0m] para selecionar/desmarcar, [\033[32mEnter\033[0m] para confirmar.\n"
    
    # Render the initial list
    for ((i=1; i<=num_options; i++)); do
        print_option $i "${menu_options[$i]}" "${selected[$i]}" "$([ $i -eq $cursor ] && echo 'true' || echo 'false')"
    done
    
    while true; do
        # Read a keypress
        local key
        read_char key
        
        # Handle escape sequence for arrows
        if [ "$key" = "$ESC" ]; then
            local next_keys next_keys_2
            read_char next_keys
            read_char next_keys_2
            key="${next_keys}${next_keys_2}"
            if [ "$key" = "[A" ]; then # Up Arrow
                ((cursor--))
                [ $cursor -lt 1 ] && cursor=$num_options
            elif [ "$key" = "[B" ]; then # Down Arrow
                ((cursor++))
                [ $cursor -gt $num_options ] && cursor=1
            fi
        elif [ "$key" = "" ] || [ "$key" = $'\r' ] || [ "$key" = $'\n' ]; then # Enter key
            break
        elif [ "$key" = " " ]; then # Spacebar
            if [ "${selected[$cursor]}" = "true" ]; then
                selected[$cursor]=false
            else
                selected[$cursor]=true
            fi
        fi
        
        # Move cursor up by num_options lines to redraw in place
        printf "${ESC}[${num_options}A"
        
        # Redraw option list
        for ((i=1; i<=num_options; i++)); do
            printf "${ESC}[K" # Clear line to prevent rendering artifacts
            print_option $i "${menu_options[$i]}" "${selected[$i]}" "$([ $i -eq $cursor ] && echo 'true' || echo 'false')"
        done
    done
    
    # Turn cursor blinking back on
    printf "${ESC}[?25h"
    echo ""
    
    # Export selected values as a global array in Zsh
    typeset -g -a SELECTED_ITEMS
    SELECTED_ITEMS=()
    for ((i=1; i<=num_options; i++)); do
        if [ "${selected[$i]}" = "true" ]; then
            SELECTED_ITEMS+=("${menu_options[$i]}")
        fi
    done
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

# Global dependency flags
HAS_BREW=true
HAS_STOW=true
HAS_NVM=true

# Package managers
install_homebrew() {
    if ! command -v brew &>/dev/null; then
        if ask_yes_no "Homebrew não foi encontrado. Deseja instalar o Homebrew? (Requerido para instalar as dependências de sistema)" "Y"; then
            log "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            # Add Homebrew to PATH
            eval "$(/opt/homebrew/bin/brew shellenv)"
            HAS_BREW=true
        else
            log "[Aviso] Instalação do Homebrew recusada pelo usuário. Os pacotes dependentes não poderão ser instalados automaticamente."
            HAS_BREW=false
            HAS_STOW=false
            HAS_NVM=false
        fi
    else
        HAS_BREW=true
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
    if [ "$HAS_BREW" = "false" ]; then
        log "[Aviso] Homebrew não está disponível. Pulando instalação em lote de pacotes."
        HAS_STOW=false
        HAS_NVM=false
        return
    fi

    # Prompt user for Homebrew package selections using spacebar/arrows
    prompt_multi_select "Selecione quais pacotes do Homebrew você deseja instalar/sincronizar:" "${BREW_PACKAGES[@]}"
    local packages_to_install=("${SELECTED_ITEMS[@]}")
    
    # Check if stow was selected or already installed
    if [[ ! " ${packages_to_install[*]} " =~ " stow " ]] && ! command -v stow &>/dev/null; then
        log "[Aviso] 'stow' não foi selecionado e não está instalado. As ferramentas que necessitam do Stow (como deploy de dotfiles) serão ignoradas."
        HAS_STOW=false
    else
        HAS_STOW=true
    fi

    # Check if nvm was selected or already installed
    if [[ ! " ${packages_to_install[*]} " =~ " nvm " ]] && [ ! -d "$HOME/.nvm" ]; then
        log "[Aviso] 'nvm' não foi selecionado e não está instalado. A instalação do Node.js via NVM será ignorada."
        HAS_NVM=false
    else
        HAS_NVM=true
    fi

    if [ ${#packages_to_install[@]} -gt 0 ]; then
        log "Installing Homebrew packages in batch: ${packages_to_install[*]}..."
        # Batch installation drastically improves performance compared to loop installs
        brew install "${packages_to_install[@]}" || log "Some Homebrew packages failed to install, but proceeding..."
    else
        log "No Homebrew packages selected for installation."
    fi
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
    if [ "$HAS_NVM" = "true" ] && [ ! -d "$HOME/.nvm" ]; then
        log "Installing nvm and Node.js..."
        mkdir -p "$HOME/.nvm"
        export NVM_DIR="$HOME/.nvm"
        
        # Check if brew has nvm prefix to source safely
        if command -v brew &>/dev/null && brew --prefix nvm &>/dev/null; then
            source $(brew --prefix nvm)/nvm.sh
            nvm install --lts
            nvm use --lts
        else
            log "[Aviso] Não foi possível carregar o nvm via brew prefix. Instalação do Node.js pulada."
        fi
    elif [ "$HAS_NVM" = "false" ]; then
        log "[Aviso] NVM não está disponível ou foi recusado. Pulando instalação do Node.js via NVM."
    fi
}

# Stow packages list matching the workspace structure
STOW_PACKAGES=(
    alacritty
    gemini
    nvim
    tmux
    vim
    wezterm
    zshrc
)

# Dotfiles setup
setup_dotfiles() {
    # Prompt user for package selections using spacebar/arrows
    prompt_multi_select "Selecione quais pacotes você deseja configurar via Stow:" "${STOW_PACKAGES[@]}"
    
    if [ ${#SELECTED_ITEMS[@]} -eq 0 ]; then
        log "Nenhum pacote Stow foi selecionado para configuração."
        return
    fi
    
    log "Setting up dotfiles for selected packages: ${SELECTED_ITEMS[*]}..."
    cd "$DOTFILES_PATH" || exit 1

    # Mapeamento dinâmico de arquivos e diretórios conflitantes por pacote
    typeset -A package_files
    package_files[wezterm]="$HOME/.wezterm.lua"
    package_files[tmux]="$HOME/.tmux.conf"
    package_files[zshrc]="$HOME/.zshrc"
    package_files[vim]="$HOME/.vimrc $HOME/.ideavimrc"
    package_files[gemini]="$HOME/.gemini/settings.json"

    typeset -A package_dirs
    package_dirs[nvim]="$HOME/.config/nvim"
    package_dirs[alacritty]="$HOME/.config/alacritty"
    package_dirs[gemini]="$HOME/.gemini/agents"

    # Remove existing real configs/symlinks of SELECTED packages only before stowing
    for config in "${SELECTED_ITEMS[@]}"; do
        # Clean conflicting files
        if [ -n "${package_files[$config]}" ]; then
            for target in ${package_files[$config]}; do
                if [ -e "$target" ] && [ ! -L "$target" ]; then
                    log "Removing existing real file $target for package $config..."
                    rm -rf "$target"
                fi
            done
        fi

        # Clean conflicting directories
        if [ -n "${package_dirs[$config]}" ]; then
            local target_dir="${package_dirs[$config]}"
            if [ -d "$target_dir" ] && [ ! -L "$target_dir" ]; then
                log "Removing existing real directory $target_dir for package $config..."
                rm -rf "$target_dir"
            fi
        fi
    done

    # Stow selected configs
    for config in "${SELECTED_ITEMS[@]}"; do
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
    
    echo -e "\n=== Deploy dos Dotfiles ==="
    if [ "$HAS_STOW" = "true" ] || command -v stow &>/dev/null; then
        if ask_yes_no "Deseja executar o Stow para configurar seus dotfiles (vincular nvim, tmux, gemini, etc.)?" "Y"; then
            setup_dotfiles
        else
            log "Pulando a etapa de configuração de dotfiles via Stow."
        fi
    else
        log "[Aviso] 'stow' não está disponível ou foi recusado. A etapa de configuração dos dotfiles via Stow foi ignorada."
    fi

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
