# TEST-NEEDS.md — nextgen-languages-evangeliser

## CRG Grade: C — ACHIEVED 2026-04-04

## Current Test State

| Category | Count | Notes |
|----------|-------|-------|
| ReScript unit tests | 6 | `test/{Analyser,Glyphs,Narrative,Patterns,Scanner,Types}_test.res` |
| Test framework | ReScript built-in | Jest-compatible |

## What's Covered

- [x] Analyser pattern testing
- [x] Glyph representation tests
- [x] Narrative generator tests
- [x] Pattern matching tests
- [x] Scanner tokenization tests
- [x] Type system tests

## Still Missing (for CRG B+)

- [ ] Property-based pattern generation
- [ ] Integration tests with external tools
- [ ] Performance benchmarks
- [ ] End-to-end evangelism flow tests

## Run Tests

```bash
cd /var/mnt/eclipse/repos/nextgen-languages-evangeliser && rescript build && npm test
```
