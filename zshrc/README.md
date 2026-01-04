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
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)

---

## 📖 Sobre

Esta configuração ZSH foi projetada para desenvolvedores que trabalham em múltiplas plataformas (Mac e Linux) e desejam uma experiência consistente e produtiva em ambos os ambientes.

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
- 🚀 **Ferramentas Modernas**: exa, bat, fd, zoxide, thefuck
- 📦 **Gerenciadores de Pacotes**: Homebrew, NVM, PNPM
- 💻 **Ambientes de Dev**: Node.js, Rust, .NET, Android SDK
- 🎯 **Aliases Inteligentes**: Git, navegação, sistema
- 🔧 **Completions Avançados**: Autocompletar inteligente
- 📝 **Histórico Aprimorado**: zsh-histdb com busca contextual

---

## 📁 Estrutura do Projeto

```
~/
├── .zshrc                           # Loader principal que carrega tudo
└── .zsh/                            # Diretório de módulos
    ├── 01-os-detection.zsh          # Detecta sistema operacional
    ├── 02-path.zsh                  # Configura PATH
    ├── 03-package-managers.zsh      # Homebrew, NVM, PNPM, .NET
    ├── 04-aliases.zsh               # Aliases e funções
    ├── 05-shell-enhancements.zsh    # Zoxide, TheFuck, histdb
    ├── 06-fzf.zsh                   # Configuração FZF
    ├── 07-omz-config.zsh            # Oh-My-Zsh e tema
    └── 08-completions.zsh           # Sistema de completions
```

### 🔍 Detalhamento dos Módulos

#### `01-os-detection.zsh` - Detecção de Sistema

- Detecta se está rodando em macOS ou Linux
- Identifica arquitetura (Apple Silicon vs Intel)
- Define variáveis úteis: `$IS_MAC`, `$IS_LINUX`, `$OS_NAME`
- Configura `$HOMEBREW_PREFIX` automaticamente
- Fornece funções helper: `run_on_mac()` e `run_on_linux()`

#### `02-path.zsh` - Configuração de PATH

- Organiza todos os PATHs necessários
- Função `add_to_path()` que só adiciona se o diretório existir
- Configura caminhos para: Rust, Neovim, Android SDK, etc.
- Separa PATHs específicos por plataforma

#### `03-package-managers.zsh` - Gerenciadores de Pacotes

- **Homebrew**: Detecta e inicializa automaticamente
- **NVM**: Gerenciador de versões do Node.js
- **PNPM**: Gerenciador de pacotes JavaScript
- **.NET**: SDK e ferramentas

#### `04-aliases.zsh` - Aliases e Funções

- Aliases para comandos do sistema
- Aliases Git otimizados
- Função `gh()` para add+commit+push em um comando
- Aliases específicos por plataforma (Mac vs Linux)

#### `05-shell-enhancements.zsh` - Melhorias do Shell

- **Zoxide**: Navegação inteligente de diretórios
- **TheFuck**: Correção automática de comandos
- **zsh-histdb**: Histórico em banco de dados SQLite

#### `06-fzf.zsh` - Busca Fuzzy

- Configuração do FZF com fd
- Atalhos de teclado para busca
- Integração com histórico de comandos

#### `07-omz-config.zsh` - Oh-My-Zsh

- Tema Spaceship configurado
- Lista de plugins
- Personalização do prompt

#### `08-completions.zsh` - Autocompletar

- Inicializa sistema de completions
- Adiciona diretórios customizados ao fpath
- Opções de styling (desabilitadas por padrão)

---

## 🛠️ Pré-requisitos

### Essenciais

1. **ZSH** (geralmente já vem instalado no Mac)

```bash
# Verificar versão
zsh --version

# Tornar ZSH o shell padrão
chsh -s $(which zsh)
```

2. **Oh-My-Zsh**

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

3. **Tema Spaceship**

```bash
git clone https://github.com/spaceship-prompt/spaceship-prompt.git \
  "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1

ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" \
  "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
```

4. **Plugins Essenciais**

```bash
# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# autoupdate
git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autoupdate
```

### Ferramentas Opcionais (mas recomendadas)

