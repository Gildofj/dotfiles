# ============================================================================
# Shell Enhancements Module
# ============================================================================

# --- Zoxide (better cd) ---
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# --- TheFuck (command correction) ---
if command -v thefuck &> /dev/null; then
  eval $(thefuck --alias)
fi

# --- zsh-histdb (history database) ---
if [[ -f "$HOME/.oh-my-zsh/custom/plugins/zsh-histdb/sqlite-history.zsh" ]]; then
  source "$HOME/.oh-my-zsh/custom/plugins/zsh-histdb/sqlite-history.zsh"
  autoload -Uz add-zsh-hook

  _zsh_autosuggest_strategy_histdb_top() {
    local query="
      select commands.argv from history
      left join commands on history.command_id = commands.rowid
      left join places on history.place_id = places.rowid
      where commands.argv LIKE '$(sql_escape $1)%'
      group by commands.argv, places.dir
      order by places.dir != '$(sql_escape $PWD)', count(*) desc
      limit 1
    "
    suggestion=$(_histdb_query "$query")
  }
fi

ZSH_AUTOSUGGEST_STRATEGY=history
