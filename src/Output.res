// SPDX-License-Identifier: PMPL-1.0-or-later
// Output: Format analysis results for terminal display
// Supports RAW, FOLDED, and GLYPHED view layers

open Types

// ANSI colour codes for terminal output
let bold = s => `\x1b[1m${s}\x1b[0m`
let green = s => `\x1b[32m${s}\x1b[0m`
let yellow = s => `\x1b[33m${s}\x1b[0m`
let cyan = s => `\x1b[36m${s}\x1b[0m`
let dim = s => `\x1b[2m${s}\x1b[0m`
let magenta = s => `\x1b[35m${s}\x1b[0m`

// Format a single pattern match for RAW view
let formatMatchRaw = (m: patternMatch, format: string): string => {
  let glyphBar = m.pattern.glyphs->Array.join(" ")
  let diffStr = difficultyToString(m.pattern.difficulty)
  let narrative = Narrative.formatNarrative(m.pattern.narrative, format)

  switch format {
  | "markdown" =>
    `### ${glyphBar} ${m.pattern.name}\n\n` ++
    `**Difficulty:** ${diffStr} | **Confidence:** ${Float.toFixed(m.pattern.confidence *. 100.0, ~digits=0)}%\n\n` ++
    `**JavaScript:**\n\`\`\`javascript\n${m.pattern.jsExample}\n\`\`\`\n\n` ++
    `**ReScript:**\n\`\`\`rescript\n${m.pattern.rescriptExample}\n\`\`\`\n\n` ++
    narrative ++ "\n\n---\n"

  | "html" =>
    `<div class="pattern-match">\n` ++
    `  <h3>${glyphBar} ${m.pattern.name}</h3>\n` ++
    `  <p><strong>Difficulty:</strong> ${diffStr} | <strong>Confidence:</strong> ${Float.toFixed(m.pattern.confidence *. 100.0, ~digits=0)}%</p>\n` ++
    `  <pre class="js"><code>${m.pattern.jsExample}</code></pre>\n` ++
    `  <pre class="rescript"><code>${m.pattern.rescriptExample}</code></pre>\n` ++
    narrative ++
    `\n</div>\n`

  | _ =>
    // plain text (terminal)
    bold(`${glyphBar} ${m.pattern.name}`) ++ "\n" ++
    dim(`Difficulty: ${diffStr} | Confidence: ${Float.toFixed(m.pattern.confidence *. 100.0, ~digits=0)}%`) ++ "\n\n" ++
    cyan("JavaScript:") ++ "\n" ++ m.pattern.jsExample ++ "\n\n" ++
    green("ReScript:") ++ "\n" ++ m.pattern.rescriptExample ++ "\n\n" ++
    narrative ++ "\n\n" ++
    dim("---") ++ "\n"
  }
}

// Format analysis results in RAW view (each match shown individually)
let formatRaw = (result: analysisResult, format: string): string => {
  if result.matches->Array.length === 0 {
    "No patterns detected. Try pasting some JavaScript code!\n"
  } else {
    let header = switch format {
    | "markdown" => "# Nextgen Languages Evangeliser - Analysis Results\n\n"
    | "html" => "<h1>Nextgen Languages Evangeliser - Analysis Results</h1>\n"
    | _ => bold("Nextgen Languages Evangeliser - Analysis Results") ++ "\n\n"
    }

    let summary = Analyser.summarise(result)
    let matches =
      result.matches
      ->Array.map(m => formatMatchRaw(m, format))
      ->Array.join("\n")

    header ++ summary ++ "\n\n" ++ matches
  }
}

// Format analysis results in FOLDED view (grouped by category)
let formatFolded = (result: analysisResult, format: string): string => {
  if result.matches->Array.length === 0 {
    "No patterns detected. Try pasting some JavaScript code!\n"
  } else {
    let header = switch format {
    | "markdown" => "# Nextgen Languages Evangeliser - Analysis Results (Grouped)\n\n"
    | "html" => "<h1>Nextgen Languages Evangeliser - Analysis Results (Grouped)</h1>\n"
    | _ => bold("Nextgen Languages Evangeliser - Analysis Results (Grouped)") ++ "\n\n"
    }

    let summary = Analyser.summarise(result)

    // Group matches by category
    let groups: Dict.t<array<patternMatch>> = Dict.make()
    result.matches->Array.forEach(m => {
      let cat = categoryToString(m.pattern.category)
      let existing = groups->Dict.get(cat)->Option.getOr([])
      groups->Dict.set(cat, existing->Array.concat([m]))
    })

    let body =
      groups
      ->Dict.toArray
      ->Array.map(((cat, matches)) => {
        let catHeader = switch format {
        | "markdown" => `## ${cat} (${Int.toString(matches->Array.length)} matches)\n\n`
        | "html" => `<h2>${cat} (${Int.toString(matches->Array.length)} matches)</h2>\n`
        | _ => yellow(`[${cat}]`) ++ ` ${dim(`(${Int.toString(matches->Array.length)} matches)`)}` ++ "\n\n"
        }
        let matchStr =
          matches
          ->Array.map(m => formatMatchRaw(m, format))
          ->Array.join("\n")
        catHeader ++ matchStr
      })
      ->Array.join("\n")

    header ++ summary ++ "\n\n" ++ body
  }
}

