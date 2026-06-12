#!/bin/bash

# Configuration
USER_HOME="$HOME"
DOTFILES_PATH="$USER_HOME/dotfiles"
ZSH_PATH="$USER_HOME/.zshrc"
LOG_FILE="$USER_HOME/setup.log"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Interactive confirmation helper
ask_yes_no() {
    local prompt="$1"
    local default="$2" # 'Y' or 'N'
    local response
    
    if [ "$default" = "Y" ]; then
        echo -n "$prompt [Y/n]: "
    else
        echo -n "$prompt [y/N]: "
    fi
    
    read -r response
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

# Read 1 character cross-shell
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
    local -a selected=()
    for ((i=0; i<num_options; i++)); do
        selected[$i]=true
    done
    
    local cursor=0
    local ESC=$(printf '\033')
    
    # Turn off cursor blinking for smooth rendering
    printf "${ESC}[?25l"
    
    echo -e "\n$title"
    echo -e "Use [\033[34m↑/↓\033[0m] para navegar, [\033[32mEspaço\033[0m] para selecionar/desmarcar, [\033[32mEnter\033[0m] para confirmar.\n"
    
    # Render the initial list
    for ((i=0; i<num_options; i++)); do
        print_option $((i+1)) "${menu_options[$i]}" "${selected[$i]}" "$([ $i -eq $cursor ] && echo 'true' || echo 'false')"
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
                [ $cursor -lt 0 ] && cursor=$((num_options - 1))
            elif [ "$key" = "[B" ]; then # Down Arrow
                ((cursor++))
                [ $cursor -ge $num_options ] && cursor=0
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
        for ((i=0; i<num_options; i++)); do
            printf "${ESC}[K" # Clear line to prevent rendering artifacts
            print_option $((i+1)) "${menu_options[$i]}" "${selected[$i]}" "$([ $i -eq $cursor ] && echo 'true' || echo 'false')"
        done
    done
    
    # Turn cursor blinking back on
    printf "${ESC}[?25h"
    echo ""
    
    # Export selected values
    SELECTED_ITEMS=()
    for ((i=0; i<num_options; i++)); do
        if [ "${selected[$i]}" = "true" ]; then
            SELECTED_ITEMS+=("${menu_options[$i]}")
        fi
    done
}

# Error handling
set -e
trap 'log "Error occurred at line $LINENO"' ERR

# Check if running on Linux
if [[ "$(uname)" != "Linux" ]]; then
    log "This script is meant for Linux only"
    exit 1
fi

# Detect package manager
PACKAGE_MANAGER=""
if command -v apt-get &>/dev/null; then
    PACKAGE_MANAGER="apt"
elif command -v dnf &>/dev/null; then
    PACKAGE_MANAGER="dnf"
elif command -v pacman &>/dev/null; then
    PACKAGE_MANAGER="pacman"
fi

# Core packages lists depending on package manager
APT_PACKAGES=(
    stow
    neovim
    tmux
    curl
    git
    fzf
    ripgrep
    bat
    eza
    fd-find
    zoxide
)

