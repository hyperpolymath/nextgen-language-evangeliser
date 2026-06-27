// SPDX-License-Identifier: MPL-2.0
// Deno server for the correspondence multi-pane workspace.
//
// Cartridge-driven: reads the validated correspondence facts under
// cartridges/**/*.cartridge.json and serves the browser workspace. No ReScript
// dependency — the workspace presents authored correspondence facts (the
// "Duolingo / Rosetta Stone" lessons), classified per the six CorrespondenceKinds.
//
//   deno run --allow-read --allow-net gui/server.js [--port N] [--host H] [--open]
//   (add --allow-env to honour EVANGELISER_GUI_PORT; --allow-run for --open)

import { loadCartridges as loadAll } from "../src/cartridges.js"

const root = new URL("../", import.meta.url)

function argValue(name, fallback) {
  const i = Deno.args.indexOf(name)
  return i === -1 || i + 1 >= Deno.args.length ? fallback : Deno.args[i + 1]
}

function envPort() {
  try {
    return Deno.env.get("EVANGELISER_GUI_PORT")
  } catch {
    return undefined // --allow-env not granted; fine
  }
}

async function loadCartridges() {
  const dir = new URL("cartridges/", root)
  return (await loadAll(dir)).map((c) => ({
    cartridge: c.name ?? "(unnamed)",
    description: c.description ?? "",
    languages: c.languages ?? [],
    transitions: Array.isArray(c.transitions) ? c.transitions : [],
  }))
}

const contentTypes = {
  ".html": "text/html; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".css": "text/css; charset=utf-8",
}

async function staticFile(name) {
  const body = await Deno.readFile(new URL(name, import.meta.url))
  const ext = name.slice(name.lastIndexOf("."))
  return new Response(body, {
    headers: { "content-type": contentTypes[ext] ?? "application/octet-stream" },
  })
}

function json(body, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "content-type": "application/json; charset=utf-8" },
  })
}

async function handler(req) {
  const url = new URL(req.url)
  try {
    if (req.method === "GET") {
      if (url.pathname === "/") return await staticFile("app.html")
      if (url.pathname === "/app.js") return await staticFile("app.js")
      if (url.pathname === "/api/cartridges") {
        return json({ cartridges: await loadCartridges() })
      }
    }
    return json({ error: "Not found" }, 404)
  } catch (err) {
    console.error(err)
    return json({ error: err.message ?? String(err) }, 500)
  }
}

const requestedPort = Number(argValue("--port", envPort() ?? "8765"))
const hostname = argValue("--host", "127.0.0.1")
let server
let port = requestedPort
for (let attempt = 0; attempt < 20; attempt += 1) {
  try {
    port = requestedPort + attempt
    server = Deno.serve({ hostname, port, onListen: () => {} }, handler)
    break
  } catch (err) {
    if (String(err.message ?? err).includes("Address already in use")) continue
    throw err
  }
}
if (!server) {
  throw new Error(`No free port from ${requestedPort} to ${requestedPort + 19}`)
}

const addr = `http://${hostname}:${port}/`
console.log(`Correspondence workspace: ${addr}`)

if (Deno.args.includes("--open")) {
  setTimeout(() => {
    for (const cmd of [["sensible-browser", addr], ["gio", "open", addr], ["xdg-open", addr]]) {
      try {
        new Deno.Command(cmd[0], { args: cmd.slice(1), stdout: "null", stderr: "null" }).spawn()
        return
      } catch {
        // try the next opener
      }
    }
  }, 250)
}

await server.finished
