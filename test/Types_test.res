// SPDX-License-Identifier: MPL-2.0
// Tests for Types module helper functions

open Types

// Simple test helper
let assert_ = (condition, message) => {
  if !condition {
    JsError.throwWithMessage(`FAIL: ${message}`)
  }
}

let testCategoryToString = () => {
  assert_(categoryToString(NullSafety) === "null-safety", "NullSafety -> null-safety")
  assert_(categoryToString(Async) === "async", "Async -> async")
  assert_(categoryToString(ErrorHandling) === "error-handling", "ErrorHandling -> error-handling")
  assert_(categoryToString(ArrayOperations) === "array-operations", "ArrayOperations -> array-operations")
  assert_(categoryToString(Conditionals) === "conditionals", "Conditionals -> conditionals")
  assert_(categoryToString(Destructuring) === "destructuring", "Destructuring -> destructuring")
  assert_(categoryToString(Defaults) === "defaults", "Defaults -> defaults")
  assert_(categoryToString(Functional) === "functional", "Functional -> functional")
  assert_(categoryToString(Templates) === "templates", "Templates -> templates")
  assert_(categoryToString(ArrowFunctions) === "arrow-functions", "ArrowFunctions -> arrow-functions")
  assert_(categoryToString(Variants) === "variants", "Variants -> variants")
  assert_(categoryToString(Modules) === "modules", "Modules -> modules")
  assert_(categoryToString(TypeSafety) === "type-safety", "TypeSafety -> type-safety")
  assert_(categoryToString(Immutability) === "immutability", "Immutability -> immutability")
  assert_(categoryToString(PatternMatching) === "pattern-matching", "PatternMatching -> pattern-matching")
  assert_(categoryToString(PipeOperator) === "pipe-operator", "PipeOperator -> pipe-operator")
  assert_(categoryToString(OopToFp) === "oop-to-fp", "OopToFp -> oop-to-fp")
  assert_(categoryToString(ClassesToRecords) === "classes-to-records", "ClassesToRecords -> classes-to-records")
  assert_(
    categoryToString(InheritanceToComposition) === "inheritance-to-composition",
    "InheritanceToComposition -> inheritance-to-composition",
  )
  assert_(categoryToString(StateMachines) === "state-machines", "StateMachines -> state-machines")
  assert_(categoryToString(DataModeling) === "data-modeling", "DataModeling -> data-modeling")
  Console.log("PASS: categoryToString - all 21 categories")
}

let testDifficultyToString = () => {
  assert_(difficultyToString(Beginner) === "beginner", "Beginner -> beginner")
  assert_(difficultyToString(Intermediate) === "intermediate", "Intermediate -> intermediate")
  assert_(difficultyToString(Advanced) === "advanced", "Advanced -> advanced")
  Console.log("PASS: difficultyToString - all 3 levels")
}

let testViewLayerToString = () => {
  assert_(viewLayerToString(RAW) === "RAW", "RAW -> RAW")
  assert_(viewLayerToString(FOLDED) === "FOLDED", "FOLDED -> FOLDED")
  assert_(viewLayerToString(GLYPHED) === "GLYPHED", "GLYPHED -> GLYPHED")
  assert_(viewLayerToString(WYSIWYG) === "WYSIWYG", "WYSIWYG -> WYSIWYG")
  Console.log("PASS: viewLayerToString - all 4 layers")
}

let runAll = () => {
  Console.log("=== Types Tests ===")
  testCategoryToString()
  testDifficultyToString()
  testViewLayerToString()
  Console.log("=== All Types tests passed ===\n")
}

runAll()
