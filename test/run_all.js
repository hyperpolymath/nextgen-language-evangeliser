#!/usr/bin/env -S deno run --allow-read
// SPDX-License-Identifier: MPL-2.0
// Engine-invariant tests over the correspondence cartridges (Deno-only — no
// ReScript). Schema conformance is covered by scripts/validate-cartridges.js;
// this asserts the *semantic* invariants the JSON Schema cannot express, and
// that mirror the Idris2 ABI (Abi.Correspondence) and the browser workspace.
//
//   deno run --allow-read test/run_all.js
//   deno task test  /  just test

import { loadCartridges, verdict } from "../src/cartridges.js"

const KINDS = [
  "cognate",
  "false-friend",
  "antonym",
  "alien-realization",
  "novel",
  "vanished",
]
const STRATA = ["surface", "structure", "intention", "trope", "invariant"]
const RESIDUE_SHAPES = ["none", "inverted", "lossy", "absent-source", "absent-target"]

let passed = 0
let failed = 0
function check(label, cond) {
  if (cond) {
    passed++
  } else {
    failed++
    console.error(`  ✗ ${label}`)
  }
}

const root = new URL("../cartridges/", import.meta.url)
const cartridges = await loadCartridges(root)

console.log("Nextgen Languages Evangeliser — cartridge invariant tests\n")

// 1. cartridges load; the reference cartridge is present
check("at least one cartridge loads", cartridges.length >= 1)
const ref = cartridges.find((c) => c.name === "worked-examples")
check("reference cartridge 'worked-examples' present", !!ref)

const all = cartridges.flatMap((c) => c.transitions ?? [])
check("at least one correspondence", all.length >= 1)

// 2. every correspondence is well-formed and classified
for (const t of all) {
  const id = `${t.concept ?? "?"} (${t.from?.language}->${t.to?.language})`
  check(`${id}: kind is one of the six`, KINDS.includes(t.kind))
  check(`${id}: has from.language+surface`, !!t.from?.language && t.from?.surface != null)
  check(`${id}: has to.language+surface`, !!t.to?.language && t.to?.surface != null)
  check(
    `${id}: residue shape valid`,
    t.residue == null || RESIDUE_SHAPES.includes(t.residue.shape),
  )
  for (const s of t.strata ?? []) {
    check(`${id}: stratum '${s.stratum}' valid`, STRATA.includes(s.stratum))
    check(`${id}: stratum '${s.stratum}' holds is boolean`, typeof s.holds === "boolean")
  }
}

// 3. false-friend signature (mirrors Abi.Correspondence.isFalseFriendShape):
//    surface corresponds AND intention diverges.
for (const ff of all.filter((t) => t.kind === "false-friend")) {
  check(`false-friend '${ff.concept}': surface holds`, verdict(ff.strata, "surface") === true)
  check(
    `false-friend '${ff.concept}': intention diverges`,
    verdict(ff.strata, "intention") === false,
  )
}

// 4. novel/vanished residue direction (per CORRESPONDENCE-MODEL.adoc)
for (const nv of all.filter((t) => t.kind === "novel")) {
  check(`novel '${nv.concept}': residue absent-source`, nv.residue?.shape === "absent-source")
}
for (const vn of all.filter((t) => t.kind === "vanished")) {
  check(`vanished '${vn.concept}': residue absent-target`, vn.residue?.shape === "absent-target")
}

// 5. the reference cartridge demonstrates all six kinds
if (ref) {
  const kinds = new Set((ref.transitions ?? []).map((t) => t.kind))
  for (const k of KINDS) check(`reference demonstrates '${k}'`, kinds.has(k))
}

console.log(`\n${passed} passed, ${failed} failed`)
if (failed) {
  console.error("\n❌ cartridge invariants violated")
  Deno.exit(1)
}
console.log("✅ all cartridge invariants hold")
