# Tri-Perimeter Contribution Framework (TPCF)

## Nextgen Languages Evangeliser: Perimeter 3 (Community Sandbox)

**Project**: Nextgen Languages Evangeliser
**TPCF Level**: Perimeter 3
**Governance**: Community-driven, fully open
**Last Updated**: 2024-11-22

---

## What is TPCF?

The **Tri-Perimeter Contribution Framework** defines three levels of contribution trust and governance:

1. **Perimeter 1 (Core)**: Maintainer-only, critical infrastructure
2. **Perimeter 2 (Stable)**: Reviewed contributions, production code
3. **Perimeter 3 (Community Sandbox)**: Fully open, experimental, community-driven

Nextgen Languages Evangeliser operates as **Perimeter 3** - a community sandbox with maximum openness.

---

## Perimeter 3 Characteristics

### Fully Open Contributions ✅

- **No approval required** for pattern additions
- **Automated review** for common changes
- **Community-driven** feature development
- **Inclusive** decision-making

### Fast Iteration ✅

- Merge patterns quickly
- Experiment freely
- Fail fast, learn faster
- Continuous improvement

### Low Barrier to Entry ✅

- First-time contributors welcome
- Good first issues labeled
- Comprehensive contribution guide
- Supportive community (CCCP)

### Graduated Trust Model ✅

Contributors can progress:
- **Contributor** → **Pattern Author** → **Reviewer** → **Maintainer**

---

## How TPCF Works for This Project

### Pattern Library (Perimeter 3)

**Full Community Access**:
- Anyone can add patterns
- Automated tests validate patterns
- Community reviews patterns
- Fast merge (24-48 hours)

**Process**:
1. Fork repository
2. Add pattern to `patterns/` directory
3. Add tests
4. Open pull request
5. Automated CI runs
6. Community feedback (optional)
7. **Auto-merge** if tests pass (no manual approval needed)

### Documentation (Perimeter 3)

**Fully Open**:
- Typo fixes: immediate merge
- New guides: community review
- Translations: fully community-driven

### Core Extension (Perimeter 2)

**Reviewed Contributions**:
- Extension logic: maintainer review required
- Security-critical code: thorough review
- Architecture changes: design discussion first

### Infrastructure (Perimeter 1)

**Maintainer-Only**:
- CI/CD configuration
- Release automation
- Security policies
- Publishing credentials

---

## Contribution Paths

### Path 1: Pattern Contributor

**Goal**: Add JavaScript → ReScript transformation patterns

**Steps**:
1. Find a JavaScript pattern not yet in library
2. Create pattern with celebrate/minimize/better narrative
3. Add tests
4. Submit PR
5. **Auto-merge** on passing tests

**Example**:
```typescript
{
  id: 'my-pattern',
  name: 'My Pattern',
  category: 'functional',
  difficulty: 'beginner',
  jsExample: `const x = [1, 2, 3];`,
  rescriptExample: `let x = [1, 2, 3]`,
  narrative: {
    celebrate: "Great array usage!",
    minimize: "Works perfectly...",
    better: "ReScript arrays are type-safe!",
    safety: "Compiler prevents index errors.",
    example: "Try it!"
  },
  // ... rest of pattern
}
```

### Path 2: Documentation Contributor

**Goal**: Improve documentation

**Steps**:
1. Fix typos, improve clarity
2. Add examples
3. Translate content
4. Submit PR
5. **Fast merge**

### Path 3: Code Contributor

**Goal**: Improve extension functionality

**Steps**:
1. Pick an issue (or create one)
2. Discuss approach (for large changes)
3. Implement
4. Add tests
5. Submit PR
6. Maintainer review
7. Merge

### Path 4: Reviewer

**Goal**: Help review contributions

**Requirements**:
- 5+ merged PRs
- Understanding of project goals
- Follow CCCP (compassionate reviews)

**Promotion**:
- Self-nominate or maintainer invite
- Consensus vote

### Path 5: Maintainer

**Goal**: Lead project direction

**Requirements**:
- 3+ months consistent contributions
- Deep understanding of codebase
- Community trust
- CCCP exemplar

**Promotion**:
- Maintainer nomination
- Consensus vote

---

## Decision Making

### Pattern Additions (Perimeter 3)

- **Who Decides**: Automated tests + community
- **Timeline**: 24-48 hours
- **Veto**: Maintainers (rare, only for harmful content)

### Feature Additions (Perimeter 2/3)

