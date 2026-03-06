// SPDX-License-Identifier: MIT OR Palimpsest-0.8
// Clean script for ReScript Evangeliser

module Deno = {
  @val @scope("Deno") external cwd: unit => string = "cwd"
  @val @scope("Deno") external remove: (string, 'options) => promise<unit> = "remove"
  @val @scope("Deno") external readDir: string => 'asyncIterable = "readDir"
}

module Fs = {
  @module("@std/fs") external exists: string => promise<bool> = "exists"
}

module Path = {
  @module("@std/path") external join2: (string, string) => string = "join"
}

let root = Deno.cwd()

let cleanTargets = [
  "lib",
  ".bsb.lock",
  "node_modules/.cache",
  "src/**/*.res.js",
  "src/**/*.bs.js",
  "src/**/*.mjs",
]

let cleanDir = async (path: string) => {
  let fullPath = Path.join2(root, path)
  if await Fs.exists(fullPath) {
    Js.Console.log(`Removing: ${path}`)
    await Deno.remove(fullPath, { "recursive": true })
  }
}

let cleanGlob = async (pattern: string) => {
  if Js.String2.includes(pattern, "**") {
    let basePath = Belt.Array.getExn(Js.String2.split(pattern, "**"), 0)
    let extension = Belt.Array.getExn(Js.Array2.sliceFrom(Js.String2.split(pattern, "*"), -1), 0)

    let fullBasePath = Path.join2(root, basePath)
    if await Fs.exists(fullBasePath) {
      let rec walkAndClean = async (dir: string) => {
        let iter: unit => promise<unit> = %raw(`
          async function() {
            for await (const entry of Deno.readDir(dir)) {
              const entryPath = dir + "/" + entry.name;
              if (entry.isDirectory) {
                await walkAndClean(entryPath);
              } else if (entry.name.endsWith(extension)) {
                console.log("Removing: " + entryPath.replace(root + "/", ""));
                await Deno.remove(entryPath);
              }
            }
          }
        `)
        await iter()
      }
      await walkAndClean(fullBasePath)
    }
  } else {
    await cleanDir(pattern)
  }
}

let main = async () => {
  Js.Console.log("=== ReScript Evangeliser Clean ===\n")
  for i in 0 to Belt.Array.length(cleanTargets) - 1 {
    let target = Belt.Array.getExn(cleanTargets, i)
    if Js.String2.includes(target, "*") {
      await cleanGlob(target)
    } else {
      await cleanDir(target)
    }
  }
  Js.Console.log("\n Clean completed!")
}
let _ = main()