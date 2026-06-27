#!/usr/bin/env -S deno run --allow-read
// SPDX-License-Identifier: MPL-2.0
// Offline CLI for the Nextgen Languages Evangeliser.
//
// Reads the validated correspondence cartridges (cartridges/**/*.cartridge.json)
// and prints the *classified* correspondences — concept · from→to · kind ·
// residue. Classify, don't translate: this mirrors the browser workspace's data
// model with zero runtime dependencies (Deno-only — no ReScript).
//
//   deno run --allow-read bin/evangeliser.js [--kind K] [--find TEXT]
//                                            [--cartridges DIR] [--json] [--help]
//
// The browser workspace ('just gui') is the primary surface; this CLI is the
// offline-first fallback.

import { loadCartridges, verdict } from "../src/cartridges.js"

const KINDS = {
  "cognate": { glyph: "🤝", pedagogy: "transfer directly" },
  "false-friend": { glyph: "🎭", pedagogy: "flag the trap" },
  "antonym": { glyph: "🔄", pedagogy: "remap the intuition" },
  "alien-realization": { glyph: "🛸", pedagogy: "bridge with effort" },
  "novel": { glyph: "✨", pedagogy: "teach de novo" },
  "vanished": { glyph: "👻", pedagogy: "un-learn / re-route" },
}

const HELP = `Nextgen Languages Evangeliser — offline correspondence CLI

Reads the correspondence cartridges and prints classified correspondences.
Classify, don't translate — each correspondence carries its CorrespondenceKind
and residue (what is lost, added, or inverted on the crossing).

USAGE:
  deno run --allow-read bin/evangeliser.js [options]

OPTIONS:
  --kind K          only the given kind (${Object.keys(KINDS).join(", ")})
  --find TEXT       filter by concept or language (case-insensitive)
  --cartridges DIR  cartridge root (default: ./cartridges)
  --json            machine-readable output
  -h, --help        this help

The browser workspace ('just gui') is the primary surface; this CLI is the
offline-first fallback.`

function parseArgs(argv) {
  const opts = { kind: null, find: null, json: false, dir: null, help: false }
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i]
    if (a === "--help" || a === "-h") opts.help = true
    else if (a === "--json") opts.json = true
    else if (a === "--kind") opts.kind = argv[++i] ?? null
    else if (a === "--find") opts.find = (argv[++i] ?? "").toLowerCase()
    else if (a === "--cartridges") opts.dir = argv[++i] ?? null
  }
  return opts
}

function render(t) {
  const k = KINDS[t.kind] ?? { glyph: "?", pedagogy: "" }
  const residue = t.residue?.shape ? ` · residue: ${t.residue.shape}` : ""
  const falseFriend = verdict(t.strata, "surface") === true &&
      verdict(t.strata, "intention") === false
    ? "    ⚠ false-friend signature (surface holds, intention diverges)"
    : null
  return [
    `${k.glyph} ${t.concept}  [${t.kind} — ${k.pedagogy}]${residue}`,
    `    ${t.from?.language ?? "?"}: ${t.from?.surface ?? ""}`,
    `    →  ${t.to?.language ?? "?"}: ${t.to?.surface ?? ""}`,
    t.residue?.note ? `    ↳ ${t.residue.note}` : null,
    falseFriend,
  ].filter((x) => x != null).join("\n")
}

async function main() {
  const opts = parseArgs(Deno.args)
  if (opts.help) {
    console.log(HELP)
    return
  }

  const root = opts.dir
    ? new URL(opts.dir.replace(/\/?$/, "/"), `file://${Deno.cwd()}/`)
    : new URL("../cartridges/", import.meta.url)

  const cartridges = await loadCartridges(root)
  let items = cartridges.flatMap((c) =>
    (c.transitions ?? []).map((t) => ({ ...t, cartridge: c.name }))
  )

  if (opts.kind) items = items.filter((t) => t.kind === opts.kind)
  if (opts.find) {
    items = items.filter((t) =>
      [t.concept, t.from?.language, t.to?.language, t.from?.surface, t.to?.surface]
        .filter(Boolean).some((s) => String(s).toLowerCase().includes(opts.find))
    )
  }

  if (opts.json) {
    console.log(JSON.stringify({ count: items.length, correspondences: items }, null, 2))
    return
  }

  if (!items.length) {
    console.log("No correspondences match.")
    return
  }
  console.log(`Nextgen Languages Evangeliser — ${items.length} correspondence(s)\n`)
  console.log(items.map(render).join("\n\n"))
  console.log(
    "\n(Classify, don't translate · the six CorrespondenceKinds · 'just gui' for the workspace)",
  )
}

await main()
