# CLAUDE.md

## Project Overview

**Nextgen Languages Evangeliser** is a pattern detection engine, CLI, and educational toolkit that teaches JavaScript developers next-generation type-safe languages through progressive code transformation — without shame.

**Flagship target:** AffineScript (affine/linear type system, borrow checking, quantity checking, WASM backend).

**Supported targets:** AffineScript (flagship), ReScript (legacy), with more to follow (Rust, Gleam, Zig being the likely next additions).

This project is the successor to *ReScript Evangeliser*. The ReScript pattern library is preserved as a legacy target; active pattern authorship now centres on affine/linear safety concerns teachable from idiomatic JavaScript.

## Project Purpose

This repository serves as a resource hub for:
- Educational materials about next-generation type-safe languages (AffineScript first)
- Pattern catalogues showing equivalent transformations from JavaScript to target languages
- Tools that detect amenable patterns in existing JS and encourage adoption
- Community content that evangelises type-safe coding without shaming incumbent code

## Technology Stack

### Core Technologies
- **AffineScript** — flagship target language (teaching subject)
- **typed-wasm** — separate repo; AffineScript's downstream codegen layer (AffineScript → typed-wasm → WASM)
- **ReScript** — current host application language (during Phase 1/2 of migration), legacy target
- **Deno** — runtime & package management (replaces Node/npm/bun)
- **Nickel** — configuration language
- **Zig** — FFI bridge (canonical, per `0-AI-MANIFEST.a2ml`)

### Language Policy (Hyperpolymath Standard)

**ALLOWED:**
- AffineScript (application code, once Phase 3 port completes)
- ReScript (current application code; demoted to legacy target after Phase 3)
- Deno (runtime & package management)
- Zig (FFI, systems code)
- Bash/POSIX Shell (scripts, automation)
- JavaScript (only where ReScript/AffineScript cannot — minimal glue code)
- Nickel (configuration)

**BANNED:**
- TypeScript (use AffineScript or ReScript)
- Node.js (use Deno)
- npm/bun (use Deno)
- Makefile (use Justfile)
- V (use Zig, except inside V-ecosystem-specific projects)

### Key Features to Evangelise

Per target, the pitch differs. The engine is target-aware:

- **AffineScript (flagship):** affine/linear types, use-at-most-once guarantees, borrow checking, quantity type theory, compile-time resource safety, WASM deployment.
- **ReScript (legacy):** sound type inference, Option/Result, pattern matching, pipe operator, zero-cost JS interop.

## Project Structure

```
nextgen-languages-evangeliser/
├── src/              # Application source (ReScript today, AffineScript post-Phase 3)
│   ├── Types.res     # Core type model — multi-target pattern representation
│   ├── Glyphs.res    # Makaton-inspired glyph system (target-agnostic)
│   ├── Narrative.res # "You were close!" narrative generation (target-aware)
│   ├── Patterns.res  # Pattern library (multi-target)
│   ├── Scanner.res   # Regex pattern detection engine
│   ├── Analyser.res  # Result aggregation and reporting
│   ├── Output.res    # RAW/FOLDED/GLYPHED rendering (multi-target)
│   └── Cli.res       # CLI entry point
├── test/             # Test suites
├── docs/             # Documentation
├── rescript.json     # Host build config (current)
├── deno.json         # Deno configuration
├── Justfile          # Task orchestration (NOT Makefile)
├── Mustfile.epx      # Deployment contract
└── config.ncl        # Nickel configuration
```

## Development Guidelines

### Code Style
- Follow the host language's official style guide (ReScript today; AffineScript post-Phase 3)
- Use meaningful names; prefer pattern matching over if/else
- Leverage the type system to make invalid states unrepresentable
- Write interface files (.resi) for public APIs
- Add SPDX license headers to all source files

### Best Practices
1. **Type-First Design** — Design types before implementation
2. **Immutability** — Prefer immutable data structures
3. **Pure Functions** — Write pure functions when possible
4. **Documentation** — Document complex type definitions and public APIs
5. **Error Handling** — Use Result and Option types (not exceptions)

