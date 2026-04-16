// SPDX-License-Identifier: PMPL-1.0-or-later
// Pattern Library for Nextgen Languages Evangeliser
// Multi-target transformation patterns from JavaScript/TypeScript to AffineScript (flagship) / ReScript (legacy)

open Types

// Helper to create a pattern with glyphs.
//
// Phase 1b note: the `~rescriptExample` parameter is preserved so all 52
// existing call-sites compile unchanged. It is wrapped internally into
// the new multi-target `targets` field as a single ReScript entry.
// Patterns authored in Phase 2 onward will call `makePatternMultiTarget`
// (below) to supply per-target examples including the flagship AffineScript.
let makePattern = (
  ~id,
  ~name,
  ~category,
  ~difficulty,
  ~jsPattern,
  ~confidence,
  ~jsExample,
  ~rescriptExample,
  ~narrative,
  ~tags,
  ~relatedPatterns,
  ~learningObjectives,
  ~commonMistakes,
  ~bestPractices,
): pattern => {
  {
    id,
    name,
    category,
    difficulty,
    jsPattern,
    confidence,
    jsExample,
    targets: [{language: ReScript, code: rescriptExample}],
    narrative,
    glyphs: Glyphs.getGlyphsForPattern(category),
    tags,
    relatedPatterns,
    learningObjectives,
    commonMistakes,
    bestPractices,
  }
}

// Multi-target pattern constructor — use this for new (Phase 2+) patterns
// that supply AffineScript (flagship) alongside ReScript (or any other
// target language).
let makePatternMultiTarget = (
  ~id,
  ~name,
  ~category,
  ~difficulty,
  ~jsPattern,
  ~confidence,
  ~jsExample,
  ~targets,
  ~narrative,
  ~tags,
  ~relatedPatterns,
  ~learningObjectives,
  ~commonMistakes,
  ~bestPractices,
): pattern => {
  {
    id,
    name,
    category,
    difficulty,
    jsPattern,
    confidence,
    jsExample,
    targets,
    narrative,
    glyphs: Glyphs.getGlyphsForPattern(category),
    tags,
    relatedPatterns,
    learningObjectives,
    commonMistakes,
    bestPractices,
  }
}

// NULL SAFETY PATTERNS
let nullCheckBasic = makePattern(
  ~id="null-check-basic",
  ~name="Basic Null Check",
  ~category=NullSafety,
  ~difficulty=Beginner,
  ~jsPattern=`if\\s*\\(\\s*(\\w+)\\s*!==?\\s*null\\s*&&\\s*\\1\\s*!==?\\s*undefined\\s*\\)`,
  ~confidence=0.9,
  ~jsExample=`if (user !== null && user !== undefined) {
  console.log(user.name);
}`,
  ~rescriptExample=`switch user {
| Some(u) => Console.log(u.name)
| None => ()
}`,
  ~narrative={
    celebrate: "You're checking for null and undefined - that's great defensive programming!",
    minimize: "The only small thing is that it's easy to forget one of these checks somewhere...",
    better: "ReScript's Option type makes null safety automatic - you literally can't forget a check!",
    safety: "The compiler won't let your code compile until you've handled both Some and None cases.",
    example: "Option types eliminate an entire class of 'Cannot read property of undefined' errors!",
  },
  ~tags=["null", "undefined", "option", "safety"],
  ~relatedPatterns=["null-check-ternary", "optional-chaining"],
  ~learningObjectives=["Understand Option<'a> type", "Pattern matching for null safety", "Exhaustiveness checking"],
  ~commonMistakes=["Forgetting to handle None case", "Using null instead of None"],
  ~bestPractices=[
    "Always use Option for nullable values",
    "Use pattern matching to handle all cases",
    "Prefer Option.map over explicit pattern matching",
  ],
)

let nullCheckTernary = makePattern(
  ~id="null-check-ternary",
  ~name="Null Check Ternary",
  ~category=NullSafety,
  ~difficulty=Beginner,
  ~jsPattern=`(\\w+)\\s*\\?\\s*(\\w+)\\.\\w+\\s*:\\s*['\"]\\w+['\"]|null|undefined`,
  ~confidence=0.85,
  ~jsExample=`const name = user ? user.name : 'Guest';`,
  ~rescriptExample=`let name = user->Option.mapOr("Guest", u => u.name)`,
  ~narrative={
    celebrate: "Nice! You're using a ternary to handle the null case - that's concise!",
    minimize: "It works great, though it can get verbose with nested checks...",
    better: "ReScript's Option.mapOr does this in one line with type safety!",
    safety: "The compiler ensures the default value matches the expected type.",
    example: "Option.mapOr handles the None case automatically!",
  },
  ~tags=["ternary", "default", "option"],
  ~relatedPatterns=["null-check-basic", "default-params"],
  ~learningObjectives=["Option.mapOr function", "Type-safe defaults"],
  ~commonMistakes=["Wrong default type"],
  ~bestPractices=["Use Option.mapOr for simple defaults"],
)

let optionalChaining = makePattern(
  ~id="optional-chaining",
  ~name="Optional Chaining",
  ~category=NullSafety,
  ~difficulty=Intermediate,
  ~jsPattern=`\\w+\\?\\.[\\w.?]+`,
  ~confidence=0.95,
  ~jsExample=`const city = user?.address?.city;`,
  ~rescriptExample=`let city = user->Option.flatMap(u => u.address)
  ->Option.map(a => a.city)`,
  ~narrative={
    celebrate: "Excellent! You're using optional chaining - you know modern JavaScript!",
    minimize: "It's really nice, though the result can still be undefined...",
    better: "ReScript's Option.flatMap chains safely and the type tells you it's optional!",
    safety: "The type system tracks the optionality through the entire chain.",
    example: "Chain Option operations with flatMap and map!",
  },
  ~tags=["optional-chaining", "nested", "option"],
  ~relatedPatterns=["null-check-basic"],
  ~learningObjectives=["Option.flatMap", "Chaining optional values"],
  ~commonMistakes=["Using map instead of flatMap"],
  ~bestPractices=["Use flatMap for nested Options"],
)

// ASYNC PATTERNS
let asyncAwaitBasic = makePattern(
  ~id="async-await-basic",
  ~name="Async/Await",
  ~category=Async,
  ~difficulty=Intermediate,
  ~jsPattern=`async\\s+function|\\basync\\s*\\(`,
  ~confidence=0.95,
  ~jsExample=`async function fetchUser(id) {
  const response = await fetch(\`/api/users/\${id}\`);
  return await response.json();
}`,
  ~rescriptExample=`let fetchUser = async (id) => {
  let response = await fetch(\`/api/users/\${id}\`)
  await response->Response.json
}`,
  ~narrative={
    celebrate: "Excellent! You're using async/await - much better than callbacks!",
    minimize: "It's great, though error handling can get scattered...",
    better: "ReScript has async/await with type-safe Promises!",
    safety: "Promise types are checked at compile time.",
    example: "Type-safe async operations prevent common Promise mistakes!",
  },
  ~tags=["async", "await", "promise"],
  ~relatedPatterns=["promise-then", "try-catch-async"],
  ~learningObjectives=["Async/await in ReScript", "Promise types"],
  ~commonMistakes=["Forgetting await", "Missing error handling"],
  ~bestPractices=["Always handle Promise rejections"],
)

let promiseThen = makePattern(
  ~id="promise-then",
  ~name="Promise Then Chain",
  ~category=Async,
  ~difficulty=Beginner,
  ~jsPattern=`\\.then\\s*\\([^)]+\\)`,
  ~confidence=0.9,
  ~jsExample=`fetch('/api/data')
  .then(res => res.json())
  .then(data => console.log(data));`,
  ~rescriptExample=`fetch("/api/data")
->Promise.then(res => res->Response.json)
->Promise.then(data => {
  Console.log(data)
  Promise.resolve()
})`,
  ~narrative={
    celebrate: "Good use of Promise chains - you understand asynchronous flow!",
    minimize: "It works well, though deeply nested thens can be hard to read...",
    better: "ReScript's Promise.then with pipe operator makes chains more readable!",
    safety: "Promise types are tracked through the chain.",
    example: "Type-safe Promise chains with pipe operator!",
  },
  ~tags=["promise", "then", "chain"],
  ~relatedPatterns=["async-await-basic"],
  ~learningObjectives=["Promise.then", "Promise chaining"],
  ~commonMistakes=["Forgetting to return Promise"],
  ~bestPractices=["Consider async/await for readability"],
)

// ERROR HANDLING PATTERNS
let tryCatchBasic = makePattern(
  ~id="try-catch-basic",
  ~name="Basic Try/Catch",
  ~category=ErrorHandling,
  ~difficulty=Beginner,
  ~jsPattern=`try\\s*\\{[^}]+\\}\\s*catch\\s*\\([^)]*\\)\\s*\\{`,
  ~confidence=0.9,
  ~jsExample=`try {
  const result = riskyOperation();
  return result;
} catch (error) {
  console.error(error);
  return null;
}`,
  ~rescriptExample=`switch riskyOperation() {
| result => Ok(result)
| exception Exn.Error(e) => Error(e)
}`,
  ~narrative={
    celebrate: "Excellent error handling with try/catch - you're thinking defensively!",
    minimize: "It works great, though errors aren't part of the function signature...",
    better: "ReScript's Result type makes errors explicit in the type!",
    safety: "Callers must handle both Ok and Error cases.",
    example: "Result<success, error> makes error handling impossible to ignore!",
  },
  ~tags=["try-catch", "error", "result"],
  ~relatedPatterns=["error-result-type"],
  ~learningObjectives=["Result type", "Explicit error handling"],
  ~commonMistakes=["Ignoring error cases"],
  ~bestPractices=["Use Result for expected errors"],
)

