# TEST-NEEDS.md — nextgen-languages-evangeliser

## CRG Grade: C — ACHIEVED 2026-04-04

## Current Test State

| Category | Count | Notes |
|----------|-------|-------|
| Cartridge invariant tests | 1 suite | `test/run_all.js` (Deno) — 59 assertions over the correspondence facts |
| Cartridge schema validation | 1 | `scripts/validate-cartridges.js` (Deno + ajv, JSON-Schema 2020-12) |
| Idris2 ABI typecheck | 1 | `abi.ipkg` / `src/interface/Abi/*.idr` (CI: idris2-abi.yml) |
| Test framework | Deno + ajv + Idris2 | host-language unit tests removed with the ReScript host |

## What's Covered

- [x] Every correspondence is classified by one of the six CorrespondenceKinds
- [x] Well-formedness: Forms (language + surface), residue shapes, strata names/booleans
- [x] False-friend signature (surface holds ∧ intention diverges) — mirrors `Abi.Correspondence.isFalseFriendShape`
- [x] Residue direction for novel (absent-source) / vanished (absent-target)
- [x] Reference cartridge demonstrates all six kinds
- [x] Cartridge JSON-Schema conformance (ajv)
- [x] Idris2 ABI typechecks (no `believe_me` / `assert_total`)

## Still Missing (for CRG B+)

- [ ] Property-based pattern generation
- [ ] Integration tests with external tools
- [ ] Performance benchmarks
- [ ] End-to-end evangelism flow tests

## Run Tests

```bash
deno task test        # cartridge invariant tests
deno task validate    # cartridge schema validation
just test             # same, via the Justfile
```
