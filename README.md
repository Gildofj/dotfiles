# 🛠️ Gildo FJ - Dotfiles

> Minhas configurações pessoais organizadas de forma modular, multiplataforma (macOS e Windows) e estruturadas para o uso com o **GNU Stow** (ou alternativas equivalentes).

Este repositório contém arquivos de configuração (`dotfiles`) para terminais, editores, multiplexadores e gerenciadores de janela, garantindo que o meu ambiente de desenvolvimento permaneça consistente e altamente produtivo em qualquer sistema operacional.

---

## 📋 Índice

- [Estrutura do Repositório](#-estrutura-do-repositório)
- [Como Implantar (Stow-like)](#-como-implantar-stow-like)
  - [No Windows](#no-windows)
  - [No macOS](#no-macos)
- [Descrição das Configurações](#-descrição-das-configurações)

---

## 📁 Estrutura do Repositório

O repositório segue a estrutura padrão exigida pelo [stow](https://www.gnu.org/software/stow/), onde cada subdiretório raiz representa um pacote contendo a estrutura de pastas exata a ser espelhada no diretório home (`$HOME` ou `~`).

```
dotfiles/
├── alacritty/       # Configuração do terminal Alacritty (multiplataforma)
├── glazewm/         # Gerenciador de janelas GlazeWM e barra Zebar (Windows)
├── nvim/            # Configuração modular de NeoVim em Lua (multiplataforma)
├── powershell/      # Perfil do PowerShell modular v5/v7 (Windows)
├── tmux/            # Multiplexador de terminal tmux com plugins e temas
├── wezterm/         # Configuração do terminal WezTerm (multiplataforma)
├── zshrc/           # Shell ZSH modular otimizado com lazy loading (macOS/Linux)
├── macosx-setup.sh  # Script de instalação e setup automatizado para macOS
└── windows-stow.ps1 # Script de gerenciamento de links simbólicos para Windows
```

---

## 🚀 Como Implantar (Stow-like)

### No Windows
Para implantar e criar links simbólicos (symlinks/hardlinks) das configurações no seu diretório de usuário (`C:\Users\<Usuario>\`):

1. Abra o terminal **PowerShell como Administrador**.
2. Execute o script [windows-stow.ps1](./windows-stow.ps1):
   ```powershell
   # Executa o stow para todas as configurações
   powershell -ExecutionPolicy Bypass -File .\windows-stow.ps1
   
   # Ou apenas para pacotes específicos (ex: powershell e nvim)
   powershell -ExecutionPolicy Bypass -File .\windows-stow.ps1 -Package powershell,nvim
   ```

### No macOS
Para configurar o seu ambiente macOS de forma automatizada (instalando ferramentas do Homebrew e linkando arquivos):

> 💡 **Nota Importante:** O setup do Neovim (ramificação `main` do `nvim-treesitter` para Neovim 0.12+) requer o pacote `tree-sitter-cli` para compilar os parsers localmente. O script `macosx-setup.sh` já inclui esse pacote e o instala de forma totalmente automatizada.

1. Dê permissão de execução ao script:
   ```bash
   chmod +x macosx-setup.sh
   ```
2. Execute o setup:
   ```bash
   ./macosx-setup.sh
   ```

---

## 📖 Descrição das Configurações

Clique nos links abaixo para obter detalhes de configuração, atalhos de teclado e recursos específicos de cada módulo:

| Pacote | Destino no Sistema | Descrição Detalhada |
| :--- | :--- | :--- |
| [alacritty](./alacritty/README.md) | `~/.config/alacritty/` | Terminal leve e veloz renderizado por GPU com tema Catppuccin Mocha. |
| [glazewm](./glazewm/README.md) | `~/.glzr/` | Gerenciador de janelas lado a lado (tiling) e barra de status (Zebar) para Windows. |
| [nvim](./nvim/README.md) | `~/.config/nvim/` e `envman` | IDE Neovim completa escrita em Lua com LSP, autocompletion e múltiplos temas. |
| [powershell](./powershell/README.md) | `~/.config/powershell/` | PowerShell moderno v5/v7 com FZF, oh-my-posh (offline), e autosugestões. |
| [tmux](./tmux/README.md) | `~/.tmux.conf` | Multiplexador de terminal com atalhos baseados no Vim e tema Catppuccin. |
| [wezterm](./wezterm/README.md) | `~/.wezterm.lua` | Terminal altamente extensível via Lua, configurado com tema Catppuccin. |
| [zshrc](./zshrc/README.md) | `~/.zsh/` e `~/.zshrc` | Shell ZSH modular com tempo de inicialização ultrarrápido (lazy loading). |

---

## 📄 Licença

Este projeto é de domínio público. Sinta-se livre para clonar, modificar e compartilhar como preferir!
