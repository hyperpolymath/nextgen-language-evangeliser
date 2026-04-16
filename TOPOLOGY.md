<!-- SPDX-License-Identifier: PMPL-1.0-or-later -->
<!-- Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk> -->
# TOPOLOGY.md — nextgen-languages-evangeliser

## Purpose

Multi-target advocacy tool that helps teams migrate from JavaScript/TypeScript to next-generation type-safe languages. Flagship target: AffineScript. Legacy target: ReScript. Analyses codebases, generates migration reports, produces evangelism content, and tracks conversion progress. Runs on Deno.

## Module Map

```
nextgen-languages-evangeliser/
├── bin/
│   └── evangeliser.js    # Main entry point (Deno CLI)
├── src/                  # Host source (ReScript today; AffineScript post-Phase 3)
├── config.ncl            # Nickel configuration
├── docs/                 # Usage and output documentation
├── justfile / Justfile   # Task runner recipes
└── deno.json             # Deno module config
```

## Data Flow

```
[JavaScript/TypeScript codebase] ──► [evangeliser.js analysis] ──► [Migration report (per target)]
      [config.ncl]  ──►         │
                         [Multi-target advocacy content generator] ──► [Reports / stats]
```
