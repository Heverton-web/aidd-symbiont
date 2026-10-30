# Technical Specification: SYMBIONT (Local AI Orchestration & Tooling Fabric)

## 1. Context & Explicit Non-Goals

### Context
SYMBIONT is a high-performance, single-binary local operating system and governance fabric for AI agent tooling, implemented in Golang. It discovers, inspects, deduplicates, standardizes, and materializes agent artifacts across Windows, Linux, and macOS filesystems. It bridges fragmented toolings (Claude Code, Antigravity, Cursor, Trae, Ollama, OpenCode) through a zero-build web interface (embedded via `//go:embed`), multi-disk scanning (Ripgrep + Goroutines), local LLM inference (Ollama `llama3.1:8b`), AST-based frontier standardization (AIDD 0.001% criteria), and zero-copy non-destructive translations.

### Explicit Non-Goals
- Remote SaaS hosting or centralized multi-tenant database: SYMBIONT is strictly local-first and decentralized.
- In-place modification of foreign binary tools: SYMBIONT observes and materializes configurations, but never patches external tool executables.
- In-place overwriting of original documentation files during translation: Translations must remain virtualized in a projection cache (`.symbiont/cache/`) without mutating original repository files.
- Generative AI decorations or non-functional visual noise (AI Slop): Visual styling must remain utilitarian, deterministic, and free of emojis.

---

## 2. Contracts & Typed Interfaces

### Core Domain Structs (Golang)

```go
package domain

type AssetType string

const (
    AssetSkill   AssetType = "Skill"
    AssetMCP     AssetType = "MCP Server"
    AssetRule    AssetType = "Rule"
    AssetHook    AssetType = "Hook"
    AssetAgent   AssetType = "Agent Spec"
    AssetScript  AssetType = "Script"
    AssetHarness AssetType = "Harness CLI"
)

type Occurrence struct {
    Path         string  `json:"path"`
    Folder       string  `json:"folder"`
    Drive        string  `json:"drive"`
    Source       string  `json:"source"`
    LastModified string  `json:"last_modified"`
    SizeKB       float64 `json:"size_kb"`
}

type CommandParam struct {
    Name        string `json:"name"`
    Type        string `json:"type"`
    Description string `json:"description"`
    Required    bool   `json:"required"`
}

type ExecCommand struct {
    Name        string         `json:"name"`
    Command     string         `json:"command"`
    Description string         `json:"description"`
    Args        string         `json:"args"`
    Type        string         `json:"type"`
    Parameters  []CommandParam `json:"parameters,omitempty"`
}

type Asset struct {
    ID             string        `json:"id"`
    Type           AssetType     `json:"type"`
    Name           string        `json:"name"`
    Description    string        `json:"description"`
    Category       string        `json:"category"`
    Path           string        `json:"path"`
    Folder         string        `json:"folder"`
    Drive          string        `json:"drive"`
    Source         string        `json:"source"`
    Command        string        `json:"command,omitempty"`
    Commands       []ExecCommand `json:"commands,omitempty"`
    Env            []string      `json:"env,omitempty"`
    IsCanonical    bool          `json:"is_canonical"`
    IsSession      bool          `json:"is_session"`
    LastModified   string        `json:"last_modified"`
    SizeKB         float64       `json:"size_kb"`
    DuplicateCount int           `json:"duplicate_count"`
    Occurrences    []Occurrence  `json:"occurrences"`
}

type PipelineMaterializeRequest struct {
    TargetDir         string   `json:"target_dir"`
    ProjectName       string   `json:"project_name"`
    TargetHarnesses   []string `json:"target_harnesses"`
    DependencyScope   string   `json:"dependency_scope"` // "none" | "project" | "global"
    RequiredSkills    []string `json:"required_skills"`
    RequiredMCPs      []string `json:"required_mcps"`
    SystemPromptLimit int      `json:"system_prompt_limit"` // Hard cap: 1500 tokens
}

type FrontierStandardizeDiff struct {
    OriginalContent  string `json:"original_content"`
    CanonicalContent string `json:"canonical_content"`
    TokenDelta       int    `json:"token_delta"`
    ASTValid         bool   `json:"ast_valid"`
}
```

