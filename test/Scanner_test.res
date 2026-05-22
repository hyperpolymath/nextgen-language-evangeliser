// SPDX-License-Identifier: MPL-2.0
// Tests for Scanner module - regex matching against known JS snippets

open Types

let assert_ = (condition, message) => {
  if !condition {
    JsError.throwWithMessage(`FAIL: ${message}`)
  }
}

let testScanDetectsNullChecks = () => {
  let code = `if (user !== null && user !== undefined) {
  console.log(user.name);
}`
  let matches = Scanner.scanAll(code)
  let hasNullSafety = matches->Array.some(m => m.pattern.category === NullSafety)
  assert_(hasNullSafety, "Detects null safety pattern in null check code")
  Console.log("PASS: Detects null check patterns")
}

let testScanDetectsAsyncAwait = () => {
  let code = `async function fetchData() {
  const response = await fetch('/api/data');
  return await response.json();
}`
  let matches = Scanner.scanAll(code)
  let hasAsync = matches->Array.some(m => m.pattern.category === Async)
  assert_(hasAsync, "Detects async pattern in async/await code")
  Console.log("PASS: Detects async/await patterns")
}

let testScanDetectsArrayOps = () => {
  let code = `const doubled = numbers.map(n => n * 2);
const evens = numbers.filter(n => n % 2 === 0);
const sum = numbers.reduce((acc, n) => acc + n, 0);`
  let matches = Scanner.scanAll(code)
  let arrayMatches = matches->Array.filter(m => m.pattern.category === ArrayOperations)
  assert_(arrayMatches->Array.length >= 3, `Detects at least 3 array operations, got ${Int.toString(arrayMatches->Array.length)}`)
  Console.log("PASS: Detects map, filter, reduce array operations")
}

let testScanDetectsTryCatch = () => {
  let code = `try {
  const result = riskyOperation();
  return result;
} catch (error) {
  console.error(error);
}`
  let matches = Scanner.scanAll(code)
  let hasError = matches->Array.some(m => m.pattern.category === ErrorHandling)
  assert_(hasError, "Detects error handling in try/catch code")
  Console.log("PASS: Detects try/catch error handling")
}

let testScanDetectsSwitch = () => {
  let code = `switch (status) {
  case 'loading': return 'Loading...';
  case 'success': return data;
  default: return null;
}`
  let matches = Scanner.scanAll(code)
  let hasConditional = matches->Array.some(m => m.pattern.category === Conditionals)
  assert_(hasConditional, "Detects conditional pattern in switch code")
  Console.log("PASS: Detects switch statement patterns")
}

let testScanDetectsPromiseThen = () => {
  let code = `fetch('/api').then(res => res.json()).then(data => console.log(data));`
  let matches = Scanner.scanAll(code)
  let hasAsync = matches->Array.some(m => m.pattern.id === "promise-then")
  assert_(hasAsync, "Detects Promise.then pattern")
  Console.log("PASS: Detects Promise.then chains")
}

let testScanDetectsSpreadOperator = () => {
  let code = `const updated = { ...user, name: 'New Name' };`
  let matches = Scanner.scanAll(code)
  let hasSpread = matches->Array.some(m => m.pattern.id === "spread-to-update")
  assert_(hasSpread, "Detects spread operator")
  Console.log("PASS: Detects spread operator for immutable updates")
}

let testScanDetectsClassInheritance = () => {
  let code = `class Dog extends Animal { speak() { return 'Woof!'; } }`
  let matches = Scanner.scanAll(code)
  let hasInheritance = matches->Array.some(m => m.pattern.category === InheritanceToComposition)
  assert_(hasInheritance, "Detects class inheritance")
  Console.log("PASS: Detects class inheritance pattern")
}

let testScanReturnsEmptyForCleanCode = () => {
  let code = `// just a comment`
  let matches = Scanner.scanAll(code)
  assert_(matches->Array.length === 0, "No matches for comment-only code")
  Console.log("PASS: Returns empty for code with no patterns")
}

let testScanSortsByConfidence = () => {
  let code = `
const doubled = numbers.map(n => n * 2);
const city = user?.address?.city;
`
  let matches = Scanner.scanAll(code)
  if matches->Array.length >= 2 {
    let first = matches->Array.getUnsafe(0)
    let second = matches->Array.getUnsafe(1)
    assert_(first.confidence >= second.confidence, "Results sorted by confidence descending")
  }
  Console.log("PASS: Results sorted by confidence descending")
}

let testUniquePatterns = () => {
  let code = `
const a = numbers.map(x => x + 1);
const b = items.map(x => x.name);
`
  let matches = Scanner.scanAll(code)
  let unique = Scanner.uniquePatterns(matches)
  // Multiple map matches should deduplicate to one unique pattern
  let mapCount = unique->Array.filter(p => p.id === "array-map")->Array.length
  assert_(mapCount <= 1, "Unique patterns deduplicates array-map")
  Console.log("PASS: uniquePatterns deduplicates correctly")
}

let testMatchesByCategory = () => {
  let code = `
const doubled = numbers.map(n => n * 2);
async function fetchData() { await fetch('/api'); }
`
  let matches = Scanner.scanAll(code)
  let byCat = Scanner.matchesByCategory(matches)
  let arrayCount = byCat->Dict.get("array-operations")->Option.getOr(0)
  assert_(arrayCount > 0, "matchesByCategory counts array operations")
  Console.log("PASS: matchesByCategory groups correctly")
}

let runAll = () => {
  Console.log("=== Scanner Tests ===")
  testScanDetectsNullChecks()
  testScanDetectsAsyncAwait()
  testScanDetectsArrayOps()
  testScanDetectsTryCatch()
  testScanDetectsSwitch()
  testScanDetectsPromiseThen()
  testScanDetectsSpreadOperator()
  testScanDetectsClassInheritance()
  testScanReturnsEmptyForCleanCode()
  testScanSortsByConfidence()
  testUniquePatterns()
  testMatchesByCategory()
  Console.log("=== All Scanner tests passed ===\n")
}

runAll()
