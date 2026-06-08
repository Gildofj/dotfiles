# ============================================================================
# Shell Enhancements Module
# ============================================================================

# --- Zoxide (better cd) ---
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# --- TheFuck (command correction) - LAZY LOAD ---
if command -v thefuck &> /dev/null; then
  fuck() {
    eval $(thefuck --alias)
    fuck "$@"
  }
fi

# --- zsh-histdb ---
HISTDB_FILE="${HOME}/.oh-my-zsh/custom/plugins/zsh-histdb/sqlite-history.zsh"
if [[ -f "$HISTDB_FILE" ]]; then
  source "$HISTDB_FILE"
  
  # Estratégia de autosuggestion usando o HistDB (comandos mais frequentes por diretório)
  if [[ -n "$functions[_zsh_autosuggest_start]" ]]; then
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
    ZSH_AUTOSUGGEST_STRATEGY=(histdb_top history completion)
  fi
fi
