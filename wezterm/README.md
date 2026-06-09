# ⚡ Configuração do WezTerm

> O **WezTerm** é um emulador de terminal multiplataforma moderno, de alto desempenho, renderizado por GPU e altamente personalizável através de scripts escritos em **Lua**.

Esta configuração fornece um visual minimalista e limpo, integrado com fontes modernas de programação e a paleta de cores Catppuccin.

---

## 📁 Estrutura de Arquivos

* [.wezterm.lua](./.wezterm.lua): Arquivo de script Lua com as regras de inicialização, fontes, aba e visual do terminal.

---

## ✨ Características Detalhadas

* 🎨 **Tema**: Paleta de cores definida para **Catppuccin Mocha**.
* 🅰️ **Fonte**: Fonte de texto definida para **`JetBrains Mono`** no tamanho `12pt`.
* 🖥️ **Dimensão Inicial**: O terminal abre por padrão com tamanho confortável de `120 colunas` e `28 linhas`.
* 📑 **Configurações de Abas**:
  - `tab_bar_at_bottom = true`: A barra de abas (tabs) é colocada na parte inferior da janela, mantendo o topo do terminal limpo.
  - `hide_tab_bar_if_only_one_tab = true`: A barra de abas é ocultada automaticamente se houver apenas uma única aba aberta, maximizando a área útil de tela.
* 🚪 **Sair sem Prompt**: Configurado `window_close_confirmation = "NeverPrompt"`, permitindo fechar o terminal instantaneamente sem pop-ups chatos de confirmação (mesmo que haja processos rodando).

---

## ⚙️ Requisitos

Para que as fontes e ícones funcionem corretamente, certifique-se de ter instalado no seu sistema:
1. O terminal **WezTerm**.
2. A fonte **JetBrains Mono** instalada no sistema operacional.