## Common Commands

```bash
# Install dependencies
just install

# Build the project
just build

# Watch mode for development
just watch

# Clean build artifacts
just clean

# Run tests
just test

# Validate project structure and policy
just validate

# Format code
just fmt

# Full validation
just validate-rsr
```

## Build System

This project uses:
- **Deno**: For build scripts and task running
- **justfile**: For task orchestration (NOT Makefile)
- **ReScript**: Current host compiler (bsb)
- **AffineScript**: Planned host compiler post-Phase 3 (OCaml 5.1+, Dune 3.14+; emits typed-wasm IR, which compiles to WASM)

## Dependencies

### Runtime
- Deno (latest stable)
- ReScript 12.2+ (current host)
- @rescript/core
- AffineScript compiler (planned, Phase 3+)

### Package Management
- **Primary**: Guix (guix.scm)
- **Fallback**: Nix (flake.nix)
- **JS deps**: Deno (deno.json imports)

## Evangelism Goals

1. **Demonstrate Value** — Show concrete benefits of each supported target
2. **Lower Barriers** — Make adoption as easy as possible
3. **Share Success Stories** — Document real-world wins
4. **Build Community** — Foster a welcoming environment
5. **Create Resources** — Provide learning materials and tools

## Philosophy: "Celebrate Good, Minimize Bad, Show Better"

We **never** shame developers. Instead:

1. **Celebrate** — Recognize what their JavaScript does well
2. **Minimize** — Gently acknowledge minor limitations
3. **Better** — Show how the target language enhances the pattern
4. **Safety** — Explain type-level (and affine/linear) guarantees
5. **Example** — Provide concrete, encouraging examples

## Migration Status (ReScript → AffineScript)

This repo is mid-migration from ReScript Evangeliser to Nextgen Languages Evangeliser. Phases:

- **Phase 0** ✅ — Decide (option A content rewrite, multilang future, rename repo, toolchain verified)
- **Phase 1** 🚧 — Rebrand + generalise engine for multi-target (host stays ReScript)
- **Phase 2** — Pattern catalogue pivot: affine/linear-safety-focused AffineScript patterns
- **Phase 3** — Host language port ReScript → AffineScript (gated on toolchain WASM maturity)
- **Phase 4** — Policy perimeter flip (ts-blocker extended, affinescript linter added)
- **Phase 5** — Zig/V policy text formalisation

## Resources

### AffineScript
- Compiler: https://github.com/hyperpolymath/affinescript
- Toolchain: OCaml 5.1+, Dune 3.14+
- Downstream codegen: typed-wasm (separate repo) → WebAssembly

### ReScript (legacy target)
- [ReScript Documentation](https://rescript-lang.org/docs)
- [ReScript Forum](https://forum.rescript-lang.org)
- [ReScript GitHub](https://github.com/rescript-lang)

## Notes for Claude

When working on this project:
- Prioritize type safety and correctness
- Suggest idiomatic patterns for whichever target is being discussed
- Treat AffineScript as the flagship target; ReScript as a well-supported legacy target
- When adding patterns, lead with the AffineScript transformation and keep ReScript as secondary
- Help maintain clear documentation
- Encourage best practices in evangelism materials
- **Use Deno, not npm/bun**
- **Use Justfile, not Makefile**
- **Use Zig for FFI, not V (except inside V-ecosystem projects)**
- **Source host language: ReScript during Phases 1-2, AffineScript from Phase 3 onward**
- Add SPDX license headers to new source files

## Project Philosophy

**Make next-generation languages approachable**: The goal is to help developers discover and adopt affine/linear type systems and other nextgen features by:
- Showing practical examples from code they already write
- Addressing common concerns
- Demonstrating real benefits
- Providing migration paths
- Building confidence through education

---

*This document should be updated as the project evolves and new patterns emerge.*
