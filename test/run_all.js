#!/usr/bin/env -S deno run --allow-read --allow-env
// SPDX-License-Identifier: PMPL-1.0-or-later
// Test runner: imports all compiled test modules sequentially

import "./Types_test.res.js"
import "./Glyphs_test.res.js"
import "./Narrative_test.res.js"
import "./Patterns_test.res.js"
import "./Scanner_test.res.js"
import "./Analyser_test.res.js"

console.log("========================================")
console.log("All test suites passed!")
console.log("========================================")
