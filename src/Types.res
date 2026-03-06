// SPDX-License-Identifier: MIT OR Palimpsest-0.8
// Core type definitions for ReScript Evangeliser
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

// A transformation pattern from JavaScript to ReScript
type pattern = {
  id: string,
  name: string,
  category: patternCategory,
  difficulty: difficultyLevel,
  jsPattern: string,
  confidence: float,
  jsExample: string,
  rescriptExample: string,
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
