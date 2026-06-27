# CLAUDE.md

## Project Overview

**Nextgen Languages Evangeliser** is **Duolingo / Rosetta Stone for programming languages** — a language-*comprehension and transfer* engine. It works one layer above text editing, on *syntactic and semantic intention*, and **classifies** cross-language correspondences so the effort spent learning one language **transfers** to the next. *Transfer learning across languages is the product.*

Canonical design: `docs/theory/CORRESPONDENCE-MODEL.adoc` — this file mirrors it. The repo began as *ReScript Evangeliser*; the ReScript host has now been **removed** — ReScript remains only as a legacy *target* language in the correspondence catalogue. The runtime surface is Deno + cartridge data; AffineScript is the future host.

### What it is NOT
- **Not an IDE** — that is **PanLL + eNSAID** (the *contact* between human, tool, task, environment). This engine *feeds* PanLL; it is not PanLL.
- **Not a linter** — not scope-colouring or spotting a missing `;` / extra `)`.
- **Not a universal translator** — no Curry–Howard-fidelity goal ("nice, not the point").
- **Not a shame-the-JavaScript pattern matcher.**

## The Model: Concept / Form / Transition

- **Concept** — the invariant / equivalence-class (the recurring *trope*).
- **Form** — a representative of a Concept in one language (`let` in ReScript, `=` in Erlang, `def` in Python).
- **Transition** — a directed Form(A)→Form(B) correspondence plus its *residue* (what is lost, added, or inverted).

Classification is a **graded `CorrespondenceKind`**, not a boolean — six grades of the Echo fibre, each with a pedagogy:
**cognate** (transfer) · **false-friend** (warn) · **antonym** (remap) · **alien-realization** (bridge) · **novel / no-anchor** (teach de novo) · **vanished** (re-route). Classification runs *per stratum* (surface → structure → intention → trope → invariant).

Carrier = **Dyadic relation + Echo loss-with-residue** (`proven-tests-and-benches` `Dyadic.idr` + `hyperpolymath/echo-types`); `invariant-path` is the governance front-end. "Knot theory" is an aspirational lens, **not** a literal computation.

## Engine vs. Cartridge

- **We build** the general engine + interface + classification vocabulary + residue model + a reference language pack.
- **The community builds** per-language modules as **cartridges** (`standards/cartridges/`).

The engine is language-agnostic; the nextgen-language collection is merely the substrate we dogfood.

## Downstream

Emits `octads` → VeriSimDB (`:8097`) + Groove signals → **PanLL** panels; view-layers conform to the estate **overlay-protocol**; ergonomics read `.machine_readable/ENSAID_CONFIG.a2ml`; accessibility meets the **Hyperpolymath Accessibility Standard** (Level A → AA).

## Technology Stack

- **Deno** — runtime, tooling & current host surface (workspace server + CLI + cartridge data); not npm/bun
- **AffineScript** — future host + first-class target (Zig FFI + Idris2 ABI seams; OCaml 5.1+; emits typed-wasm IR → WebAssembly)
- **Zig** — FFI layer; **Idris2** — ABI / proofs
- **Nickel** — configuration
- **ReScript** — *removed* as host (2026-06); retained only as a legacy *target* language in the catalogue

### Language Policy (Hyperpolymath Standard)

**ALLOWED:** AffineScript (future host), Deno, Zig (FFI), Idris2 (ABI/proofs), Bash/POSIX shell, JavaScript (glue only — see exemptions in `.claude/CLAUDE.md`), Nickel. ReScript is allowed only as a legacy *target* language in correspondence content (cartridges, examples), never as host code.

**BANNED:** TypeScript, Node.js, npm/bun, Makefile (use Justfile), V (outside the V ecosystem), Python, Go. **ReScript is banned in _new_ host code** — the ReScript host has been removed; do not reintroduce `.res` host source (`.affine` is the host path).

## Project Structure

```
nextgen-languages-evangeliser/
├── src/interface/    # Engine spine (no host application code yet)
│   ├── Abi/          # Idris2 ABI — Carrier.idr, Correspondence.idr (typechecked)
│   ├── ffi/          # Zig C-ABI mirror (build.zig + src/ + test/)
│   └── host/         # AffineScript host binding (Correspondence.affine; compiler pending)
├── cartridges/       # Correspondence facts (the "lessons"): schema + reference pack
├── gui/              # Browser multi-pane workspace (primary surface; Deno + static)
├── bin/evangeliser.js  # Offline CLI (Deno; reads cartridges)
├── test/run_all.js   # Cartridge invariant tests (Deno)
├── docs/theory/CORRESPONDENCE-MODEL.adoc  # Canonical design spec
├── Justfile          # Task orchestration (NOT Makefile)
└── deno.json         # Deno configuration
```

## Common Commands

```bash
just install      # Warm dependency cache (Deno)
just build        # Validate cartridge data (no compile step — Deno-only)
just gui          # Launch the browser correspondence workspace
just watch        # Serve workspace with live reload
just test         # Run cartridge invariant tests
just assail       # panic-attack static-analysis scan
just validate-rsr # RSR compliance
just fmt          # Format
```

## Philosophy: no shame, transfer-first

We **never** shame developers. The voice stays **celebrate / minimise / better / safety / example**. The six kinds map to: transfer cognates, warn on false friends, remap antonyms, bridge the alien, teach the novel, re-route the vanished.

## Re-point Status (was the ReScript → AffineScript "migration")

- ✅ Correspondence-model spec merged (Concept/Form/Transition + six kinds + Dyadic/Echo carrier)
- ✅ Standards / repo hygiene merged (6a2 manifests, panic-attack gate, eNSAID config)
- ✅ Idris2 ABI spine + Zig FFI mirror + AffineScript host binding authored (ABI typechecks)
- ✅ Browser multi-pane GUI (overlay view-layers) merged
- ✅ Legacy ReScript host **removed** — runtime surface is Deno + cartridges
- 🚧 Identity re-point + abstraction-model pivot (classify, not translate)
- → AffineScript host port (Zig FFI + Idris2 ABI) — fill in the host application
- → Cartridge contract + second language pack
- → Proofs/benches + PanLL octad emission

## Notes for Claude

- Lead with the **correspondence model**; AffineScript is one first-class target/host, not the sole pitch.
- **Classify, don't translate.** No universal-translator or Curry–Howard-fidelity claims.
- **No shame.** Keep the celebrate / minimise / better / safety / example voice.
- **Use Deno, not npm/bun. Use Justfile, not Makefile. Use Zig for FFI, Idris2 for ABI/proofs.**
- **The ReScript host is removed.** ReScript is allowed only as a legacy *target* in correspondence content; never reintroduce `.res` host code — the host path is AffineScript (`.affine`).
- Toolchain may be absent in this environment — **author now, verify in CI**; never claim a green build you did not run.
- **Licence: MPL-2.0 (sole-owner repo). Add SPDX `MPL-2.0` to new files. NEVER relicense or bulk-sweep SPDX; licence-label drift is FLAG-ONLY to the owner.**

---

*Keep this in sync with `docs/theory/CORRESPONDENCE-MODEL.adoc` as the engine evolves.*
