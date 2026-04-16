// SPDX-License-Identifier: PMPL-1.0-or-later
// Tests for Narrative module

open Types

let assert_ = (condition, message) => {
  if !condition {
    JsError.throwWithMessage(`FAIL: ${message}`)
  }
}

let testGetTemplateForCategory = () => {
  // Categories with explicit templates
  let categoriesWithTemplates = [
    NullSafety, Async, ErrorHandling, ArrayOperations, Conditionals, Functional,
  ]

  categoriesWithTemplates->Array.forEach(cat => {
    let _template = Narrative.getTemplateForCategory(cat)
    // If it returned without error, the template exists
    ()
  })

  // Categories without templates should fall back to default
  let _defaultTemplate = Narrative.getTemplateForCategory(Destructuring)
  Console.log("PASS: getTemplateForCategory - 6 explicit + fallback to default")
}

let testGenerateCategoryNarrative = () => {
  let narrative = Narrative.generateCategoryNarrative(NullSafety, "Test Pattern")
  assert_(String.length(narrative.celebrate) > 0, "celebrate is non-empty")
  assert_(String.length(narrative.minimize) > 0, "minimize is non-empty")
  assert_(String.length(narrative.better) > 0, "better is non-empty")
  assert_(String.length(narrative.safety) > 0, "safety is non-empty")
  assert_(String.includes(narrative.example, "Test Pattern"), "example mentions pattern name")
  Console.log("PASS: generateCategoryNarrative - all narrative fields populated")
}

let testFormatNarrative = () => {
  let narrative: narrative = {
    celebrate: "Great job!",
    minimize: "Just a small thing...",
    better: "ReScript makes it better!",
    safety: "Type-safe guaranteed.",
    example: "See example here.",
  }

  let plain = Narrative.formatNarrative(narrative, "plain")
  assert_(String.includes(plain, "Great job!"), "plain format includes celebrate")
  assert_(String.includes(plain, "Safety:"), "plain format includes safety label")

  let html = Narrative.formatNarrative(narrative, "html")
  assert_(String.includes(html, "<div class=\"narrative\">"), "html format has narrative div")
  assert_(String.includes(html, "celebrate"), "html format has celebrate class")

  let markdown = Narrative.formatNarrative(narrative, "markdown")
  assert_(String.includes(markdown, "**You were close!**"), "markdown format has bold header")
  assert_(String.includes(markdown, "**Safety:**"), "markdown format has safety header")

  Console.log("PASS: formatNarrative - plain, html, markdown all formatted correctly")
}

let testGenerateSuccessMessage = () => {
  let msg = Narrative.generateSuccessMessage("Array.map", "beginner")
  assert_(String.includes(msg, "Array.map"), "success message mentions pattern name")
  assert_(String.length(msg) > 10, "success message is non-trivial")
  Console.log("PASS: generateSuccessMessage - includes pattern name")
}

let testGenerateHint = () => {
  let mockPattern: pattern = {
    id: "test",
    name: "Test",
    category: NullSafety,
    difficulty: Beginner,
    jsPattern: "",
    confidence: 0.9,
    jsExample: "",
    targets: [{language: ReScript, code: ""}],
    narrative: {
      celebrate: "",
      minimize: "",
      better: "",
      safety: "",
      example: "",
    },
    glyphs: [],
    tags: [],
    relatedPatterns: [],
    learningObjectives: ["Learn Option type"],
    commonMistakes: ["Forgetting None"],
    bestPractices: ["Always handle None"],
  }

  let hint = Narrative.generateHint(mockPattern)
  assert_(String.length(hint) > 0, "hint is non-empty")
  Console.log("PASS: generateHint - returns non-empty hint")
}

let runAll = () => {
  Console.log("=== Narrative Tests ===")
  testGetTemplateForCategory()
  testGenerateCategoryNarrative()
  testFormatNarrative()
  testGenerateSuccessMessage()
  testGenerateHint()
  Console.log("=== All Narrative tests passed ===\n")
}

runAll()
