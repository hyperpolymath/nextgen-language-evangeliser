<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
<!-- Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk> -->
# TOPOLOGY.md — nextgen-languages-evangeliser

## Purpose

Cross-language *comprehension and transfer* engine — Duolingo / Rosetta Stone for programming languages. It *classifies* correspondences between a known language and a target so learning transfers (it does not translate, lint, or build IDEs). Flagship / future host: AffineScript. Legacy target: ReScript (host removed). Runs on Deno; the browser multi-pane workspace is the primary surface.

## Module Map

```
nextgen-languages-evangeliser/
├── bin/
│   └── evangeliser.js    # Offline CLI (Deno; reads cartridges)
├── src/interface/        # Engine spine: Idris2 ABI + Zig FFI + AffineScript host binding
├── cartridges/           # Correspondence facts (schema + reference pack)
├── gui/                  # Browser multi-pane workspace (primary surface)
├── config.ncl            # Nickel configuration
├── docs/                 # Usage and output documentation
├── Justfile              # Task runner recipes
└── deno.json             # Deno module config
```

## Data Flow

```
[JavaScript/TypeScript codebase] ──► [evangeliser.js analysis] ──► [Migration report (per target)]
      [config.ncl]  ──►         │
                         [Multi-target advocacy content generator] ──► [Reports / stats]
```
