// SPDX-License-Identifier: PMPL-1.0-or-later
// Narrative generation for Nextgen Languages Evangeliser
// Philosophy: "Celebrate good, minimize bad, show better"
// - NEVER shame developers
// - ALWAYS celebrate what their JavaScript does well
// - Gently show how ReScript makes it even better

open Types

// Template for narrative generation
type narrativeTemplate = {
  celebrate: array<string>,
  minimize: array<string>,
  better: array<string>,
  safety: array<string>,
}

// Pick a random element from an array
let pickRandom = (arr: array<string>): string => {
  let len = arr->Array.length
  if len === 0 {
    ""
  } else {
    let idx = Math.floor(Math.random() *. Int.toFloat(len))->Float.toInt
    arr->Array.getUnsafe(idx)
  }
}

// Narrative templates organized by category
let narrativeTemplates: Dict.t<narrativeTemplate> = Dict.fromArray([
  (
    "null-safety",
    {
      celebrate: [
        "You're already thinking about null and undefined - that's great defensive programming!",
        "Nice! You're checking for null values - you understand the importance of safety.",
        "You've got null checks in place - you're already thinking like a type-safe developer!",
        "Smart move checking for null! You know that data isn't always what you expect.",
      ],
      minimize: [
        "The only small thing is that it's easy to forget one of these checks somewhere...",
        "It's just a tiny bit verbose with all these conditional checks...",
        "These checks work, though they do add a bit of cognitive overhead...",
        "Nothing wrong with this approach, it's just that there's a way to make it even simpler...",
      ],
      better: [
        "ReScript's Option type makes null safety automatic - you literally can't forget a check!",
        "With ReScript, the compiler ensures you handle the None case - no runtime surprises!",
        "ReScript's Option type gives you the same safety with cleaner, more expressive code.",
        "In ReScript, null safety is built into the type system - it's impossible to forget!",
      ],
      safety: [
        "The compiler won't let your code compile until you've handled both Some and None cases.",
        "100% null-safe at compile time - no more 'Cannot read property of undefined' errors!",
        "Type-level guarantee that you've considered the absence of a value.",
        "ReScript eliminates an entire class of runtime errors related to null/undefined.",
      ],
    },
  ),
  (
    "async",
    {
      celebrate: [
        "Async/await is a huge improvement over callback hell - you're writing modern JavaScript!",
        "Great use of async/await! You understand asynchronous programming patterns.",
        "Nice! You're already using async/await - you know how to handle asynchronous operations.",
        "You've mastered one of JavaScript's most powerful features - async/await!",
      ],
      minimize: [
        "The only thing is that error handling can get a bit scattered with try/catch...",
        "It works great, though tracking all the possible error states can be tricky...",
        "This is solid code, there's just a way to make async errors more explicit...",
        "Nothing wrong here, but error paths aren't always obvious in the type system...",
      ],
      better: [
        "ReScript makes async operations type-safe with Promise types that flow through your code!",
        "With ReScript, your async functions have explicit return types - no surprises!",
        "ReScript's type system tracks async operations and ensures you handle all cases.",
        "In ReScript, async errors are part of the type signature - impossible to ignore!",
      ],
      safety: [
        "The compiler ensures you handle both success and failure cases for async operations.",
        "Type-level tracking of async operations prevents race conditions and timing bugs.",
        "Explicit Promise types make async behavior clear and prevent common mistakes.",
        "ReScript's type system catches async errors at compile time, not runtime.",
      ],
    },
  ),
  (
    "error-handling",
    {
      celebrate: [
        "Excellent! You're using try/catch - you know that errors need handling!",
        "Great defensive programming! You're catching errors before they crash the app.",
        "You understand that things can go wrong - that's mature error handling!",
        "Nice! You're already thinking about the unhappy path - many developers forget this.",
      ],
      minimize: [
        "The only small thing is that errors can sometimes slip through if you're not careful...",
        "It works well, though it's easy to forget error handling in some code paths...",
        "This is good, there's just a way to make errors impossible to ignore...",
        "Nothing wrong with try/catch, but the type system doesn't help track errors...",
      ],
      better: [
        "ReScript's Result type makes errors explicit - they're part of your function signature!",
        "With Result<success, error>, you can't ignore errors - the compiler won't let you!",
        "ReScript treats errors as values, making them composable and type-safe.",
        "In ReScript, error handling is enforced by the type system - no forgotten catch blocks!",
      ],
      safety: [
        "The compiler ensures you handle both Ok and Error cases - no silent failures!",
        "Result types make error handling explicit and impossible to ignore.",
        "Type-safe error handling means errors are documented in function signatures.",
        "ReScript eliminates the possibility of unhandled exceptions at compile time.",
      ],
    },
  ),
  (
    "array-operations",
    {
      celebrate: [
        "Perfect! You're using array methods like map and filter - functional programming at its best!",
        "Great use of array operations! You understand how to work with collections.",
        "Nice! These array methods are exactly the right tool for transforming data.",
        "You're writing functional code with map/filter/reduce - that's excellent!",
      ],
      minimize: [
        "The only thing is that these methods can sometimes be chained in ways that are hard to read...",
        "It works perfectly, there's just a more readable way to express these transformations...",
        "This is fine, though deeply nested callbacks can get a bit hard to follow...",
        "Nothing wrong here, but there's a syntax that makes data flow even clearer...",
      ],
      better: [
        "ReScript's pipe operator lets you write these transformations in reading order!",
        "With ReScript's ->, data transformations read like a sentence from left to right!",
        "ReScript makes array operations more readable with the pipe operator and better inference.",
        "In ReScript, you can chain operations naturally with -> and the compiler handles the rest!",
      ],
      safety: [
        "Type inference ensures your array transformations are always type-safe.",
        "The compiler catches type mismatches in your data pipelines before runtime.",
        "ReScript's array operations are fully typed - no runtime type errors!",
        "Type-safe array operations prevent common mistakes like accessing undefined indices.",
      ],
    },
  ),
  (
    "conditionals",
    {
      celebrate: [
        "Good use of conditionals! You're handling different cases in your logic.",
        "Nice! You're thinking through the different paths your code can take.",
        "Great! You understand that code needs to branch based on different conditions.",
        "You're handling multiple cases - that's thorough programming!",
      ],
      minimize: [
        "The only thing is that it's possible to miss a case with if/else chains...",
        "It works, though the compiler can't help you know if you've covered all cases...",
        "This is solid, there's just a way to make sure you never forget a case...",
        "Nothing wrong with if/else, but there's a more exhaustive way to handle cases...",
      ],
      better: [
        "ReScript's pattern matching ensures you handle ALL cases - the compiler checks!",
        "With switch expressions, ReScript won't compile until all cases are covered!",
        "ReScript's pattern matching is exhaustive - impossible to forget a case!",
        "In ReScript, switch is an expression with compile-time exhaustiveness checking!",
      ],
      safety: [
        "Exhaustive pattern matching means every case is handled - no forgotten branches!",
        "The compiler proves you've covered all possible values - no runtime surprises!",
        "Pattern matching with exhaustiveness checking eliminates an entire class of bugs.",
        "ReScript's switch won't compile until you've handled every possible case!",
      ],
    },
  ),
  (
    "functional",
    {
      celebrate: [
        "Excellent! You're using pure functions - you understand functional programming!",
        "Great! These functions are predictable and testable - that's good design!",
        "Nice functional code! You're avoiding side effects and mutations.",
        "You're writing pure functions - that's a sign of a skilled developer!",
      ],
      minimize: [
        "The only thing is that JavaScript doesn't enforce purity - it's easy to slip...",
        "It works great, though mutations can accidentally creep in...",
        "This is solid functional code, there's just a way to make purity automatic...",
        "Nothing wrong here, but JavaScript allows mutations that can break purity...",
      ],
      better: [
        "ReScript makes immutability the default - you have to explicitly opt into mutation!",
        "With ReScript, functional programming is natural and enforced by the type system!",
        "ReScript's immutable-by-default data structures prevent accidental side effects!",
        "In ReScript, pure functional programming is the easy path, not the hard one!",
      ],
      safety: [
        "Immutability by default means no accidental mutations - safer concurrent code!",
        "The type system ensures your functions are actually pure - no hidden side effects!",
        "ReScript's functional features prevent entire categories of bugs related to shared state.",
        "Compiler-enforced immutability makes your code more predictable and testable!",
      ],
    },
  ),
  (
    "default",
    {
      celebrate: [
        "You're already writing good JavaScript - this pattern works!",
        "Nice! You understand this programming concept well.",
        "Great code! You're using modern JavaScript features effectively.",
        "You've got the right idea - this is solid programming!",
      ],
      minimize: [
        "There's just a small opportunity to make this even better...",
        "It works perfectly, there's just a more type-safe way to express this...",
        "Nothing wrong with this approach, but ReScript has a nice enhancement...",
        "This is fine, there's just a way to get more compiler help...",
      ],
      better: [
        "ReScript brings type safety and better error messages to this pattern!",
        "With ReScript, you get the same functionality with stronger guarantees!",
        "ReScript makes this pattern more explicit and catches errors earlier!",
        "In ReScript, this becomes even more clear and type-safe!",
      ],
      safety: [
        "The compiler provides stronger guarantees about correctness!",
        "Type safety catches potential issues before they become runtime errors!",
        "ReScript's type system helps prevent common mistakes in this pattern!",
        "Compile-time checking means more confidence in your code!",
      ],
    },
  ),
])

