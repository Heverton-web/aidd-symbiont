# Implementation Plan: SYMBIONT (Local AI Orchestration & Tooling Fabric)

## Overview & Architecture Roadmap
This plan decomposes the execution of `SPEC.md` into four vertical-slice tracer-bullet phases. Each phase implements, tests, and validates an end-to-end operational seam within the Golang backend and the zero-build HTML/JS embedded frontend.

---

## Phase 1: Multi-Asset Scanner Expansion & Unified Filters
**Objective:** Broaden discovery beyond Skills/MCPs to encompass Rules, Hooks, Agent Specs, Utility Scripts, and System Harnesses.

- **Ticket 1.1:** Extend Go scanner signatures in `main.go` to detect:
  - Rules: `.cursorrules`, `.clauderules`, `.windsurfrules`, `.geminirules`, folders `rules/`
  - Agent Specs: `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `copilot-instructions.md`
  - Hooks: `.hooks/`, `hooks.json`, lifecycle scripts
  - Scripts: `.bat`, `.ps1`, `.sh`, `.py` in project directories
- **Ticket 1.2:** Probe host OS `$PATH` for installed AI harnesses (`claude`, `agy`, `opencode`, `ollama`, `cursor`, `trae`).
- **Ticket 1.3:** Implement top navigation filter tabs in `index.html`: `All`, `Skills`, `MCPs`, `Rules`, `Hooks`, `Agents`, `Scripts`.
- **Validation:** Endpoint `/api/catalog` categorizes all discovered asset types with occurrences and unique counts.

---

## Phase 2: Frontier Standardizer (AIDD 0.001%) & Side-by-Side Diff View
**Objective:** Provide safe elevation of existing skills and configs into canonical frontier standards.

- **Ticket 2.1:** Implement canonical template generator in Go:
  - Frontmatter parser and serializer with 1-sentence imperative trigger.
  - AST section validator (Activation Triggers, Input/Output Contracts, Error Boundaries, Binary Acceptance Criteria).
- **Ticket 2.2:** Add `/api/standardize/diff` and `/api/standardize/apply` endpoints:
  - Return side-by-side markdown comparison with token delta.
  - Apply with automatic `.bak` copy creation.
  - Support multi-project duplicate propagation.
- **Ticket 2.3:** Implement interactive Diff View modal in `index.html`:
  - Split-pane comparison (Original vs. Canonical Standard).
  - Actions: Confirm Apply, Cancel, Copy New, Download `.md`.
- **Validation:** Elevation tests on sample legacy skill execute without loss of existing script or path references.

---

## Phase 3: Pipeline Synthesis with Ollama & Hybrid Materializer
**Objective:** Natural language DAG pipeline generation and one-click directory scaffolding.

- **Ticket 3.1:** Connect Go backend to local Ollama API (`http://127.0.0.1:11434/api/generate` with `llama3.1:8b`):
  - Assemble context envelope containing discovered local inventory.
  - Synthesize DAG execution graph in markdown spec format.
- **Ticket 3.2:** Add `/api/pipeline/materialize` endpoint:
  - Scaffold physical target folder.
  - Generate `AGENTS.md` and `CLAUDE.md` under the strict 1,500 token ceiling.
  - Link required skills and generate tailored `mcp.json`.
- **Ticket 3.3:** Add Pipeline Lab UI view in `index.html`:
  - Prompt input (text/transcription).
  - Target directory selector and harness checkboxes.
  - Dual output tabs: `spec.md` preview and Project Scaffolding trigger.
- **Validation:** Materializing project creates valid directory tree with compliant `AGENTS.md`.

---

## Phase 4: Virtual PT-BR Translation, Webperf & Code Simplification
**Objective:** Non-destructive bilingual reading layer, bundle optimization, and static analysis.

- **Ticket 4.1:** Add `/api/translate` endpoint:
  - Cache translations in `.symbiont/cache/translations/{hash}.md`.
  - Zero disk mutations on original files.
- **Ticket 4.2:** Web performance review:
  - Virtualize card rendering for ultra-low DOM footprint.
  - Ensure zero layout shifts and strict container alignment (`max-w-7xl`).
- **Ticket 4.3:** Binary build & packaging:
  - Compile stripped single binary (`skills-mcp-hub.exe`) with embedded assets.
  - Validate zero-emoji invariant.

