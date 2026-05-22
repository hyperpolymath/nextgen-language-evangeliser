// SPDX-License-Identifier: MPL-2.0
// Analyser: Orchestrates scanning and produces analysis results
// Computes coverage, difficulty assessment, and pattern suggestions

open Types

// Determine overall difficulty based on matched patterns
let assessDifficulty = (matches: array<patternMatch>): difficultyLevel => {
  let advancedCount = matches->Array.filter(m => m.pattern.difficulty === Advanced)->Array.length
  let intermediateCount =
    matches->Array.filter(m => m.pattern.difficulty === Intermediate)->Array.length

  if advancedCount > 0 {
    Advanced
  } else if intermediateCount > 0 {
    Intermediate
  } else {
    Beginner
  }
}

// Suggest next patterns to learn based on what was matched
let suggestNextPatterns = (
  matches: array<patternMatch>,
  allPatterns: array<pattern>,
): array<pattern> => {
  let matchedIds = matches->Array.map(m => m.pattern.id)
  let matchedCategories =
    matches
    ->Array.map(m => categoryToString(m.pattern.category))
    ->Set.fromArray

  // Suggest related patterns from matched categories that weren't found
  let relatedSuggestions =
    matches
    ->Array.flatMap(m => m.pattern.relatedPatterns)
    ->Array.filter(id => !(matchedIds->Array.includes(id)))
    ->Array.filterMap(id => allPatterns->Array.find(p => p.id === id))

  // Suggest patterns from unmatched categories (prioritise Beginner)
  let unmatchedCategorySuggestions =
    allPatterns
    ->Array.filter(p => !(matchedCategories->Set.has(categoryToString(p.category))))
    ->Array.filter(p => p.difficulty === Beginner)

  // Combine, deduplicate, take top 5
  let seen = Dict.make()
  Array.concat(relatedSuggestions, unmatchedCategorySuggestions)
  ->Array.filter(p => {
    switch seen->Dict.get(p.id) {
    | Some(_) => false
    | None =>
      seen->Dict.set(p.id, true)
      true
    }
  })
  ->Array.slice(~start=0, ~end=5)
}

// Compute coverage: what percentage of available categories were matched
let computeCoverage = (matches: array<patternMatch>): float => {
  let totalCategories = 20 // from Types.patternCategory
  let matchedCategories =
    matches
    ->Array.map(m => categoryToString(m.pattern.category))
    ->Set.fromArray
    ->Set.size

  if totalCategories === 0 {
    0.0
  } else {
    Int.toFloat(matchedCategories) /. Int.toFloat(totalCategories) *. 100.0
  }
}

// Run full analysis on a code string
let analyse = (code: string): analysisResult => {
  let startTime = Date.now()
  let matches = Scanner.scanAll(code)
  let endTime = Date.now()

  {
    matches,
    totalPatterns: Patterns.getPatternCount(),
    coveragePercentage: computeCoverage(matches),
    difficulty: assessDifficulty(matches),
    suggestedNextPatterns: suggestNextPatterns(matches, Patterns.patternLibrary),
    analysisTime: endTime -. startTime,
    memoryUsed: 0,
  }
}

// Analyse with a custom pattern set
let analyseWithPatterns = (code: string, patterns: array<pattern>): analysisResult => {
  let startTime = Date.now()
  let matches = Scanner.scanCode(code, patterns)
  let endTime = Date.now()

  {
    matches,
    totalPatterns: patterns->Array.length,
    coveragePercentage: computeCoverage(matches),
    difficulty: assessDifficulty(matches),
    suggestedNextPatterns: suggestNextPatterns(matches, patterns),
    analysisTime: endTime -. startTime,
    memoryUsed: 0,
  }
}

// Generate a narrative summary for the analysis
let summarise = (result: analysisResult): string => {
  let matchCount = result.matches->Array.length
  let uniquePatterns = Scanner.uniquePatterns(result.matches)->Array.length
  let diffStr = difficultyToString(result.difficulty)
  let coverageStr = Float.toFixed(result.coveragePercentage, ~digits=1)

  if matchCount === 0 {
    "No JavaScript patterns detected. Try pasting some JavaScript code to see how ReScript can improve it!"
  } else {
    let patternsWord = if uniquePatterns === 1 { "pattern" } else { "patterns" }
    `Found ${Int.toString(matchCount)} match(es) across ${Int.toString(uniquePatterns)} unique ${patternsWord}.\n` ++
    `Code complexity: ${diffStr}\n` ++
    `Category coverage: ${coverageStr}%\n` ++
    if result.suggestedNextPatterns->Array.length > 0 {
      let suggestions =
        result.suggestedNextPatterns
        ->Array.map(p => p.name)
        ->Array.join(", ")
      `\nSuggested next patterns to explore: ${suggestions}`
    } else {
      ""
    }
  }
}
