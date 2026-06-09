# 🪟 Configuração do GlazeWM & Zebar

> O **GlazeWM** é um gerenciador de janelas lado a lado (*Tiling Window Manager*) para Windows, inspirado em conceitos consagrados no Linux (como o i3wm e bspwm). Ele é acompanhado pelo **Zebar**, uma barra de tarefas/status altamente personalizável.

Esta configuração transforma a experiência no Windows, permitindo organizar e mover janelas usando apenas o teclado, sem a necessidade de arrastar janelas manualmente com o mouse.

---

## 📁 Estrutura de Arquivos

* [config.yaml](./.glzr/glazewm/config.yaml): Definição de regras de comportamento de janelas, espaçamento (gaps), atalhos e workspaces do GlazeWM.
* [settings.json](./.glzr/zebar/settings.json): Configuração da barra de status do Zebar.

---

## ✨ Características Detalhadas

### Integração
* **Auto-start/kill**: Inicia a barra do `zebar` automaticamente ao abrir o GlazeWM e a encerra no encerramento (`taskkill`).
* **Regras de Exceção**: Janelas do Zebar, Picture-in-Picture de navegadores (Arc, Chrome, Firefox) e utilitários (PowerToys, Lively Wallpaper, Fluent Search) são ignorados pelo tiling para operarem livremente de forma flutuante.

### Espaçamento & Visual
* **Bordas Dinâmicas (Windows 11)**: Janela focada recebe uma borda de destaque cor `#b4befe` (Catppuccin Lavender). Janelas desfocadas usam `#6c7086`.
* **Gaps**:
  - `20px` de espaçamento interno (*inner gaps*) entre janelas.
  - `60px` de espaçamento superior (*top outer gap*) para reservar espaço perfeito para a barra Zebar.
  - `20px` nos demais cantos externos.

### ⌨️ Atalhos de Teclado (Keybindings)

#### Navegação e Foco
* `Alt + H` ou `Alt + Left`: Focar janela à esquerda
* `Alt + L` ou `Alt + Right`: Focar janela à direita
* `Alt + K` ou `Alt + Up`: Focar janela acima
* `Alt + J` ou `Alt + Down`: Focar janela abaixo
* `Alt + Space`: Ciclar foco entre tiling ➡️ floating ➡️ fullscreen
* `Alt + A` / `Alt + S`: Focar workspace anterior / seguinte ativo
* `Alt + D`: Focar workspace recente (alt-tab de workspaces)

#### Movimentação de Janelas
* `Alt + Shift + H` / `Left`: Mover janela para a esquerda
* `Alt + Shift + L` / `Right`: Mover janela para a direita
* `Alt + Shift + K` / `Up`: Mover janela para cima
* `Alt + Shift + J` / `Down`: Mover janela para baixo
* `Alt + Shift + Space`: Alternar estado flutuante (*floating*) da janela ativa (centralizada)
* `Alt + T`: Fixar/Soltar modo tiling da janela
* `Alt + F`: Alternar tela cheia (*fullscreen*)

#### Workspaces (Áreas de Trabalho 1 a 9)
* `Alt + 1` até `Alt + 9`: Alternar para o Workspace X
* `Alt + Shift + 1` até `Alt + Shift + 9`: Mover janela ativa para o Workspace X e focar nele

#### Utilitários e Controle
* `Alt + Enter`: Abre o terminal padrão (**Windows Terminal / wt**)
* `Alt + Shift + Q`: Fechar a janela focada
* `Alt + Shift + P`: Pausar/Retomar o GlazeWM (volta para o comportamento padrão do Windows)
* `Alt + Shift + R`: Recarregar configurações do arquivo `config.yaml`
* `Alt + Shift + E`: Encerrar e sair do GlazeWM
* `Alt + R`: Entra no modo **Resize** (redimensionar):
  - Use `H`, `J`, `K`, `L` ou as setas para ajustar o tamanho das janelas.
  - Pressione `Esc` ou `Enter` para sair do modo de redimensionamento.
