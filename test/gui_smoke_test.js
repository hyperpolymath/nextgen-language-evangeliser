#!/usr/bin/env -S deno run --allow-read
// SPDX-License-Identifier: MPL-2.0
// GUI smoke test — exercises the workspace server's request handler in-process
// (no socket, no network): the static shell, the client bundle, and the
// cartridge API. gui/server.js exports `handler` and only opens a listener under
// import.meta.main, so importing it here is side-effect-free.
//
//   deno run --allow-read test/gui_smoke_test.js
//   deno task test  /  just test-gui

import { handler } from "../gui/server.js"

const KINDS = [
  "cognate",
  "false-friend",
  "antonym",
  "alien-realization",
  "novel",
  "vanished",
]

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

function get(path) {
  return handler(new Request(`http://localhost${path}`))
}

console.log("Nextgen Languages Evangeliser — GUI smoke test\n")

// 1. the static shell
{
  const res = await get("/")
  check("/ -> 200", res.status === 200)
  check("/ is html", (res.headers.get("content-type") ?? "").includes("text/html"))
  const html = await res.text()
  check("/ has the workspace title", html.includes("Correspondence Workspace"))
  for (const id of ["index", "paneForms", "paneClassify"]) {
    check(`/ has #${id} pane`, html.includes(`id="${id}"`))
  }
  check("/ loads /app.js", html.includes("/app.js"))
}

// 2. the client bundle
{
  const res = await get("/app.js")
  check("/app.js -> 200", res.status === 200)
  check("/app.js is javascript", (res.headers.get("content-type") ?? "").includes("javascript"))
  check("/app.js carries an SPDX header", (await res.text()).includes("SPDX-License-Identifier"))
}

// 3. the cartridge API
{
  const res = await get("/api/cartridges")
  check("/api/cartridges -> 200", res.status === 200)
  const body = await res.json()
  check("api: cartridges is an array", Array.isArray(body.cartridges))
  const transitions = (body.cartridges ?? []).flatMap((c) => c.transitions ?? [])
  check("api: at least one correspondence", transitions.length >= 1)
  for (const t of transitions) {
    check(`api: '${t.concept}' has a valid kind`, KINDS.includes(t.kind))
    check(`api: '${t.concept}' has from+to`, !!t.from?.language && !!t.to?.language)
  }
}

// 4. unknown route is a clean 404
{
  const res = await get("/does-not-exist")
  check("/does-not-exist -> 404", res.status === 404)
  await res.body?.cancel()
}

console.log(`\n${passed} passed, ${failed} failed`)
if (failed) {
  console.error("\n❌ GUI smoke test failed")
  Deno.exit(1)
}
console.log("✅ GUI smoke test passed")
