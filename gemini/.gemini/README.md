# 🚀 Gemini CLI - Configurações & Meta-Agentes Local (`.gemini`)

Este diretório contém a estrutura de configuração local, personalizações e meta-agentes especializados para o **Gemini CLI** e o ecossistema **Antigravity**. Ele atua como o cérebro e centro de controle das preferências do usuário e das capacidades estendidas dos agentes.

---

## 📂 Estrutura de Diretórios

```text
.gemini/
├── README.md               # Este arquivo de documentação
├── settings.json           # Configurações globais do CLI, IDE e MCP
└── agents/                 # Meta-agentes especializados (Gildo Core Edition)
    ├── agent-creator.md     # Criador e mantenedor de agentes
    ├── extension-creator.md # Estruturador e validador de extensões nativas
    ├── skill-creator.md     # Criador e gerenciador de Agent Skills contextuais
    └── subagent-creator.md  # Criador de subagentes modulares e focados
```

---

## ⚙️ Configurações Globais (`settings.json`)

O arquivo `settings.json` centraliza o comportamento do CLI, as integrações de IDE, as políticas de segurança e a orquestração de servidores externos por meio do **Model Context Protocol (MCP)**.

### Seções Principais

1. **`ide`**: Controla a integração com ambientes de desenvolvimento.
   - `enabled`: Habilita ou desabilita as funcionalidades de IDE.
   - `hasSeenNudge`: Indica se o usuário já visualizou avisos/introduções do sistema.

2. **`security`**: Define as diretrizes e os métodos de autenticação.
   - `auth.selectedType`: Define o fluxo de login ativo (ex: `oauth-personal` para uso individual seguro).

3. **`mcpServers`**: Configura servidores MCP externos para expandir as capacidades do Gemini CLI.
   - **Exemplo (GitHub MCP)**: Integra o CLI com APIs do GitHub utilizando tokens dinâmicos via variáveis de ambiente (`$GITHUB_MCP_PAT`).

4. **`ui`**: Configurações visuais do terminal e painéis interativos.
   - `theme`: Define o tema visual padrão (ex: `Solarized Light`).

---

## 🤖 Meta-Agentes (`agents/`) — *Gildo Core Edition*

Os arquivos dentro da pasta `agents/` definem **meta-agentes** de altíssimo nível. Em vez de realizarem tarefas comuns de desenvolvimento, estes subagentes são focados no **metaprogramador**, ou seja, em criar e otimizar a própria infraestrutura de IA e agentes do ecossistema.

### 1. 🛠️ Agent Creator (`agent-creator.md`)
Especializado em criar novos agentes resilientes, estruturados e alinhados com as diretrizes do ecossistema.
- **Foco principal:** Manter a consistência de personas, garantir que as diretrizes globais não sejam violadas e selecionar cirurgicamente as ferramentas necessárias para cada nova IA.
- **Abordagem:** Utiliza a lógica **CO-STAR** para modelar o comportamento de novos agentes.

### 2. 🧩 Extension Creator (`extension-creator.md`)
Subagente focado no ciclo de vida de extensões nativas do Gemini CLI e Antigravity.
- **Foco principal:** Estruturar o manifesto obrigatório (`gemini-extension.json`), garantir a correta separação de diretórios (`agents/`, `skills/`, `commands/`, `policies/`, `hooks/`), e validar que as extensões estão prontas para distribuição local ou global.

### 3. 🎯 Skill Creator (`skill-creator.md`)
Especialista em construir instruções altamente eficientes e contextualizadas para estender o agente principal.
- **Foco principal:** Desenvolver arquivos `SKILL.md` super-otimizados que economizam tokens.
- **Estrutura Mandatória:** Toda nova skill gerada deve conter seções claras de *Activation Conditions*, *Core Rules*, *Workflows & Steps* e *Anti-patterns*.

### 4. 🔗 Subagent Creator (`subagent-creator.md`)
Focado no encapsulamento e no princípio de responsabilidade única (*Single Responsibility*).
- **Foco principal:** Projetar subagentes altamente focados e ultra-específicos (ex: auditores de segurança, otimizadores de queries) com conjuntos mínimos de ferramentas para economizar contexto e garantir máxima segurança operacional.

---

## 🚀 Como Utilizar os Meta-Agentes

Para invocar qualquer um dos agentes especialistas contidos neste repositório durante uma sessão interativa do Gemini CLI, utilize o comando de invocação de agente:

```bash
# Exemplo de invocação para criar uma nova habilidade/skill
invoke_agent --agent_name skill-creator --prompt "Crie uma skill para desenvolvimento seguro em Rust"
```

### Boas Práticas ao Adicionar Novos Elementos
- **Novas Configurações:** Ao editar o `settings.json`, sempre valide se a estrutura do JSON é válida e evite expor segredos diretamente (prefira o uso de referências de variáveis de ambiente como `$GITHUB_MCP_PAT`).
- **Novos Subagentes:** Siga estritamente o padrão Markdown com frontmatter YAML contendo as permissões de ferramentas (`tools`), descrição curta e persona robusta.
