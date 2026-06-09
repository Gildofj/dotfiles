# 🗂️ Configuração do tmux

> O **tmux** é um multiplexador de terminal que permite dividir uma única janela de terminal em múltiplos painéis (splits), criar várias sessões e abas (windows), e manter processos rodando em background mesmo se a conexão cair.

Esta configuração customiza o comportamento padrão do tmux para alinhar com atalhos baseados no editor **Vim** e aplica a paleta de cores moderna **Catppuccin**.

---

## 📁 Estrutura de Arquivos

* [.tmux.conf](./.tmux.conf): Arquivo de configuração principal que define prefixos, atalhos, plugins do TPM e visual.

---

## ✨ Características Detalhadas

* ⌨️ **Prefixo Amigável**: Prefixo alterado de `Ctrl + B` para **`Ctrl + S`** (muito mais confortável e rápido de alcançar no teclado).
* 🔀 **Atalhos Estilo Vim**:
  - `setw -g mode-keys vi`: Modo de seleção e navegação com teclas do Vim.
  - Navegação entre painéis mapeada para as teclas de direção do Vim (`h` esquerda, `j` baixo, `k` cima, `l` direita) usando a combinação `Prefixo + Tecla` ou navegação integrada.
* ⚡ **Navegação Integrada Vim-tmux**: Inclui o plugin `christoomey/vim-tmux-navigator` para que você navegue perfeitamente entre janelas divididas do Neovim e painéis do tmux usando as mesmas teclas de atalho.
* 🎨 **Tema Catppuccin**:
  - Posição da barra de status configurada no topo (`status-position top`).
  - Separadores arredondados estilo bolha (``).
  - Módulos de status ativados: Nome da aplicação rodando, identificador da sessão ativa e data/hora.
* 🛠️ **Recarga Rápida**: Atalho `Prefixo + R` recarrega as configurações do arquivo `.tmux.conf` instantaneamente na sessão ativa.
* 💻 **Cor de 256 bits**: Configura suporte a TrueColor (RGB) e define o shell padrão do tmux para o Zsh (`/bin/zsh`).

---

## 🔌 Plugins Ativos (via TPM - Tmux Plugin Manager)

1. [tmux-plugins/tpm](https://github.com/tmux-plugins/tpm): Gerenciador de Plugins do tmux.
2. [tmux-plugins/tmux-sensible](https://github.com/tmux-plugins/tmux-sensible): Configurações padrão seguras de comportamento do shell.
3. [christoomey/vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator): Integração de navegação fluida Neovim-tmux.
4. [catppuccin/tmux](https://github.com/catppuccin/tmux): Tema estético Catppuccin.

---

## ⚙️ Instalação dos Plugins

Para que os temas e plugins carreguem corretamente:
1. Certifique-se de ter o **TPM** clonado na pasta `~/.tmux/plugins/tpm`:
   ```bash
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   ```
2. Após implantar o arquivo `.tmux.conf`, abra o tmux e pressione `Ctrl + S` seguido de `I` (letra i maiúscula) para baixar e instalar todos os plugins automaticamente.
