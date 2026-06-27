// SPDX-License-Identifier: MPL-2.0
// Shared cartridge loader (Deno glue) for the CLI, the GUI server, the schema
// validator, and the invariant tests. One walk of cartridges/**/*.cartridge.json
// so the readers do not each re-implement it.

// Invoke `fn(fileUrl, fileName)` for every *.cartridge.json under `rootUrl`.
export async function eachCartridgeFile(rootUrl, fn) {
  async function walk(d) {
    let entries
    try {
      entries = Deno.readDir(d)
    } catch {
      return
    }
    for await (const e of entries) {
      const child = new URL(e.name + (e.isDirectory ? "/" : ""), d)
      if (e.isDirectory) {
        await walk(child)
        continue
      }
      if (!e.name.endsWith(".cartridge.json")) continue
      await fn(child, e.name)
    }
  }
  await walk(rootUrl)
}

// Parse every cartridge under `rootUrl`; returns the raw cartridge objects.
export async function loadCartridges(rootUrl) {
  const out = []
  await eachCartridgeFile(rootUrl, async (url, name) => {
    try {
      out.push(JSON.parse(await Deno.readTextFile(url)))
    } catch (err) {
      console.error(`skip ${name}: ${err.message}`)
    }
  })
  return out
}

// Whether a correspondence holds at the named stratum (true / false / null).
export function verdict(strata, name) {
  const v = (strata ?? []).find((s) => s.stratum === name)
  return v ? v.holds : null
}
