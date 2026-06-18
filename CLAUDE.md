# CLAUDE.md

## Project Overview

**Nextgen Languages Evangeliser** is **Duolingo / Rosetta Stone for programming languages** — a language-*comprehension and transfer* engine. It works one layer above text editing, on *syntactic and semantic intention*, and **classifies** cross-language correspondences so the effort spent learning one language **transfers** to the next. *Transfer learning across languages is the product.*

Canonical design: `docs/theory/CORRESPONDENCE-MODEL.adoc` — this file mirrors it. The repo began as *ReScript Evangeliser*; ReScript is now a legacy host (being migrated) and a legacy target.

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

- **ReScript** — current / legacy host (being ported; banned in *new* code per estate policy: `.res` → `.affine`)
- **AffineScript** — future host + first-class target (Zig FFI + Idris2 ABI seams; OCaml 5.1+; emits typed-wasm IR → WebAssembly)
- **Deno** — runtime & package management (not npm/bun)
- **Zig** — FFI layer; **Idris2** — ABI / proofs
- **Nickel** — configuration

### Language Policy (Hyperpolymath Standard)

**ALLOWED:** AffineScript (future host), ReScript (legacy host/target), Deno, Zig (FFI), Idris2 (ABI/proofs), Bash/POSIX shell, JavaScript (glue only — see exemptions in `.claude/CLAUDE.md`), Nickel.

**BANNED:** TypeScript, Node.js, npm/bun, Makefile (use Justfile), V (outside the V ecosystem), Python, Go. **ReScript is banned in _new_ code** — migrate `.res` → `.affine` directly.

## Project Structure

```
nextgen-languages-evangeliser/
├── src/              # Host source (ReScript today; AffineScript target)
│   ├── Types.res     # Core type model (→ Concept / Form / Transition)
│   ├── Glyphs.res    # Makaton-inspired glyph view-layer
│   ├── Narrative.res # Shame-free narrative (per CorrespondenceKind)
│   ├── Patterns.res  # Correspondence catalogue (→ reference language pack)
│   ├── Scanner.res   # Detection engine
│   ├── Analyser.res  # Classification + aggregation
│   ├── Output.res    # focus/glyph/blockly/raw/side-by-side view-layers
│   └── Cli.res       # CLI entry point (offline fallback)
├── gui/              # Browser multi-pane workspace (primary surface)
├── docs/theory/CORRESPONDENCE-MODEL.adoc  # Canonical design spec
├── test/             # Test suites
├── Justfile          # Task orchestration (NOT Makefile)
└── deno.json         # Deno configuration
```

## Common Commands

```bash
just install      # Install dependencies (Deno)
just build        # Build host sources
just watch        # Watch mode
just test         # Run tests
just assail       # panic-attack static-analysis scan
just validate-rsr # RSR compliance
just fmt          # Format
```

## Philosophy: no shame, transfer-first

We **never** shame developers. The voice stays **celebrate / minimise / better / safety / example**. The six kinds map to: transfer cognates, warn on false friends, remap antonyms, bridge the alien, teach the novel, re-route the vanished.

## Re-point Status (was the ReScript → AffineScript "migration")

- ✅ Correspondence-model spec merged (Concept/Form/Transition + six kinds + Dyadic/Echo carrier)
- ✅ Standards / repo hygiene merged (6a2 manifests, panic-attack gate, eNSAID config)
- 🚧 Identity re-point + abstraction-model pivot (classify, not translate)
- → Browser multi-pane GUI (overlay view-layers)
- → AffineScript host port (Zig FFI + Idris2 ABI)
- → Cartridge contract + second language pack
- → Proofs/benches + PanLL octad emission

## Notes for Claude

- Lead with the **correspondence model**; AffineScript is one first-class target/host, not the sole pitch.
- **Classify, don't translate.** No universal-translator or Curry–Howard-fidelity claims.
- **No shame.** Keep the celebrate / minimise / better / safety / example voice.
- **Use Deno, not npm/bun. Use Justfile, not Makefile. Use Zig for FFI, Idris2 for ABI/proofs.**
- **ReScript is banned in new code** → AffineScript (`.affine`).
- Toolchain may be absent in this environment — **author now, verify in CI**; never claim a green build you did not run.
- **Licence: MPL-2.0 (sole-owner repo). Add SPDX `MPL-2.0` to new files. NEVER relicense or bulk-sweep SPDX; licence-label drift is FLAG-ONLY to the owner.**

---

*Keep this in sync with `docs/theory/CORRESPONDENCE-MODEL.adoc` as the engine evolves.*
