#!/bin/bash

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verifica se está no macOS
if [[ "$(uname)" != "Darwin" ]]; then
    log_error "Este script de sincronização de tema automático é destinado apenas ao macOS."
    exit 1
fi

USER_HOME="$HOME"
ALACRITTY_CONFIG_DIR="$USER_HOME/.config/alacritty"
SYNC_SCRIPT_PATH="$ALACRITTY_CONFIG_DIR/alacritty-sync-theme.sh"
PLIST_PATH="$USER_HOME/Library/LaunchAgents/com.user.alacritty-sync-theme.plist"

log_info "Iniciando a configuração do tema dinâmico para o Alacritty..."

# 1. Garante que o script de sincronização tem permissão de execução
if [ -f "$SYNC_SCRIPT_PATH" ]; then
    chmod +x "$SYNC_SCRIPT_PATH"
    log_success "Permissão de execução concedida ao script de sincronização."
else
    # Se ainda não foi stowed, damos permissão no diretório local dos dotfiles
    DIR_SCRIPT="$(dirname "$0")/.config/alacritty/alacritty-sync-theme.sh"
    if [ -f "$DIR_SCRIPT" ]; then
        chmod +x "$DIR_SCRIPT"
        log_success "Permissão de execução concedida ao script local dos dotfiles."
    else
        log_warn "Script alacritty-sync-theme.sh não encontrado em $SYNC_SCRIPT_PATH. Certifique-se de executar o Stow primeiro."
    fi
fi

# 2. Cria o diretório de LaunchAgents se não existir
mkdir -p "$USER_HOME/Library/LaunchAgents"

# 3. Cria o arquivo PLIST dinamicamente com o nome correto do usuário
log_info "Criando o LaunchAgent plist em $PLIST_PATH..."

cat <<EOF > "$PLIST_PATH"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.alacritty-sync-theme</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$USER_HOME/.config/alacritty/alacritty-sync-theme.sh</string>
    </array>
    <key>WatchPaths</key>
    <array>
        <string>$USER_HOME/Library/Preferences/.GlobalPreferences.plist</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

log_success "LaunchAgent plist criado com sucesso."

# 4. Carrega e ativa o LaunchAgent
log_info "Carregando o LaunchAgent no launchctl..."

# Descarrega se já estiver carregado para evitar erros de duplicidade
launchctl unload "$PLIST_PATH" 2>/dev/null || true

# Carrega o agente
if launchctl load "$PLIST_PATH"; then
    log_success "LaunchAgent carregado e ativo com sucesso!"
else
    log_error "Falha ao carregar o LaunchAgent usando launchctl."
fi

# 5. Executa a sincronização pela primeira vez para definir o tema atual
log_info "Executando a sincronização inicial de tema..."
if [ -f "$SYNC_SCRIPT_PATH" ]; then
    bash "$SYNC_SCRIPT_PATH"
    log_success "Tema inicial sincronizado com sucesso!"
elif [ -f "$(dirname "$0")/.config/alacritty/alacritty-sync-theme.sh" ]; then
    bash "$(dirname "$0")/.config/alacritty/alacritty-sync-theme.sh"
    log_success "Tema inicial sincronizado com sucesso usando o script local!"
else
    log_warn "Não foi possível rodar a sincronização inicial porque o script de sincronização não foi encontrado."
fi

echo -e "\n${GREEN}=== Configuração Concluída! ===${NC}"
echo -e "O Alacritty agora mudará de tema automaticamente de acordo com o macOS."
echo -e "Esquemas suportados: Catppuccin Mocha (Dark) / Catppuccin Latte (Light)"
