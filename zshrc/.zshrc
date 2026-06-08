# Diretório de configurações
ZSH_CONFIG_DIR="${HOME}/.zsh"

# Carregar módulos em ordem
if [[ -d "$ZSH_CONFIG_DIR" ]]; then
  # Ordenar por nome para garantir a ordem correta
  for config_file in "$ZSH_CONFIG_DIR"/*.zsh(N); do
    if [[ -f "$config_file" ]]; then
      source "$config_file"
    fi
  done
else
  echo "⚠️  Diretório $ZSH_CONFIG_DIR não encontrado!"
  echo "Crie os módulos de configuração em ~/.zsh/"
fi

# ============================================================================
# CONFIGURAÇÕES PRIVADAS
# ============================================================================
# Carregue suas variáveis de ambiente privadas aqui (tokens, keys, etc.)
[[ -f "$HOME/.secrets.zsh" ]] && source "$HOME/.secrets.zsh"

# ============================================================================
# CONFIGURAÇÕES ESPECÍFICAS DA MÁQUINA
# ============================================================================
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
