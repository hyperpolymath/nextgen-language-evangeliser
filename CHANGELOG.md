# Changelog

All notable changes to the Nextgen Languages Evangeliser project (formerly *ReScript Evangeliser*) will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Migration to **Nextgen Languages Evangeliser** — multi-target pattern catalogue
- AffineScript added as flagship target (successor to ReScript as the teaching subject)
- Roadmap with 6 migration phases (see `ROADMAP.adoc`)
- Zig formalised as canonical FFI layer; V banned outside V-ecosystem work
- ReScript source files (Types.res, Glyphs.res, Narrative.res, Patterns.res)
- Deno configuration (deno.json) and build scripts
- Mustfile.epx deployment contract
- Nickel configuration (config.ncl)
- Makefile blocker workflow (enforce Justfile usage)
- npm/bun blocker workflow (enforce Deno usage)
- SPDX license headers on all ReScript source files

### Changed
- **BREAKING**: Migrated from TypeScript to ReScript (Hyperpolymath language policy)
- **BREAKING**: Migrated from npm to Deno (Hyperpolymath language policy)
- Updated Justfile to use Deno tasks instead of npm scripts
- Updated README.adoc to reflect ReScript/Deno stack
- Updated CLAUDE.md with new language policy and structure
- Updated .gitignore for ReScript and Deno artifacts

### Removed
- TypeScript source files (migrated to ReScript)
- extension/ directory (old VS Code extension scaffolding)
- npm package.json (replaced with deno.json)
- tsconfig.json, eslint configuration (TypeScript tooling)
- TS_CONVERSION_NEEDED.md (no longer needed)

### Deprecated
- N/A (initial release)

### Removed
- N/A (initial release)

### Fixed
- N/A (initial release)

### Security
- Implemented input validation for all user code
- Content Security Policy for webviews
- Resource limits (file size, parsing timeout, memory)
- No network dependencies (offline-first security model)
- Supply chain security (minimal dependencies, lockfile)
- RFC 9116 compliant security.txt

## [0.1.0] - 2024-11-22

### Added
- Initial alpha release
- Core extension functionality
- 10 foundational patterns (Phase 1 complete):
  1. Null safety checks → Option types
  2. Async/await → Promise types
  3. Try/catch → Result types
  4. Array.map/filter/reduce → Pipe operator
  5. Ternary conditionals → Pattern matching
  6. Object destructuring → Record patterns
  7. Default parameters → Option.getOr
  8. Array.reduce → Recursive patterns
  9. Template literals → String interpolation
  10. Arrow functions → ReScript functions
- RAW view (side-by-side comparison with narratives)
- GLYPHED view (symbol-annotated code)
- Basic UI shells for FOLDED and WYSIWYG views
- 11 core glyphs (🔄🎯🛡️➡️🌿📦🔗💎⏳✅💡)
- Pattern detection via regex (Phase 1) and AST (Phase 2)
- VS Code extension scaffolding
- TypeScript strict mode configuration
- ESLint and testing infrastructure
- Initial documentation

### Performance
- Pattern detection: 50-100ms (target: <300ms) ✅
- Memory usage: ~20MB (target: <100MB) ✅
- UI response: 10-20ms (target: <50ms) ✅

### Documentation
- README with quick start guide
- CLAUDE.md with project context
- Pattern library documentation
- Quick start guide
- Project overview
- Status tracking document

## Version History

### Version Numbering

We use **Semantic Versioning** (SemVer):

- **MAJOR** (0.x.x): Breaking changes to public API or extension behavior
- **MINOR** (x.1.x): New features, backwards-compatible
- **PATCH** (x.x.1): Bug fixes, backwards-compatible

### Pre-1.0 Status

This project is currently **pre-1.0** (alpha/beta):

- **0.x.x**: API and behavior may change between minor versions
- **1.0.0**: First stable release, API stability guaranteed
- **Target**: Q2 2025 for 1.0.0 release

### Release Cycle

- **Major releases**: Every 6-12 months (post-1.0)
- **Minor releases**: Every 1-2 months
- **Patch releases**: As needed for critical bugs
- **Security releases**: Immediate (out-of-band)

## Migration Guides

### Upgrading to 0.1.0

This is the initial release, no migration needed!

### Future Upgrades

Migration guides will be provided for breaking changes:

- **0.1.x → 0.2.x**: [Coming soon]
- **0.x.x → 1.0.0**: [Coming soon]

## Deprecated Features

### Currently Deprecated

*None yet - this is a new project!*

### Deprecation Policy

- **Notice Period**: 3 months minimum before removal
- **Migration Path**: Always provided for deprecated features
- **Documentation**: Clearly marked in docs and code
- **Warnings**: Runtime warnings in VS Code (if applicable)

## Breaking Changes

### 0.x.x Series

Breaking changes may occur in minor versions during pre-1.0 development. We will:

- Clearly document all breaking changes
- Provide migration instructions
- Offer support in GitHub Discussions

### Post-1.0

Breaking changes will only occur in major version bumps.

## Security Updates

Security updates are released **immediately** and out-of-band from regular releases.

See [SECURITY.md](SECURITY.md) for:
- Security update timeline
- Vulnerability reporting process
- Supported versions

## Contributing to Changelog

When contributing, please update this file:

1. Add your changes under `[Unreleased]`
2. Choose appropriate section (Added, Changed, Fixed, etc.)
3. Write clear, user-focused descriptions
4. Link to relevant issues/PRs when applicable

Example:
```markdown
### Added
- New pattern for object spread operator ([#123](https://github.com/...))
- Support for TypeScript decorators ([#456](https://github.com/...))
```

## Changelog Standards

We follow these standards:

- **User-focused**: Describe impact on users, not implementation
- **Concise**: One line per change when possible
- **Links**: Include links to issues/PRs for details
- **Grouped**: Group related changes together
- **Emoji-free**: Keep changelog text-only (readability)
- **Date format**: ISO 8601 (YYYY-MM-DD)

## Acknowledgments

Thank you to all contributors who help make each release possible!

See [humans.txt](.well-known/humans.txt) for contributor recognition.

---

**How to stay updated:**

- Watch this repository for releases
- Subscribe to GitHub notifications
- Follow announcements in GitHub Discussions
- Check the [Releases page](https://github.com/Hyperpolymath/nextgen-languages-evangeliser/releases)

---

**Questions about a release?**

Ask in [GitHub Discussions](https://github.com/Hyperpolymath/nextgen-languages-evangeliser/discussions) or open an issue.

[Unreleased]: https://github.com/Hyperpolymath/nextgen-languages-evangeliser/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/Hyperpolymath/nextgen-languages-evangeliser/releases/tag/v0.1.0
