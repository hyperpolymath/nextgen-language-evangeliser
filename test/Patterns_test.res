// SPDX-License-Identifier: PMPL-1.0-or-later
// Tests for Patterns module - pattern registry completeness

open Types

let assert_ = (condition, message) => {
  if !condition {
    JsError.throwWithMessage(`FAIL: ${message}`)
  }
}

let testPatternCount = () => {
  let count = Patterns.getPatternCount()
  assert_(count >= 50, `Expected 50+ patterns, got ${Int.toString(count)}`)
  Console.log(`PASS: Pattern count is ${Int.toString(count)} (target: 50+)`)
}

let testAllCategoriesHavePatterns = () => {
  let categories: array<patternCategory> = [
    NullSafety, Async, ErrorHandling, ArrayOperations, Conditionals,
    Destructuring, Defaults, Functional, Templates, ArrowFunctions,
    Variants, Modules, TypeSafety, Immutability, PatternMatching,
    PipeOperator, OopToFp, ClassesToRecords, InheritanceToComposition,
    StateMachines, DataModeling,
  ]

  let missingCategories = categories->Array.filter(cat => {
    Patterns.getPatternsByCategory(cat)->Array.length === 0
  })

  if missingCategories->Array.length > 0 {
    let missing =
      missingCategories
      ->Array.map(cat => categoryToString(cat))
      ->Array.join(", ")
    JsError.throwWithMessage(`FAIL: Categories with no patterns: ${missing}`)
  }
  Console.log("PASS: All 21 categories have at least one pattern")
}

let testPatternIdsAreUnique = () => {
  let seen = Dict.make()
  let duplicates = ref([])

  Patterns.patternLibrary->Array.forEach(p => {
    switch seen->Dict.get(p.id) {
    | Some(_) => duplicates := duplicates.contents->Array.concat([p.id])
    | None => seen->Dict.set(p.id, true)
    }
  })

  if duplicates.contents->Array.length > 0 {
    JsError.throwWithMessage(`FAIL: Duplicate pattern IDs: ${duplicates.contents->Array.join(", ")}`)
  }
  Console.log("PASS: All pattern IDs are unique")
}

let testPatternsHaveRequiredFields = () => {
  Patterns.patternLibrary->Array.forEach(p => {
    assert_(String.length(p.id) > 0, `Pattern missing id`)
    assert_(String.length(p.name) > 0, `Pattern ${p.id} missing name`)
    assert_(String.length(p.jsPattern) > 0, `Pattern ${p.id} missing jsPattern`)
    assert_(p.confidence > 0.0 && p.confidence <= 1.0, `Pattern ${p.id} confidence out of range`)
    assert_(String.length(p.jsExample) > 0, `Pattern ${p.id} missing jsExample`)
    assert_(p.targets->Array.length > 0, `Pattern ${p.id} has no target examples`)
    p.targets->Array.forEach(t => {
      assert_(String.length(t.code) > 0, `Pattern ${p.id} has empty code for target ${targetLangLabel(t.language)}`)
    })
    assert_(String.length(p.narrative.celebrate) > 0, `Pattern ${p.id} missing narrative.celebrate`)
    assert_(String.length(p.narrative.minimize) > 0, `Pattern ${p.id} missing narrative.minimize`)
    assert_(String.length(p.narrative.better) > 0, `Pattern ${p.id} missing narrative.better`)
    assert_(String.length(p.narrative.safety) > 0, `Pattern ${p.id} missing narrative.safety`)
    assert_(p.tags->Array.length > 0, `Pattern ${p.id} missing tags`)
    assert_(p.learningObjectives->Array.length > 0, `Pattern ${p.id} missing learningObjectives`)
    assert_(p.glyphs->Array.length === 3, `Pattern ${p.id} should have 3 glyphs`)
  })
  Console.log("PASS: All patterns have required fields populated")
}

let testGetPatternById = () => {
  switch Patterns.getPatternById("null-check-basic") {
  | Some(p) => assert_(p.name === "Basic Null Check", "Found null-check-basic by ID")
  | None => JsError.throwWithMessage("FAIL: null-check-basic not found")
  }

  switch Patterns.getPatternById("nonexistent") {
  | Some(_) => JsError.throwWithMessage("FAIL: nonexistent pattern should return None")
  | None => ()
  }
  Console.log("PASS: getPatternById - found and not-found cases")
}

let testGetPatternsByDifficulty = () => {
  let beginnerPatterns = Patterns.getPatternsByDifficulty(Beginner)
  let intermediatePatterns = Patterns.getPatternsByDifficulty(Intermediate)
  let advancedPatterns = Patterns.getPatternsByDifficulty(Advanced)

  assert_(beginnerPatterns->Array.length > 0, "Has beginner patterns")
  assert_(intermediatePatterns->Array.length > 0, "Has intermediate patterns")
  assert_(advancedPatterns->Array.length > 0, "Has advanced patterns")

  let total =
    beginnerPatterns->Array.length +
    intermediatePatterns->Array.length +
    advancedPatterns->Array.length
  assert_(
    total === Patterns.getPatternCount(),
    "Difficulty counts sum to total",
  )
  Console.log("PASS: getPatternsByDifficulty - all difficulty levels populated, sum matches total")
}

let testGetPatternStats = () => {
  let stats = Patterns.getPatternStats()
  assert_(stats.total === Patterns.getPatternCount(), "stats.total matches getPatternCount")

  let catTotal = ref(0)
  stats.byCategory->Dict.toArray->Array.forEach(((_key, count)) => {
    catTotal := catTotal.contents + count
  })
  assert_(catTotal.contents === stats.total, "category counts sum to total")

  let diffTotal = ref(0)
  stats.byDifficulty->Dict.toArray->Array.forEach(((_key, count)) => {
    diffTotal := diffTotal.contents + count
  })
  assert_(diffTotal.contents === stats.total, "difficulty counts sum to total")
  Console.log("PASS: getPatternStats - totals are consistent")
}

let runAll = () => {
  Console.log("=== Patterns Tests ===")
  testPatternCount()
  testAllCategoriesHavePatterns()
  testPatternIdsAreUnique()
  testPatternsHaveRequiredFields()
  testGetPatternById()
  testGetPatternsByDifficulty()
  testGetPatternStats()
  Console.log("=== All Patterns tests passed ===\n")
}

runAll()
