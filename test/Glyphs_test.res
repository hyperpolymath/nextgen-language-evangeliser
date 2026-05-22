// SPDX-License-Identifier: MPL-2.0
// Tests for Glyphs module

open Types

let assert_ = (condition, message) => {
  if !condition {
    JsError.throwWithMessage(`FAIL: ${message}`)
  }
}

let testGetAllGlyphs = () => {
  let all = Glyphs.getAllGlyphs()
  assert_(all->Array.length === 21, `getAllGlyphs returns 21 glyphs, got ${Int.toString(all->Array.length)}`)
  Console.log("PASS: getAllGlyphs returns 21 glyphs (11 core + 10 extended)")
}

let testGetGlyphBySymbol = () => {
  switch Glyphs.getGlyphBySymbol(`🔄`) {
  | Some(g) => assert_(g.name === "Transform", "Transform glyph found by symbol")
  | None => JsError.throwWithMessage("FAIL: Transform glyph not found by symbol")
  }

  switch Glyphs.getGlyphBySymbol(`🛡️`) {
  | Some(g) => assert_(g.name === "Shield", "Shield glyph found by symbol")
  | None => JsError.throwWithMessage("FAIL: Shield glyph not found by symbol")
  }

  switch Glyphs.getGlyphBySymbol("NONEXISTENT") {
  | Some(_) => JsError.throwWithMessage("FAIL: Nonexistent glyph should return None")
  | None => ()
  }
  Console.log("PASS: getGlyphBySymbol - found and not-found cases")
}

let testGetGlyphsByCategory = () => {
  let safetyGlyphs = Glyphs.getGlyphsByCategory(Safety)
  assert_(safetyGlyphs->Array.length > 0, "Safety category has glyphs")

  let transformGlyphs = Glyphs.getGlyphsByCategory(Transformation)
  assert_(transformGlyphs->Array.length > 0, "Transformation category has glyphs")

  let flowGlyphs = Glyphs.getGlyphsByCategory(Flow)
  assert_(flowGlyphs->Array.length > 0, "Flow category has glyphs")

  let structureGlyphs = Glyphs.getGlyphsByCategory(Structure)
  assert_(structureGlyphs->Array.length > 0, "Structure category has glyphs")

  let dataGlyphs = Glyphs.getGlyphsByCategory(Data)
  assert_(dataGlyphs->Array.length > 0, "Data category has glyphs")

  Console.log("PASS: getGlyphsByCategory - all semantic categories have glyphs")
}

let testGetGlyphsForPattern = () => {
  // Every pattern category should map to exactly 3 glyphs
  let categories: array<patternCategory> = [
    NullSafety, Async, ErrorHandling, ArrayOperations, Conditionals,
    Destructuring, Defaults, Functional, Templates, ArrowFunctions,
    Variants, Modules, TypeSafety, Immutability, PatternMatching,
    PipeOperator, OopToFp, ClassesToRecords, InheritanceToComposition,
    StateMachines, DataModeling,
  ]

  categories->Array.forEach(cat => {
    let glyphs = Glyphs.getGlyphsForPattern(cat)
    assert_(
      glyphs->Array.length === 3,
      `${categoryToString(cat)} should have 3 glyphs, got ${Int.toString(glyphs->Array.length)}`,
    )
  })
  Console.log("PASS: getGlyphsForPattern - all 21 categories map to 3 glyphs each")
}

let testAnnotateWithGlyphs = () => {
  let result = Glyphs.annotateWithGlyphs("some code", [`🔄`, `🛡️`])
  assert_(String.includes(result, `🔄`), "annotated code includes first glyph")
  assert_(String.includes(result, "some code"), "annotated code includes original code")
  Console.log("PASS: annotateWithGlyphs - glyphs prepended to code")
}

let testCreateGlyphLegend = () => {
  let legend = Glyphs.createGlyphLegend()
  assert_(String.includes(legend, "Glyph Legend"), "legend has header")
  assert_(String.includes(legend, "Safety"), "legend includes Safety category")
  assert_(String.includes(legend, "Transformation"), "legend includes Transformation category")
  assert_(String.includes(legend, "Flow"), "legend includes Flow category")
  assert_(String.includes(legend, "Structure"), "legend includes Structure category")
  assert_(String.includes(legend, "Data"), "legend includes Data category")
  Console.log("PASS: createGlyphLegend - contains all category sections")
}

let runAll = () => {
  Console.log("=== Glyphs Tests ===")
  testGetAllGlyphs()
  testGetGlyphBySymbol()
  testGetGlyphsByCategory()
  testGetGlyphsForPattern()
  testAnnotateWithGlyphs()
  testCreateGlyphLegend()
  Console.log("=== All Glyphs tests passed ===\n")
}

runAll()
