# ============================================================================
# Alacritty Theme Sync Module
# ============================================================================
# Sincroniza o tema do Alacritty com o esquema de cores atual do macOS

if [[ "$IS_MAC" == true ]] && [[ -f "$HOME/.config/alacritty/alacritty-sync-theme.sh" ]]; then
  # Executa o script de sincronização em background para não impactar o tempo de startup do shell
  bash "$HOME/.config/alacritty/alacritty-sync-theme.sh" &>/dev/null &
fi