```bash
# macOS
brew install exa bat fd fzf zoxide thefuck

# Linux (Debian/Ubuntu)
sudo apt install exa bat fd-find fzf

# Linux via Homebrew
brew install exa bat fd fzf zoxide thefuck
```

**O que cada ferramenta faz:**

- **exa**: Substituto moderno do `ls` com cores e ícones
- **bat**: Substituto do `cat` com syntax highlighting
- **fd**: Substituto do `find` mais rápido e intuitivo
- **fzf**: Busca fuzzy interativa
- **zoxide**: `cd` inteligente que aprende seus diretórios mais usados
- **thefuck**: Corrige comandos digitados incorretamente

---

## 📥 Instalação

### Método 1: Manual (Recomendado)

```bash
# 1. Fazer backup do .zshrc atual
cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d)

# 2. Criar estrutura de diretórios
mkdir -p ~/.zsh

# 3. Criar cada módulo
# Copie o conteúdo de cada módulo do artifact "Todos os Módulos ZSH"

nano ~/.zsh/01-os-detection.zsh
nano ~/.zsh/02-path.zsh
nano ~/.zsh/03-package-managers.zsh
nano ~/.zsh/04-aliases.zsh
nano ~/.zsh/05-shell-enhancements.zsh
nano ~/.zsh/06-fzf.zsh
nano ~/.zsh/07-omz-config.zsh
nano ~/.zsh/08-completions.zsh

# 4. Criar o .zshrc principal
nano ~/.zshrc
# Cole o conteúdo do "Arquivo 9: ~/.zshrc (Loader Principal)"

# 5. Recarregar
source ~/.zshrc
```

### Método 2: Script Automatizado

```bash
#!/bin/bash
# save-as: install-zsh-config.sh

# Backup
cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d) 2>/dev/null

# Criar estrutura
mkdir -p ~/.zsh

echo "✅ Estrutura criada!"
echo "📝 Agora copie o conteúdo de cada módulo para ~/.zsh/"
echo "   Use o artifact 'Todos os Módulos ZSH' como referência"
```

---

## 🎯 Como Funciona

### Fluxo de Carregamento

```
1. ~/.zshrc é lido pelo ZSH
         ↓
2. Verifica se ~/.zsh/ existe
         ↓
3. Carrega módulos em ordem alfabética:
   01-os-detection.zsh    → Define $IS_MAC, $IS_LINUX
   02-path.zsh            → Configura PATH
   03-package-managers.zsh → Inicializa Homebrew, NVM, etc
   04-aliases.zsh         → Define aliases
   05-shell-enhancements.zsh → Carrega zoxide, thefuck
   06-fzf.zsh             → Configura FZF
   07-omz-config.zsh      → Carrega Oh-My-Zsh
   08-completions.zsh     → Inicializa completions
         ↓
4. Carrega ~/.secrets.zsh (se existir)
         ↓
5. Carrega ~/.zshrc.local (se existir)
         ↓
6. Shell pronto para uso! 🎉
```

### Detecção Automática de Plataforma

```bash
# No módulo 01-os-detection.zsh

# Variáveis disponíveis após carregar:
$IS_MAC           # true se macOS, false se Linux
$IS_LINUX         # true se Linux, false se macOS
$OS_NAME          # "macOS" ou "Linux"
$HOMEBREW_PREFIX  # "/opt/homebrew" ou "/usr/local" ou "/home/linuxbrew/.linuxbrew"

# Funções helper:
run_on_mac "comando"    # Executa apenas no Mac
run_on_linux "comando"  # Executa apenas no Linux
```

**Exemplo de uso:**

```bash
# No seu próprio script ou .zshrc.local
run_on_mac "echo 'Estou no Mac!'"
run_on_linux "echo 'Estou no Linux!'"
```

---

## 🎨 Personalização

### Adicionar suas próprias configurações

#### Opção 1: Arquivo de Secrets (`~/.secrets.zsh`)

Para tokens, chaves de API e variáveis sensíveis:

