// SPDX-License-Identifier: PMPL-1.0-or-later
// Makaton-inspired glyph system for Nextgen Languages Evangeliser
// Glyphs transcend syntax to show semantic meaning.

open Types

// Core set of glyphs representing fundamental programming concepts
let coreGlyphs: Dict.t<glyph> = Dict.fromArray([
  (
    "TRANSFORM",
    {
      symbol: `🔄`,
      name: "Transform",
      meaning: "Data transformation or mapping operation",
      semanticCategory: Transformation,
      usageExample: "array.map(x => x * 2) becomes array->Array.map(x => x * 2)",
    },
  ),
  (
    "TARGET",
    {
      symbol: `🎯`,
      name: "Target",
      meaning: "Precise type targeting - no ambiguity",
      semanticCategory: Safety,
      usageExample: "Explicit type annotation ensures correctness",
    },
  ),
  (
    "SHIELD",
    {
      symbol: `🛡️`,
      name: "Shield",
      meaning: "Protection from null/undefined errors",
      semanticCategory: Safety,
      usageExample: "Option<string> prevents null reference errors",
    },
  ),
  (
    "FLOW",
    {
      symbol: `➡️`,
      name: "Flow",
      meaning: "Pipe operator - data flows naturally left to right",
      semanticCategory: Flow,
      usageExample: "data->transform->filter->map reads like English",
    },
  ),
  (
    "BRANCH",
    {
      symbol: `🌿`,
      name: "Branch",
      meaning: "Pattern matching - exhaustive branching",
      semanticCategory: Flow,
      usageExample: "switch statement with all cases covered",
    },
  ),
  (
    "PACKAGE",
    {
      symbol: `📦`,
      name: "Package",
      meaning: "Module or encapsulated data structure",
      semanticCategory: Structure,
      usageExample: "Module or record type grouping related data",
    },
  ),
  (
    "LINK",
    {
      symbol: `🔗`,
      name: "Link",
      meaning: "Composition - connecting functions or modules",
      semanticCategory: Structure,
      usageExample: "Function composition or module composition",
    },
  ),
  (
    "CRYSTAL",
    {
      symbol: `💎`,
      name: "Crystal",
      meaning: "Immutability - unchanging, pure data",
      semanticCategory: Data,
      usageExample: "Immutable data structures prevent accidental mutation",
    },
  ),
  (
    "HOURGLASS",
    {
      symbol: `⏳`,
      name: "Hourglass",
      meaning: "Async operation - time-dependent computation",
      semanticCategory: Flow,
      usageExample: "async/await or Promise handling",
    },
  ),
  (
    "CHECKPOINT",
    {
      symbol: `✅`,
      name: "Checkpoint",
      meaning: "Result type - explicit success/failure handling",
      semanticCategory: Safety,
      usageExample: "Result<success, error> makes error handling explicit",
    },
  ),
  (
    "LIGHT",
    {
      symbol: `💡`,
      name: "Light",
      meaning: "Type inference - compiler figures it out for you",
      semanticCategory: Safety,
      usageExample: "ReScript infers types without verbose annotations",
    },
  ),
])

// Extended glyphs for additional patterns
let extendedGlyphs: Dict.t<glyph> = Dict.fromArray([
  (
    "GEAR",
    {
      symbol: `⚙️`,
      name: "Gear",
      meaning: "Function - a working mechanism",
      semanticCategory: Transformation,
      usageExample: "Pure function that transforms inputs to outputs",
    },
  ),
  (
    "STACK",
    {
      symbol: `📚`,
      name: "Stack",
      meaning: "Collection or sequence of items",
      semanticCategory: Data,
      usageExample: "Array, List, or Stack data structure",
    },
  ),
  (
    "LOCK",
    {
      symbol: `🔒`,
      name: "Lock",
      meaning: "Encapsulation - private implementation",
      semanticCategory: Structure,
      usageExample: "Private module members or abstract types",
    },
  ),
  (
    "KEY",
    {
      symbol: `🔑`,
      name: "Key",
      meaning: "Access - public API or interface",
      semanticCategory: Structure,
      usageExample: "Public module signature or interface",
    },
  ),
  (
    "RECYCLE",
    {
      symbol: `♻️`,
      name: "Recycle",
      meaning: "Recursion - function calls itself",
      semanticCategory: Flow,
      usageExample: "Recursive function processing",
    },
  ),
  (
    "FILTER",
    {
      symbol: `🔍`,
      name: "Filter",
      meaning: "Selection or filtering operation",
      semanticCategory: Transformation,
      usageExample: "Array.filter or pattern matching with guards",
    },
  ),
  (
    "MERGE",
    {
      symbol: `🔀`,
      name: "Merge",
      meaning: "Combining or merging data",
      semanticCategory: Transformation,
      usageExample: "Object spread, record update, or concatenation",
    },
  ),
  (
    "WARNING",
    {
      symbol: `⚠️`,
      name: "Warning",
      meaning: "Potential issue or anti-pattern",
      semanticCategory: Safety,
      usageExample: "Code that could be improved for safety",
    },
  ),
  (
    "ROCKET",
    {
      symbol: `🚀`,
      name: "Rocket",
      meaning: "Performance optimization",
      semanticCategory: Transformation,
      usageExample: "Fast, optimized code generation",
    },
  ),
  (
    "PUZZLE",
    {
      symbol: `🧩`,
      name: "Puzzle",
      meaning: "Type composition - building complex types from simple ones",
      semanticCategory: Structure,
      usageExample: "Variant types, record types, or type composition",
    },
  ),
])

