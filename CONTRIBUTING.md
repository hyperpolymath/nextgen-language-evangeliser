# Contributing to Nextgen Languages Evangeliser

Thank you for your interest in contributing! 🎉

> **Note:** This project is mid-migration from *ReScript Evangeliser* to *Nextgen Languages Evangeliser* (flagship target: AffineScript). Some sections below still reference the ReScript-centric dev setup — these will be updated through Phases 1–3. See `ROADMAP.adoc`.

This project follows the **Compassionate Code Contribution Pledge (CCCP)** and **Tri-Perimeter Contribution Framework (TPCF) - Perimeter 3**.

## 🌟 Philosophy: "Celebrate Good, Minimize Bad, Show Better"

Our contribution process mirrors our teaching philosophy:

1. **Celebrate**: We appreciate every contribution, no matter how small
2. **Minimize**: We gently guide improvements without harsh criticism
3. **Better**: We collaboratively make the code even better
4. **Safety**: We ensure type safety and test coverage
5. **Example**: We provide concrete examples and mentorship

## 🚀 Quick Start

### Prerequisites

- Node.js 20+ (LTS recommended)
- VS Code 1.85+
- Git
- Optional: Nix (for reproducible builds)

### Development Setup

```bash
# Fork and clone
git clone https://github.com/YOUR_USERNAME/nextgen-languages-evangeliser.git
cd nextgen-languages-evangeliser/extension

# Install dependencies
npm install

# Compile TypeScript
npm run compile

# Run tests
npm test

# Launch extension in VS Code
# Press F5 or Run > Start Debugging
```

### First Contribution

1. **Find an issue** labeled `good first issue` or `help wanted`
2. **Comment** on the issue to claim it
3. **Create a branch**: `git checkout -b feature/your-feature-name`
4. **Make changes** following our guidelines (below)
5. **Test thoroughly**: `npm test` and `npm run lint`
6. **Commit**: Use conventional commits (see below)
7. **Push**: `git push origin feature/your-feature-name`
8. **Open a Pull Request**: Describe your changes clearly

## 📋 Contribution Types

### 1. Pattern Contributions (Most Welcome!)

Add new JavaScript → ReScript transformation patterns.

**Template**: See [docs/PATTERN_AUTHORING.md](docs/PATTERN_AUTHORING.md)

**Example**:
```typescript
{
  id: 'my-pattern',
  name: 'My Cool Pattern',
  category: 'functional',
  difficulty: 'beginner',
  jsPattern: /const\s+(\w+)\s*=/,
  jsExample: `const x = 42;`,
  rescriptExample: `let x = 42`,
  narrative: {
    celebrate: "You're using const - you know about immutability!",
    minimize: "The only small thing is const isn't always enforced...",
    better: "ReScript makes immutability the default!",
    safety: "The compiler ensures no accidental mutations.",
    example: "See how let in ReScript is always immutable!"
  },
  glyphs: ['💎', '🛡️'],
  tags: ['variables', 'immutability'],
  relatedPatterns: [],
  learningObjectives: ['Understand immutability by default'],
  commonMistakes: ['Trying to reassign let bindings'],
  bestPractices: ['Use let for immutable bindings, use ref for mutable ones']
}
```

### 2. Code Contributions

**Areas**:
- Core extension functionality
- Pattern detection engine (AST parsing)
- UI views (RAW/FOLDED/GLYPHED/WYSIWYG)
- Test coverage improvements
- Performance optimizations
- Documentation

### 3. Documentation Contributions

- Improving README, guides, tutorials
- Adding code examples
- Creating video scripts
- Translating documentation
- Writing blog posts

### 4. Testing Contributions

- Unit tests for patterns
- Integration tests
- UI tests
- Performance benchmarks
- Security tests

### 5. Design Contributions

- UI/UX improvements
- Glyph designs
- Color schemes
- Accessibility enhancements

## 📝 Guidelines

### Code Style

We use TypeScript with strict mode:

```typescript
// ✅ Good
function transformCode(code: string): string {
  if (!code) {
    throw new Error('Code is required');
  }
  return code.trim();
}

// ❌ Avoid
function transformCode(code) { // Missing types
  return code.trim(); // No validation
}
```

**Rules**:
- Strict TypeScript (`strict: true`)
- No `any` types (use `unknown` and narrow)
- Explicit return types for public functions
- JSDoc comments for public APIs
- Meaningful variable names

### Testing Requirements

All contributions must include tests:

```bash
# Run all tests
npm test

# Run with coverage
npm run test:coverage

# Watch mode during development
npm run test:watch
```

**Requirements**:
- Unit tests for new functions
- Integration tests for new features
- 70%+ code coverage (enforced by CI)
- All tests must pass

### Commit Message Format

We use **Conventional Commits**:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style (formatting, no logic change)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Build process, dependencies

**Examples**:
```
feat(patterns): add null coalescing operator pattern

Add detection and transformation for ?? operator to ReScript's
Option.getOr pattern. Includes tests and documentation.

Closes #42
```

```
fix(parser): handle nested ternary expressions

Previously nested ternaries caused parser to fail. Now properly
handles up to 3 levels of nesting with pattern matching suggestion.

Fixes #123
```

### Code Review Process

1. **Automated Checks**:
   - CI runs tests and linting
   - RSR compliance verification
   - Coverage report generated

2. **Peer Review**:
   - At least one approval required
   - Constructive feedback following CCCP
   - Suggestions, not demands

3. **Maintainer Review**:
   - Final architectural review
   - Merge approval

### TPCF Perimeter 3: Community Sandbox

This project is **fully open** to contributions:

