export PATH=$HOME/bin:/usr/local/bin:/sbin/:$HOME/.cargo/bin:$HOME/.local/share/:$HOME/.local/share/bob/nvim-bin:$PATH

#Nvm setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Dotnet setup
export DOTNET_ROOT=/usr/local/share/dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

#Rustup setup
export PATH="/usr/local/opt/rustup/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="spaceship"
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  fzf
  autoupdate
  tmux
)

SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  exec_time     # Execution time
  line_sep      # Line break
  #vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "

source $ZSH/oh-my-zsh.sh
eval "$(zoxide init zsh)"

# zsh-histdb config
source $HOME/.oh-my-zsh/custom/plugins/zsh-histdb/sqlite-history.zsh
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

ZSH_AUTOSUGGEST_STRATEGY=histdb_top

# FZF
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval $(fzf --zsh)
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

## Use fd (https://github.com/sharkdp/fd) for listing path candidates.
## - The first argument to the function ($1) is the base path to start transversal
## - See the source code (completion.{bash,zsh}) for details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

## Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd type=d --hidden --exclude .git . "$1"
}

# source ~/fzf-git.sh/fzf-git.sh

# Aliases
# alias upgrade="~/scripts/upgrade.sh" # Just in Linux environments
alias ls="exa --icons"
alias cat="bat"
alias c="clear"
## Github
alias ga="git add ."
alias gs="git status"
alias gc="git commit -m"
alias gp="git push"
alias gpoh="git push origin HEAD"

gh() {
  local msg="$*"
  if [ -z "$msg" ]; then
    echo "Por favor, forneça uma mensagem de commit."
  else
    ga && gc "$msg" && gpoh
  fi
}

# TheFuck
eval $(thefuck --alias)

# start new session of tmux
# if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
#   tmux list-sessions | grep -v attached | cut -d: -f1 | xargs -I {} tmux kill-session -t {} &
#   wait
#   tmux new-session
# fi

# Set autocompletions
fpath+=("/usr/local/share/zsh/site-functions")
autoload -Uz compinit
compinit
