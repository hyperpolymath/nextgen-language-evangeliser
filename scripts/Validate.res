// SPDX-License-Identifier: MIT OR Palimpsest-0.8
// Validation script for ReScript Evangeliser

module Deno = {
  @val @scope("Deno") external cwd: unit => string = "cwd"
  @val @scope("Deno") external exit: int => 'a = "exit"
  @val @scope("Deno") external readDir: string => 'asyncIterable = "readDir"
  @val @scope("Deno") external readTextFile: string => promise<string> = "readTextFile"
}

module Fs = {
  @module("@std/fs") external exists: string => promise<bool> = "exists"
}

module Path = {
  @module("@std/path") external join2: (string, string) => string = "join"
}

let root = Deno.cwd()

type validationResult = {
  name: string,
  passed: bool,
  message: string,
}

let results: array<validationResult> = []

let log = (emoji: string, message: string) => {
  Js.Console.log(`${emoji} ${message}`)
}

let pass = (name: string, message: string) => {
  let _ = Js.Array2.push(results, { name, passed: true, message })
  log("✅", `${name}: ${message}`)
}

let fail = (name: string, message: string) => {
  let _ = Js.Array2.push(results, { name, passed: false, message })
  log("❌", `${name}: ${message}`)
}

let validateStructure = async () => {
  log("🏗️", "Checking project structure...")

  let requiredFiles = [
    "rescript.json",
    "deno.json",
    "justfile",
    "README.adoc",
    "CLAUDE.md",
    "SECURITY.md",
    "CONTRIBUTING.md",
    "CODE_OF_CONDUCT.md",
    "LICENSE-MIT.txt",
    "LICENSE-PALIMPSEST.txt",
  ]

  for i in 0 to Belt.Array.length(requiredFiles) - 1 {
    let file = Belt.Array.getExn(requiredFiles, i)
    if await Fs.exists(Path.join2(root, file)) {
      pass("Structure", `Found ${file}`)
    } else {
      fail("Structure", `Missing ${file}`)
    }
  }

  let requiredDirs = ["src", "docs", ".github"]
  for i in 0 to Belt.Array.length(requiredDirs) - 1 {
    let dir = Belt.Array.getExn(requiredDirs, i)
    if await Fs.exists(Path.join2(root, dir)) {
      pass("Structure", `Found ${dir}/`)
    } else {
      fail("Structure", `Missing ${dir}/`)
    }
  }
}

let validateNoMakefile = async () => {
  log("📋", "Checking for banned Makefile...")

  if await Fs.exists(Path.join2(root, "Makefile")) {
    fail("Policy", "Makefile detected - use justfile instead")
  } else if await Fs.exists(Path.join2(root, "makefile")) {
    fail("Policy", "makefile detected - use justfile instead")
  } else if await Fs.exists(Path.join2(root, "GNUmakefile")) {
    fail("Policy", "GNUmakefile detected - use justfile instead")
  } else {
    pass("Policy", "No Makefile found (using justfile)")
  }
}

let validateNoNewTypeScript = async () => {
  log("📜", "Checking for TypeScript/JavaScript in src/...")
  let srcDir = Path.join2(root, "src")
  if !(await Fs.exists(srcDir)) {
    pass("Policy", "No src/ directory to check")
  } else {
    let state = {"foundTS": false, "foundJS": false}

    let rec walkDir = async (dir: string) => {
      let iter: unit => promise<unit> = %raw(`
        async function() {
          for await (const entry of Deno.readDir(dir)) {
            const entryPath = dir + "/" + entry.name;
            if (entry.isDirectory) {
              await walkDir(entryPath);
            } else {
              if (entry.name.endsWith(".ts") || entry.name.endsWith(".tsx")) {
                state.foundTS = true;
                fail("Policy", "TypeScript file in src/: " + entry.name);
              }
              if ((entry.name.endsWith(".js") || entry.name.endsWith(".jsx")) &&
                  !entry.name.endsWith(".res.js") && !entry.name.endsWith(".bs.js")) {
                state.foundJS = true;
                fail("Policy", "JavaScript file in src/: " + entry.name);
              }
            }
          }
        }
      `)
      await iter()
    }
    await walkDir(srcDir)
    if !state["foundTS"] && !state["foundJS"] {
      pass("Policy", "No TypeScript/JavaScript in src/ (ReScript only)")
    }
  }
}

let validateReScriptFiles = async () => {
  log("🔷", "Checking for ReScript source files...")
  let srcDir = Path.join2(root, "src")
  if !(await Fs.exists(srcDir)) {
    fail("ReScript", "No src/ directory found")
  } else {
    let state = {"resCount": 0}
    let rec walkDir = async (dir: string) => {
      let iter: unit => promise<unit> = %raw(`
        async function() {
          for await (const entry of Deno.readDir(dir)) {
            const entryPath = dir + "/" + entry.name;
            if (entry.isDirectory) {
              await walkDir(entryPath);
            } else if (entry.name.endsWith(".res")) {
              state.resCount++;
            }
          }
        }
      `)
      await iter()
    }
    await walkDir(srcDir)
    if state["resCount"] > 0 {
      pass("ReScript", `Found ${Belt.Int.toString(state["resCount"])} ReScript source files`)
    } else {
      fail("ReScript", "No ReScript (.res) files found in src/")
    }
  }
}

let validateSPDXHeaders = async () => {
  log("📝", "Checking SPDX license headers in ReScript files...")
  let srcDir = Path.join2(root, "src")
  if await Fs.exists(srcDir) {
    let state = {"checked": 0, "withHeaders": 0}
    let rec walkDir = async (dir: string) => {
      let iter: unit => promise<unit> = %raw(`
        async function() {
          for await (const entry of Deno.readDir(dir)) {
            const entryPath = dir + "/" + entry.name;
            if (entry.isDirectory) {
              await walkDir(entryPath);
            } else if (entry.name.endsWith(".res")) {
              state.checked++;
              const content = await Deno.readTextFile(entryPath);
              if (content.includes("SPDX-License-Identifier:")) {
                state.withHeaders++;
              } else {
                fail("SPDX", "Missing SPDX header: " + entry.name);
              }
            }
          }
        }
      `)
      await iter()
    }
    await walkDir(srcDir)
    if state["checked"] == state["withHeaders"] && state["checked"] > 0 {
      pass("SPDX", `All ${Belt.Int.toString(state["checked"])} ReScript files have SPDX headers`)
    }
  }
}

let main = async () => {
  Js.Console.log("=== ReScript Evangeliser Validation ===\n")

  await validateStructure()
  await validateNoMakefile()
  await validateNoNewTypeScript()
  await validateReScriptFiles()
  await validateSPDXHeaders()

  Js.Console.log("\n=== Summary ===")

  let passed = results->Belt.Array.keep(r => r.passed)->Belt.Array.length
  let failed = results->Belt.Array.keep(r => !r.passed)->Belt.Array.length

  Js.Console.log(`Passed: ${Belt.Int.toString(passed)}`)
  Js.Console.log(`Failed: ${Belt.Int.toString(failed)}`)

  if failed > 0 {
    Js.Console.log("\n Validation failed!")
    Deno.exit(1)
  } else {
    Js.Console.log("\n Validation passed!")
  }
}

let _ = main()