let errorResultType = makePattern(
  ~id="error-result-type",
  ~name="Result Type Pattern",
  ~category=ErrorHandling,
  ~difficulty=Intermediate,
  ~jsPattern=`return\\s*\\{\\s*(?:success|ok|error)\\s*:`,
  ~confidence=0.7,
  ~jsExample=`function divide(a, b) {
  if (b === 0) {
    return { error: 'Division by zero' };
  }
  return { success: a / b };
}`,
  ~rescriptExample=`let divide = (a, b) => {
  if b == 0 {
    Error("Division by zero")
  } else {
    Ok(a / b)
  }
}`,
  ~narrative={
    celebrate: "Smart! You're using an object to represent success/error - that's Result-like!",
    minimize: "It works, though the shape isn't enforced by types...",
    better: "ReScript's built-in Result type is exactly this, but type-safe!",
    safety: "The compiler ensures you handle both Ok and Error.",
    example: "Result<'a, 'error> is a first-class type!",
  },
  ~tags=["result", "error", "success"],
  ~relatedPatterns=["try-catch-basic"],
  ~learningObjectives=["Result type usage", "Error as value"],
  ~commonMistakes=["Inconsistent error shapes"],
  ~bestPractices=["Always use Result for fallible operations"],
)

// ARRAY OPERATION PATTERNS
let arrayMap = makePattern(
  ~id="array-map",
  ~name="Array.map",
  ~category=ArrayOperations,
  ~difficulty=Beginner,
  ~jsPattern=`\\.map\\s*\\(\\s*(?:\\w+|\\([^)]*\\))\\s*=>`,
  ~confidence=0.95,
  ~jsExample=`const doubled = numbers.map(n => n * 2);`,
  ~rescriptExample=`let doubled = numbers->Array.map(n => n * 2)`,
  ~narrative={
    celebrate: "Perfect! Array.map is functional programming at its best!",
    minimize: "Nothing wrong here, ReScript just adds the pipe operator...",
    better: "ReScript's pipe operator makes data flow left-to-right!",
    safety: "Type inference ensures the transformation is type-safe.",
    example: "The -> operator makes transformations read like sentences!",
  },
  ~tags=["array", "map", "transform"],
  ~relatedPatterns=["array-filter", "array-reduce", "pipe-operator"],
  ~learningObjectives=["Array.map", "Pipe operator"],
  ~commonMistakes=["Side effects in map"],
  ~bestPractices=["Keep map pure, use pipe for readability"],
)

let arrayFilter = makePattern(
  ~id="array-filter",
  ~name="Array.filter",
  ~category=ArrayOperations,
  ~difficulty=Beginner,
  ~jsPattern=`\\.filter\\s*\\(\\s*(?:\\w+|\\([^)]*\\))\\s*=>`,
  ~confidence=0.95,
  ~jsExample=`const evens = numbers.filter(n => n % 2 === 0);`,
  ~rescriptExample=`let evens = numbers->Array.filter(n => mod(n, 2) == 0)`,
  ~narrative={
    celebrate: "Great use of filter - functional programming done right!",
    minimize: "Works perfectly, ReScript adds type-safe predicates...",
    better: "ReScript's type system ensures your predicate always returns bool!",
    safety: "The compiler checks that filter predicates return boolean.",
    example: "Type-safe filtering with pipe operator!",
  },
  ~tags=["array", "filter", "predicate"],
  ~relatedPatterns=["array-map"],
  ~learningObjectives=["Array.filter", "Boolean predicates"],
  ~commonMistakes=["Predicate returning non-boolean"],
  ~bestPractices=["Keep predicates pure and simple"],
)

let arrayReduce = makePattern(
  ~id="array-reduce",
  ~name="Array.reduce",
  ~category=ArrayOperations,
  ~difficulty=Intermediate,
  ~jsPattern=`\\.reduce\\s*\\(\\s*\\([^)]*\\)\\s*=>`,
  ~confidence=0.9,
  ~jsExample=`const sum = numbers.reduce((acc, n) => acc + n, 0);`,
  ~rescriptExample=`let sum = numbers->Array.reduce(0, (acc, n) => acc + n)`,
  ~narrative={
    celebrate: "Excellent! Array.reduce is a powerful functional pattern!",
    minimize: "It's great, though the parameter order can be confusing...",
    better: "ReScript puts the initial value first - more intuitive!",
    safety: "Type inference ensures accumulator and result types match.",
    example: "Type-safe reduce with clear parameter order!",
  },
  ~tags=["array", "reduce", "fold"],
  ~relatedPatterns=["array-map"],
  ~learningObjectives=["Array.reduce", "Accumulator patterns"],
  ~commonMistakes=["Wrong initial value type"],
  ~bestPractices=["Consider specialized functions like sum, join"],
)

let arrayFind = makePattern(
  ~id="array-find",
  ~name="Array.find",
  ~category=ArrayOperations,
  ~difficulty=Beginner,
  ~jsPattern=`\\.find\\s*\\(\\s*(?:\\w+|\\([^)]*\\))\\s*=>`,
  ~confidence=0.9,
  ~jsExample=`const user = users.find(u => u.id === userId);`,
  ~rescriptExample=`let user = users->Array.find(u => u.id == userId)`,
  ~narrative={
    celebrate: "Good! You're using find to search arrays efficiently!",
    minimize: "It works, though the result can be undefined...",
    better: "ReScript's Array.find returns Option to handle 'not found' safely!",
    safety: "The Option return type forces you to handle the not-found case.",
    example: "Option<'a> makes missing values explicit!",
  },
  ~tags=["array", "find", "search"],
  ~relatedPatterns=["null-check-basic"],
  ~learningObjectives=["Array.find with Option"],
  ~commonMistakes=["Not checking for undefined"],
  ~bestPractices=["Pattern match on find result"],
)

// CONDITIONAL PATTERNS
let switchStatement = makePattern(
  ~id="switch-statement",
  ~name="Switch Statement",
  ~category=Conditionals,
  ~difficulty=Beginner,
  ~jsPattern=`switch\\s*\\([^)]+\\)\\s*\\{`,
  ~confidence=0.9,
  ~jsExample=`switch (status) {
  case 'loading': return 'Loading...';
  case 'success': return data;
  case 'error': return 'Error!';
  default: return null;
}`,
  ~rescriptExample=`switch status {
| Loading => "Loading..."
| Success(data) => data
| Error(_) => "Error!"
}`,
  ~narrative={
    celebrate: "Good use of switch! You're handling multiple cases systematically.",
    minimize: "It works, though the 'default' case can hide missing cases...",
    better: "ReScript's pattern matching ensures you handle ALL cases - the compiler checks!",
    safety: "The compiler ensures every variant is handled.",
    example: "Exhaustive pattern matching catches missing cases at compile time!",
  },
  ~tags=["switch", "conditionals", "pattern-matching"],
  ~relatedPatterns=["if-else-chain"],
  ~learningObjectives=["Pattern matching basics", "Exhaustiveness"],
  ~commonMistakes=["Relying on default for unhandled cases"],
  ~bestPractices=["Let the compiler ensure completeness"],
)

let ifElseChain = makePattern(
  ~id="if-else-chain",
  ~name="If/Else Chain",
  ~category=Conditionals,
  ~difficulty=Beginner,
  ~jsPattern=`if\\s*\\([^)]+\\)\\s*\\{[^}]*\\}\\s*else\\s*if`,
  ~confidence=0.85,
  ~jsExample=`if (x > 10) {
  return 'large';
} else if (x > 5) {
  return 'medium';
} else {
  return 'small';
}`,
  ~rescriptExample=`if x > 10 {
  "large"
} else if x > 5 {
  "medium"
} else {
  "small"
}`,
  ~narrative={
    celebrate: "You're handling multiple conditions - that's thorough logic!",
    minimize: "It works, though ReScript can make this even cleaner...",
    better: "ReScript if/else is an expression that returns a value!",
    safety: "All branches must return the same type.",
    example: "Expression-based control flow is safer and cleaner!",
  },
  ~tags=["if", "else", "conditionals"],
  ~relatedPatterns=["switch-statement"],
  ~learningObjectives=["If as expression", "Type consistency across branches"],
  ~commonMistakes=["Inconsistent return types"],
  ~bestPractices=["Consider pattern matching for complex conditions"],
)

// FUNCTIONAL PATTERNS
let pureFunction = makePattern(
  ~id="pure-function",
  ~name="Pure Function",
  ~category=Functional,
  ~difficulty=Beginner,
  ~jsPattern=`const\\s+\\w+\\s*=\\s*\\([^)]*\\)\\s*=>\\s*[^{]`,
  ~confidence=0.6,
  ~jsExample=`const add = (a, b) => a + b;`,
  ~rescriptExample=`let add = (a, b) => a + b`,
  ~narrative={
    celebrate: "Excellent! Pure functions are predictable and testable!",
    minimize: "JavaScript doesn't enforce purity, but you're doing it right...",
    better: "ReScript's immutability by default makes purity natural!",
    safety: "No hidden state mutations possible.",
    example: "Pure functions are the foundation of reliable code!",
  },
  ~tags=["pure", "function", "immutable"],
  ~relatedPatterns=["array-map"],
  ~learningObjectives=["Pure functions", "Immutability"],
  ~commonMistakes=["Accidental mutations"],
  ~bestPractices=["Keep functions pure when possible"],
)

