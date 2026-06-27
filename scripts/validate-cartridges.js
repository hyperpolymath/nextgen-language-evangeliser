// SPDX-License-Identifier: MPL-2.0
// Validate every *.cartridge.json under cartridges/ against the correspondence
// schema (JSON Schema draft 2020-12). Deno + ajv.
//
//   deno run -A --no-lock scripts/validate-cartridges.js
//   just validate-cartridges
//
// Exits non-zero if any cartridge fails — suitable for CI.

import Ajv2020 from "npm:ajv@8/dist/2020.js"
import { eachCartridgeFile } from "../src/cartridges.js"

const dir = new URL("../cartridges/", import.meta.url)
const schema = JSON.parse(
  await Deno.readTextFile(new URL("correspondence-cartridge.schema.json", dir)),
)

const AjvCtor = Ajv2020.default ?? Ajv2020
const validate = new AjvCtor({ allErrors: true, strict: false }).compile(schema)

let count = 0
let bad = 0

await eachCartridgeFile(dir, async (url, name) => {
  count++
  const data = JSON.parse(await Deno.readTextFile(url))
  if (validate(data)) {
    console.log(`VALID    ${name}  (${data.transitions.length} transitions)`)
  } else {
    bad++
    console.error(`INVALID  ${name}`)
    console.error(JSON.stringify(validate.errors, null, 2))
  }
})

console.log(`\n${count - bad}/${count} cartridges valid.`)
Deno.exit(bad ? 1 : 0)
