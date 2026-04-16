// SPDX-License-Identifier: PMPL-1.0-or-later
// CLI: Entry point for the nextgen-languages-evangeliser command-line tool
// Usage: evangeliser scan <file.js> | patterns | legend

open Types

// Read file contents via Deno or Node fs
@module("node:fs") external readFileSync: (string, string) => string = "readFileSync"

// Read command-line arguments
@val external argv: array<string> = "process.argv"

// Parse CLI options from args
type cliOptions = {
  command: string,
  file: option<string>,
  format: string,
  difficulty: option<difficultyLevel>,
  view: viewLayer,
  target: targetLang,
}

let parseArgs = (args: array<string>): cliOptions => {
  // Skip first two args (deno/node + script path)
  let userArgs = args->Array.slice(~start=2, ~end=Array.length(args))

  let command = userArgs->Array.get(0)->Option.getOr("help")
  let file = ref(None)
  let format = ref("plain")
  let difficulty = ref(None)
  let view = ref(RAW)
  let target = ref(flagshipTarget)

  userArgs->Array.forEachWithIndex((_arg, idx) => {
    let arg = userArgs->Array.getUnsafe(idx)
    switch arg {
    | "--format" =>
      switch userArgs->Array.get(idx + 1) {
      | Some("markdown") => format := "markdown"
      | Some("html") => format := "html"
      | _ => format := "plain"
      }
    | "--difficulty" =>
      switch userArgs->Array.get(idx + 1) {
      | Some("beginner") => difficulty := Some(Beginner)
      | Some("intermediate") => difficulty := Some(Intermediate)
      | Some("advanced") => difficulty := Some(Advanced)
      | _ => ()
      }
    | "--view" =>
      switch userArgs->Array.get(idx + 1) {
      | Some("raw") => view := RAW
      | Some("folded") => view := FOLDED
      | Some("glyphed") => view := GLYPHED
      | _ => ()
      }
    | "--target" =>
      switch userArgs->Array.get(idx + 1) {
      | Some(t) =>
        switch stringToTargetLang(t) {
        | Some(lang) => target := lang
        | None => () // unknown target: keep default (flagship)
        }
      | None => ()
      }
    | _ =>
      // First non-flag arg after command is the file
      if idx > 0 && !(String.startsWith(arg, "--")) {
        let prevArg = userArgs->Array.get(idx - 1)->Option.getOr("")
        if !(String.startsWith(prevArg, "--")) || idx === 1 {
          if file.contents === None && idx >= 1 {
            file := Some(arg)
          }
        }
      }
    }
  })

  {
    command,
    file: file.contents,
    format: format.contents,
    difficulty: difficulty.contents,
    view: view.contents,
    target: target.contents,
  }
}

let showHelp = (): string => {
  `Nextgen Languages Evangeliser - "Celebrate good, minimize bad, show better"

Usage:
  evangeliser scan <file.js>   Scan a JavaScript file for improvable patterns
  evangeliser patterns          List all available transformation patterns
  evangeliser legend             Show the glyph legend
  evangeliser stats              Show pattern library statistics
  evangeliser help               Show this help message

Options:
  --format plain|markdown|html  Output format (default: plain)
  --difficulty beginner|intermediate|advanced  Filter patterns by difficulty
  --view raw|folded|glyphed     View layer (default: raw)
  --target affinescript|rescript|rust|gleam|zig
                                Target language for transformations
                                (default: affinescript — the flagship target).
                                Patterns that have not yet been ported to the
                                requested target fall back to their first
                                available example with a note.

Examples:
  evangeliser scan app.js
  evangeliser scan utils.js --format markdown --view folded
  evangeliser scan app.js --target rescript
  evangeliser patterns --difficulty beginner
`
}

let showStats = (): string => {
  let stats = Patterns.getPatternStats()
  let lines = ref(`Pattern Library Statistics\n`)
  lines := lines.contents ++ `Total patterns: ${Int.toString(stats.total)}\n\n`
  lines := lines.contents ++ `By difficulty:\n`
  stats.byDifficulty->Dict.toArray->Array.forEach(((key, count)) => {
    lines := lines.contents ++ `  ${key}: ${Int.toString(count)}\n`
  })
  lines := lines.contents ++ `\nBy category:\n`
  stats.byCategory->Dict.toArray->Array.forEach(((key, count)) => {
    lines := lines.contents ++ `  ${key}: ${Int.toString(count)}\n`
  })

  // Also count patterns per target, so users can see coverage at a glance.
  let byTarget = Dict.make()
  Patterns.patternLibrary->Array.forEach(p => {
    p.targets->Array.forEach(t => {
      let key = targetLangLabel(t.language)
      let current = byTarget->Dict.get(key)->Option.getOr(0)
      byTarget->Dict.set(key, current + 1)
    })
  })
  lines := lines.contents ++ `\nBy target (patterns supplying that target):\n`
  byTarget->Dict.toArray->Array.forEach(((key, count)) => {
    lines := lines.contents ++ `  ${key}: ${Int.toString(count)}\n`
  })

  lines.contents
}

let run = (): unit => {
  let opts = parseArgs(argv)

  let output = switch opts.command {
  | "scan" =>
    switch opts.file {
    | None => "Error: Please specify a JavaScript file to scan.\n\nUsage: evangeliser scan <file.js>\n"
    | Some(filePath) =>
      try {
        let code = readFileSync(filePath, "utf-8")
        let result = switch opts.difficulty {
        | None => Analyser.analyse(code)
        | Some(diff) =>
          let filtered = Patterns.getPatternsByDifficulty(diff)
          Analyser.analyseWithPatterns(code, filtered)
        }
        Output.format(result, opts.view, opts.format, opts.target)
      } catch {
      | JsExn(e) =>
        let msg = e->JsExn.message->Option.getOr("Unknown error")
        `Error reading file '${filePath}': ${msg}\n`
      }
    }

  | "patterns" =>
    Output.formatPatternList(opts.format)

  | "legend" =>
    Glyphs.createGlyphLegend()

  | "stats" =>
    showStats()

  | "help" | "--help" | "-h" =>
    showHelp()

  | unknown =>
    `Unknown command: '${unknown}'\n\n` ++ showHelp()
  }

  Console.log(output)
}

// Execute
run()