let higherOrderFunction = makePattern(
  ~id="higher-order-function",
  ~name="Higher Order Function",
  ~category=Functional,
  ~difficulty=Intermediate,
  ~jsPattern=`\\([^)]*=>\\s*\\([^)]*\\)\\s*=>`,
  ~confidence=0.8,
  ~jsExample=`const multiply = factor => num => num * factor;
const double = multiply(2);`,
  ~rescriptExample=`let multiply = factor => num => num * factor
let double = multiply(2)`,
  ~narrative={
    celebrate: "Great! Higher-order functions show advanced functional skills!",
    minimize: "Works perfectly, ReScript's syntax is nearly identical...",
    better: "ReScript's currying makes this pattern natural!",
    safety: "Type inference tracks through all the layers.",
    example: "Curried functions compose beautifully!",
  },
  ~tags=["higher-order", "currying", "functional"],
  ~relatedPatterns=["pure-function"],
  ~learningObjectives=["Currying", "Function composition"],
  ~commonMistakes=["Losing track of closure variables"],
  ~bestPractices=["Use currying for reusable transformations"],
)

// DESTRUCTURING PATTERNS
let objectDestructuring = makePattern(
  ~id="object-destructuring",
  ~name="Object Destructuring",
  ~category=Destructuring,
  ~difficulty=Beginner,
  ~jsPattern=`const\\s*\\{[^}]+\\}\\s*=`,
  ~confidence=0.9,
  ~jsExample=`const { name, age, email } = user;`,
  ~rescriptExample=`let {name, age, email} = user`,
  ~narrative={
    celebrate: "Nice destructuring! You're extracting exactly what you need.",
    minimize: "It's clean, though missing properties silently become undefined...",
    better: "ReScript destructuring is type-checked - missing fields are compile errors!",
    safety: "The compiler guarantees every destructured field exists on the record.",
    example: "Type-safe destructuring means no 'undefined' surprises!",
  },
  ~tags=["destructuring", "object", "record"],
  ~relatedPatterns=["array-destructuring"],
  ~learningObjectives=["Record destructuring", "Type-safe field access"],
  ~commonMistakes=["Destructuring non-existent fields"],
  ~bestPractices=["Destructure only what you need"],
)

let arrayDestructuring = makePattern(
  ~id="array-destructuring",
  ~name="Array Destructuring",
  ~category=Destructuring,
  ~difficulty=Beginner,
  ~jsPattern=`const\\s*\\[[^\\]]+\\]\\s*=`,
  ~confidence=0.85,
  ~jsExample=`const [first, second, ...rest] = items;`,
  ~rescriptExample=`switch items {
| [first, second, ...rest] => // use values
| _ => // handle other cases
}`,
  ~narrative={
    celebrate: "Great! Array destructuring makes your code expressive!",
    minimize: "It works, though arrays might not have enough elements...",
    better: "ReScript uses pattern matching for array destructuring with safety!",
    safety: "Pattern matching forces you to handle the case where the array is too short.",
    example: "Safe array destructuring through exhaustive pattern matching!",
  },
  ~tags=["destructuring", "array", "pattern-matching"],
  ~relatedPatterns=["object-destructuring"],
  ~learningObjectives=["Array pattern matching", "Rest patterns"],
  ~commonMistakes=["Assuming array has enough elements"],
  ~bestPractices=["Always handle the empty/short case"],
)

// DEFAULT PARAMETER PATTERNS
let defaultParams = makePattern(
  ~id="default-params",
  ~name="Default Parameters",
  ~category=Defaults,
  ~difficulty=Beginner,
  ~jsPattern=`function\\s+\\w+\\s*\\([^)]*=\\s*[^,)]+`,
  ~confidence=0.85,
  ~jsExample=`function greet(name = 'World', greeting = 'Hello') {
  return \`\${greeting}, \${name}!\`;
}`,
  ~rescriptExample=`let greet = (~name="World", ~greeting="Hello") => {
  \`\${greeting}, \${name}!\`
}`,
  ~narrative={
    celebrate: "Smart use of default parameters - you're making your API flexible!",
    minimize: "Works well, though optional and default can get confusing...",
    better: "ReScript's labeled arguments with defaults are type-safe and self-documenting!",
    safety: "The compiler ensures default values match the parameter type.",
    example: "Labeled arguments make function calls self-documenting!",
  },
  ~tags=["defaults", "parameters", "labeled"],
  ~relatedPatterns=["null-check-ternary"],
  ~learningObjectives=["Labeled arguments", "Default values"],
  ~commonMistakes=["Wrong default type"],
  ~bestPractices=["Use labeled arguments for clarity"],
)

let nullishCoalescing = makePattern(
  ~id="nullish-coalescing",
  ~name="Nullish Coalescing",
  ~category=Defaults,
  ~difficulty=Beginner,
  ~jsPattern=`\\w+\\s*\\?\\?\\s*`,
  ~confidence=0.9,
  ~jsExample=`const displayName = user.name ?? 'Anonymous';`,
  ~rescriptExample=`let displayName = user.name->Option.getOr("Anonymous")`,
  ~narrative={
    celebrate: "Good use of nullish coalescing - you know modern JavaScript!",
    minimize: "It's concise, though ?? only covers null and undefined...",
    better: "ReScript's Option.getOr is explicit about what 'missing' means!",
    safety: "Option type makes the absence of a value part of the type signature.",
    example: "Option.getOr is the type-safe equivalent of ??!",
  },
  ~tags=["nullish", "coalescing", "default", "option"],
  ~relatedPatterns=["default-params", "null-check-ternary"],
  ~learningObjectives=["Option.getOr", "Default value patterns"],
  ~commonMistakes=["Confusing ?? with ||"],
  ~bestPractices=["Use Option.getOr for explicit defaults"],
)

// TEMPLATE LITERAL PATTERNS
let templateLiterals = makePattern(
  ~id="template-literals",
  ~name="Template Literals",
  ~category=Templates,
  ~difficulty=Beginner,
  ~jsPattern="`.+\\$\\{.+\\}.+`",
  ~confidence=0.9,
  ~jsExample="`Hello, ${name}! You have ${count} messages.`",
  ~rescriptExample="`Hello, ${name}! You have ${Int.toString(count)} messages.`",
  ~narrative={
    celebrate: "Nice! Template literals are much better than string concatenation!",
    minimize: "They're great, though any expression can be interpolated without type checking...",
    better: "ReScript template literals require explicit type conversion - no accidental coercion!",
    safety: "The compiler ensures interpolated values are strings - no [object Object] surprises.",
    example: "Type-safe string interpolation prevents silent coercion bugs!",
  },
  ~tags=["template", "string", "interpolation"],
  ~relatedPatterns=[],
  ~learningObjectives=["String interpolation", "Explicit type conversion"],
  ~commonMistakes=["Interpolating non-string values without conversion"],
  ~bestPractices=["Always convert non-string values explicitly"],
)

let taggedTemplates = makePattern(
  ~id="tagged-templates",
  ~name="Tagged Template Literals",
  ~category=Templates,
  ~difficulty=Advanced,
  ~jsPattern=`\\w+\s*\`.+\\$\\{`,
  ~confidence=0.7,
  ~jsExample=`const query = sql\`SELECT * FROM users WHERE id = \${userId}\`;`,
  ~rescriptExample=`// Use a dedicated query builder with type-safe parameters
let query = Sql.select(~table="users", ~where=Sql.eq("id", userId))`,
  ~narrative={
    celebrate: "Advanced! Tagged templates show deep JavaScript knowledge!",
    minimize: "They're powerful, though the tag function's types aren't checked...",
    better: "ReScript uses dedicated type-safe builders for domain-specific strings!",
    safety: "Type-safe query builders prevent SQL injection by construction.",
    example: "Domain-specific builders are safer than string interpolation!",
  },
  ~tags=["template", "tagged", "dsl"],
  ~relatedPatterns=["template-literals"],
  ~learningObjectives=["Domain-specific builders", "Type-safe DSLs"],
  ~commonMistakes=["SQL injection through templates"],
  ~bestPractices=["Use type-safe builders for SQL, HTML, etc."],
)

// ARROW FUNCTION PATTERNS
let arrowFunction = makePattern(
  ~id="arrow-function",
  ~name="Arrow Function",
  ~category=ArrowFunctions,
  ~difficulty=Beginner,
  ~jsPattern=`(?:const|let)\\s+\\w+\\s*=\\s*\\([^)]*\\)\\s*=>\\s*\\{`,
  ~confidence=0.8,
  ~jsExample=`const calculateTotal = (items) => {
  return items.reduce((sum, item) => sum + item.price, 0);
};`,
  ~rescriptExample=`let calculateTotal = items => {
  items->Array.reduce(0, (sum, item) => sum + item.price)
}`,
  ~narrative={
    celebrate: "Great! Arrow functions are concise and avoid 'this' confusion!",
    minimize: "They're perfect, ReScript's syntax is just a tiny bit cleaner...",
    better: "ReScript functions are always arrow-style with automatic return!",
    safety: "No 'this' binding issues - all functions are lexically scoped.",
    example: "ReScript functions always return the last expression - no 'return' needed!",
  },
  ~tags=["arrow", "function", "lambda"],
  ~relatedPatterns=["pure-function"],
  ~learningObjectives=["Function syntax", "Implicit return"],
  ~commonMistakes=["Forgetting return in multi-line arrows"],
  ~bestPractices=["Use concise body when possible"],
)

