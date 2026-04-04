<!-- SPDX-License-Identifier: PMPL-1.0-or-later -->
<!-- Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk> -->
# TOPOLOGY.md — rescript-evangeliser

## Purpose

ReScript (and AffineScript) advocacy tool that helps teams migrate from TypeScript to ReScript. Analyses codebases, generates migration reports, produces evangelism content, and tracks conversion progress. Runs on Deno.

## Module Map

```
rescript-evangeliser/
├── bin/
│   └── evangeliser.js    # Main entry point (Deno CLI)
├── config.ncl            # Nickel configuration
├── docs/                 # Usage and output documentation
├── justfile / Justfile   # Task runner recipes
└── deno.json             # Deno module config
```

## Data Flow

```
[TypeScript codebase] ──► [evangeliser.js analysis] ──► [Migration report]
      [config.ncl]  ──►         │
                         [Advocacy content generator] ──► [Reports / stats]
```