install_linux_packages() {
    if [ -z "$PACKAGE_MANAGER" ]; then
        log "[Aviso] Nenhum gerenciador de pacotes suportado (apt, dnf, pacman) encontrado. Instalação de pacotes pulada."
        return
    fi

    log "Detectado gerenciador de pacotes: $PACKAGE_MANAGER"

    if [ "$PACKAGE_MANAGER" = "apt" ]; then
        prompt_multi_select "Selecione quais pacotes do sistema você deseja instalar/sincronizar via APT:" "${APT_PACKAGES[@]}"
        local packages_to_install=("${SELECTED_ITEMS[@]}")
        
        if [ ${#packages_to_install[@]} -gt 0 ]; then
            log "Atualizando listas de pacotes (sudo apt-get update)..."
            sudo apt-get update
            
            # Ajuste específico para eza e bat no Debian/Ubuntu antigos se necessário
            # Caso contrário, tenta instalar em lote
            log "Instalando pacotes selecionados: ${packages_to_install[*]}..."
            sudo apt-get install -y "${packages_to_install[@]}" || log "Alguns pacotes falharam, mas prosseguindo..."
            
            # Cria atalho conveniente para fd se instalado como fd-find
            if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
                mkdir -p "$HOME/.local/bin"
                ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
            fi
            
            # Cria atalho conveniente para bat se instalado como batcat
            if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
                mkdir -p "$HOME/.local/bin"
                ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
            fi
        fi
    elif [ "$PACKAGE_MANAGER" = "dnf" ]; then
        # Tradução simples para dnf
        local dnf_packages=(stow neovim tmux curl git fzf ripgrep bat eza fd-find zoxide)
        prompt_multi_select "Selecione os pacotes para instalar via DNF:" "${dnf_packages[@]}"
        local packages_to_install=("${SELECTED_ITEMS[@]}")
        if [ ${#packages_to_install[@]} -gt 0 ]; then
            log "Instalando pacotes via DNF: ${packages_to_install[*]}..."
            sudo dnf install -y "${packages_to_install[@]}"
        fi
    elif [ "$PACKAGE_MANAGER" = "pacman" ]; then
        # Tradução simples para pacman
        local pac_packages=(stow neovim tmux curl git fzf ripgrep bat eza fd zoxide)
        prompt_multi_select "Selecione os pacotes para instalar via Pacman:" "${pac_packages[@]}"
        local packages_to_install=("${SELECTED_ITEMS[@]}")
        if [ ${#packages_to_install[@]} -gt 0 ]; then
            log "Instalando pacotes via Pacman: ${packages_to_install[*]}..."
            sudo pacman -Syu --noconfirm "${packages_to_install[@]}"
        fi
    fi
}

# ZSH plugins and themes
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
ZSH_PLUGINS=(
    "zsh-users/zsh-syntax-highlighting"
    "zsh-users/zsh-autosuggestions"
    "spaceship-prompt/spaceship-prompt"
    "larkery/zsh-histdb"
    "TamCore/autoupdate-oh-my-zsh-plugins"
)

install_zsh_plugins() {
    log "Instalando plugins ZSH em paralelo..."
    for plugin in "${ZSH_PLUGINS[@]}"; do
        local plugin_name=$(basename "$plugin")
        local clone_target="$ZSH_CUSTOM/plugins/$plugin_name"

        if [ "$plugin_name" = "spaceship-prompt" ]; then
            clone_target="$ZSH_CUSTOM/themes/$plugin_name"
        elif [ "$plugin_name" = "autoupdate-oh-my-zsh-plugins" ]; then
            clone_target="$ZSH_CUSTOM/plugins/autoupdate"
        fi

        if [ ! -d "$clone_target" ]; then
            (git clone "https://github.com/$plugin" "$clone_target" || log "Falhou ao clonar $plugin") &
        fi
    done

    # Aguarda todos os clones em background terminarem
    wait

    # Cria link simbólico para spaceship-prompt se instalado
    if [ -d "$ZSH_CUSTOM/themes/spaceship-prompt" ]; then
        ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
    fi
}

# Development tools
install_dev_tools() {
    # Oh My Zsh
    if [ ! -d "$USER_HOME/.oh-my-zsh" ]; then
        log "Instalando Oh My Zsh..."
        zsh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Rust
    if ! command -v rustc &>/dev/null; then
        log "Instalando Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        # shellcheck disable=SC1090
        source "$USER_HOME/.cargo/env"
    fi

    # Install Node.js via nvm
    if [ ! -d "$HOME/.nvm" ]; then
        log "Instalando NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        # shellcheck disable=SC1090
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        log "Instalando Node.js LTS..."
        nvm install --lts
        nvm use --lts
    fi
}

# Stow packages list
STOW_PACKAGES=(
    editor-core
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
    prompt_multi_select "Selecione quais pacotes você deseja configurar via Stow:" "${STOW_PACKAGES[@]}"
    
    if [ ${#SELECTED_ITEMS[@]} -eq 0 ]; then
        log "Nenhum pacote Stow foi selecionado para configuração."
        return
    fi

    # Dependência: se nvim ou vim forem selecionados, garante que editor-core também seja
    local has_editor=false
    local has_core=false
    for item in "${SELECTED_ITEMS[@]}"; do
        if [ "$item" = "nvim" ] || [ "$item" = "vim" ]; then
            has_editor=true
        fi
        if [ "$item" = "editor-core" ]; then
            has_core=true
        fi
    done

    if [ "$has_editor" = "true" ] && [ "$has_core" = "false" ]; then
        log "[Dependência] Vim/Neovim selecionados. Adicionando 'editor-core' automaticamente..."
        SELECTED_ITEMS+=("editor-core")
    fi
    
    log "Configurando dotfiles via Stow para os pacotes: ${SELECTED_ITEMS[*]}..."
    cd "$DOTFILES_PATH" || exit 1

    # Mapeamento dinâmico de arquivos e diretórios conflitantes
    declare -A package_files
    package_files[editor-core]="$HOME/.editor_shared.vim $HOME/.exrc"
    package_files[wezterm]="$HOME/.wezterm.lua"
    package_files[tmux]="$HOME/.tmux.conf"
    package_files[zshrc]="$HOME/.zshrc"
    package_files[vim]="$HOME/.vimrc $HOME/.ideavimrc"
    package_files[gemini]="$HOME/.gemini/settings.json"

    declare -A package_dirs
    package_dirs[nvim]="$HOME/.config/nvim"
    package_dirs[alacritty]="$HOME/.config/alacritty"
    package_dirs[gemini]="$HOME/.gemini/agents"

    # Remove arquivos conflitantes reais antes do stow
    for config in "${SELECTED_ITEMS[@]}"; do
        if [ -n "${package_files[$config]}" ]; then
            for target in ${package_files[$config]}; do
                if [ -e "$target" ] && [ ! -L "$target" ]; then
                    log "Removendo arquivo existente real $target do pacote $config..."
                    rm -rf "$target"
                fi
            done
        fi

        if [ -n "${package_dirs[$config]}" ]; then
            local target_dir="${package_dirs[$config]}"
            if [ -d "$target_dir" ] && [ ! -L "$target_dir" ]; then
                log "Removendo diretório existente real $target_dir do pacote $config..."
                rm -rf "$target_dir"
            fi
        fi
    done

    # Stow selected configs
    for config in "${SELECTED_ITEMS[@]}"; do
        log "Executando Stow em ${config}..."
        stow -v --restow "$config" || log "Falhou ao executar stow em $config"
    done

    cd "$USER_HOME" || exit 1
}

# Main installation flow
main() {
    log "Iniciando setup no Linux..."
    install_linux_packages
    install_dev_tools
    install_zsh_plugins
    
    echo -e "\n=== Deploy dos Dotfiles ==="
    if command -v stow &>/dev/null; then
        if ask_yes_no "Deseja executar o Stow para configurar seus dotfiles (vincular nvim, tmux, gemini, etc.)?" "Y"; then
            setup_dotfiles
        else
            log "Pulando a etapa de configuração de dotfiles via Stow."
        fi
    else
        log "[Aviso] 'stow' não está disponível. Pulando configuração via Stow."
    fi

    # Create secrets file if it doesn't exist
    if [ ! -f "$HOME/.secrets.zsh" ]; then
        touch "$HOME/.secrets.zsh"
    fi

    log "Setup do Linux concluído com sucesso!"

    cat << EOF
==============================================
Setup concluído! Por favor faça o seguinte:
1. Reinicie seu terminal
2. Rode 'source ~/.zshrc'
3. Adicione suas variáveis de ambiente sensíveis em ~/.secrets.zsh
==============================================
EOF
}

# Run the script
main