let arrowImplicitReturn = makePattern(
  ~id="arrow-implicit-return",
  ~name="Arrow Implicit Return",
  ~category=ArrowFunctions,
  ~difficulty=Beginner,
  ~jsPattern=`(?:const|let)\\s+\\w+\\s*=\\s*\\([^)]*\\)\\s*=>\\s*[^{]`,
  ~confidence=0.75,
  ~jsExample=`const double = (n) => n * 2;`,
  ~rescriptExample=`let double = n => n * 2`,
  ~narrative={
    celebrate: "Clean! Implicit return makes your arrow functions concise!",
    minimize: "It's already great, ReScript just drops the parentheses too...",
    better: "ReScript's function syntax is minimal - everything is an expression!",
    safety: "The return type is inferred and checked automatically.",
    example: "Minimal syntax, maximum type safety!",
  },
  ~tags=["arrow", "implicit-return", "concise"],
  ~relatedPatterns=["arrow-function", "pure-function"],
  ~learningObjectives=["Expression-based functions", "Type inference"],
  ~commonMistakes=["Accidentally returning an object literal"],
  ~bestPractices=["Prefer concise form for simple transforms"],
)

// VARIANT PATTERNS
let enumToVariant = makePattern(
  ~id="enum-to-variant",
  ~name="Enum to Variant",
  ~category=Variants,
  ~difficulty=Intermediate,
  ~jsPattern=`(?:const|var|let)\\s+\\w+\\s*=\\s*(?:Object\\.freeze\\()?\\{[^}]*:\\s*['\"]\\w+['\"]`,
  ~confidence=0.7,
  ~jsExample=`const Status = Object.freeze({
  LOADING: 'loading',
  SUCCESS: 'success',
  ERROR: 'error'
});`,
  ~rescriptExample=`type status = Loading | Success | Error`,
  ~narrative={
    celebrate: "Smart! You're creating an enum-like pattern for safety!",
    minimize: "Object.freeze helps, but the values are still just strings at runtime...",
    better: "ReScript variants are real types - no string matching, no typos possible!",
    safety: "Variants are exhaustively checked - add a new case and the compiler shows every spot to update.",
    example: "Variants make impossible states truly impossible!",
  },
  ~tags=["enum", "variant", "type-safe"],
  ~relatedPatterns=["switch-statement", "union-to-variant"],
  ~learningObjectives=["Variant types", "Exhaustive matching"],
  ~commonMistakes=["Typos in string enums"],
  ~bestPractices=["Use variants for finite sets of values"],
)

let unionToVariant = makePattern(
  ~id="union-to-variant",
  ~name="Union Type to Variant",
  ~category=Variants,
  ~difficulty=Intermediate,
  ~jsPattern=`type\\s+\\w+\\s*=\\s*['\"]\\w+['\"]\\s*\\|`,
  ~confidence=0.65,
  ~jsExample=`// TypeScript: type Shape = 'circle' | 'square' | 'triangle';
const area = (shape) => {
  if (shape === 'circle') return Math.PI * r * r;
  if (shape === 'square') return s * s;
};`,
  ~rescriptExample=`type shape = Circle(float) | Square(float) | Triangle(float, float)

let area = shape =>
  switch shape {
  | Circle(r) => Math.Constants.pi *. r *. r
  | Square(s) => s *. s
  | Triangle(b, h) => 0.5 *. b *. h
  }`,
  ~narrative={
    celebrate: "Good thinking with union types - you want type safety!",
    minimize: "String unions help, but they can't carry data...",
    better: "ReScript variants carry data AND are exhaustively checked!",
    safety: "Each variant case can hold different typed data - impossible to mix up.",
    example: "Variants with payloads are like tagged unions on steroids!",
  },
  ~tags=["union", "variant", "tagged-union"],
  ~relatedPatterns=["enum-to-variant"],
  ~learningObjectives=["Variants with payloads", "Tagged unions"],
  ~commonMistakes=["Forgetting to handle new variant cases"],
  ~bestPractices=["Give variants meaningful payload types"],
)

// MODULE PATTERNS
let namespaceToModule = makePattern(
  ~id="namespace-to-module",
  ~name="Namespace to Module",
  ~category=Modules,
  ~difficulty=Intermediate,
  ~jsPattern=`(?:export\\s+)?(?:const|class)\\s+\\w+\\s*=\\s*\\{`,
  ~confidence=0.5,
  ~jsExample=`export const MathUtils = {
  add: (a, b) => a + b,
  subtract: (a, b) => a - b,
  multiply: (a, b) => a * b,
};`,
  ~rescriptExample=`// MathUtils.res - each file IS a module
let add = (a, b) => a + b
let subtract = (a, b) => a - b
let multiply = (a, b) => a * b`,
  ~narrative={
    celebrate: "Good! You're organizing code into namespaces - clean architecture!",
    minimize: "Object namespaces work, but they're just convention, not enforced...",
    better: "In ReScript, every file is automatically a module with proper encapsulation!",
    safety: "Modules have interfaces (.resi files) that enforce what's public.",
    example: "File = module, no boilerplate needed!",
  },
  ~tags=["module", "namespace", "organization"],
  ~relatedPatterns=["class-to-module"],
  ~learningObjectives=["File-based modules", "Module interfaces"],
  ~commonMistakes=["Over-nesting modules"],
  ~bestPractices=["Use .resi files for public API control"],
)

// TYPE SAFETY PATTERNS
let typeAssertionToType = makePattern(
  ~id="type-assertion-to-type",
  ~name="Type Assertion to Sound Type",
  ~category=TypeSafety,
  ~difficulty=Intermediate,
  ~jsPattern=`as\\s+\\w+|<\\w+>\\w+`,
  ~confidence=0.6,
  ~jsExample=`const input = document.getElementById('name') as HTMLInputElement;
const value = (input as any).value;`,
  ~rescriptExample=`// Use proper bindings instead of type assertions
@val @return(nullable)
external getElementById: string => option<Dom.element> = "document.getElementById"

switch getElementById("name") {
| Some(el) => // safely use element
| None => // handle missing element
}`,
  ~narrative={
    celebrate: "You know about type annotations - that's type-aware programming!",
    minimize: "Type assertions override the compiler - they can hide real errors...",
    better: "ReScript has no type assertions - the type system is 100% sound!",
    safety: "Sound types mean if it compiles, the types are correct. No 'as any' escape hatch.",
    example: "100% sound type system - no type assertions, no type lies!",
  },
  ~tags=["type-safety", "assertion", "sound"],
  ~relatedPatterns=["any-to-typed"],
  ~learningObjectives=["Sound type system", "External bindings"],
  ~commonMistakes=["Reaching for 'as any'"],
  ~bestPractices=["Write proper bindings instead of type assertions"],
)

let anyToTyped = makePattern(
  ~id="any-to-typed",
  ~name="Any Type to Proper Type",
  ~category=TypeSafety,
  ~difficulty=Intermediate,
  ~jsPattern=`:\\s*any\\b|as\\s+any`,
  ~confidence=0.85,
  ~jsExample=`function processData(data: any) {
  return data.map((item: any) => item.name);
}`,
  ~rescriptExample=`type item = {name: string}

let processData = (data: array<item>) => {
  data->Array.map(item => item.name)
}`,
  ~narrative={
    celebrate: "You're using TypeScript's type system - that's progress from plain JS!",
    minimize: "'any' is sometimes needed, but it turns off type checking entirely...",
    better: "ReScript has no 'any' type - everything is properly typed from the start!",
    safety: "No escape hatches means the compiler catches ALL type errors.",
    example: "No 'any', no 'unknown', no type holes - just correct types!",
  },
  ~tags=["any", "type-safety", "typed"],
  ~relatedPatterns=["type-assertion-to-type"],
  ~learningObjectives=["Eliminating any", "Full type coverage"],
  ~commonMistakes=["Using any as a quick fix"],
  ~bestPractices=["Define proper types for all data"],
)

// IMMUTABILITY PATTERNS
let constToLet = makePattern(
  ~id="const-to-let",
  ~name="Const to Immutable Let",
  ~category=Immutability,
  ~difficulty=Beginner,
  ~jsPattern=`(?:let|var)\\s+\\w+\\s*=`,
  ~confidence=0.5,
  ~jsExample=`let count = 0;
count = count + 1; // mutation allowed!

var name = 'initial';
name = 'changed'; // mutation allowed!`,
  ~rescriptExample=`let count = 0
// count = count + 1  // ERROR: can't reassign let binding!

let count2 = count + 1  // create a new binding instead`,
  ~narrative={
    celebrate: "You're using variables to track state - the foundation of programming!",
    minimize: "let and var allow reassignment, which can cause subtle bugs...",
    better: "ReScript's let is immutable by default - you create new bindings instead!",
    safety: "Immutable bindings prevent accidental state corruption.",
    example: "Immutable by default, mutable only when you explicitly ask for it!",
  },
  ~tags=["immutable", "let", "const", "binding"],
  ~relatedPatterns=["spread-to-update"],
  ~learningObjectives=["Immutable bindings", "Creating new values"],
  ~commonMistakes=["Trying to reassign let bindings"],
  ~bestPractices=["Prefer creating new bindings over mutation"],
)