- ✅ **No approval required** for common changes
- ✅ **Automated review** for pattern additions
- ✅ **Community-driven** governance
- ✅ **Inclusive** decision-making

See [docs/TPCF.md](docs/TPCF.md) for full framework.

## 🛡️ Security Contributions

Security is critical! Please:

1. **Never** commit secrets, API keys, or credentials
2. **Report** vulnerabilities privately (see [SECURITY.md](SECURITY.md))
3. **Test** for common vulnerabilities (XSS, injection, etc.)
4. **Follow** security checklist in [SECURITY.md](SECURITY.md)

## ♿ Accessibility

We strive for **WCAG 2.1 AA compliance**:

- Semantic HTML in webviews
- Keyboard navigation support
- Screen reader compatibility
- Sufficient color contrast
- No flashing/blinking elements

## 🌍 Internationalization

Currently English-only, but we welcome:

- Translation contributions
- i18n infrastructure
- Localized examples
- Cultural adaptations of narratives

## 📊 Performance Standards

All code must meet performance targets:

- **Pattern detection**: <300ms
- **Memory usage**: <100MB
- **UI response**: <50ms

Run benchmarks:
```bash
npm run benchmark
```

## 🎨 UI/UX Contributions

When contributing to UI:

1. **Consistency**: Follow VS Code design guidelines
2. **Simplicity**: Progressive disclosure, not overwhelming
3. **Accessibility**: WCAG 2.1 AA minimum
4. **Performance**: 60fps animations, lazy loading

## 🧪 Testing Patterns

### Unit Test Example

```typescript
import { detectPattern } from '../patterns/pattern-library';

describe('Pattern Detection', () => {
  it('should detect null check pattern', () => {
    const code = 'if (x !== null && x !== undefined)';
    const matches = detectPattern(code);

    expect(matches).toHaveLength(1);
    expect(matches[0].pattern.id).toBe('null-safety');
  });

  it('should handle edge case of nested null checks', () => {
    const code = 'if (a && a.b && a.b.c)';
    const matches = detectPattern(code);

    expect(matches.length).toBeGreaterThan(0);
  });
});
```

## 📚 Documentation Standards

When writing documentation:

- **Clear**: Plain language, no jargon
- **Concise**: Respect the reader's time
- **Concrete**: Provide examples
- **Encouraging**: Follow "celebrate good" philosophy
- **Inclusive**: Consider diverse backgrounds

## 🏆 Recognition

Contributors are recognized in:

- [humans.txt](.well-known/humans.txt)
- Release notes
- GitHub contributors list
- Annual "Top Contributors" spotlight

## 🎯 Roadmap Priorities

Current priorities (see [GitHub Projects](https://github.com/Hyperpolymath/nextgen-languages-evangeliser/projects)):

1. **High Priority**:
   - Expanding pattern library (50 → 100+ patterns)
   - WYSIWYG view implementation
   - Tutorial system

2. **Medium Priority**:
   - Multi-language support (Elm, Haskell)
   - Performance optimizations
   - Accessibility improvements

3. **Low Priority**:
   - Theme customization
   - Custom glyph sets
   - Plugin system

## 💬 Communication

### Channels

- **GitHub Issues**: Bug reports, feature requests
- **GitHub Discussions**: Questions, ideas, showcase
- **Discord**: Real-time chat (ReScript community)
- **Forum**: Long-form discussion (ReScript forum)

### Response Times

We aim for:
- **Issues**: Response within 48 hours
- **PRs**: Initial review within 7 days
- **Security**: Acknowledgment within 24 hours

## 🙏 Code of Conduct

This project follows the **Compassionate Code Contribution Pledge (CCCP)**:

### Our Pledge

We pledge to make participation a harassment-free, psychologically safe experience for everyone, regardless of:

- Age, body size, disability, ethnicity
- Gender identity and expression
- Level of experience, education, socio-economic status
- Nationality, personal appearance, race, religion
- Sexual identity and orientation

### Our Standards

**Positive behaviors**:
- ✅ Celebrating others' knowledge and contributions
- ✅ Being respectful of differing viewpoints
- ✅ Giving and gracefully accepting constructive feedback
- ✅ Focusing on what's best for the community
- ✅ Showing empathy towards other community members

**Unacceptable behaviors**:
- ❌ Harassment, trolling, insulting/derogatory comments
- ❌ Public or private harassment
- ❌ Publishing others' private information
- ❌ Shaming developers for not knowing something
- ❌ Any conduct inappropriate in a professional setting

### Enforcement

Violations should be reported to project maintainers. All complaints will be reviewed and investigated promptly and fairly.

**Consequences**:
1. **Warning**: Private, written warning
2. **Temporary Ban**: 30-day suspension
3. **Permanent Ban**: Permanent exclusion

See full [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

## 🎓 Learning Resources

New to contributing? Check out:

- [First Contributions](https://github.com/firstcontributions/first-contributions)
- [How to Contribute to Open Source](https://opensource.guide/how-to-contribute/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [ReScript Documentation](https://rescript-lang.org/docs)

## ❓ Questions?

Don't hesitate to ask!

- **GitHub Discussions**: For general questions
- **Issues**: For specific technical questions
- **Maintainers**: See [MAINTAINERS.md](MAINTAINERS.md)

---

## 📜 License

By contributing, you agree that your contributions will be dual-licensed under:

- **MIT License** (LICENSE-MIT.txt)
- **Palimpsest License v0.8** (LICENSE-PALIMPSEST.txt)

You retain copyright of your contributions.

---

**Thank you for contributing to Nextgen Languages Evangeliser!** 🚀

Remember: You were close! We're here to help make it even better together. 💙
