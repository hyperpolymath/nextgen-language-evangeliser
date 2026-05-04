# CLAUDE.md - AI Assistant Instructions

## Project: Nextgen Languages Evangeliser

Flagship target: **AffineScript**. Legacy target: **ReScript**. More targets planned (Rust, Gleam, Zig).
Current host application language: ReScript (migration to AffineScript planned in Phase 3).

## Language Policy (Hyperpolymath Standard)

### ALLOWED Languages & Tools

| Language/Tool | Use Case | Notes |
|---------------|----------|-------|
| **AffineScript** | Flagship target language; future host | Affine/linear types, borrow checker, QTT, WASM backend |
| **ReScript** | Current host application code; legacy target | Compiles to JS, type-safe |
| **Deno** | Runtime & package management | Replaces Node/npm/bun |
| **Rust** | Performance-critical, systems, WASM | Preferred for CLI tools |
| **Zig** | FFI, C-ABI bridges, systems | Canonical FFI layer (per `0-AI-MANIFEST.a2ml`) |
| **Tauri 2.0+** | Mobile apps (iOS/Android) | Rust backend + web UI |
| **Dioxus** | Mobile apps (native UI) | Pure Rust, React-like |
| **Gleam** | Backend services | Runs on BEAM or compiles to JS |
| **Elixir** | BEAM supervision and bot-role orchestration metadata | Support role only; not the host language or flagship target |
| **Bash/POSIX Shell** | Scripts, automation | Keep minimal |
| **JavaScript** | Only where ReScript/AffineScript cannot | MCP protocol glue, Deno APIs |
| **Nickel** | Configuration language | For complex configs |
| **Guile Scheme** | State/meta files | STATE.scm, META.scm, ECOSYSTEM.scm |
| **Julia** | Batch scripts, data processing | Per RSR |
| **OCaml** | AffineScript compiler | Language-specific |
| **Ada** | Safety-critical systems | Where required |

### BANNED - Do Not Use

| Banned | Replacement |
|--------|-------------|
| TypeScript | AffineScript (preferred) or ReScript |
| Node.js | Deno |
| npm | Deno |
| Bun | Deno |
| pnpm/yarn | Deno |
| Go | Rust or Zig |
| Python | Julia/Rust/ReScript/AffineScript |
| Java/Kotlin | Rust/Tauri/Dioxus |
| Swift | Tauri/Dioxus |
| React Native | Tauri/Dioxus |
| Flutter/Dart | Tauri/Dioxus |
| V | Zig (except inside V-ecosystem-specific projects) |

### Mobile Development

**No exceptions for Kotlin/Swift** - use Rust-first approach:

1. **Tauri 2.0+** - Web UI (ReScript/AffineScript) + Rust backend, MIT/Apache-2.0
2. **Dioxus** - Pure Rust native UI, MIT/Apache-2.0

Both are FOSS with independent governance (no Big Tech).

### Enforcement Rules

1. **No new TypeScript files** - Convert existing TS to AffineScript or ReScript
2. **No package.json for runtime deps** - Use deno.json imports
3. **No node_modules in production** - Deno caches deps automatically
4. **No Go code** - Use Rust or Zig instead
5. **No Python anywhere** - Use Julia for data/batch, Rust for systems, ReScript/AffineScript for apps
6. **No Kotlin/Swift for mobile** - Use Tauri 2.0+ or Dioxus
7. **No V outside the V ecosystem** - Use Zig

### JavaScript Exemptions

JavaScript is allowed only when it is generated ReScript output, Deno/browser runtime glue, or a launcher bridge that cannot currently be written in AffineScript without losing operability.

| Path | Files | Rationale | Unblock condition |
|------|-------|-----------|-------------------|
| `bin/evangeliser.js` | 1 | Deno CLI shim importing compiled ReScript output | Replace when AffineScript host CLI is runnable directly |
| `gui/server.js` | 1 | Local Deno HTTP bridge for the AffineScript GUI contract and compiled ReScript analyser | Replace when AffineScript-to-Deno/webview bridge is available |
| `gui/app.js` | 1 | Browser-side event/render bridge for the GUI shell | Replace when AffineScript DOM/TEA bridge can drive this UI directly |

### TypeScript Exemptions

| Path | Files | Rationale | Unblock condition |
|------|-------|-----------|-------------------|
| `node_modules/` | generated | Deno-managed npm compatibility cache for ReScript tooling | Do not commit; local cache only |

### BEAM / Elixir Roles

Elixir is a support-role language for BEAM supervision of automation and fleet orchestration. It is not a target language in this repo and must not displace the ReScript host or AffineScript flagship path.

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
