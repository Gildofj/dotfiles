# 📝 Configuração Modular do Neovim (Lua)

> Uma configuração profissional, modular e extremamente otimizada para o **Neovim** escrita 100% em Lua, focada em produtividade e desenvolvimento moderno.

Esta configuração atua como uma IDE completa, leve e rápida, trazendo recursos avançados como suporte a múltiplos servidores LSP, auto-complete inteligente, formatação sob demanda, árvores de arquivos interativas e múltiplos temas visuais.

---

## 📁 Estrutura de Pastas

```
nvim/.config/nvim/
├── init.lua              # Ponto de entrada do Neovim
└── lua/gildofj/
    ├── init.lua          # Loader principal do setup do usuário
    ├── core/             # Configurações nativas do Neovim
    │   ├── init.lua      # Centralizador do core
    │   ├── options.lua   # Configurações de comportamento (tabulação, números de linha, etc.)
    │   ├── keymaps.lua   # Mapeamento de teclas de atalho gerais
    │   ├── autocmds.lua  # Eventos e gatilhos automatizados
    │   ├── theme.lua     # Gerenciamento de cores padrão
    │   └── icons/        # Dicionários de ícones Nerd Fonts
    ├── plugins/          # Configuração dos plugins instalados pelo Lazy
    │   ├── lsp/          # Configuração centralizada de Language Servers (LSP)
    │   │   ├── mason.lua # Gerenciador de LSPs, linters e formatadores
    │   │   └── config/   # Mapeamentos e handlers individuais por linguagem
    │   ├── cmp/          # Motor de Auto-complete (fontes, mapeamentos, formato)
    │   ├── colors/       # Arquivos de ativação para temas instalados
    │   │   ├── catppuccin.lua, kanagawa.lua, nightfox.lua, rose-pine.lua, tokyonight.lua
    │   ├── telescope.lua # Motor de busca fuzzy global (arquivos, textos, buffers)
    │   ├── neo-tree.lua  # Explorador de arquivos lateral moderno com Git integrado
    │   ├── noice.lua     # Interface gráfica experimental para mensagens, prompts e cmdline
    │   ├── conform.lua   # Mecanismo de formatação automática de código (Prettier, Black, etc.)
    │   └── ...           # Outros plugins utilitários (Git, autopairs, terminal, rust, conform)
    └── utils/            # Funções utilitárias auxiliares
```

---

## ✨ Características Detalhadas

### 💻 Language Server Protocol (LSP)
Gerenciado via **Mason** e configurado de forma extensível em [lsp/config/handlers/](./.config/nvim/lua/gildofj/plugins/lsp/config/handlers):
- **Astro** (`astro`)
- **C#** (`csharp_ls`)
- **CSS** (`cssmodules_ls`)
- **Emmet** (`emmet_ls`)
- **HTML** (`html`)
- **JSON** (`jsonls`)
- **Lua** (`lua_ls`)
- **PowerShell** (`powershell_es`)
- **Python** (`pyright`)
- **Rust** (`rust_analyzer`)
- **Tailwind CSS** (`tailwindcss`)
- **TypeScript/JavaScript** (`vtsls`)

### ⚡ Formatação & Linting
- Formatação assíncrona robusta via **`conform.nvim`**, permitindo aplicar formatação com salvamento automático ou atalho de teclado.

### 🔍 Auto-complete Inteligente
Alimentado por **`nvim-cmp`** estruturado em módulos:
- Autocompleta LSPs, buffers de texto, caminhos de arquivo, e documentações.
- Renderização limpa usando ícones personalizados por tipo de sugestão.

### 🎨 Temas e Aparência
Suporta mudança rápida entre temas visuais consagrados:
* **Catppuccin** (Mocha/Macchiato)
* **Kanagawa** (Wave/Dragon)
* **Nightfox**
* **Rose Pine**
* **Tokyonight**

### 📦 Outros Plugins Chave
* **Treesitter**: Parser AST de alta performance para syntax highlighting perfeito de mais de 100 linguagens.
* **Telescope**: Busca fuzzy ultra-rápida de textos, arquivos, commits e buffers abertos.
* **Neo-tree**: Barra de arquivos moderna que reflete o estado do Git (arquivos novos, alterados e ignorados).
* **Toggleterm**: Abertura rápida de múltiplos terminais flutuantes ou em divisões de tela dentro do editor.
* **Which-key**: Exibe um menu pop-up interativo com os atalhos de teclado disponíveis ao começar a digitar uma combinação.

---

## ⚙️ Instalação do Config

Para rodar este Neovim modular:
1. Instale o **Neovim v0.10+**.
2. Certifique-se de que os compiladores `git`, `make`, `gcc` ou `clang`, e ferramentas de terminal como `ripgrep`, `fzf` e `fd` estejam no PATH.
3. Implante a pasta com o script de stow:
   - No Windows: `powershell -ExecutionPolicy Bypass -File .\windows-stow.ps1 -Package nvim`
   - No macOS: `./macosx-setup.sh`
4. Na primeira inicialização, o gerenciador **Lazy.nvim** instalará todos os plugins e esquemas de cores automaticamente.
