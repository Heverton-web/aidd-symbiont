# Skills & MCP Dynamic Hub

Um centro de controle visual de altíssima performance, escrito em **Golang** nativo, para catalogar, explorar, inspecionar e orquestrar todas as suas **Skills** e **MCPs (Model Context Protocol)** na sua máquina.

Distribuído como um **executável único (`.exe`) de ~7 MB**, com frontend embutido em memória (`//go:embed`), sem depender de Python, Node.js ou compilações de pacotes.

---

## Recursos Principais

- **Executável Único & Portável:** Um único binário compilado. Basta executar e abrir o navegador.
- **Varredura Ultrarrápida:** Varre milhares de repositórios em frações de segundo utilizando Goroutines concorrentes e integração com Ripgrep.
- **100% Livre de Emojis:** Interface limpa, sóbria e refinada inspirada nos padrões do Linear, Obsidian e na skill Impeccable.
- **Painel Fixo & Encolhível:** O cabeçalho e os filtros permanecem fixos no topo, com botão para recolher as métricas e liberar espaço útil de navegação.
- **Inspeção de Slash Commands & Parâmetros:** Extrai automaticamente comandos executáveis (ex: `/polish`, `/audit`, `/critique`) e parâmetros de ferramentas MCP com botão de cópia rápida.
- **Diretórios Customizáveis (GitHub Ready):** Qualquer pessoa que clonar o projeto pode definir suas próprias pastas de varredura diretamente no modal de configurações da interface ou via `config.json`.
- **Live Sync em Tempo Real:** Conexão contínua via *Server-Sent Events (SSE)* atualiza o dashboard instantaneamente quando novos arquivos são adicionados ao disco.

---

## Como Executar

### Opção 1: Via Executável Pré-Compilado (Windows)
1. Dê dois cliques em `skills-mcp-hub.exe` (ou execute `iniciar_hub.bat`).
2. Acesse no navegador: **[http://localhost:54321](http://localhost:54321)**.

### Opção 2: Compilando a partir do Código Fonte (Multiplataforma)

Requisitos: [Go 1.22+](https://golang.org) instalado.

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/skills-mcp-hub.git
cd skills-mcp-hub

# Compile o binário único com HTML embutido
go build -ldflags "-s -w" -o skills-mcp-hub.exe .

# Execute
./skills-mcp-hub.exe
```

---

## Configuração de Pastas de Varredura

Você pode configurar as pastas que o Hub deve monitorar de duas formas:
1. **Pela Interface Web:** Clique no ícone de engrenagem no cabeçalho, adicione os caminhos das suas pastas (ex: `C:\Projetos`, `D:\.agents`, `/home/usuario/skills`) e clique em **Salvar & Reindexar**.
2. **Via `config.json`:**
```json
{
  "port": 54321,
  "search_roots": [
    "C:\\Users\\seu-usuario",
    "C:\\Projetos",
    "D:\\.agents"
  ]
}
```

---

## Licença

Distribuído sob a licença MIT. Sinta-se livre para customizar e compartilhar com a comunidade de desenvolvedores e agentes de IA!