// Format analysis results in GLYPHED view (glyph-annotated summary)
let formatGlyphed = (result: analysisResult, format: string): string => {
  if result.matches->Array.length === 0 {
    "No patterns detected. Try pasting some JavaScript code!\n"
  } else {
    let header = switch format {
    | "markdown" => "# Nextgen Languages Evangeliser - Glyph Overview\n\n"
    | "html" => "<h1>Nextgen Languages Evangeliser - Glyph Overview</h1>\n"
    | _ => bold("Nextgen Languages Evangeliser - Glyph Overview") ++ "\n\n"
    }

    let uniquePatterns = Scanner.uniquePatterns(result.matches)

    let glyphMap =
      uniquePatterns
      ->Array.map(p => {
        let glyphs = p.glyphs->Array.join(" ")
        switch format {
        | "markdown" => `- ${glyphs} **${p.name}**: ${p.narrative.better}\n`
        | "html" => `<li>${glyphs} <strong>${p.name}</strong>: ${p.narrative.better}</li>\n`
        | _ => `${glyphs} ${magenta(p.name)}: ${p.narrative.better}\n`
        }
      })
      ->Array.join("")

    let legend = switch format {
    | "plain" => "\n" ++ dim("Use 'evangeliser legend' to see the full glyph legend.") ++ "\n"
    | _ => ""
    }

    header ++ Analyser.summarise(result) ++ "\n\n" ++ glyphMap ++ legend
  }
}

// Format results using the specified view layer
let format = (result: analysisResult, view: viewLayer, outputFormat: string): string => {
  switch view {
  | RAW => formatRaw(result, outputFormat)
  | FOLDED => formatFolded(result, outputFormat)
  | GLYPHED => formatGlyphed(result, outputFormat)
  | WYSIWYG => formatRaw(result, "html") // WYSIWYG falls back to HTML for now
  }
}

// Format the pattern list for the `patterns` command
let formatPatternList = (format: string): string => {
  let stats = Patterns.getPatternStats()
  let header = switch format {
  | "markdown" =>
    `# Pattern Library (${Int.toString(stats.total)} patterns)\n\n`
  | _ =>
    bold(`Pattern Library (${Int.toString(stats.total)} patterns)`) ++ "\n\n"
  }

  let categories = [
    NullSafety, Async, ErrorHandling, ArrayOperations, Conditionals,
    Destructuring, Defaults, Functional, Templates, ArrowFunctions,
    Variants, Modules, TypeSafety, Immutability, PatternMatching,
    PipeOperator, OopToFp, ClassesToRecords, InheritanceToComposition,
    StateMachines, DataModeling,
  ]

  let body =
    categories
    ->Array.map(cat => {
      let patterns = Patterns.getPatternsByCategory(cat)
      let catStr = categoryToString(cat)
      let glyphs = Glyphs.getGlyphsForPattern(cat)->Array.join(" ")
      let catHeader = switch format {
      | "markdown" =>
        `## ${glyphs} ${catStr} (${Int.toString(patterns->Array.length)})\n\n`
      | _ =>
        yellow(`${glyphs} ${catStr}`) ++ dim(` (${Int.toString(patterns->Array.length)})`) ++ "\n"
      }

      let patternList =
        patterns
        ->Array.map(p => {
          let diffStr = difficultyToString(p.difficulty)
          switch format {
          | "markdown" =>
            `- **${p.name}** (${diffStr}) - ${p.narrative.celebrate}\n`
          | _ =>
            `  ${green(p.name)} ${dim(`[${diffStr}]`)} ${p.narrative.celebrate}\n`
          }
        })
        ->Array.join("")

      catHeader ++ patternList ++ "\n"
    })
    ->Array.join("")

  header ++ body
}