let spreadToUpdate = makePattern(
  ~id="spread-to-update",
  ~name="Spread to Record Update",
  ~category=Immutability,
  ~difficulty=Beginner,
  ~jsPattern=`\\{\\s*\\.\\.\\.\\w+`,
  ~confidence=0.9,
  ~jsExample=`const updated = { ...user, name: 'New Name', age: 30 };`,
  ~rescriptExample=`let updated = {...user, name: "New Name", age: 30}`,
  ~narrative={
    celebrate: "Excellent! Spread operator for immutable updates - that's functional thinking!",
    minimize: "It's great, though spread is shallow and types aren't checked...",
    better: "ReScript's record update syntax is type-safe and looks almost identical!",
    safety: "The compiler ensures updated fields exist and have the right types.",
    example: "Type-safe record updates with familiar spread-like syntax!",
  },
  ~tags=["spread", "immutable", "record-update"],
  ~relatedPatterns=["const-to-let"],
  ~learningObjectives=["Record update syntax", "Immutable data updates"],
  ~commonMistakes=["Shallow copy issues"],
  ~bestPractices=["Use record update for immutable modifications"],
)

// PATTERN MATCHING PATTERNS
let switchToMatch = makePattern(
  ~id="switch-to-match",
  ~name="Switch to Pattern Match",
  ~category=PatternMatching,
  ~difficulty=Intermediate,
  ~jsPattern=`switch\\s*\\([^)]+\\)\\s*\\{\\s*case`,
  ~confidence=0.9,
  ~jsExample=`switch (action.type) {
  case 'INCREMENT': return { count: state.count + 1 };
  case 'DECREMENT': return { count: state.count - 1 };
  case 'RESET': return { count: 0 };
  default: return state;
}`,
  ~rescriptExample=`switch action {
| Increment => {...state, count: state.count + 1}
| Decrement => {...state, count: state.count - 1}
| Reset => {...state, count: 0}
}`,
  ~narrative={
    celebrate: "Good pattern! Switch on action type is a solid state management approach!",
    minimize: "It works, but string matching can have typos and the default hides missing cases...",
    better: "ReScript pattern matching on variants is exhaustive - no default needed!",
    safety: "Add a new action and the compiler shows every switch that needs updating.",
    example: "Exhaustive pattern matching is the heart of ReScript!",
  },
  ~tags=["switch", "pattern-matching", "exhaustive"],
  ~relatedPatterns=["switch-statement", "enum-to-variant"],
  ~learningObjectives=["Deep pattern matching", "Exhaustiveness"],
  ~commonMistakes=["Using default as a catch-all"],
  ~bestPractices=["Never use a default/wildcard without good reason"],
)

let nestedTernaryToMatch = makePattern(
  ~id="nested-ternary-to-match",
  ~name="Nested Ternary to Match",
  ~category=PatternMatching,
  ~difficulty=Intermediate,
  ~jsPattern=`\\?[^:]+:[^?]+\\?`,
  ~confidence=0.7,
  ~jsExample=`const label = status === 'loading' ? 'Loading...'
  : status === 'error' ? 'Error!'
  : status === 'success' ? 'Done!'
  : 'Unknown';`,
  ~rescriptExample=`let label = switch status {
| Loading => "Loading..."
| Error(_) => "Error!"
| Success => "Done!"
}`,
  ~narrative={
    celebrate: "You're handling multiple cases - that's thorough!",
    minimize: "Nested ternaries work but can be hard to read...",
    better: "ReScript's switch is cleaner and exhaustive - no 'Unknown' default needed!",
    safety: "The compiler ensures you handle every possible case.",
    example: "Pattern matching replaces nested ternaries with clarity!",
  },
  ~tags=["ternary", "pattern-matching", "readability"],
  ~relatedPatterns=["switch-to-match"],
  ~learningObjectives=["Replacing ternaries", "Switch expressions"],
  ~commonMistakes=["Deeply nested ternaries"],
  ~bestPractices=["Use switch for more than 2 cases"],
)

// PIPE OPERATOR PATTERNS
let chainToPipe = makePattern(
  ~id="chain-to-pipe",
  ~name="Method Chain to Pipe",
  ~category=PipeOperator,
  ~difficulty=Beginner,
  ~jsPattern=`\\w+\\.\\w+\\([^)]*\\)\\.\\w+\\([^)]*\\)\\.\\w+`,
  ~confidence=0.8,
  ~jsExample=`const result = users
  .filter(u => u.active)
  .map(u => u.name)
  .sort();`,
  ~rescriptExample=`let result = users
->Array.filter(u => u.active)
->Array.map(u => u.name)
->Array.toSorted(String.compare)`,
  ~narrative={
    celebrate: "Excellent method chaining! You know how to compose operations!",
    minimize: "It's clean, though methods must be on the prototype...",
    better: "ReScript's pipe operator works with ANY function, not just methods!",
    safety: "Pipe operator is more flexible than method chaining and fully typed.",
    example: "The -> operator: data flows left-to-right through any function!",
  },
  ~tags=["pipe", "chain", "composition"],
  ~relatedPatterns=["array-map", "array-filter"],
  ~learningObjectives=["Pipe operator ->", "Data-first functions"],
  ~commonMistakes=["Forgetting -> syntax"],
  ~bestPractices=["Use pipe for readable data transformations"],
)

let nestedCallsToPipe = makePattern(
  ~id="nested-calls-to-pipe",
  ~name="Nested Calls to Pipe",
  ~category=PipeOperator,
  ~difficulty=Beginner,
  ~jsPattern=`\\w+\\(\\w+\\([^)]*\\)\\)`,
  ~confidence=0.7,
  ~jsExample=`const result = capitalize(trim(toLowerCase(input)));`,
  ~rescriptExample=`let result = input
->String.toLowerCase
->String.trim
->String.capitalize`,
  ~narrative={
    celebrate: "You're composing functions - that's functional programming!",
    minimize: "Nested calls read inside-out, which can be confusing...",
    better: "ReScript's pipe operator makes the flow read naturally left-to-right!",
    safety: "Each step's types are checked as data flows through the pipe.",
    example: "Read data transformations like a sentence, not an onion!",
  },
  ~tags=["pipe", "nested", "readability"],
  ~relatedPatterns=["chain-to-pipe"],
  ~learningObjectives=["Pipe vs nesting", "Readable composition"],
  ~commonMistakes=["Reading order confusion"],
  ~bestPractices=["Use pipe for 2+ nested function calls"],
)

// OOP TO FP PATTERNS
let classMethodToFunction = makePattern(
  ~id="class-method-to-function",
  ~name="Class Method to Function",
  ~category=OopToFp,
  ~difficulty=Intermediate,
  ~jsPattern=`class\\s+\\w+\\s*\\{[^}]*\\w+\\s*\\([^)]*\\)\\s*\\{`,
  ~confidence=0.7,
  ~jsExample=`class Calculator {
  add(a, b) { return a + b; }
  subtract(a, b) { return a - b; }
}
const calc = new Calculator();
calc.add(1, 2);`,
  ~rescriptExample=`// Calculator.res
let add = (a, b) => a + b
let subtract = (a, b) => a - b

// Usage:
Calculator.add(1, 2)`,
  ~narrative={
    celebrate: "Good OOP! Classes organize related operations together!",
    minimize: "Classes work, but they carry mutable state and 'this' binding issues...",
    better: "ReScript modules group functions without 'this', 'new', or hidden state!",
    safety: "Pure functions in modules - no constructor issues, no 'this' confusion.",
    example: "Modules: all the organization of classes, none of the complexity!",
  },
  ~tags=["class", "module", "oop", "fp"],
  ~relatedPatterns=["namespace-to-module"],
  ~learningObjectives=["Classes to modules", "Stateless programming"],
  ~commonMistakes=["Trying to use 'this' in ReScript"],
  ~bestPractices=["Think modules and records, not classes and instances"],
)

// CLASSES TO RECORDS PATTERNS
let classToRecord = makePattern(
  ~id="class-to-record",
  ~name="Class to Record",
  ~category=ClassesToRecords,
  ~difficulty=Intermediate,
  ~jsPattern=`class\\s+\\w+\\s*\\{\\s*constructor`,
  ~confidence=0.8,
  ~jsExample=`class User {
  constructor(name, email, age) {
    this.name = name;
    this.email = email;
    this.age = age;
  }
}`,
  ~rescriptExample=`type user = {
  name: string,
  email: string,
  age: int,
}

let makeUser = (~name, ~email, ~age) => {name, email, age}`,
  ~narrative={
    celebrate: "Classes for data structures - you're organizing your data well!",
    minimize: "Constructor classes are verbose and allow mutation of fields...",
    better: "ReScript records are simpler, immutable, and fully typed!",
    safety: "Records are immutable by default - no accidental field mutations.",
    example: "Records: data without the ceremony of classes!",
  },
  ~tags=["class", "record", "data"],
  ~relatedPatterns=["class-method-to-function"],
  ~learningObjectives=["Record types", "Constructor functions"],
  ~commonMistakes=["Adding methods to records"],
  ~bestPractices=["Use records for data, modules for functions"],
)

