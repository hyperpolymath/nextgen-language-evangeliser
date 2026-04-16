// SPDX-License-Identifier: PMPL-1.0-or-later
// Core type definitions for Nextgen Languages Evangeliser
// Philosophy: "Celebrate good, minimize bad, show better"

type viewLayer = RAW | FOLDED | GLYPHED | WYSIWYG

type difficultyLevel = Beginner | Intermediate | Advanced

type patternCategory =
  | NullSafety
  | Async
  | ErrorHandling
  | ArrayOperations
  | Conditionals
  | Destructuring
  | Defaults
  | Functional
  | Templates
  | ArrowFunctions
  | Variants
  | Modules
  | TypeSafety
  | Immutability
  | PatternMatching
  | PipeOperator
  | OopToFp
  | ClassesToRecords
  | InheritanceToComposition
  | StateMachines
  | DataModeling

type semanticCategory =
  | Transformation
  | Safety
  | Flow
  | Structure
  | State
  | Data

// Target languages the evangeliser can emit examples for.
// AffineScript is the flagship (Phase 2 onward); ReScript is the legacy
// catalogue preserved during migration. Others are planned (Phase 5+).
type targetLang =
  | AffineScript
  | ReScript
  | Rust
  | Gleam
  | Zig

// Flagship target — consumed by Cli/Output when --target is not specified.
let flagshipTarget: targetLang = AffineScript

// A Makaton-inspired glyph that represents semantic meaning beyond syntax
type glyph = {
  symbol: string,
  name: string,
  meaning: string,
  semanticCategory: semanticCategory,
  usageExample: string,
}

// Encouraging narrative following "Celebrate, Minimize, Better" philosophy
type narrative = {
  celebrate: string,
  minimize: string,
  better: string,
  safety: string,
  example: string,
}

// A single target-language example for a pattern.
// In Phase 1b, only `code` varies per target; narrative is shared at
// pattern level. In Phase 2 this record can gain an optional per-target
// narrative override so AffineScript's affine-safety pitch differs from
// ReScript's Option-type pitch.
type targetExample = {
  language: targetLang,
  code: string,
}

// A transformation pattern from JavaScript to one or more target languages.
type pattern = {
  id: string,
  name: string,
  category: patternCategory,
  difficulty: difficultyLevel,
  jsPattern: string,
  confidence: float,
  jsExample: string,
  // Multi-target: each entry pairs a target language with its example code.
  // Patterns must have at least one target; the first target is used as
  // fallback if --target requests a language this pattern has not been
  // ported to yet.
  targets: array<targetExample>,
  narrative: narrative,
  glyphs: array<string>,
  tags: array<string>,
  relatedPatterns: array<string>,
  learningObjectives: array<string>,
  commonMistakes: array<string>,
  bestPractices: array<string>,
}

// A matched pattern in user's code
type patternMatch = {
  pattern: pattern,
  code: string,
  startLine: int,
  endLine: int,
  confidence: float,
  transformation: option<string>,
}

// Analysis result for a file or selection
type analysisResult = {
  matches: array<patternMatch>,
  totalPatterns: int,
  coveragePercentage: float,
  difficulty: difficultyLevel,
  suggestedNextPatterns: array<pattern>,
  analysisTime: float,
  memoryUsed: int,
}

// User's learning progress
type rec learningProgress = {
  patternsCompleted: Set.t<string>,
  currentDifficulty: difficultyLevel,
  totalTransformations: int,
  favoritePatterns: array<string>,
  achievements: array<achievement>,
  startDate: Date.t,
  lastActive: Date.t,
}
and achievement = {
  achievementId: string,
  achievementName: string,
  description: string,
  icon: string,
  unlockedAt: option<Date.t>,
}

// Extension configuration
type extensionConfig = {
  defaultView: viewLayer,
  showNarratives: bool,
  autoDetectPatterns: bool,
  difficultyLevel: option<difficultyLevel>,
  enableTelemetry: bool,
  performanceMode: bool,
  customPatternPaths: array<string>,
}

