# 🖥️ Configuração do Alacritty

> O Alacritty é um emulador de terminal multiplataforma moderno, rápido e focado em performance, renderizado diretamente por GPU (placa de vídeo).

Esta configuração define um visual limpo, moderno e de alta fidelidade visual para o dia a dia de desenvolvimento.

---

## 📁 Estrutura de Arquivos

* [alacritty.toml](./.config/alacritty/alacritty.toml): Arquivo de configuração principal que define fontes, opacidade e temas importados.
* [alacritty-sync-theme.sh](./.config/alacritty/alacritty-sync-theme.sh): Script responsável por detectar o tema do macOS e atualizar a configuração ativa.
* [setup-theme-sync.sh](./setup-theme-sync.sh): Script utilitário para instalar e ativar o agente de sincronização de temas em background no macOS.

---

## ✨ Características Detalhadas

* 🎨 **Tema Dinâmico (Light/Dark)**: Configurado para alternar automaticamente entre **Catppuccin Mocha** (Escuro) e **Catppuccin Latte** (Claro) acompanhando as mudanças no tema do sistema operacional.
* 🪟 **Transparência**: Opacidade da janela definida em `0.9` (90% de opacidade/10% de transparência), permitindo ver de forma sutil o papel de parede do sistema sem prejudicar a leitura.
* 🅰️ **Fontes**: 
  - Família de fonte padrão definida para **`FiraCode Nerd Font`** (ideal para exibir ícones nos scripts do shell e na barra do Neovim).
  - Tamanho da fonte padrão definido para `12pt`.
  - Suporte completo a variantes Regular, Bold, Italic e Bold Italic.

---

## ⚙️ Configuração do Tema Dinâmico (macOS)

Para ativar a mudança dinâmica de tema no Alacritty (que reage instantaneamente quando você altera o modo claro/escuro do sistema):

1. Certifique-se de que os seus dotfiles estão aplicados via **Stow** (`stow alacritty`).
2. Execute o script de configuração automática de temas a partir do diretório dos seus dotfiles:
   ```bash
   ./alacritty/setup-theme-sync.sh
   ```

Este script irá configurar um **LaunchAgent** nativo do macOS para monitorar as preferências do sistema e alternar o tema do Alacritty instantaneamente em todas as janelas abertas.

---

## ⚙️ Requisitos

Para que as fontes e ícones funcionem corretamente, certifique-se de ter instalado no seu sistema:
1. O terminal **Alacritty**.
2. A fonte **FiraCode Nerd Font** (ou outra Nerd Font de sua preferência) instalada no sistema operacional.
3. O diretório de temas do Alacritty clonado ou configurado sob o diretório `~/.config/alacritty/themes/`.