// INHERITANCE TO COMPOSITION PATTERNS
let inheritanceToComposition = makePattern(
  ~id="inheritance-to-composition",
  ~name="Inheritance to Composition",
  ~category=InheritanceToComposition,
  ~difficulty=Advanced,
  ~jsPattern=`class\\s+\\w+\\s+extends\\s+\\w+`,
  ~confidence=0.9,
  ~jsExample=`class Animal { speak() { return '...'; } }
class Dog extends Animal { speak() { return 'Woof!'; } }
class Cat extends Animal { speak() { return 'Meow!'; } }`,
  ~rescriptExample=`type animal = Dog | Cat | Bird

let speak = animal =>
  switch animal {
  | Dog => "Woof!"
  | Cat => "Meow!"
  | Bird => "Tweet!"
  }`,
  ~narrative={
    celebrate: "You understand inheritance - it's a fundamental OOP concept!",
    minimize: "Deep inheritance hierarchies can become rigid and hard to change...",
    better: "ReScript variants + pattern matching give you polymorphism without inheritance!",
    safety: "Adding a new variant forces you to update all pattern matches - no forgotten overrides.",
    example: "Variants: polymorphism that the compiler checks exhaustively!",
  },
  ~tags=["inheritance", "composition", "variant", "polymorphism"],
  ~relatedPatterns=["class-to-record", "enum-to-variant"],
  ~learningObjectives=["Composition over inheritance", "Variant-based polymorphism"],
  ~commonMistakes=["Deep inheritance hierarchies"],
  ~bestPractices=["Prefer variants and modules over class hierarchies"],
)

// STATE MACHINE PATTERNS
let stateMachine = makePattern(
  ~id="state-machine",
  ~name="State Machine",
  ~category=StateMachines,
  ~difficulty=Advanced,
  ~jsPattern=`(?:state|status)\\s*===?\\s*['\"]\\w+['\"]`,
  ~confidence=0.6,
  ~jsExample=`let state = 'idle';
function transition(event) {
  if (state === 'idle' && event === 'start') state = 'running';
  else if (state === 'running' && event === 'pause') state = 'paused';
  else if (state === 'paused' && event === 'resume') state = 'running';
  else if (state === 'running' && event === 'stop') state = 'idle';
}`,
  ~rescriptExample=`type state = Idle | Running | Paused
type event = Start | Pause | Resume | Stop

let transition = (state, event) =>
  switch (state, event) {
  | (Idle, Start) => Running
  | (Running, Pause) => Paused
  | (Paused, Resume) => Running
  | (Running, Stop) => Idle
  | (state, _) => state
  }`,
  ~narrative={
    celebrate: "State machines! You understand that systems have discrete states!",
    minimize: "String-based states can have typos and invalid transitions...",
    better: "ReScript variants make each state and transition explicit and type-checked!",
    safety: "Invalid state transitions are caught at compile time, not runtime.",
    example: "Type-safe state machines where illegal states are impossible!",
  },
  ~tags=["state-machine", "variant", "transition"],
  ~relatedPatterns=["enum-to-variant", "switch-to-match"],
  ~learningObjectives=["Variant-based state machines", "Tuple pattern matching"],
  ~commonMistakes=["Missing state transitions"],
  ~bestPractices=["Model all states as variants, all events as variants"],
)

// DATA MODELING PATTERNS
let interfaceToType = makePattern(
  ~id="interface-to-type",
  ~name="Interface to Type",
  ~category=DataModeling,
  ~difficulty=Intermediate,
  ~jsPattern=`(?:interface|type)\\s+\\w+\\s*\\{`,
  ~confidence=0.6,
  ~jsExample=`interface User {
  id: number;
  name: string;
  email: string;
  role: 'admin' | 'user' | 'guest';
}`,
  ~rescriptExample=`type role = Admin | User | Guest

type user = {
  id: int,
  name: string,
  email: string,
  role: role,
}`,
  ~narrative={
    celebrate: "Great data modeling! Interfaces define clear contracts!",
    minimize: "Interfaces are structural and can be widened accidentally...",
    better: "ReScript types are nominal and variants replace string unions!",
    safety: "Nominal types prevent accidental structural compatibility.",
    example: "Types + variants = precise, exhaustive data modeling!",
  },
  ~tags=["interface", "type", "record", "data-modeling"],
  ~relatedPatterns=["class-to-record", "enum-to-variant"],
  ~learningObjectives=["Record types", "Nominal typing"],
  ~commonMistakes=["Expecting structural compatibility"],
  ~bestPractices=["Model domain data with records and variants"],
)

let nestedObjectToVariant = makePattern(
  ~id="nested-object-to-variant",
  ~name="Nested Object to Variant",
  ~category=DataModeling,
  ~difficulty=Advanced,
  ~jsPattern=`\\{\\s*type\\s*:\\s*['\"]\\w+['\"]`,
  ~confidence=0.7,
  ~jsExample=`const response = {
  type: 'success',
  data: { users: [...] }
};
// OR
const response = {
  type: 'error',
  message: 'Not found'
};`,
  ~rescriptExample=`type response =
  | Success({users: array<user>})
  | Error({message: string})

switch response {
| Success({users}) => // use users
| Error({message}) => // handle error
}`,
  ~narrative={
    celebrate: "Smart! Discriminated unions with a 'type' field - you're thinking in types!",
    minimize: "The type field is just a string - easy to misspell or forget to check...",
    better: "ReScript variants with inline records are this exact pattern, but type-safe!",
    safety: "Each variant arm has its own typed payload - no casting needed.",
    example: "Variants with inline records: the best of both worlds!",
  },
  ~tags=["discriminated-union", "variant", "data-modeling"],
  ~relatedPatterns=["union-to-variant", "interface-to-type"],
  ~learningObjectives=["Inline records in variants", "Discriminated unions"],
  ~commonMistakes=["Forgetting to destructure variant payload"],
  ~bestPractices=["Use inline records for variant data"],
)

// ADDITIONAL MODULE PATTERNS
let importToOpen = makePattern(
  ~id="import-to-open",
  ~name="Import to Open",
  ~category=Modules,
  ~difficulty=Beginner,
  ~jsPattern=`import\\s*\\{[^}]+\\}\\s*from`,
  ~confidence=0.85,
  ~jsExample=`import { map, filter, reduce } from './utils';
import { useState, useEffect } from 'react';`,
  ~rescriptExample=`// Just use the module name directly - no imports needed!
// Utils.map, Utils.filter, Utils.reduce

// Or open the module to use unqualified names:
open Utils
map(data, fn)`,
  ~narrative={
    celebrate: "Good! Named imports keep your namespace clean!",
    minimize: "Import lists can get long and need updating when APIs change...",
    better: "ReScript modules are always available - no imports needed!",
    safety: "The compiler resolves module references automatically - no stale imports.",
    example: "No import statements, no circular dependency headaches!",
  },
  ~tags=["import", "module", "open"],
  ~relatedPatterns=["namespace-to-module"],
  ~learningObjectives=["Module auto-resolution", "open keyword"],
  ~commonMistakes=["Overusing open (namespace pollution)"],
  ~bestPractices=["Prefer qualified access, use open sparingly"],
)

// ADDITIONAL OOP TO FP PATTERNS
let thisToModule = makePattern(
  ~id="this-to-module",
  ~name="This Binding to Module",
  ~category=OopToFp,
  ~difficulty=Intermediate,
  ~jsPattern=`this\\.\\w+`,
  ~confidence=0.5,
  ~jsExample=`class Counter {
  constructor() { this.count = 0; }
  increment() { this.count++; return this; }
  getCount() { return this.count; }
}`,
  ~rescriptExample=`type counter = {count: int}

let make = () => {count: 0}
let increment = c => {count: c.count + 1}
let getCount = c => c.count

// Usage: make()->increment->increment->getCount`,
  ~narrative={
    celebrate: "You understand method chaining with 'this' - fluent interface!",
    minimize: "'this' binding is one of JavaScript's most confusing features...",
    better: "ReScript passes data explicitly - no 'this', no binding confusion!",
    safety: "Explicit data flow means no lost 'this' context in callbacks.",
    example: "Pipe operator replaces method chaining without 'this'!",
  },
  ~tags=["this", "binding", "oop", "module"],
  ~relatedPatterns=["class-method-to-function", "chain-to-pipe"],
  ~learningObjectives=["Eliminating this", "Explicit data passing"],
  ~commonMistakes=["Looking for 'this' in ReScript"],
  ~bestPractices=["Pass state as first argument, use pipe for chaining"],
)

// ADDITIONAL CLASSES TO RECORDS PATTERNS
let getterToField = makePattern(
  ~id="getter-to-field",
  ~name="Getter/Setter to Record Field",
  ~category=ClassesToRecords,
  ~difficulty=Beginner,
  ~jsPattern=`get\\s+\\w+\\s*\\(\\)|set\\s+\\w+\\s*\\(`,
  ~confidence=0.8,
  ~jsExample=`class Person {
  #name;
  get name() { return this.#name; }
  set name(value) { this.#name = value; }
}`,
  ~rescriptExample=`type person = {name: string}

// Read: just access the field
let getName = p => p.name

// "Update": create a new record
let setName = (p, name) => {...p, name}`,
  ~narrative={
    celebrate: "Encapsulation with getters/setters - you're protecting your data!",
    minimize: "Getters and setters add boilerplate for what's essentially field access...",
    better: "ReScript records have direct field access and immutable updates!",
    safety: "Record fields are typed - no need for validation in getters/setters.",
    example: "Direct field access + immutable updates = simpler code!",
  },
  ~tags=["getter", "setter", "record", "field"],
  ~relatedPatterns=["class-to-record"],
  ~learningObjectives=["Record field access", "Immutable record update"],
  ~commonMistakes=["Trying to mutate record fields"],
  ~bestPractices=["Use record update syntax for changes"],
)