- **Who Decides**: Community discussion
- **Process**:
  1. Open issue/RFC
  2. Community feedback (7 days)
  3. Rough consensus
  4. Implementation
  5. Review
  6. Merge

### Breaking Changes (Perimeter 2)

- **Who Decides**: Maintainers + community
- **Process**:
  1. RFC with migration plan
  2. Community discussion (14 days)
  3. Maintainer consensus
  4. Implementation
  5. Documented in CHANGELOG

### Security Fixes (Perimeter 1)

- **Who Decides**: Lead maintainer
- **Timeline**: Immediate
- **Process**: Private fix → disclosure → release

---

## Community Standards

### Compassionate Code Contribution Pledge (CCCP)

**Core Principle**: "Celebrate good, minimize bad, show better"

**All contributors must**:
- ✅ Never shame developers
- ✅ Celebrate existing knowledge
- ✅ Provide constructive feedback
- ✅ Assume good intent
- ✅ Foster psychological safety

See [CODE_OF_CONDUCT.md](../CODE_OF_CONDUCT.md) for full pledge.

### Review Guidelines

**When reviewing PRs**:
- Celebrate what works
- Gently suggest improvements
- Provide examples
- Be patient with learners
- Remember: everyone was a beginner once

**Example Good Review**:
> Nice pattern! I like how you handled the null check. One small suggestion: could we add a test for nested null values? Here's an example: [code]. What do you think?

**Example Bad Review** (❌ Don't do this):
> This is wrong. You should know better. Read the docs.

---

## Perimeter Boundaries

### What Requires Review?

**Perimeter 1** (Maintainer-only):
- Release process
- CI/CD changes
- Security policies
- Publishing

**Perimeter 2** (Reviewed):
- Extension core logic
- UI components
- Security-sensitive code
- Breaking changes

**Perimeter 3** (Auto-merge):
- Pattern additions
- Documentation
- Tests
- Examples
- Translations

### Migration Between Perimeters

Code can move between perimeters:

**P3 → P2**: Experimental features that mature
**P2 → P1**: Critical infrastructure components

Always documented in issues/discussions.

---

## Conflict Resolution

### Process

1. **Direct Discussion**: Contributors talk it out
2. **Community Input**: Open discussion
3. **Maintainer Mediation**: If needed
4. **Consensus**: Aim for agreement
5. **Maintainer Decision**: Final arbiter (rare)

### Principles

- Assume good intent
- Focus on project health
- Follow CCCP
- Document decisions
- Move forward

---

## Benefits of Perimeter 3

### For Contributors

- 🚀 Fast iteration
- 💪 Low barriers
- 🎓 Learning opportunities
- 🤝 Community support
- ⭐ Recognition

### For Users

- 📈 Rapid feature growth
- 🔧 Community-driven fixes
- 📚 Rich pattern library
- 🌍 Diverse perspectives

### For Project

- 🌱 Sustainable growth
- 🎯 Community ownership
- 💡 Innovation
- 🔄 Continuous improvement

---

## Metrics & Transparency

### Public Metrics

- Patterns added per month
- Contributors (first-time, returning)
- PR merge time (target: <48h for P3)
- Community satisfaction

### Transparency

- All decisions documented
- Public issue discussions
- Open governance meetings
- Regular reports

---

## Examples from Other Projects

**Perimeter 3 (like us)**:
- Wikipedia article edits
- Open source pattern libraries
- Community-driven docs

**Perimeter 2**:
- Linux kernel contributions
- VS Code extensions (core)

**Perimeter 1**:
- Security patches
- Release management

---

## FAQ

**Q: Can I add any pattern?**
A: Yes! As long as it:
- Has JavaScript → ReScript transformation
- Includes tests
- Follows "celebrate good" philosophy
- Passes automated checks

**Q: How do I become a maintainer?**
A: Contribute regularly (3+ months), help community, exemplify CCCP values, get nominated.

**Q: What if my PR is rejected?**
A: Very rare for P3. Usually means:
- Tests failing (fix and resubmit)
- Harmful content (won't merge)
- Better discussed first (open issue)

**Q: Can I fork and create my own version?**
A: Absolutely! MIT OR Palimpsest license. We'd love to see your innovations!

---

## Contact

**Questions about TPCF?**

- GitHub Discussions: General questions
- Issues: Specific concerns
- Maintainers: See [MAINTAINERS.md](../MAINTAINERS.md)

---

**Remember**: Perimeter 3 means you're empowered to contribute! We trust you. Welcome to the community! 💙
