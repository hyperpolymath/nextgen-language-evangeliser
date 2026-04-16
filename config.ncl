# config.ncl - Nickel configuration for Nextgen Languages Evangeliser
# SPDX-License-Identifier: MIT OR Palimpsest-0.8
#
# Type-safe configuration using Nickel
# Renamed from rescript-evangeliser on 2026-04-16

{
  project = {
    name = "nextgen-languages-evangeliser",
    predecessor = "rescript-evangeliser",
    version = "0.6.0-alpha",
    description = "Learn next-generation type-safe languages (flagship: AffineScript) through progressive code transformation",
    license = "MIT OR Palimpsest-0.8",
  },

  # Target languages (what we teach)
  targets = {
    flagship = "AffineScript",
    legacy = ["ReScript"],
    planned = ["Rust", "Gleam", "Zig"],
  },

  # Language policy (what we write the toolkit in)
  languages = {
    allowed = [
      "AffineScript",  # planned host (Phase 3+)
      "ReScript",      # current host
      "Deno",
      "Rust",
      "Zig",           # canonical FFI
      "Bash",
      "JavaScript",    # minimal glue code only
      "Nickel",
    ],

    banned = [
      "TypeScript",
      "Node.js",
      "npm",
      "bun",
      "Go",
      "V",             # use Zig, except inside V-ecosystem projects
    ],

    primary = "ReScript",        # current host language
    primary_planned = "AffineScript",  # post-Phase 3
    runtime = "Deno",
  },

  # Build configuration
  build = {
    tool = "just",
    package_manager = "deno",

    tasks = {
      build = "deno task build",
      clean = "deno task clean",
      validate = "deno task validate",
      test = "deno task test",
      fmt = "deno task fmt",
      lint = "deno task lint",
    },
  },

  # Paths
  paths = {
    src = "src",
    scripts = "scripts",
    docs = "docs",
    lib = "lib",
  },

  # CI configuration
  ci = {
    platforms = ["ubuntu-latest"],
    required_checks = [
      "ts-blocker",
      "makefile-blocker",
      "npm-bun-blocker",
      "validate",
      "build",
      "test",
    ],
  },

  # ReScript configuration (current host)
  rescript = {
    version = "12",
    module_format = "es6",
    suffix = ".res.js",
    uncurried = true,
  },
}
