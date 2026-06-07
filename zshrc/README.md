# 🚀 Configuração ZSH Modular - Multiplataforma

> Uma configuração ZSH moderna, organizada e otimizada que funciona perfeitamente tanto no **macOS** (Intel e Apple Silicon) quanto no **Linux**.

## 📋 Índice

- [Sobre](#sobre)
- [Características](#características)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Como Funciona](#como-funciona)
- [Personalização](#personalização)
- [Aliases Disponíveis](#aliases-disponíveis)
- [Utilitários e Scripts](#utilitários-e-scripts)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)

---

## 📖 Sobre

Esta configuração ZSH foi projetada para desenvolvedores que trabalham em múltiplas plataformas (Mac e Linux) e desejam uma experiência consistente e produtiva em ambos os ambientes. Recentemente otimizada para performance, alcançando um tempo de carregamento **~10x mais rápido** através de técnicas de lazy loading.

### Por que Modular?

✅ **Organização** - Cada funcionalidade em seu próprio arquivo  
✅ **Manutenção** - Fácil de editar e debugar  
✅ **Reutilização** - Compartilhe apenas os módulos que precisa  
✅ **Clareza** - Entenda o que cada parte faz  
✅ **Flexibilidade** - Ative/desative recursos facilmente

---

## ✨ Características

- 🖥️ **Multiplataforma**: Detecta automaticamente macOS ou Linux
- 🎨 **Tema Spaceship**: Prompt bonito e informativo
- 🔍 **FZF**: Busca fuzzy para arquivos, histórico e diretórios
- ⚡ **Alta Performance**: Lazy loading para NVM e TheFuck (startup instantâneo)
- 🚀 **Ferramentas Modernas**: eza/exa, bat, fd, zoxide, thefuck
- 📦 **Gerenciadores de Pacotes**: Homebrew, NVM, PNPM, JBang, .NET
- 💻 **Ambientes de Dev**: Node.js, Rust, Android SDK (consolidado no PATH)
- 🎯 **Aliases Inteligentes**: Git, navegação, sistema, portas
- 🔧 **Completions Avançados**: Autocompletar inteligente
- 📝 **Histórico Inteligente**: zsh-histdb integrado às autosuggestions

---

## 📁 Estrutura do Projeto

```
~/
├── .zshrc                           # Loader principal (minimalista)
├── bin/                             # Scripts e utilitários executáveis
│   └── codespace-connect            # Gerenciador de conexão GitHub Codespaces
└── .zsh/                            # Diretório de módulos
    ├── 01-os-detection.zsh          # Detecta sistema operacional
    ├── 02-path.zsh                  # Configura PATH (Centralizado)
    ├── 03-package-managers.zsh      # Homebrew, Lazy NVM, PNPM, .NET
    ├── 04-aliases.zsh               # Aliases e funções (gh, ports, etc.)
    ├── 05-shell-enhancements.zsh    # Zoxide, TheFuck (Lazy), HistDB
    ├── 06-fzf.zsh                   # Configuração FZF
    ├── 07-omz-config.zsh            # Oh-My-Zsh e tema
    └── 08-completions.zsh           # Sistema de completions
```

### 🔍 Detalhamento dos Módulos

#### `01-os-detection.zsh` - Detecção de Sistema
- Define variáveis úteis: `$IS_MAC`, `$IS_LINUX`, `$OS_NAME`.
- Configura `$HOMEBREW_PREFIX` automaticamente.

#### `02-path.zsh` - Configuração de PATH (Centralizado)
- **O Ponto Único de Verdade**: Todos os PATHs de ferramentas (Antigravity, JBang, Cargo, Android SDK) são gerenciados aqui.
- Usa a função `add_to_path()` para garantir segurança e evitar entradas duplicadas.

#### `03-package-managers.zsh` - Gerenciadores de Pacotes
- **Lazy Loading NVM**: Node/NPM/PNPM só são carregados quando você os executa pela primeira vez, mantendo o shell rápido.
- **PNPM & .NET**: Configurações de ambiente e home directories.

#### `04-aliases.zsh` - Aliases e Funções
- **Git Flow (`gh`)**: Função simplificada para `add .`, `commit` e `push` em um comando.
- **Utilitários**: Alias `ports` para listar processos em execução.

#### `05-shell-enhancements.zsh` - Melhorias do Shell
- **Lazy Loading TheFuck**: Carrega o comando `fuck` sob demanda.
- **Smarter Suggestions**: `zsh-histdb` integrado para sugerir comandos baseados no seu diretório atual.

---

## 🎯 Aliases Disponíveis

### Sistema

| Alias    | Comando           | Descrição                           |
| -------- | ----------------- | ----------------------------------- |
| `c`      | `clear`           | Limpa a tela                        |
| `reload` | `source ~/.zshrc` | Recarrega configurações             |
| `ls`     | `eza/exa --icons` | Lista moderna com ícones            |
| `ports`  | `lsof (LISTEN)`   | Mostra portas em uso                |
| `dot`    | `cd ~/dotfiles`   | Atalho para seus dotfiles           |

### Git

| Alias      | Comando                     | Descrição                  |
| ---------- | --------------------------- | -------------------------- |
| `ga`       | `git add`                   | Prepara arquivos           |
| `gaa`      | `git add .`                 | Adiciona todos os arquivos |
| `gs`       | `git status`                | Status do repositório      |
| `gc "msg"` | `git commit -m "msg"`       | Commit com mensagem        |
| `gp`       | `git push`                  | Push para remote           |
| `gpl`      | `git pull`                  | Pull do remote             |
| `glog`     | `git log --oneline --graph` | Log visual                 |

### Função Especial: `gh` (Git Flow)

Executa o fluxo completo (add + commit + push) em um único comando:

```bash
# Uso
gh "minha mensagem de commit"
```

---

## 🚀 Utilitários e Scripts

### `codespace-connect`
Localizado em `~/dotfiles/zshrc/bin`, este script permite conectar ao GitHub Codespaces via túnel SSH.

- **Conecte com facilidade**: Menu interativo para selecionar o Codespace.
- **Auto-start**: Inicia Codespaces que estão parados.
- **Configuração SSH**: Gerencia automaticamente o host `codespace-local` no seu `~/.ssh/config`.

```bash
# Uso simples
codespace-connect

# Filtrando por repositório
codespace-connect owner/repo
```

---

## 🎨 Personalização

### Adicionar suas próprias configurações

#### Opção 1: Arquivo de Secrets (`~/.secrets.zsh`)
Para tokens e chaves de API. **Nunca commite este arquivo.**

#### Opção 2: Arquivo Local (`~/.zshrc.local`)
Configurações específicas da máquina onde os dotfiles estão instalados.

#### Opção 3: Criar seu próprio módulo
Adicione um arquivo `.zsh` em `~/.zsh/` para que ele seja carregado automaticamente.

---

## 🐛 Troubleshooting

### Problema: Shell lento após instalação de ferramentas
**Causa**: Algumas ferramentas adicionam comandos ao `.zshrc` ou módulos que carregam scripts pesados.
**Solução**: Verifique o `03-package-managers.zsh` e implemente o wrapper de lazy loading similar ao do NVM.

---

## 📄 Licença

MIT - Use como quiser, compartilhe, modifique!