// Pattern statistics
type patternStats = {
  total: int,
  byCategory: Dict.t<int>,
  byDifficulty: Dict.t<int>,
}

// Helper functions for category string conversion
let categoryToString = (category: patternCategory): string => {
  switch category {
  | NullSafety => "null-safety"
  | Async => "async"
  | ErrorHandling => "error-handling"
  | ArrayOperations => "array-operations"
  | Conditionals => "conditionals"
  | Destructuring => "destructuring"
  | Defaults => "defaults"
  | Functional => "functional"
  | Templates => "templates"
  | ArrowFunctions => "arrow-functions"
  | Variants => "variants"
  | Modules => "modules"
  | TypeSafety => "type-safety"
  | Immutability => "immutability"
  | PatternMatching => "pattern-matching"
  | PipeOperator => "pipe-operator"
  | OopToFp => "oop-to-fp"
  | ClassesToRecords => "classes-to-records"
  | InheritanceToComposition => "inheritance-to-composition"
  | StateMachines => "state-machines"
  | DataModeling => "data-modeling"
  }
}

let difficultyToString = (difficulty: difficultyLevel): string => {
  switch difficulty {
  | Beginner => "beginner"
  | Intermediate => "intermediate"
  | Advanced => "advanced"
  }
}

let viewLayerToString = (view: viewLayer): string => {
  switch view {
  | RAW => "RAW"
  | FOLDED => "FOLDED"
  | GLYPHED => "GLYPHED"
  | WYSIWYG => "WYSIWYG"
  }
}

// Canonical string name for a target language (lowercase, used in CLI args).
let targetLangToString = (t: targetLang): string => {
  switch t {
  | AffineScript => "affinescript"
  | ReScript => "rescript"
  | Rust => "rust"
  | Gleam => "gleam"
  | Zig => "zig"
  }
}

// Display-friendly label (capitalisation for rendering).
let targetLangLabel = (t: targetLang): string => {
  switch t {
  | AffineScript => "AffineScript"
  | ReScript => "ReScript"
  | Rust => "Rust"
  | Gleam => "Gleam"
  | Zig => "Zig"
  }
}

// Markdown / Rouge syntax-highlighter tag for a target language.
let targetLangSyntaxTag = (t: targetLang): string => {
  switch t {
  | AffineScript => "affinescript"
  | ReScript => "rescript"
  | Rust => "rust"
  | Gleam => "gleam"
  | Zig => "zig"
  }
}

let stringToTargetLang = (s: string): option<targetLang> => {
  switch String.toLowerCase(s) {
  | "affinescript" | "affine" | "as" => Some(AffineScript)
  | "rescript" | "res" => Some(ReScript)
  | "rust" | "rs" => Some(Rust)
  | "gleam" => Some(Gleam)
  | "zig" => Some(Zig)
  | _ => None
  }
}

// Find the example code for a specific target language in a pattern.
// Returns None if the pattern has no entry for that target.
let patternExampleFor = (p: pattern, lang: targetLang): option<targetExample> => {
  p.targets->Array.find(t => t.language == lang)
}

// Get the code string for a specific target, falling back to the first
// available target if the requested one is not present. Empty string if
// the pattern has no targets at all (should never happen in practice).
let patternCodeFor = (p: pattern, lang: targetLang): string => {
  switch patternExampleFor(p, lang) {
  | Some(t) => t.code
  | None =>
    switch p.targets->Array.get(0) {
    | Some(t) => t.code
    | None => ""
    }
  }
}

// The effective target for a pattern given a requested target: the
// requested one if supported, else the pattern's first target (fallback).
let patternEffectiveTarget = (p: pattern, requested: targetLang): targetLang => {
  switch patternExampleFor(p, requested) {
  | Some(_) => requested
  | None =>
    switch p.targets->Array.get(0) {
    | Some(t) => t.language
    | None => requested
    }
  }
}