### HTTP REST & SSE Endpoints

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/` | Serves embedded zero-build SPA HTML (`//go:embed index.html`) |
| `GET` | `/api/catalog` | Consolidated asset catalog with unique counts and occurrences |
| `POST` | `/api/scan` | Triggers background Goroutine scan across configured roots |
| `GET` | `/api/inspect` | Returns AST parsed subcommands, parameters, and references |
| `POST` | `/api/standardize/diff` | Generates side-by-side diff between target file and frontier canonical standard |
| `POST` | `/api/standardize/apply` | Applies standardization with `.bak` creation and duplicate propagation option |
| `POST` | `/api/pipeline/generate` | Calls Ollama `llama3.1:8b` to synthesize DAG spec from natural language |
| `POST` | `/api/pipeline/materialize`| Scaffolds physical directory, `AGENTS.md` (<1500 tokens), configs, and skills |
| `POST` | `/api/translate` | Virtualizes translation via Ollama without disk file mutation |
| `GET` | `/api/harness/status` | Probes operating system `$PATH` for active CLI harnesses |
| `GET` | `/api/events` | Server-Sent Events (SSE) live-reload stream |

---

## 3. Invariants & Business Rules

1. **Non-Destructive Invariant:** Original source files on disk MUST NEVER be modified or translated in-place unless explicitly approved via the Diff View confirmation dialog.
2. **Context Window Ceiling:** Every generated `AGENTS.md` or `CLAUDE.md` MUST strictly abide by a hard ceiling of 1,500 tokens, enforced via deterministic whitespace-delimited word estimation or token counter check.
3. **Skill Frontmatter Economy:** All canonical skill headers MUST constrain the YAML `description` field to a single telegraphic sentence beginning with an imperative trigger (e.g., `Use when...`) to preserve the host harness prompt envelope.
4. **Deterministic Backup Invariant:** Prior to executing `apply` on any existing file, the server MUST create a byte-exact backup copy with `.bak` suffix in the immediate parent directory.
5. **No-Emoji Invariant:** All UI presentation elements, markdown exports, badges, logs, and metadata MUST be 100% devoid of Unicode emojis; only SVGs and typographic glyphs are allowed.
6. **Container Alignment Invariant:** All persistent layout sections (Header, Navigation, Metrics, Search, Grid, Modals) MUST maintain identical max-width boundaries (`max-w-7xl mx-auto px-4 sm:px-6 lg:px-8`).
7. **Cross-Platform Path Invariant:** Filesystem paths passed to external process executors MUST be stripped of trailing slashes and normalized to host OS semantics to avoid CLI argument escaping faults.

---

## 4. Binary Acceptance Criteria

- `[BAC-01]` `go build -ldflags "-s -w" -o skills-mcp-hub.exe .` executes with exit code 0.
- `[BAC-02]` `Invoke-RestMethod -Uri "http://127.0.0.1:54321/api/catalog"` returns HTTP status 200 with non-empty `total_items`, `total_unique_skills`, and `items`.
- `[BAC-03]` `Invoke-RestMethod -Uri "http://127.0.0.1:54321/api/inspect?type=Skill&path=..."` returns HTTP status 200 with structured `commands` array containing `name`, `command`, and `args`.
- `[BAC-04]` Running grep/regex for emojis `[\x{1F600}-\x{1F64F}\x{1F300}-\x{1F5FF}\x{1F680}-\x{1F6FF}\x{2600}-\x{26FF}\x{2700}-\x{27BF}]` on `index.html` yields exactly 0 occurrences.
- `[BAC-05]` Materializing a pipeline via `POST /api/pipeline/materialize` creates the specified target folder containing `AGENTS.md` whose token count is ≤ 1,500 words/tokens.
- `[BAC-06]` Opening `/api/translate` returns translated Portuguese text while the MD5 checksum of the target file on disk remains completely identical.

---

## 5. Failure & Degradation Modes

- **Ripgrep Absence:** If `rg` binary is missing from system `$PATH` and fallback directories, SYMBIONT gracefully degrades to native concurrent `filepath.WalkDir` Go routines without application crash.
- **Access Denied (Windows OS Error 5):** When scanning restricted directories (e.g. `ElevatedDiagnostics`), Ripgrep flags `--no-messages` and non-zero exit code suppression ensure discovered assets are processed without pipeline abort.
- **Ollama Offline (Connection Refused):** If `127.0.0.1:11434` is unreachable, pipeline generation and translation endpoints return a descriptive JSON payload indicating Ollama is unavailable, prompting for external API key or manual spec fallback.
- **Filesystem Write Protection:** If target materialization path is read-only, `POST /api/pipeline/materialize` aborts transaction cleanly, removes incomplete staging directories, and returns HTTP status 403 with exact OS error message.

