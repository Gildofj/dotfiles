# ============================================================================
# OS Detection Module
# ============================================================================
# Detecta o sistema operacional e exporta variáveis úteis

if [[ "$OSTYPE" == "darwin"* ]]; then
  export IS_MAC=true
  export IS_LINUX=false
  export OS_NAME="macOS"
  
  # Detectar arquitetura do Mac
  if [[ $(uname -m) == "arm64" ]]; then
    export IS_APPLE_SILICON=true
    export HOMEBREW_PREFIX="/opt/homebrew"
  else
    export IS_APPLE_SILICON=false
    export HOMEBREW_PREFIX="/usr/local"
  fi
  
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export IS_MAC=false
  export IS_LINUX=true
  export OS_NAME="Linux"
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  
  # Detectar distribuição Linux
  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    export LINUX_DISTRO=$ID
  fi
fi

# Função helper para executar código específico por OS
run_on_mac() {
  [[ "$IS_MAC" == true ]] && eval "$@"
}

run_on_linux() {
  [[ "$IS_LINUX" == true ]] && eval "$@"
}