// ADDITIONAL INHERITANCE TO COMPOSITION PATTERNS
let mixinToModule = makePattern(
  ~id="mixin-to-module",
  ~name="Mixin to Module Include",
  ~category=InheritanceToComposition,
  ~difficulty=Advanced,
  ~jsPattern=`Object\\.assign\\s*\\(|\\.\\.\\.[^,]+prototype`,
  ~confidence=0.6,
  ~jsExample=`const Serializable = {
  serialize() { return JSON.stringify(this); }
};
const Loggable = {
  log() { console.log(this.toString()); }
};
Object.assign(MyClass.prototype, Serializable, Loggable);`,
  ~rescriptExample=`// Serializable.res
let serialize = data => data->JSON.stringifyAny

// Loggable.res
let log = data => Console.log(data)

// Usage: compose by calling module functions
Serializable.serialize(myData)
Loggable.log(myData)`,
  ~narrative={
    celebrate: "Mixins! You're composing behaviour from multiple sources!",
    minimize: "Runtime mixins can conflict and have no compile-time checks...",
    better: "ReScript modules compose statically - just call functions from different modules!",
    safety: "No runtime prototype manipulation, no method name conflicts.",
    example: "Module composition: explicit, type-safe, no surprises!",
  },
  ~tags=["mixin", "composition", "module", "prototype"],
  ~relatedPatterns=["inheritance-to-composition", "namespace-to-module"],
  ~learningObjectives=["Module composition", "Avoiding mixins"],
  ~commonMistakes=["Trying to merge modules at runtime"],
  ~bestPractices=["Compose by calling functions from multiple modules"],
)

// ADDITIONAL STATE MACHINE PATTERNS
let reducerToVariant = makePattern(
  ~id="reducer-to-variant",
  ~name="Reducer to Variant Actions",
  ~category=StateMachines,
  ~difficulty=Intermediate,
  ~jsPattern=`(?:case|action\\.type\\s*===?)\\s*['\"]\\w+['\"]`,
  ~confidence=0.65,
  ~jsExample=`function reducer(state, action) {
  switch (action.type) {
    case 'ADD_TODO': return {...state, todos: [...state.todos, action.payload]};
    case 'REMOVE_TODO': return {...state, todos: state.todos.filter(t => t.id !== action.id)};
    case 'TOGGLE_TODO': return {...state, todos: state.todos.map(t =>
      t.id === action.id ? {...t, done: !t.done} : t)};
    default: return state;
  }
}`,
  ~rescriptExample=`type action =
  | AddTodo(todo)
  | RemoveTodo(int)
  | ToggleTodo(int)

let reducer = (state, action) =>
  switch action {
  | AddTodo(todo) => {...state, todos: state.todos->Array.concat([todo])}
  | RemoveTodo(id) => {...state, todos: state.todos->Array.filter(t => t.id != id)}
  | ToggleTodo(id) => {...state, todos: state.todos->Array.map(t =>
      t.id == id ? {...t, done: !t.done} : t)}
  }`,
  ~narrative={
    celebrate: "Redux-style reducer! You understand unidirectional data flow!",
    minimize: "String action types are easy to typo and payloads aren't type-checked...",
    better: "ReScript variant actions carry typed payloads - no string matching!",
    safety: "Add a new action and the compiler shows every reducer that needs updating.",
    example: "Variant-based reducers: the pattern Redux wishes it had!",
  },
  ~tags=["reducer", "state-machine", "variant", "action"],
  ~relatedPatterns=["state-machine", "switch-to-match"],
  ~learningObjectives=["Variant-based actions", "Type-safe reducers"],
  ~commonMistakes=["Using strings for action types"],
  ~bestPractices=["Model every action as a variant with typed payload"],
)

// ADDITIONAL VARIANT PATTERNS
let typeGuardToVariant = makePattern(
  ~id="type-guard-to-variant",
  ~name="Type Guard to Variant",
  ~category=Variants,
  ~difficulty=Advanced,
  ~jsPattern=`(?:typeof|instanceof)\\s+\\w+\\s*===?`,
  ~confidence=0.6,
  ~jsExample=`function formatValue(value) {
  if (typeof value === 'string') return value.toUpperCase();
  if (typeof value === 'number') return value.toFixed(2);
  if (Array.isArray(value)) return value.join(', ');
  return String(value);
}`,
  ~rescriptExample=`type value = String(string) | Number(float) | List(array<string>)

let formatValue = v =>
  switch v {
  | String(s) => String.toUpperCase(s)
  | Number(n) => Float.toFixed(n, ~digits=2)
  | List(items) => items->Array.join(", ")
  }`,
  ~narrative={
    celebrate: "Type guards! You're narrowing types at runtime - smart!",
    minimize: "Runtime type checks can miss cases and aren't enforced by the compiler...",
    better: "ReScript variants carry the type WITH the data - no runtime checks needed!",
    safety: "Exhaustive matching means you handle every type, guaranteed.",
    example: "Variants replace typeof/instanceof with compile-time safety!",
  },
  ~tags=["type-guard", "typeof", "instanceof", "variant"],
  ~relatedPatterns=["enum-to-variant", "union-to-variant"],
  ~learningObjectives=["Replacing runtime type checks", "Variant-based dispatch"],
  ~commonMistakes=["Using typeof in ReScript"],
  ~bestPractices=["Model data shapes as variants from the start"],
)

// ADDITIONAL TYPE SAFETY PATTERNS
let typeGuardFnToVariant = makePattern(
  ~id="type-guard-fn-to-variant",
  ~name="Type Guard Function to Pattern Match",
  ~category=TypeSafety,
  ~difficulty=Advanced,
  ~jsPattern=`function\\s+is\\w+\\s*\\(|:\\s*\\w+\\s+is\\s+\\w+`,
  ~confidence=0.65,
  ~jsExample=`function isError(result): result is Error {
  return result instanceof Error;
}
if (isError(value)) {
  console.error(value.message);
}`,
  ~rescriptExample=`type result<'a> = Ok('a) | Error(string)

switch value {
| Ok(data) => Console.log(data)
| Error(msg) => Console.error(msg)
}`,
  ~narrative={
    celebrate: "Type guard functions! You're bringing type safety to runtime checks!",
    minimize: "Type predicates are powerful but rely on you writing them correctly...",
    better: "ReScript's pattern matching IS the type narrowing - no guard functions needed!",
    safety: "Pattern matching narrows types automatically and exhaustively.",
    example: "Every switch arm narrows the type - no manual type guards!",
  },
  ~tags=["type-guard", "predicate", "pattern-matching", "type-safety"],
  ~relatedPatterns=["type-assertion-to-type", "switch-to-match"],
  ~learningObjectives=["Automatic type narrowing", "Pattern-based dispatch"],
  ~commonMistakes=["Writing manual type predicates"],
  ~bestPractices=["Let pattern matching narrow types automatically"],
)

// ADDITIONAL FUNCTIONAL PATTERNS
let compose = makePattern(
  ~id="function-compose",
  ~name="Function Composition",
  ~category=Functional,
  ~difficulty=Intermediate,
  ~jsPattern=`compose\\s*\\(|(?:const|let)\\s+\\w+\\s*=\\s*\\(\\.\\.\\.[^)]*\\)\\s*=>\\s*\\w+\\.reduce`,
  ~confidence=0.55,
  ~jsExample=`const compose = (...fns) => x => fns.reduceRight((acc, fn) => fn(acc), x);
const transform = compose(capitalize, trim, toLowerCase);
const result = transform(input);`,
  ~rescriptExample=`// No compose needed - pipe operator IS composition!
let result = input
->String.toLowerCase
->String.trim
->String.capitalize`,
  ~narrative={
    celebrate: "Function composition! You're building complex operations from simple ones!",
    minimize: "Compose utilities work but read right-to-left which is unnatural...",
    better: "ReScript's pipe operator composes left-to-right - no utility needed!",
    safety: "Each step in the pipe is type-checked individually.",
    example: "Pipe operator: built-in composition that reads like English!",
  },
  ~tags=["compose", "functional", "pipe"],
  ~relatedPatterns=["chain-to-pipe", "nested-calls-to-pipe", "higher-order-function"],
  ~learningObjectives=["Pipe as composition", "Left-to-right data flow"],
  ~commonMistakes=["Creating compose utilities in ReScript"],
  ~bestPractices=["Use pipe operator instead of compose"],
)