```bash
# ~/.secrets.zsh
export GITHUB_TOKEN="ghp_xxxxxxxxxxxxx"
export OPENAI_API_KEY="sk-xxxxxxxxxxxxx"
export AWS_ACCESS_KEY_ID="xxxxxxxxxxxxx"
```

#### Opção 2: Arquivo Local (`~/.zshrc.local`)

Para configurações específicas da máquina:

```bash
# ~/.zshrc.local

# Aliases específicos desta máquina
alias work="cd ~/Projects/work"
alias personal="cd ~/Projects/personal"

# Configurações específicas
export EDITOR="nvim"
export VISUAL="nvim"
```

#### Opção 3: Criar seu próprio módulo

```bash
# ~/.zsh/09-custom.zsh

# Suas configurações customizadas
export MY_VAR="value"

my_function() {
  echo "Minha função customizada"
}
```

### Desabilitar um módulo

Simplesmente renomeie o arquivo para remover a extensão `.zsh`:

```bash
# Desabilitar FZF temporariamente
mv ~/.zsh/06-fzf.zsh ~/.zsh/06-fzf.zsh.disabled

# Reabilitar
mv ~/.zsh/06-fzf.zsh.disabled ~/.zsh/06-fzf.zsh
```

### Modificar ordem de carregamento

Os módulos são carregados em ordem alfabética. Para mudar a ordem, renomeie os arquivos:

```bash
# Carregar suas configs antes dos aliases
mv ~/.zsh/09-custom.zsh ~/.zsh/03.5-custom.zsh
```

---

## 🎯 Aliases Disponíveis

### Sistema

| Alias    | Comando           | Descrição                           |
| -------- | ----------------- | ----------------------------------- |
| `c`      | `clear`           | Limpa a tela                        |
| `reload` | `source ~/.zshrc` | Recarrega configurações             |
| `ls`     | `exa --icons`     | Lista com ícones (se exa instalado) |
| `cat`    | `bat`             | Visualiza com syntax highlight      |

### Git

| Alias      | Comando                     | Descrição                  |
| ---------- | --------------------------- | -------------------------- |
| `ga`       | `git add .`                 | Adiciona todos os arquivos |
| `gs`       | `git status`                | Status do repositório      |
| `gc "msg"` | `git commit -m "msg"`       | Commit com mensagem        |
| `gp`       | `git push`                  | Push para remote           |
| `gpoh`     | `git push origin HEAD`      | Push da branch atual       |
| `gpl`      | `git pull`                  | Pull do remote             |
| `gco`      | `git checkout`              | Muda de branch             |
| `gcb`      | `git checkout -b`           | Cria nova branch           |
| `glog`     | `git log --oneline --graph` | Log visual                 |

### Função Especial: `gh`

Executa add + commit + push em um único comando:

```bash
# Uso
gh "minha mensagem de commit"

# Saída
📦 Adicionando arquivos...
💬 Commitando: minha mensagem de commit
🚀 Fazendo push...
✅ Concluído!
```

### Navegação

| Alias  | Comando       | Descrição            |
| ------ | ------------- | -------------------- |
| `..`   | `cd ..`       | Sobe um diretório    |
| `...`  | `cd ../..`    | Sobe dois diretórios |
| `....` | `cd ../../..` | Sobe três diretórios |

### Específicos do Mac

| Alias       | Comando                            | Descrição |
| ----------- | ---------------------------------- | --------- |
| `showfiles` | Mostra arquivos ocultos no Finder  |
| `hidefiles` | Esconde arquivos ocultos no Finder |

---

## 🐛 Troubleshooting

### Problema: "command not found: brew"

**Causa:** Homebrew não instalado ou não está no PATH

**Solução:**

```bash
# Verificar se está instalado
ls -la /opt/homebrew/bin/brew      # Apple Silicon
ls -la /usr/local/bin/brew         # Intel Mac
ls -la /home/linuxbrew/.linuxbrew/bin/brew  # Linux

# Se não estiver instalado:
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Problema: Plugin não encontrado

**Causa:** Plugin do Oh-My-Zsh não instalado

**Solução:**

```bash
# Verificar plugins instalados
ls ~/.oh-my-zsh/custom/plugins/

