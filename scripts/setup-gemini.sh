#!/usr/bin/env bash
# ==============================================================================
# Setup Gemini/Antigravity CLI - Stow & Cross-Platform Deploy Script (Unix)
# ==============================================================================
set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # Sem Cor

echo -e "${BLUE}=== Iniciando Configuração do Gemini/Antigravity CLI (Unix) ===${NC}"

# 1. Detectar os CLIs disponíveis (pode possuir ambos instalados)
AVAILABLE_CLIS=()
if command -v gemini &> /dev/null; then
    AVAILABLE_CLIS+=("gemini")
fi
if command -v agy &> /dev/null; then
    AVAILABLE_CLIS+=("agy")
fi

if [ ${#AVAILABLE_CLIS[@]} -eq 0 ]; then
    echo -e "${RED}[Erro] Nem 'gemini' CLI corporativo nem 'agy' (Antigravity CLI) foram detectados no PATH.${NC}"
    echo "Instale pelo menos um deles antes de rodar este script de setup."
    exit 1
fi

echo -e "CLIs Ativos Detectados: ${GREEN}${AVAILABLE_CLIS[*]}${NC}"

# Pegando o caminho absoluto do diretório do dotfiles
DOTFILES_DIR="$HOME/dotfiles"

if [ ! -d "$DOTFILES_DIR/gemini" ]; then
    echo -e "${RED}[Erro] Pasta $DOTFILES_DIR/gemini não foi encontrada.${NC}"
    exit 1
fi

# 2. Configurar Links Simbólicos
echo -e "\n${BLUE}[1/2] Configurando Links Simbólicos dos Subagentes e Configurações...${NC}"

if command -v stow &> /dev/null; then
    echo -e "GNU Stow detectado! Vinculando pacote ${GREEN}gemini${NC} e adotando arquivos existentes..."
    # Roda o stow a partir do diretório dotfiles para o $HOME, adotando conflitos físicos
    cd "$DOTFILES_DIR"
    stow -R --adopt -t "$HOME" gemini
    echo -e "${GREEN}✔ Links simbólicos criados com sucesso via GNU Stow!${NC}"
else
    echo -e "${YELLOW}[Aviso] GNU Stow não está instalado. Usando fallback clássico de ln -s...${NC}"
    mkdir -p "$HOME/.gemini/agents"
    
    # settings.json
    if [ -f "$DOTFILES_DIR/gemini/.gemini/settings.json" ]; then
        ln -sf "$DOTFILES_DIR/gemini/.gemini/settings.json" "$HOME/.gemini/settings.json"
    fi
    
    # agents
    for agent in "$DOTFILES_DIR/gemini/.gemini/agents"/*.md; do
        [ -e "$agent" ] || continue
        ln -sf "$agent" "$HOME/.gemini/agents/$(basename "$agent")"
    done
    echo -e "${GREEN}✔ Links simbólicos criados com sucesso!${NC}"
fi

# 3. Instalar Extensões de ~/Projects/ para cada CLI ativo
echo -e "\n${BLUE}[2/2] Instalando extensões locais do ~/Projects/ de forma offline...${NC}"

EXTENSIONS=("gemini-ext-backend-scalable" "gemini-ext-mobile-clean" "gemini-ext-modern-web-guidance" "gemini-ext-web-fsd")

for ext in "${EXTENSIONS[@]}"; do
    EXT_PATH="$HOME/Projects/$ext"
    if [ -d "$EXT_PATH" ]; then
        for cli in "${AVAILABLE_CLIS[@]}"; do
            echo -e "Instalando extensão via ${cli} de: ${YELLOW}$EXT_PATH${NC}..."
            # Instala localmente usando cada CLI ativo (gemini ou agy)
            $cli extensions install "$EXT_PATH" --skip-settings --consent
            echo -e "Extensão ${GREEN}${ext}${NC} instalada no ${cli}!"
        done
    else
        echo -e "${RED}[Aviso] Repositório da extensão não encontrado em: $EXT_PATH${NC}"
    fi
done

echo -e "\n${GREEN}✔ Configuração concluída com sucesso!${NC}"
