# justfile for Nextgen Languages Evangeliser
# https://github.com/casey/just
# SPDX-License-Identifier: MPL-2.0 OR Palimpsest-0.8
#
# Per Hyperpolymath policy:
# - Use Deno, not npm/bun
# - Use justfile, not Makefile
# - Use AffineScript, not TypeScript (ReScript host removed 2026-06; AffineScript host pending)

# List all available recipes
import? "contractile.just"

default:
    @just --list

# === BUILD ===

# "Build" = validate the cartridge data the workspace + CLI consume.
# There is no compile step: the host is AffineScript (compiler pending) and the
# runtime surface is Deno + cartridge data (the ReScript host was removed).
build:
    @echo "🧩 Validating cartridges (no compile step — Deno-only host)..."
    deno task build

# Serve the workspace with live reload on change
watch:
    @echo "👀 Watching — workspace reloads on change..."
    deno run --allow-read --allow-net --watch gui/server.js

# Clean caches / build leftovers
clean:
    @echo "🧹 Cleaning..."
    @rm -rf lib .deno 2>/dev/null || true

# Deep clean (including dependencies)
clean-all: clean
    rm -rf node_modules
    rm -f deno.lock

# Rebuild from scratch
rebuild: clean-all setup build

# === DEVELOPMENT ===

# Install / warm dependency cache (Deno — no npm runtime deps)
install:
    @echo "📦 Warming dependency cache..."
    @deno cache scripts/validate-cartridges.js gui/server.js bin/evangeliser.js test/run_all.js

# First-time setup
setup: install
    @echo "🎉 Development environment ready!"
    @echo "Run 'just gui'  to launch the correspondence workspace"
    @echo "Run 'just test' to run the cartridge invariant tests"

# Format code
fmt:
    @echo "✨ Formatting..."
    deno task fmt

# Lint code
lint:
    @echo "🔍 Linting..."
    deno task lint

# Serve the browser correspondence workspace (multi-pane, cartridge-driven)
gui:
    @echo "🖥️  Correspondence workspace → http://127.0.0.1:8765"
    @deno run --allow-read --allow-net gui/server.js

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

# Validate cartridges against the correspondence schema (Deno + ajv)
validate-cartridges:
    @echo "🧩 Validating cartridges..."
    @deno run -A --no-lock scripts/validate-cartridges.js

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
    @test -d cartridges || (echo "❌ Missing cartridges/" && exit 1)
    @test -f deno.json || (echo "❌ Missing deno.json" && exit 1)
    @echo "✅ Project structure valid"

# Validate documentation
validate-docs:
    @echo "📚 Checking documentation..."
    @test -f README.adoc || (echo "❌ Missing README.adoc" && exit 1)
    @test -f CONTRIBUTING.md || (echo "❌ Missing CONTRIBUTING.md" && exit 1)
    @test -f CODE_OF_CONDUCT.md || (echo "❌ Missing CODE_OF_CONDUCT.md" && exit 1)
    @test -f SECURITY.md || (echo "❌ Missing SECURITY.md" && exit 1)
    @test -f MAINTAINERS.adoc || (echo "❌ Missing MAINTAINERS.adoc" && exit 1)
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
    @! find src -name "*.ts" -o -name "*.tsx" 2>/dev/null | grep -q . || (echo "❌ TypeScript in src/ - use AffineScript" && exit 1)
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
    @echo "Cartridges:"
    @find cartridges -name "*.cartridge.json" 2>/dev/null | wc -l || echo "0"
    @echo "AffineScript host files (.affine):"
    @find . -name "*.affine" -not -path './.git/*' 2>/dev/null | wc -l || echo "0"
    @echo "Idris2 ABI files (.idr):"
    @find . -name "*.idr" -not -path './.git/*' 2>/dev/null | wc -l || echo "0"
    @echo "Zig FFI files (.zig):"
    @find . -name "*.zig" -not -path './.git/*' 2>/dev/null | wc -l || echo "0"
    @echo "Deno/JS glue:"
    @find bin gui scripts test -name "*.js" 2>/dev/null | wc -l || echo "0"
    @echo "Documentation files:"
    @find docs -name "*.adoc" -o -name "*.md" 2>/dev/null | wc -l || echo "0"

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
    @echo "Running diagnostics for nextgen-languages-evangeliser..."
    @echo "Checking required tools..."
    @command -v just >/dev/null 2>&1 && echo "  [OK] just" || echo "  [FAIL] just not found"
    @command -v git >/dev/null 2>&1 && echo "  [OK] git" || echo "  [FAIL] git not found"
    @echo "Checking for hardcoded paths..."
    @grep -rn '$HOME\|$ECLIPSE_DIR' --include='*.rs' --include='*.ex' --include='*.res' --include='*.gleam' --include='*.sh' . 2>/dev/null | head -5 || echo "  [OK] No hardcoded paths"
    @echo "Diagnostics complete."

# Auto-repair common issues
heal:
    @echo "Attempting auto-repair for nextgen-languages-evangeliser..."
    @echo "Fixing permissions..."
    @find . -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    @echo "Cleaning stale caches..."
    @rm -rf .cache/stale 2>/dev/null || true
    @echo "Repair complete."

# Guided tour of key features
tour:
    @echo "=== nextgen-languages-evangeliser Tour ==="
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
    @echo "=== nextgen-languages-evangeliser Help ==="
    @echo "Platform: $(uname -s) $(uname -m)"
    @echo "Shell: $SHELL"
    @echo ""
    @echo "To report an issue:"
    @echo "  https://github.com/hyperpolymath/nextgen-languages-evangeliser/issues/new"
    @echo ""
    @echo "Include the output of 'just doctor' in your report."

# Run panic-attack pre-commit scan
assail:
    @command -v panic-attack >/dev/null 2>&1 && panic-attack assail . || echo "panic-attack not found — install from https://github.com/hyperpolymath/panic-attack"


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
