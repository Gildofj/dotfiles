# 🖥️ Configuração do Alacritty

> O Alacritty é um emulador de terminal multiplataforma moderno, rápido e focado em performance, renderizado diretamente por GPU (placa de vídeo).

Esta configuração define um visual limpo, moderno e de alta fidelidade visual para o dia a dia de desenvolvimento.

---

## 📁 Estrutura de Arquivos

* [alacritty.toml](./.config/alacritty/alacritty.toml): Arquivo de configuração principal que define fontes, opacidade e temas importados.

---

## ✨ Características Detalhadas

* 🎨 **Tema**: Configurado para importar o tema **Catppuccin Mocha** (`catppuccin_mocha.toml`).
* 🪟 **Transparência**: Opacidade da janela definida em `0.9` (90% de opacidade/10% de transparência), permitindo ver de forma sutil o papel de parede do sistema sem prejudicar a leitura.
* 🅰️ **Fontes**: 
  - Família de fonte padrão definida para **`FiraCode Nerd Font`** (ideal para exibir ícones nos scripts do shell e na barra do Neovim).
  - Tamanho da fonte padrão definido para `12pt`.
  - Suporte completo a variantes Regular, Bold, Italic e Bold Italic.

---

## ⚙️ Requisitos

Para que as fontes e ícones funcionem corretamente, certifique-se de ter instalado no seu sistema:
1. O terminal **Alacritty**.
2. A fonte **FiraCode Nerd Font** (ou outra Nerd Font de sua preferência) instalada no sistema operacional.
3. O diretório de temas do Alacritty clonado ou configurado sob o diretório `~/.config/alacritty/themes/`.
