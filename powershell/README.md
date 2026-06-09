# 🐚 Configuração Modular do PowerShell (Windows)

> Uma configuração moderna, de alta performance e organizada de forma modular para o **PowerShell** (suporta tanto o Windows PowerShell 5.1 padrão quanto o PowerShell 7+ / Core).

Esta configuração foi desenhada de forma modular utilizando uma pasta de carregamento de scripts dinâmicos, similar ao comportamento do `profile.d` em sistemas Unix, trazendo recursos avançados de usabilidade que equiparam o console do Windows ao Zsh/Bash.

---

## 📁 Estrutura de Pastas

A configuração fica sob o diretório `.config/powershell` no perfil do usuário (`~/.config/powershell`):

```
powershell/.config/powershell/
├── gildofj-spaceship.omp.json  # Tema Spaceship do Oh My Posh salvo localmente (offline-first)
└── profile.d/                  # Scripts modulares executados na inicialização
    ├── 00-modules.ps1          # Inicialização segura de PSReadLine, previsões e cores
    ├── 10-aliases.ps1          # Aliases comuns, navegação rápida (.., ...) e utilitários
    ├── 20-bash-like-commands.ps1 # Comandos Unix portados para Windows (touch, head, tail, etc.)
    ├── 30-ui.ps1               # Inicialização ultrarrápida do Oh My Posh
    ├── 40-utils.ps1            # Inicialização segura do Zoxide (jump cmd)
    ├── 45-fzf.ps1              # Integração avançada e atalhos com fzf (Ctrl+R, fcd, fv)
    └── 50-github.ps1           # Atalhos avançados para Git (Oh My Zsh style)
```

---

## 🔍 Detalhamento dos Módulos

### [00-modules.ps1](./.config/powershell/profile.d/00-modules.ps1) - Módulos Core
- **PSReadLine**: Configura o shell com **autosugestões em linha** (estilo `zsh-autosuggestions`), preenchimento inteligente de tabulação (`MenuComplete`) que exibe um menu navegável, busca substring do histórico ao navegar com as setas para cima/baixo, e cores customizadas legíveis.
- **Terminal-Icons**: Importa ícones Nerd Fonts para exibição de pastas e extensões de arquivos no terminal.

### [10-aliases.ps1](./.config/powershell/profile.d/10-aliases.ps1) - Aliases e Navegação
- Atalhos comuns: `c` para limpar tela, `ff` para fastfetch, `v`/`vim` para Neovim.
- Atalhos rápidos de diretório: `..` para subir um nível, `...` para subir dois, e `....` para subir três.
- Detecção dinâmica de ferramentas CLI: Se o `bat` estiver instalado, substitui o `cat` tradicional. Se `eza` ou `lsd` estiverem instalados, substitui o `ls` padrão para exibir ícones e status de Git integrados.
- Atalho `reload-profile` (ou `rld`) para recarregar o perfil instantaneamente sem fechar a janela.

### [20-bash-like-commands.ps1](./.config/powershell/profile.d/20-bash-like-commands.ps1) - Comandos Unix
- Define aliases compatíveis com Linux: `mv`, `rm`, `ps`, `kill`, `ln`, `which` e `whichdir`.
- **Touch Seguro**: Uma reescrita completa da função `touch`. Diferente do comportamento do PowerShell padrão (que apaga o arquivo ao recriá-lo), esta função atualiza apenas a data de modificação se o arquivo existir, cria novas pastas pai automaticamente caso necessário e aceita múltiplos arquivos.

### [30-ui.ps1](./.config/powershell/profile.d/30-ui.ps1) - Oh My Posh Offline
- Inicializa o prompt customizado de forma offline rápida usando o arquivo de tema em cache local. Isso evita chamadas de rede lentas de até 2 segundos a cada abertura de terminal. Possui fallback automático para a URL do GitHub em caso de ausência do arquivo local.

### [40-utils.ps1](./.config/powershell/profile.d/40-utils.ps1) - Zoxide Jump
- Valida se o `zoxide` está instalado no PATH antes de executar sua inicialização, evitando a emissão de erros no shell.

### [45-fzf.ps1](./.config/powershell/profile.d/45-fzf.ps1) - Integração com FZF (Fuzzy Finder)
- **Fuzzy History (`Ctrl+R`)**: Pressione `Ctrl+R` para abrir um buscador fuzzy do seu histórico de comandos. Ele lê tanto o histórico da sessão atual quanto o arquivo físico salvo pelo PSReadLine, pré-filtrando o buscador com o texto que você já digitou.
- **`fcd` (Fuzzy Change Directory)**: Busca e pula para pastas no seu diretório atual recursivamente (ignora pastas `.git`).
- **`fv` (Fuzzy View/Edit)**: Busca de arquivos de forma rápida para abrir no Neovim (`nvim`) ou VS Code (`code`).

### [50-github.ps1](./.config/powershell/profile.d/50-github.ps1) - Atalhos de Git
- Atalhos robustos com suporte completo de repasse de argumentos (`$args`): `ga` (git add), `gs` (git status), `gp` (git push), `gpl` (git pull), `gd` (git diff), `gco` (git checkout), `gcb` (git checkout -b), `gb` (git branch), `gst` (git stash) e `gl` / `gla` (visualizadores visuais de commits limitados).
- **`gc` inteligente**: Executar `gc` sem parâmetros abre o seu editor padrão do Git para escrever a mensagem. Executar `gc mensagem do commit` realiza o commit com a mensagem digitada direto na linha de comando.
- **`gacp` (Add, Commit & Push)**: Executa `git add -A`, faz o commit com a mensagem informada e realiza o push dinâmico direto para a sua branch ativa atual (identificada de forma dinâmica).

---

## ⚙️ Como Ativar no Windows

PowerShell busca o perfil de usuário em `$PROFILE`. Para que este repositório modular seja executado:

1. Garanta que você executou o [windows-stow.ps1](./windows-stow.ps1) em um shell de Administrador para criar os links simbólicos para `~/.config/powershell`.
2. Certifique-se de que o seu arquivo de perfil real do PowerShell (retornado pela variável `$PROFILE` no terminal) possui o código de importação do diretório modular. O seu arquivo de perfil em `~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` (ou `WindowsPowerShell`) deve conter o seguinte:

```powershell
Get-ChildItem -Path "C:\Users\junio\.config\powershell\profile.d\*.ps1" |
    ForEach-Object { . $_.FullName }
```

Caso o arquivo não exista ou esteja em branco, você pode criá-lo e adicionar este conteúdo.
