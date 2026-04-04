# justfile for ReScript Evangeliser
# https://github.com/casey/just
# SPDX-License-Identifier: MIT OR Palimpsest-0.8
#
# Per Hyperpolymath policy:
# - Use Deno, not npm/bun
# - Use justfile, not Makefile
# - Use ReScript, not TypeScript

# List all available recipes
default:
    @just --list

# === BUILD ===

# Build ReScript sources
build:
    @echo "🔷 Building ReScript..."
    deno task build

# Build in watch mode
watch:
    @echo "👀 Watching for changes..."
    npx rescript build -w

# Clean build artifacts
clean:
    @echo "🧹 Cleaning..."
    deno task clean

# Deep clean (including dependencies)
clean-all: clean
    rm -rf node_modules
    rm -f deno.lock

# Rebuild from scratch
rebuild: clean-all setup build

# === DEVELOPMENT ===

# Install dependencies
install:
    @echo "📦 Installing dependencies..."
    deno cache scripts/*.ts
    deno install

# First-time setup
setup: install
    @echo "🎉 Development environment ready!"
    @echo "Run 'just build' to compile ReScript"
    @echo "Run 'just watch' for development"

# Format code
fmt:
    @echo "✨ Formatting..."
    deno task fmt

# Lint code
lint:
    @echo "🔍 Linting..."
    deno task lint

# === TESTING ===

# Run all tests
test:
    @echo "🧪 Running tests..."
    deno task test

# === VALIDATION ===

# Run full validation
validate:
    @echo "🔍 Validating project..."
    deno task validate

# Validate RSR compliance
validate-rsr:
    @echo "🔍 Validating RSR Bronze-level compliance..."
    @just validate-structure
    @just validate-docs
    @just validate-security
    @just validate-licenses
    @just validate-policy
    @echo "✅ RSR validation complete!"

# Validate project structure
validate-structure:
    @echo "📁 Checking project structure..."
    @test -d src || (echo "❌ Missing src/" && exit 1)
    @test -f rescript.json || (echo "❌ Missing rescript.json" && exit 1)
    @test -f deno.json || (echo "❌ Missing deno.json" && exit 1)
    @echo "✅ Project structure valid"

# Validate documentation
validate-docs:
    @echo "📚 Checking documentation..."
    @test -f README.adoc || (echo "❌ Missing README.adoc" && exit 1)
    @test -f CONTRIBUTING.md || (echo "❌ Missing CONTRIBUTING.md" && exit 1)
    @test -f CODE_OF_CONDUCT.md || (echo "❌ Missing CODE_OF_CONDUCT.md" && exit 1)
    @test -f SECURITY.md || (echo "❌ Missing SECURITY.md" && exit 1)
    @test -f MAINTAINERS.md || (echo "❌ Missing MAINTAINERS.md" && exit 1)
    @test -f CHANGELOG.md || (echo "❌ Missing CHANGELOG.md" && exit 1)
    @test -f CLAUDE.md || (echo "❌ Missing CLAUDE.md" && exit 1)
    @echo "✅ Documentation complete"

# Validate security files
validate-security:
    @echo "🛡️ Checking security files..."
    @test -f SECURITY.md || (echo "❌ Missing SECURITY.md" && exit 1)
    @echo "✅ Security files present"

# Validate licenses
validate-licenses:
    @echo "⚖️ Checking licenses..."
    @test -f LICENSE-MIT.txt || (echo "❌ Missing LICENSE-MIT.txt" && exit 1)
    @test -f LICENSE-PALIMPSEST.txt || (echo "❌ Missing LICENSE-PALIMPSEST.txt" && exit 1)
    @echo "✅ Dual licenses present"

# Validate language policy (no Makefile, no new TS)
validate-policy:
    @echo "📋 Checking language policy..."
    @test ! -f Makefile || (echo "❌ Makefile detected - use justfile" && exit 1)
    @test ! -f makefile || (echo "❌ makefile detected - use justfile" && exit 1)
    @! find src -name "*.ts" -o -name "*.tsx" 2>/dev/null | grep -q . || (echo "❌ TypeScript in src/ - use ReScript" && exit 1)
    @echo "✅ Language policy enforced"

# === CI/CD ===

# Pre-commit checks
pre-commit: lint validate
    @echo "✅ Pre-commit checks passed!"

# Pre-push checks
pre-push: pre-commit build test
    @echo "✅ Pre-push checks passed!"

# CI simulation
ci: clean setup build lint test validate-rsr
    @echo "✅ CI simulation complete!"

# === PROJECT INFO ===

# Show project statistics
stats:
    @echo "📊 Project Statistics"
    @echo "===================="
    @echo "ReScript files:"
    @find src -name "*.res" 2>/dev/null | wc -l || echo "0"
    @echo "Lines of ReScript:"
    @find src -name "*.res" -exec cat {} \; 2>/dev/null | wc -l || echo "0"
    @echo "Deno scripts:"
    @find scripts -name "*.ts" 2>/dev/null | wc -l || echo "0"
    @echo "Documentation files:"
    @find docs -name "*.md" -o -name "*.adoc" 2>/dev/null | wc -l || echo "0"

# === GIT HOOKS ===

# Install Git hooks
install-hooks:
    @echo "🪝 Installing Git hooks..."
    @echo "#!/bin/sh\njust pre-commit" > .git/hooks/pre-commit
    @chmod +x .git/hooks/pre-commit
    @echo "#!/bin/sh\njust pre-push" > .git/hooks/pre-push
    @chmod +x .git/hooks/pre-push
    @echo "✅ Git hooks installed"

# Remove Git hooks
uninstall-hooks:
    @rm -f .git/hooks/pre-commit .git/hooks/pre-push
    @echo "🗑️  Git hooks removed"

# === NIX/GUIX ===

# Nix build (if available)
nix-build:
    @command -v nix >/dev/null && nix build || echo "Nix not installed"

# Nix development shell
nix-shell:
    @command -v nix >/dev/null && nix develop || echo "Nix not installed"

# Guix build (if available)
guix-build:
    @command -v guix >/dev/null && guix build -f guix.scm || echo "Guix not installed"

# === HELP ===

# Show help for a specific recipe
help RECIPE:
    @just --show {{RECIPE}}

# Self-diagnostic — checks dependencies, permissions, paths
doctor:
    @echo "Running diagnostics for rescript-evangeliser..."
    @echo "Checking required tools..."
    @command -v just >/dev/null 2>&1 && echo "  [OK] just" || echo "  [FAIL] just not found"
    @command -v git >/dev/null 2>&1 && echo "  [OK] git" || echo "  [FAIL] git not found"
    @echo "Checking for hardcoded paths..."
    @grep -rn '$HOME\|$ECLIPSE_DIR' --include='*.rs' --include='*.ex' --include='*.res' --include='*.gleam' --include='*.sh' . 2>/dev/null | head -5 || echo "  [OK] No hardcoded paths"
    @echo "Diagnostics complete."

# Auto-repair common issues
heal:
    @echo "Attempting auto-repair for rescript-evangeliser..."
    @echo "Fixing permissions..."
    @find . -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    @echo "Cleaning stale caches..."
    @rm -rf .cache/stale 2>/dev/null || true
    @echo "Repair complete."

# Guided tour of key features
tour:
    @echo "=== rescript-evangeliser Tour ==="
    @echo ""
    @echo "1. Project structure:"
    @ls -la
    @echo ""
    @echo "2. Available commands: just --list"
    @echo ""
    @echo "3. Read README.adoc for full overview"
    @echo "4. Read EXPLAINME.adoc for architecture decisions"
    @echo "5. Run 'just doctor' to check your setup"
    @echo ""
    @echo "Tour complete! Try 'just --list' to see all available commands."

# Open feedback channel with diagnostic context
help-me:
    @echo "=== rescript-evangeliser Help ==="
    @echo "Platform: $(uname -s) $(uname -m)"
    @echo "Shell: $SHELL"
    @echo ""
    @echo "To report an issue:"
    @echo "  https://github.com/hyperpolymath/rescript-evangeliser/issues/new"
    @echo ""
    @echo "Include the output of 'just doctor' in your report."

# Run panic-attacker pre-commit scan
assail:
    @command -v panic-attack >/dev/null 2>&1 && panic-attack assail . || echo "panic-attack not found — install from https://github.com/hyperpolymath/panic-attacker"


# Print the current CRG grade (reads from READINESS.md '**Current Grade:** X' line)
crg-grade:
    @grade=$$(grep -oP '(?<=\*\*Current Grade:\*\* )[A-FX]' READINESS.md 2>/dev/null | head -1); \
    [ -z "$$grade" ] && grade="X"; \
    echo "$$grade"

# Generate a shields.io badge markdown for the current CRG grade
# Looks for '**Current Grade:** X' in READINESS.md; falls back to X
crg-badge:
    @grade=$$(grep -oP '(?<=\*\*Current Grade:\*\* )[A-FX]' READINESS.md 2>/dev/null | head -1); \
    [ -z "$$grade" ] && grade="X"; \
    case "$$grade" in \
      A) color="brightgreen" ;; B) color="green" ;; C) color="yellow" ;; \
      D) color="orange" ;; E) color="red" ;; F) color="critical" ;; \
      *) color="lightgrey" ;; esac; \
    echo "[![CRG $$grade](https://img.shields.io/badge/CRG-$$grade-$$color?style=flat-square)](https://github.com/hyperpolymath/standards/tree/main/component-readiness-grades)"
