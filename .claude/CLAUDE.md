# CLAUDE.md - AI Assistant Instructions

## Project: Nextgen Languages Evangeliser

**Duolingo / Rosetta Stone for programming languages** — a language-*comprehension and transfer* engine that **classifies** cross-language correspondences (it does not translate, lint, or build IDEs) so learning transfers from a known language to a new one. Canonical design: `docs/theory/CORRESPONDENCE-MODEL.adoc`.

- **Not** an IDE (that is **PanLL + eNSAID**; this engine *feeds* PanLL), **not** a linter, **not** a universal translator (no Curry–Howard-fidelity goal), **not** a shame-the-JS pattern matcher.
- **Model:** Concept / Form / Transition; six `CorrespondenceKind`s (cognate / false-friend / antonym / alien-realization / novel / vanished) as graded Echo fibres; classification runs per stratum. Carrier = Dyadic relation + Echo loss-with-residue (`proven-tests-and-benches` + `echo-types`).
- **Division of labour:** we build the engine + interface + vocabulary; the community authors per-language **cartridges** (`standards/cartridges/`).

Host: **ReScript host removed** (2026-06) — ReScript remains only as a legacy *target* language in correspondence content (cartridges/examples), never host code. The current runtime surface is **Deno + cartridge data**; **AffineScript** is the future host and a first-class target (Zig FFI + Idris2 ABI seams).

When working here: classify-don't-translate; keep the no-shame voice; lead with the correspondence model (AffineScript is one first-class target/host, not the sole pitch); author-now / verify-in-CI when the toolchain is absent; **MPL-2.0 SPDX on new files, never relicense or sweep SPDX (licence-label drift is FLAG-ONLY to the owner)**.

## Language Policy (Hyperpolymath Standard)

### ALLOWED Languages & Tools

| Language/Tool | Use Case | Notes |
|---------------|----------|-------|
| **AffineScript** | Flagship target language; future host | Affine/linear types, borrow checker, QTT, WASM backend |
| **ReScript** | Legacy *target* language only (host removed) | Appears in cartridges/examples; not host code |
| **Deno** | Runtime & package management | Replaces Node/npm/bun |
| **Rust** | Performance-critical, systems, WASM | Preferred for CLI tools |
| **Zig** | FFI, C-ABI bridges, systems | Canonical FFI layer (per `0-AI-MANIFEST.a2ml`) |
| **Tauri 2.0+** | Mobile apps (iOS/Android) | Rust backend + web UI |
| **Dioxus** | Mobile apps (native UI) | Pure Rust, React-like |
| **Gleam** | Backend services | Runs on BEAM or compiles to JS |
| **Elixir** | BEAM supervision and bot-role orchestration metadata | Support role only; not the host language or flagship target |
| **Bash/POSIX Shell** | Scripts, automation | Keep minimal |
| **JavaScript** | Only where AffineScript cannot (Deno glue) | Workspace server, CLI, cartridge tooling |
| **Nickel** | Configuration language | For complex configs |
| **Guile Scheme** | State/meta files | STATE.scm, META.scm, ECOSYSTEM.scm |
| **Julia** | Batch scripts, data processing | Per RSR |
| **OCaml** | AffineScript compiler | Language-specific |
| **Ada** | Safety-critical systems | Where required |

### BANNED - Do Not Use

| Banned | Replacement |
|--------|-------------|
| TypeScript | AffineScript |
| Node.js | Deno |
| npm | Deno |
| Bun | Deno |
| pnpm/yarn | Deno |
| Go | Rust or Zig |
| Python | Julia/Rust/AffineScript |
| Java/Kotlin | Rust/Tauri/Dioxus |
| Swift | Tauri/Dioxus |
| React Native | Tauri/Dioxus |
| Flutter/Dart | Tauri/Dioxus |
| V | Zig (except inside V-ecosystem-specific projects) |

### Mobile Development

**No exceptions for Kotlin/Swift** - use Rust-first approach:

1. **Tauri 2.0+** - Web UI (AffineScript) + Rust backend, MIT/Apache-2.0
2. **Dioxus** - Pure Rust native UI, MIT/Apache-2.0

Both are FOSS with independent governance (no Big Tech).

### Enforcement Rules

1. **No new TypeScript files** - Convert existing TS to AffineScript
2. **No package.json for runtime deps** - Use deno.json imports
3. **No node_modules in production** - Deno caches deps automatically
4. **No Go code** - Use Rust or Zig instead
5. **No Python anywhere** - Use Julia for data/batch, Rust for systems, AffineScript for apps
6. **No Kotlin/Swift for mobile** - Use Tauri 2.0+ or Dioxus
7. **No V outside the V ecosystem** - Use Zig

### JavaScript Exemptions

JavaScript is allowed only when it is Deno/browser runtime glue or a launcher bridge that cannot currently be written in AffineScript without losing operability. (The ReScript host has been removed, so there is no longer any generated-ReScript-output JS.)

| Path | Files | Rationale | Unblock condition |
|------|-------|-----------|-------------------|
| `bin/evangeliser.js` | 1 | Deno CLI reading correspondence cartridges (offline fallback) | Replace when AffineScript host CLI is runnable directly |
| `gui/server.js` | 1 | Local Deno HTTP bridge serving the workspace + cartridge API | Replace when AffineScript-to-Deno/webview bridge is available |
| `gui/app.js` | 1 | Browser-side event/render bridge for the GUI shell | Replace when AffineScript DOM/TEA bridge can drive this UI directly |
| `scripts/validate-cartridges.js` | 1 | Deno cartridge-schema validator (ajv) | Replace when AffineScript can host the validator |
| `test/run_all.js` | 1 | Deno cartridge invariant tests | Replace when AffineScript test runner is runnable directly |

### TypeScript Exemptions

| Path | Files | Rationale | Unblock condition |
|------|-------|-----------|-------------------|
| _(none)_ | — | No TypeScript in the repo. The former `node_modules/` ReScript-tooling cache is obsolete now the ReScript host is removed. | — |

### BEAM / Elixir Roles

Elixir is a support-role language for BEAM supervision of automation and fleet orchestration. It is not a target language in this repo and must not displace the AffineScript host path.

| Role | Owner | Purpose | Boundary |
|------|-------|---------|----------|
| `hypatia` | Elixir supervisor role | Coordinate audit, merge, and policy sweeps across repos | May report and open patches; must not bypass repo-local CI evidence |
| `gitbot-fleet` | Elixir worker pool role | Execute scoped branch, dependency, and workflow maintenance jobs | Must read `.machine_readable/bot_directives/roles.a2ml` before acting |
| `repo-maintainer` | Human/Codex role | Apply local fixes and push verified changes | Owns final judgement when bot directives are absent or stale |

### Package Management

- **Primary**: Guix (guix.scm)
- **Fallback**: Nix (flake.nix)
- **JS deps**: Deno (deno.json imports)

### Security Requirements

- No MD5/SHA1 for security (use SHA256+)
- HTTPS only (no HTTP URLs)
- No hardcoded secrets
- SHA-pinned dependencies
- SPDX license headers on all files
