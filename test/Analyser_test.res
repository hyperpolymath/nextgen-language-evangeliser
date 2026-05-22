// SPDX-License-Identifier: MPL-2.0
// Tests for Analyser module - end-to-end analysis pipeline

open Types

let assert_ = (condition, message) => {
  if !condition {
    JsError.throwWithMessage(`FAIL: ${message}`)
  }
}

let testAnalyseEmptyCode = () => {
  let result = Analyser.analyse("")
  assert_(result.matches->Array.length === 0, "Empty code produces no matches")
  assert_(result.coveragePercentage === 0.0, "Empty code has 0% coverage")
  assert_(result.difficulty === Beginner, "Empty code defaults to Beginner difficulty")
  Console.log("PASS: analyse('') returns empty result with Beginner difficulty")
}

let testAnalyseSimpleJS = () => {
  let code = `const doubled = numbers.map(n => n * 2);
const evens = numbers.filter(n => n % 2 === 0);`
  let result = Analyser.analyse(code)
  assert_(result.matches->Array.length > 0, "Simple JS code produces matches")
  assert_(result.totalPatterns > 0, "totalPatterns is populated")
  assert_(result.analysisTime >= 0.0, "analysisTime is non-negative")
  Console.log("PASS: analyse with simple JS produces matches")
}

let testAnalyseComplexJS = () => {
  let code = `
async function fetchUsers() {
  try {
    const response = await fetch('/api/users');
    const users = await response.json();
    return users.map(u => u.name).filter(n => n !== null);
  } catch (error) {
    console.error(error);
    return [];
  }
}

if (user !== null && user !== undefined) {
  const { name, email } = user;
  const displayName = name ?? 'Anonymous';
}
`
  let result = Analyser.analyse(code)
  assert_(result.matches->Array.length >= 3, "Complex JS matches multiple patterns")
  assert_(result.coveragePercentage > 0.0, "Complex JS has non-zero coverage")
  Console.log(`PASS: Complex JS analysis found ${Int.toString(result.matches->Array.length)} matches, ${Float.toFixed(result.coveragePercentage, ~digits=1)}% coverage`)
}

let testDifficultyAssessment = () => {
  // Beginner-only code
  let beginnerCode = `const doubled = numbers.map(n => n * 2);`
  let beginnerResult = Analyser.analyse(beginnerCode)
  assert_(beginnerResult.difficulty === Beginner, "Simple map code is Beginner")

  // Code with advanced patterns
  let advancedCode = `class Dog extends Animal { speak() { return 'Woof!'; } }`
  let advancedResult = Analyser.analyse(advancedCode)
  assert_(advancedResult.difficulty === Advanced, "Inheritance code is Advanced")

  Console.log("PASS: Difficulty assessment - Beginner and Advanced correctly identified")
}

let testSuggestedNextPatterns = () => {
  let code = `const doubled = numbers.map(n => n * 2);`
  let result = Analyser.analyse(code)
  assert_(result.suggestedNextPatterns->Array.length > 0, "Suggestions provided")
  assert_(result.suggestedNextPatterns->Array.length <= 5, "At most 5 suggestions")
  Console.log("PASS: suggestedNextPatterns returns 1-5 suggestions")
}

let testAnalyseWithPatterns = () => {
  let code = `const doubled = numbers.map(n => n * 2);`
  let onlyArrayPatterns = Patterns.getPatternsByCategory(ArrayOperations)
  let result = Analyser.analyseWithPatterns(code, onlyArrayPatterns)
  assert_(result.totalPatterns === onlyArrayPatterns->Array.length, "totalPatterns matches custom set")
  Console.log("PASS: analyseWithPatterns uses custom pattern set")
}

let testSummarise = () => {
  let emptyResult = Analyser.analyse("")
  let emptySummary = Analyser.summarise(emptyResult)
  assert_(String.includes(emptySummary, "No JavaScript patterns"), "Empty summary has helpful message")

  let code = `const doubled = numbers.map(n => n * 2);`
  let result = Analyser.analyse(code)
  let summary = Analyser.summarise(result)
  assert_(String.includes(summary, "match"), "Summary mentions matches")
  assert_(String.includes(summary, "coverage"), "Summary mentions coverage")
  Console.log("PASS: summarise - empty and non-empty results produce appropriate messages")
}

let testCoverageCalculation = () => {
  // Code that touches many categories
  let code = `
const doubled = numbers.map(n => n * 2);
async function f() { await fetch('/api'); }
try { x(); } catch(e) { console.log(e); }
if (x > 10) { return 'large'; } else if (x > 5) { return 'medium'; } else { return 'small'; }
const { name } = user;
const updated = { ...user, name: 'New' };
`
  let result = Analyser.analyse(code)
  // Should have coverage > 0 and < 100 (we won't match all 21 categories)
  assert_(result.coveragePercentage > 0.0, "Multi-category code has positive coverage")
  assert_(result.coveragePercentage <= 100.0, "Coverage is at most 100%")
  Console.log(`PASS: Coverage calculation - ${Float.toFixed(result.coveragePercentage, ~digits=1)}% for multi-category code`)
}

let runAll = () => {
  Console.log("=== Analyser Tests ===")
  testAnalyseEmptyCode()
  testAnalyseSimpleJS()
  testAnalyseComplexJS()
  testDifficultyAssessment()
  testSuggestedNextPatterns()
  testAnalyseWithPatterns()
  testSummarise()
  testCoverageCalculation()
  Console.log("=== All Analyser tests passed ===\n")
}

runAll()
