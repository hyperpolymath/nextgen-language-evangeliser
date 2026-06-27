<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
# Contributing to Nextgen Languages Evangeliser

Thank you for your interest in contributing! 🎉

This project is **Duolingo / Rosetta Stone for programming languages** — a
language-*comprehension and transfer* engine that **classifies** cross-language
correspondences so learning transfers from a language you know to one you don't.
It is **not** an IDE, a linter, a universal translator, or a "fix your
JavaScript" tool. Canonical design: [`docs/theory/CORRESPONDENCE-MODEL.adoc`](docs/theory/CORRESPONDENCE-MODEL.adoc).

We follow the **Compassionate Code Contribution Pledge (CCCP)** and the
**Tri-Perimeter Contribution Framework (TPCF) — Perimeter 3** (see
[`docs/TPCF.adoc`](docs/TPCF.adoc)).

## Philosophy: no shame, transfer-first

Our contribution process mirrors our teaching voice — **celebrate / minimise /
better / safety / example**:

1. **Celebrate** every contribution, however small.
2. **Minimise** — guide gently, never shame.
3. **Better** — improve collaboratively.
4. **Safety** — keep the data valid and the invariants honest.
5. **Example** — show, don't lecture.

## The main way to contribute: author a cartridge

The engine is language-agnostic. The community authors **cartridges** —
per-language packs of correspondence *facts* (data, not code). This is the
highest-value, lowest-barrier contribution.

A cartridge entry is a **Transition**: a Concept shown through a Form in language
A and a Form in language B, classified by its **CorrespondenceKind** and its
**residue** (what is lost, added, or inverted on the crossing):

- **cognate** — transfer directly
- **false-friend** — flag the trap (surface matches, intention diverges)
- **antonym** — remap the intuition (related but inverted)
- **alien-realization** — bridge with effort (same goal, foreign machinery)
- **novel** — teach de novo (no prior anchor)
- **vanished** — un-learn / re-route (the habit is gone here)

### Steps

1. Read [`docs/theory/CORRESPONDENCE-MODEL.adoc`](docs/theory/CORRESPONDENCE-MODEL.adoc).
2. Add or extend a `*.cartridge.json` under `cartridges/`, following
   `cartridges/correspondence-cartridge.schema.json`.
3. Classify each Transition's kind + residue + per-stratum verdicts, and write
   the no-shame narrative.
4. Validate: `just validate-cartridges` and `just test`.
5. Open a pull request.

The worked exemplar is
[`cartridges/reference/worked-examples.cartridge.json`](cartridges/reference/worked-examples.cartridge.json)
— one correspondence per kind.

## Development setup

The runtime surface is **Deno + cartridge data** — no compile step, no Node, no
npm.

### Prerequisites

- [Deno](https://deno.land) (latest stable) — the only required tool
- [just](https://github.com/casey/just) — task runner
- Git
- _Optional, for the engine spine:_ Idris2 (ABI typecheck), Zig (FFI). The
  AffineScript host is the future host; its compiler is not yet released.

### Common tasks

```bash
just gui                # browser multi-pane correspondence workspace (primary surface)
just test               # cartridge invariant tests
just validate-cartridges # schema-validate the cartridges
just build              # validate cartridge data (no compile step)
deno run --allow-read bin/evangeliser.js --help   # offline CLI
```

## Contribution areas

- **Cartridges** (most welcome) — correspondence facts for any language pair.
- **Engine / interface** (`src/interface/**`, `gui/**`, `bin/`) — reviewed
  contributions; discuss architectural changes in an issue first.
- **Engine spine** — the Idris2 ABI (`src/interface/Abi/`), Zig FFI mirror
  (`src/interface/ffi/`), AffineScript host binding (`src/interface/host/`).
- **Documentation** — guides, examples, translations.
- **Accessibility** — the workspace targets the Hyperpolymath Accessibility
  Standard (Level A → AA): keyboard-only, ≥4.5:1 contrast, ARIA, reduced-motion,
  plain-language and glyph layers.

## Language policy

Per the Hyperpolymath Standard: **Deno** (not npm/bun), **Justfile** (not
Makefile), **Zig** for FFI, **Idris2** for ABI/proofs, **AffineScript** as the
future host. **TypeScript, Node.js, Python, Go are banned.** ReScript is a legacy
*target* language only (the ReScript host was removed) — never reintroduce `.res`
host code. See [`CLAUDE.md`](CLAUDE.md) and [`.claude/CLAUDE.md`](.claude/CLAUDE.md)
for the full policy and JavaScript-glue exemptions.

## Commits & pull requests

- **Conventional Commits**: `type(scope): description` (`feat`, `fix`, `docs`,
  `refactor`, `test`, `chore`, …).
- **Sign off** every commit (DCO): `git commit -s`.
- Keep commits atomic and focused; describe the change clearly in the PR.
- CI runs the cartridge tests, schema validation, the `panic-attack` gate, and
  the governance/policy checks.

## Security

Never commit secrets. Report vulnerabilities privately — see
[`SECURITY.md`](SECURITY.md).

## Code of Conduct

This project follows the **Compassionate Code Contribution Pledge** — see
[`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md). In short: never shame developers,
celebrate existing knowledge, assume good intent, foster psychological safety.

## License

By contributing, you agree that your contributions are licensed under the
project licence — see [`LICENSE`](LICENSE). You retain copyright of your
contributions.

---

**Thank you for contributing!** Remember the motto: *Learn — to love it!* 💙