// Get all available glyphs
let getAllGlyphs = (): array<glyph> => {
  let core = coreGlyphs->Dict.valuesToArray
  let extended = extendedGlyphs->Dict.valuesToArray
  Array.concat(core, extended)
}

// Get glyph by symbol
let getGlyphBySymbol = (symbol: string): option<glyph> => {
  getAllGlyphs()->Array.find(g => g.symbol === symbol)
}

// Get glyphs by semantic category
let getGlyphsByCategory = (category: semanticCategory): array<glyph> => {
  getAllGlyphs()->Array.filter(g => g.semanticCategory === category)
}

// Annotate code with glyphs based on detected patterns
let annotateWithGlyphs = (code: string, glyphSymbols: array<string>): string => {
  let glyphBar = glyphSymbols->Array.join(" ")
  `${glyphBar}\n${code}`
}

// Create a glyph legend for educational purposes
let createGlyphLegend = (): string => {
  let categories = [Safety, Transformation, Flow, Structure, Data]

  let legend = ref("# Glyph Legend\n\nVisual symbols representing programming concepts:\n\n")

  categories->Array.forEach(category => {
    let categoryGlyphs = getGlyphsByCategory(category)
    if categoryGlyphs->Array.length > 0 {
      let categoryName = switch category {
      | Safety => "Safety"
      | Transformation => "Transformation"
      | Flow => "Flow"
      | Structure => "Structure"
      | State => "State"
      | Data => "Data"
      }
      legend := legend.contents ++ `## ${categoryName}\n\n`

      categoryGlyphs->Array.forEach(glyph => {
        legend :=
          legend.contents ++
          `- ${glyph.symbol} **${glyph.name}**: ${glyph.meaning}\n` ++
          `  - Example: ${glyph.usageExample}\n\n`
      })
    }
  })

  legend.contents
}

// Get glyphs for a specific pattern category
let getGlyphsForPattern = (patternCategory: patternCategory): array<string> => {
  switch patternCategory {
  | NullSafety => [`🛡️`, `✅`, `💎`]
  | Async => [`⏳`, `🔄`, `➡️`]
  | ErrorHandling => [`✅`, `🛡️`, `🌿`]
  | ArrayOperations => [`🔄`, `📚`, `🔍`]
  | Conditionals => [`🌿`, `🎯`, `🧩`]
  | Destructuring => [`📦`, `🔑`, `🔀`]
  | Defaults => [`🛡️`, `💎`, `🎯`]
  | Functional => [`⚙️`, `🔗`, `💎`]
  | Templates => [`🔄`, `🔀`, `➡️`]
  | ArrowFunctions => [`⚙️`, `➡️`, `🔄`]
  | Variants => [`🧩`, `🌿`, `🎯`]
  | Modules => [`📦`, `🔒`, `🔑`]
  | TypeSafety => [`🎯`, `🛡️`, `💡`]
  | Immutability => [`💎`, `🔒`, `🛡️`]
  | PatternMatching => [`🌿`, `🎯`, `✅`]
  | PipeOperator => [`➡️`, `🔄`, `🔗`]
  | OopToFp => [`⚙️`, `💎`, `🔗`]
  | ClassesToRecords => [`📦`, `💎`, `🎯`]
  | InheritanceToComposition => [`🔗`, `🧩`, `📦`]
  | StateMachines => [`🌿`, `🧩`, `✅`]
  | DataModeling => [`🧩`, `📦`, `🎯`]
  }
}
