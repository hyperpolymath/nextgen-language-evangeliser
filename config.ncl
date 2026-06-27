# config.ncl - Nickel configuration for Nextgen Languages Evangeliser
# SPDX-License-Identifier: MPL-2.0
#
# Type-safe configuration using Nickel
# Renamed from rescript-evangeliser on 2026-04-16

{
  project = {
    name = "nextgen-languages-evangeliser",
    predecessor = "rescript-evangeliser",
    version = "0.6.0-alpha",
    description = "Learn next-generation type-safe languages (flagship: AffineScript) through progressive code transformation",
    license = "MPL-2.0",
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
      "AffineScript",  # future host (Phase 3+)
      "ReScript",      # legacy target language only (host removed)
      "Deno",
      "Rust",
      "Zig",           # canonical FFI
      "Elixir",        # BEAM automation supervision role only
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

    primary = "Deno",            # interim host surface (ReScript host removed)
    primary_planned = "AffineScript",  # post-Phase 3
    runtime = "Deno",

    roles = {
      elixir = {
        status = "support",
        purpose = "BEAM supervision metadata for Hypatia/gitbot-fleet style automation",
        boundary = "not a host-language replacement and not a public transformation target",
      },
    },
  },

  # Build configuration
  build = {
    tool = "just",
    package_manager = "deno",

    tasks = {
      build = "deno task build",
      clean = "just clean",
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
}