// Get template for a category
let getTemplateForCategory = (category: patternCategory): narrativeTemplate => {
  let categoryStr = categoryToString(category)
  switch narrativeTemplates->Dict.get(categoryStr) {
  | Some(template) => template
  | None =>
    switch narrativeTemplates->Dict.get("default") {
    | Some(t) => t
    | None => {
        celebrate: [],
        minimize: [],
        better: [],
        safety: [],
      }
    }
  }
}

// Generate narrative based on pattern category
let generateCategoryNarrative = (category: patternCategory, patternName: string): narrative => {
  let template = getTemplateForCategory(category)

  {
    celebrate: pickRandom(template.celebrate),
    minimize: pickRandom(template.minimize),
    better: pickRandom(template.better),
    safety: pickRandom(template.safety),
    example: `See how the ${patternName} pattern works in ReScript!`,
  }
}

// Generate an encouraging narrative for a pattern
let generateNarrative = (pattern: pattern): narrative => {
  pattern.narrative
}

// Format narrative for display
let formatNarrative = (narrative: narrative, format: string): string => {
  switch format {
  | "plain" =>
    `${narrative.celebrate}

${narrative.minimize}

${narrative.better}

🛡️ Safety: ${narrative.safety}

💡 ${narrative.example}`

  | "html" =>
    `<div class="narrative">
  <p class="celebrate">✨ ${narrative.celebrate}</p>
  <p class="minimize">💭 ${narrative.minimize}</p>
  <p class="better">🚀 ${narrative.better}</p>
  <p class="safety"><strong>🛡️ Safety:</strong> ${narrative.safety}</p>
  <p class="example"><em>💡 ${narrative.example}</em></p>
</div>`

  | _ =>
    // markdown (default)
    `✨ **You were close!** ${narrative.celebrate}

💭 ${narrative.minimize}

🚀 **Even better:** ${narrative.better}

🛡️ **Safety:** ${narrative.safety}

💡 *${narrative.example}*`
  }
}

// Generate a success message for completed transformations
let generateSuccessMessage = (patternName: string, _difficulty: string): string => {
  let messages = [
    `Awesome! You've mastered the ${patternName} pattern! 🎉`,
    `Great job! ${patternName} is now part of your ReScript toolkit! ✨`,
    `Excellent work! You understand ${patternName} in ReScript! 🚀`,
    `Well done! ${patternName} - another pattern conquered! 💪`,
  ]
  pickRandom(messages)
}

// Generate an encouraging hint for learning
let generateHint = (pattern: pattern): string => {
  let hints = [
    `💡 Tip: ${pattern.bestPractices->Array.get(0)->Option.getOr("Practice makes perfect!")}`,
    `🎯 Remember: ${pattern.learningObjectives->Array.get(0)->Option.getOr("Focus on understanding the concept.")}`,
    `⚠️ Watch out: ${pattern.commonMistakes->Array.get(0)->Option.getOr("Take your time and read the examples.")}`,
    `✨ Pro tip: Try transforming your own code to really internalize this pattern!`,
  ]
  pickRandom(hints)
}