// ADDITIONAL PIPE OPERATOR PATTERNS
let callbackToPipe = makePattern(
  ~id="callback-to-pipe",
  ~name="Callback to Pipe",
  ~category=PipeOperator,
  ~difficulty=Intermediate,
  ~jsPattern=`\\w+\\s*\\(\\s*function|\\w+\\s*\\(\\s*\\([^)]*\\)\\s*=>\\s*\\{[^}]*\\}\\s*\\)`,
  ~confidence=0.5,
  ~jsExample=`addEventListener('click', function(event) {
  const target = getTarget(event);
  const data = extractData(target);
  const result = processData(data);
  updateUI(result);
});`,
  ~rescriptExample=`addEventListener("click", event => {
  event
  ->getTarget
  ->extractData
  ->processData
  ->updateUI
})`,
  ~narrative={
    celebrate: "Callbacks for event handling - the foundation of interactive code!",
    minimize: "Deeply nested operations inside callbacks can be hard to follow...",
    better: "ReScript's pipe operator flattens callback internals into readable chains!",
    safety: "Each function in the pipe is type-checked against the previous return type.",
    example: "Pipe operator turns nested callback logic into linear flow!",
  },
  ~tags=["callback", "pipe", "event", "readability"],
  ~relatedPatterns=["chain-to-pipe", "nested-calls-to-pipe"],
  ~learningObjectives=["Pipe in callbacks", "Readable event handling"],
  ~commonMistakes=["Deeply nested callback logic"],
  ~bestPractices=["Use pipe to flatten callback internals"],
)

// ADDITIONAL IMMUTABILITY PATTERNS
let freezeToRecord = makePattern(
  ~id="freeze-to-record",
  ~name="Object.freeze to Record",
  ~category=Immutability,
  ~difficulty=Beginner,
  ~jsPattern=`Object\\.freeze\\s*\\(`,
  ~confidence=0.9,
  ~jsExample=`const config = Object.freeze({
  apiUrl: 'https://api.example.com',
  timeout: 5000,
  retries: 3,
});`,
  ~rescriptExample=`type config = {
  apiUrl: string,
  timeout: int,
  retries: int,
}

let config = {
  apiUrl: "https://api.example.com",
  timeout: 5000,
  retries: 3,
}
// Already immutable - no freeze needed!`,
  ~narrative={
    celebrate: "Object.freeze for immutability - you value data integrity!",
    minimize: "Object.freeze is shallow and only checked at runtime...",
    better: "ReScript records are immutable by default - deeply and at compile time!",
    safety: "Immutability is enforced by the compiler, not a runtime function.",
    example: "Records: immutable by default, no Object.freeze needed!",
  },
  ~tags=["freeze", "immutable", "record", "const"],
  ~relatedPatterns=["const-to-let", "spread-to-update"],
  ~learningObjectives=["Default immutability", "Compile-time guarantees"],
  ~commonMistakes=["Trying to freeze ReScript records (already immutable)"],
  ~bestPractices=["Trust the type system - records are always immutable"],
)

// ADDITIONAL ARRAY OPERATION PATTERNS
let forEachToIter = makePattern(
  ~id="foreach-to-iter",
  ~name="ForEach to Array.forEach",
  ~category=ArrayOperations,
  ~difficulty=Beginner,
  ~jsPattern=`\\.forEach\\s*\\(\\s*(?:\\w+|\\([^)]*\\))\\s*=>`,
  ~confidence=0.9,
  ~jsExample=`users.forEach(user => {
  console.log(user.name);
  sendEmail(user.email);
});`,
  ~rescriptExample=`users->Array.forEach(user => {
  Console.log(user.name)
  sendEmail(user.email)
})`,
  ~narrative={
    celebrate: "forEach for side effects - you know when NOT to use map!",
    minimize: "Works great, ReScript's version is nearly identical...",
    better: "ReScript's forEach with pipe operator reads cleanly left-to-right!",
    safety: "forEach returns unit - the compiler prevents accidentally using a 'result'.",
    example: "forEach returns unit, not undefined - type-safe side effects!",
  },
  ~tags=["foreach", "array", "side-effect"],
  ~relatedPatterns=["array-map", "array-filter"],
  ~learningObjectives=["Array.forEach", "Side effects vs transforms"],
  ~commonMistakes=["Using map for side effects"],
  ~bestPractices=["Use forEach for side effects, map for transforms"],
)

// ADDITIONAL CONDITIONAL PATTERNS
let guardClause = makePattern(
  ~id="guard-clause",
  ~name="Guard Clause / Early Return",
  ~category=Conditionals,
  ~difficulty=Intermediate,
  ~jsPattern=`if\\s*\\([^)]+\\)\\s*(?:return|throw)`,
  ~confidence=0.7,
  ~jsExample=`function processUser(user) {
  if (!user) return null;
  if (!user.active) return null;
  if (!user.email) throw new Error('No email');
  return sendWelcome(user.email);
}`,
  ~rescriptExample=`let processUser = user =>
  switch user {
  | None => None
  | Some({active: false}) => None
  | Some({email: None}) => Error("No email")
  | Some({email: Some(email), active: true}) => Ok(sendWelcome(email))
  }`,
  ~narrative={
    celebrate: "Guard clauses! Early returns keep your code flat and readable!",
    minimize: "Multiple early returns can make the happy path hard to spot...",
    better: "ReScript pattern matching handles all guards in one clear expression!",
    safety: "Pattern matching ensures you've considered every case explicitly.",
    example: "Pattern matching replaces guard clauses with exhaustive case analysis!",
  },
  ~tags=["guard", "early-return", "pattern-matching"],
  ~relatedPatterns=["if-else-chain", "switch-to-match"],
  ~learningObjectives=["Pattern matching for guards", "Exhaustive case analysis"],
  ~commonMistakes=["Forgetting a guard case"],
  ~bestPractices=["Use pattern matching to make all cases explicit"],
)

// PATTERN LIBRARY
let patternLibrary: array<pattern> = [
  // Null Safety (3)
  nullCheckBasic,
  nullCheckTernary,
  optionalChaining,
  // Async (2)
  asyncAwaitBasic,
  promiseThen,
  // Error Handling (2)
  tryCatchBasic,
  errorResultType,
  // Array Operations (4)
  arrayMap,
  arrayFilter,
  arrayReduce,
  arrayFind,
  // Conditionals (2)
  switchStatement,
  ifElseChain,
  // Functional (2)
  pureFunction,
  higherOrderFunction,
  // Destructuring (2)
  objectDestructuring,
  arrayDestructuring,
  // Defaults (2)
  defaultParams,
  nullishCoalescing,
  // Templates (2)
  templateLiterals,
  taggedTemplates,
  // Arrow Functions (2)
  arrowFunction,
  arrowImplicitReturn,
  // Variants (2)
  enumToVariant,
  unionToVariant,
  // Modules (2)
  namespaceToModule,
  importToOpen,
  // Type Safety (3)
  typeAssertionToType,
  anyToTyped,
  typeGuardFnToVariant,
  // Immutability (3)
  constToLet,
  spreadToUpdate,
  freezeToRecord,
  // Pattern Matching (2)
  switchToMatch,
  nestedTernaryToMatch,
  // Pipe Operator (3)
  chainToPipe,
  nestedCallsToPipe,
  callbackToPipe,
  // OOP to FP (2)
  classMethodToFunction,
  thisToModule,
  // Classes to Records (2)
  classToRecord,
  getterToField,
  // Inheritance to Composition (2)
  inheritanceToComposition,
  mixinToModule,
  // State Machines (2)
  stateMachine,
  reducerToVariant,
  // Data Modeling (2)
  interfaceToType,
  nestedObjectToVariant,
  // Additional Variants (1)
  typeGuardToVariant,
  // Additional Functional (1)
  compose,
  // Additional Array Operations (1)
  forEachToIter,
  // Additional Conditionals (1)
  guardClause,
]

// Get pattern by ID
let getPatternById = (id: string): option<pattern> => {
  patternLibrary->Array.find(p => p.id === id)
}

// Get patterns by category
let getPatternsByCategory = (category: patternCategory): array<pattern> => {
  patternLibrary->Array.filter(p => p.category === category)
}

// Get patterns by difficulty
let getPatternsByDifficulty = (difficulty: difficultyLevel): array<pattern> => {
  patternLibrary->Array.filter(p => p.difficulty === difficulty)
}

// Create regex from pattern string
@val external createRegex: (string, string) => Nullable.t<RegExp.t> = "RegExp"

// Detect patterns in code
let detectPatterns = (code: string): array<pattern> => {
  patternLibrary
  ->Array.filter(pattern => {
    switch createRegex(pattern.jsPattern, "")->Nullable.toOption {
    | Some(regex) => regex->RegExp.test(code)
    | None => false
    }
  })
  ->Array.toSorted((a, b) => b.confidence -. a.confidence)
}

// Get total pattern count
let getPatternCount = (): int => {
  patternLibrary->Array.length
}

// Get pattern statistics
let getPatternStats = (): patternStats => {
  let byCategory = Dict.make()
  let byDifficulty = Dict.make()

  patternLibrary->Array.forEach(pattern => {
    let catStr = categoryToString(pattern.category)
    let diffStr = difficultyToString(pattern.difficulty)

    let catCount = byCategory->Dict.get(catStr)->Option.getOr(0)
    byCategory->Dict.set(catStr, catCount + 1)

    let diffCount = byDifficulty->Dict.get(diffStr)->Option.getOr(0)
    byDifficulty->Dict.set(diffStr, diffCount + 1)
  })

  {
    total: patternLibrary->Array.length,
    byCategory,
    byDifficulty,
  }
}