# Reinstalar plugin específico (exemplo: zsh-syntax-highlighting)
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### Problema: Tema Spaceship não carrega

**Causa:** Tema não instalado corretamente

**Solução:**

```bash
# Verificar instalação
ls -la ~/.oh-my-zsh/custom/themes/spaceship.zsh-theme

# Reinstalar
git clone https://github.com/spaceship-prompt/spaceship-prompt.git \
  "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1

ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" \
  "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

# Recarregar
source ~/.zshrc
```

### Problema: Caracteres quebrados (^M)

**Causa:** Arquivo editado no Windows com CRLF

**Solução:**

```bash
# Converter para Unix (LF)
dos2unix ~/.zshrc ~/.zsh/*.zsh

# Ou com sed
sed -i '' 's/\r$//' ~/.zshrc
sed -i '' 's/\r$//' ~/.zsh/*.zsh
```

### Problema: "zsh compinit: insecure directories"

**Causa:** Permissões incorretas em diretórios do Oh-My-Zsh

**Solução:**

```bash
# Corrigir permissões
chmod -R 755 ~/.oh-my-zsh
compaudit | xargs chmod g-w
```

### Problema: Módulos não carregam

**Causa:** Diretório ~/.zsh não existe ou está vazio

**Solução:**

```bash
# Verificar
ls -la ~/.zsh/

# Recriar se necessário
mkdir -p ~/.zsh
# Copiar módulos novamente
```

---

## ❓ FAQ

### Q: Preciso instalar todas as ferramentas opcionais?

**R:** Não! A configuração verifica se cada ferramenta existe antes de usá-la. Se `exa` não estiver instalado, o alias `ls` usará o `ls` padrão. O mesmo vale para `bat`, `fd`, `zoxide`, etc.

### Q: Posso usar esta configuração junto com minha atual?

**R:** Sim! Faça backup do seu `.zshrc` atual e você pode mesclar as configurações ou usar apenas módulos específicos.

### Q: Como adiciono meus próprios aliases?

**R:** Três opções:

1. Adicione em `~/.zsh/04-aliases.zsh`
2. Crie `~/.zshrc.local` com seus aliases
3. Crie seu próprio módulo `~/.zsh/09-custom.zsh`

### Q: A configuração deixa o shell mais lento?

**R:** Não significativamente. Os módulos são carregados uma vez ao iniciar o shell. O tempo de carregamento típico é < 1 segundo.

### Q: Posso usar no Bash?

**R:** Esta configuração é específica para ZSH, mas os conceitos podem ser adaptados para Bash.

### Q: Como atualizo os plugins?

**R:**

```bash
# Oh-My-Zsh
omz update

# Plugins custom
cd ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git pull

cd ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git pull
```

### Q: Como desinstalo?

**R:**

```bash
# Restaurar backup
cp ~/.zshrc.backup ~/.zshrc

# Remover módulos (opcional)
rm -rf ~/.zsh

# Recarregar
source ~/.zshrc
```

---

## 📚 Recursos Úteis

- [Oh-My-Zsh](https://ohmyz.sh/) - Framework para gerenciar configuração ZSH
- [Spaceship Prompt](https://spaceship-prompt.sh/) - Prompt minimalista e poderoso
- [FZF](https://github.com/junegunn/fzf) - Fuzzy finder de linha de comando
- [Zoxide](https://github.com/ajeetdsouza/zoxide) - cd mais inteligente
- [exa](https://github.com/ogham/exa) - ls moderno
- [bat](https://github.com/sharkdp/bat) - cat com asas
- [fd](https://github.com/sharkdp/fd) - find simplificado

---

## 📄 Licença

MIT - Use como quiser, compartilhe, modifique!

---

## 💡 Dicas Finais

1. **Comece simples**: Não ative tudo de uma vez. Vá adicionando ferramentas conforme precisar.

2. **Faça backups**: Sempre antes de grandes mudanças.

3. **Use .secrets.zsh**: Nunca commite tokens ou senhas no Git.

4. **Explore os plugins**: Oh-My-Zsh tem centenas de plugins úteis.

5. **Aprenda os atalhos**: FZF e Zoxide vão economizar muito tempo.

---
