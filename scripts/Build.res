// SPDX-License-Identifier: MIT OR Palimpsest-0.8
// Build script for ReScript Evangeliser

module Deno = {
  @val @scope("Deno") external cwd: unit => string = "cwd"
  @val @scope("Deno") external exit: int => 'a = "exit"
  type command
  @new @scope("Deno") external makeCommand: (string, 'options) => command = "Command"
  @send external output: command => promise<{ "success": bool }> = "output"
}

module Fs = {
  @module("@std/fs") external ensureDir: string => promise<unit> = "ensureDir"
  @module("@std/fs") external exists: string => promise<bool> = "exists"
}

module Path = {
  @module("@std/path") external join2: (string, string) => string = "join"
}

let root = Deno.cwd()
let outDir = Path.join2(root, "lib")

let runCommand = async (cmd: array<string>) => {
  Js.Console.log(`Running: ${Js.Array2.joinWith(cmd, " ")}`)
  let command = Deno.makeCommand(
    Belt.Array.getExn(cmd, 0),
    {
      "args": Js.Array2.sliceFrom(cmd, 1),
      "stdout": "inherit",
      "stderr": "inherit",
    }
  )
  let result = await Deno.output(command)
  result["success"]
}

let buildReScript = async () => {
  Js.Console.log("Building ReScript sources...")

  if !(await Fs.exists(Path.join2(root, "rescript.json"))) {
    Js.Console.error("Error: rescript.json not found")
    false
  } else {
    let success = await runCommand(["npx", "rescript", "build"])
    if success {
      Js.Console.log("ReScript build completed successfully")
    }
    success
  }
}

let copyAssets = async () => {
  Js.Console.log("Preparing output directory...")
  await Fs.ensureDir(outDir)
}

let main = async () => {
  Js.Console.log("=== ReScript Evangeliser Build ===\n")
  await copyAssets()
  let success = await buildReScript()

  if success {
    Js.Console.log("\n Build completed successfully!")
  } else {
    Js.Console.error("\n Build failed!")
    Deno.exit(1)
  }
}

let _ = main()