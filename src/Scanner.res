// SPDX-License-Identifier: PMPL-1.0-or-later
// Scanner: Matches JavaScript code against pattern library using regex detection
// Returns detailed patternMatch results with line numbers and confidence scores

open Types

// Create regex from pattern string (reuse from Patterns)
@val external createRegex: (string, string) => Nullable.t<RegExp.t> = "RegExp"

// Split code into lines for line-number tracking
let splitLines = (code: string): array<string> => {
  code->String.split("\n")
}

// Find the line number where a match occurs in the source code
let findMatchLine = (code: string, matchedText: string): int => {
  let lines = splitLines(code)
  let foundLine = ref(1)
  lines->Array.forEachWithIndex((line, idx) => {
    if String.includes(line, String.slice(matchedText, ~start=0, ~end=Math.Int.min(40, String.length(matchedText)))) {
      foundLine := idx + 1
    }
  })
  foundLine.contents
}

// Count the number of lines in a matched code fragment
let countMatchLines = (matchedText: string): int => {
  splitLines(matchedText)->Array.length
}

// Scan a block of code against a single pattern, returning matches
let scanPattern = (code: string, pattern: pattern): array<patternMatch> => {
  switch createRegex(pattern.jsPattern, "gm")->Nullable.toOption {
  | None => []
  | Some(regex) =>
    let matches = ref([])
    let safetyCounter = ref(0)
    let continue_ = ref(true)

    while continue_.contents && safetyCounter.contents < 1000 {
      safetyCounter := safetyCounter.contents + 1
      switch regex->RegExp.exec(code) {
      | None => continue_ := false
      | Some(result) =>
        let matchedText = result->RegExp.Result.input
        let startLine = findMatchLine(code, matchedText)
        let endLine = startLine + countMatchLines(matchedText) - 1

        matches :=
          matches.contents->Array.concat([
            {
              pattern,
              code: matchedText,
              startLine,
              endLine,
              confidence: pattern.confidence,
              // Use flagship target's code as the offered transformation;
              // falls back to whatever target the pattern does support.
              transformation: Some(patternCodeFor(pattern, flagshipTarget)),
            },
          ])
      }
    }

    matches.contents
  }
}

// Scan code against all patterns in the library
let scanCode = (code: string, patterns: array<pattern>): array<patternMatch> => {
  patterns
  ->Array.flatMap(pattern => scanPattern(code, pattern))
  ->Array.toSorted((a, b) => {
    // Sort by confidence descending, then by line number ascending
    let confDiff = b.confidence -. a.confidence
    if confDiff != 0.0 {
      confDiff
    } else {
      Int.toFloat(a.startLine - b.startLine)
    }
  })
}

// Scan code against the full pattern library
let scanAll = (code: string): array<patternMatch> => {
  scanCode(code, Patterns.patternLibrary)
}

// Get unique patterns matched (deduplicated by pattern ID)
let uniquePatterns = (matches: array<patternMatch>): array<pattern> => {
  let seen = Dict.make()
  matches->Array.filter(m => {
    switch seen->Dict.get(m.pattern.id) {
    | Some(_) => false
    | None =>
      seen->Dict.set(m.pattern.id, true)
      true
    }
  })->Array.map(m => m.pattern)
}

// Count matches per category
let matchesByCategory = (matches: array<patternMatch>): Dict.t<int> => {
  let counts = Dict.make()
  matches->Array.forEach(m => {
    let cat = categoryToString(m.pattern.category)
    let current = counts->Dict.get(cat)->Option.getOr(0)
    counts->Dict.set(cat, current + 1)
  })
  counts
}
