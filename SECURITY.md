# Security Policy

## 🛡️ Security Philosophy

Security is a **first-class concern** in Nextgen Languages Evangeliser. We follow a **10+ dimensional security model**:

1. **Input Validation** - All user input is validated and sanitized
2. **Output Encoding** - Code transformations are safe from injection
3. **Authentication** - VS Code workspace trust model
4. **Authorization** - File system access controls
5. **Session Management** - No network sessions required (offline-first)
6. **Cryptography** - No cryptographic operations (not needed)
7. **Error Handling** - No sensitive data in error messages
8. **Logging** - No PII in logs
9. **Privacy** - Zero telemetry by default
10. **Supply Chain** - Minimal dependencies, lockfile verification

## 🚨 Reporting Vulnerabilities

### Responsible Disclosure

If you discover a security vulnerability, please report it responsibly:

**DO:**
- ✅ Email security details to the maintainers (see [MAINTAINERS.md](MAINTAINERS.md))
- ✅ Use encrypted email if possible (PGP key in [.well-known/security.txt](.well-known/security.txt))
- ✅ Wait for response before public disclosure (max 90 days)
- ✅ Provide detailed reproduction steps

**DON'T:**
- ❌ Open public GitHub issues for vulnerabilities
- ❌ Disclose before maintainers have responded
- ❌ Exploit vulnerabilities for malicious purposes

### What to Report

Security issues include:
- Code injection vulnerabilities
- Path traversal attacks
- Arbitrary code execution
- Information disclosure
- Denial of service
- Supply chain attacks

### Response Timeline

- **24 hours**: Initial acknowledgment
- **7 days**: Preliminary assessment
- **30 days**: Fix developed and tested
- **90 days**: Public disclosure (coordinated)

## 🔒 Security Architecture

### Threat Model

**In Scope:**
- Malicious JavaScript/TypeScript files opened in VS Code
- Crafted pattern definitions
- File system traversal attempts
- Resource exhaustion (DoS)

**Out of Scope:**
- Physical access to developer machine
- OS-level vulnerabilities
- VS Code API vulnerabilities
- Network-based attacks (extension is offline-first)

### Security Boundaries

```
┌─────────────────────────────────────────┐
│ VS Code Workspace (Untrusted)           │
│  ├─ User JavaScript files               │
│  └─ Custom pattern definitions          │
└─────────────────────────────────────────┘
           ↓ (sandboxed parsing)
┌─────────────────────────────────────────┐
│ Nextgen Languages Evangeliser Extension          │
│  ├─ AST Parser (Babel, sandboxed)       │
│  ├─ Pattern Matcher (validated)         │
│  ├─ Webview (Content Security Policy)   │
│  └─ File System (read-only by default)  │
└─────────────────────────────────────────┘
```

### Defense Mechanisms

1. **Input Sanitization**
   - All JavaScript/TypeScript parsed via Babel AST (not eval)
   - Pattern regexes validated for ReDoS attacks
   - File paths validated against traversal

2. **Content Security Policy**
   - Webview UI runs with strict CSP
   - No inline scripts or styles
   - No external resource loading

3. **Resource Limits**
   - Maximum file size: 10MB
   - Parser timeout: 5 seconds
   - Memory limit: 100MB per analysis

4. **Least Privilege**
   - Read-only file access by default
   - No network access (offline-first)
   - No external process execution

## 🔐 Privacy Guarantees

### Zero Telemetry by Default

- **NO** data sent to external servers
- **NO** user-identifying information collected
- **NO** code snippets transmitted
- **NO** analytics without explicit opt-in

### Optional Privacy-Preserving Telemetry

If enabled (opt-in only):
- Aggregated, anonymous usage counts
- Pattern category usage (no code snippets)
- Performance metrics (timing only)
- Crash reports (no PII)

All telemetry is:
- Local-first (stored in VS Code settings)
- User-controlled (can be deleted anytime)
- Transparent (see [docs/TELEMETRY.md](docs/TELEMETRY.md))

## 🧪 Security Testing

### Automated Testing

```bash
# Run security tests
npm run test:security

# Check dependencies for vulnerabilities
npm audit

# Run linter with security rules
npm run lint
```

### Manual Security Reviews

Before each release:
- [ ] Dependency audit (npm audit)
- [ ] Code review for injection risks
- [ ] CSP header validation
- [ ] File path sanitization check
- [ ] Resource limit testing
- [ ] Fuzz testing (pattern matching)

## 📦 Supply Chain Security

### Dependency Management

**Current Dependencies:**
- `@babel/parser` - AST parsing (well-maintained, widely used)
- `@babel/traverse` - AST traversal
- `@babel/types` - AST type definitions

**Security Measures:**
- Package lock file committed (package-lock.json)
- Regular dependency updates
- Automated vulnerability scanning
- Minimal dependency tree (<10 packages)

### Build Integrity

- Reproducible builds via Nix flake
- Checksum verification
- Signed commits (when available)

## 🌐 Offline-First Security

### No Network Dependencies

This extension:
- **Never** makes network requests
- **Never** loads external resources
- Works in air-gapped environments
- No CDN dependencies

### Benefits

- Zero network-based attack surface
- No data exfiltration risks
- No man-in-the-middle vulnerabilities
- Works in high-security environments

## 🎯 VS Code Workspace Trust

This extension respects VS Code's workspace trust model:

- **Untrusted Workspaces**: Limited functionality (read-only)
- **Trusted Workspaces**: Full pattern detection and transformation

See: https://code.visualstudio.com/docs/editor/workspace-trust

## 📋 Security Checklist for Contributors

When contributing code:

- [ ] No `eval()` or `Function()` constructors
- [ ] All file paths sanitized
- [ ] Regex patterns checked for ReDoS
- [ ] No hardcoded secrets or credentials
- [ ] Error messages don't leak sensitive info
- [ ] No external network requests
- [ ] Input validation for all user data
- [ ] Resource limits respected

See [CONTRIBUTING.md](CONTRIBUTING.md) for full guidelines.

## 🏆 Security Compliance

### Standards Followed

- **OWASP Top 10** - Protection against common web vulnerabilities
- **CWE Top 25** - Mitigation of common software weaknesses
- **RFC 9116** - security.txt for vulnerability disclosure
- **NIST Cybersecurity Framework** - Security best practices
- **Software-Defined Perimeter** - Zero trust architecture

### Certifications

- RSR Bronze-level security requirements ✅
- Offline-first architecture ✅
- Privacy-preserving design ✅

## 📚 Additional Resources

- [OWASP VS Code Extension Security](https://owasp.org/)
- [VS Code Extension Security Best Practices](https://code.visualstudio.com/api/references/extension-manifest)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

## 🔄 Security Updates

Security updates are released as soon as possible:

- **Critical**: Within 24-48 hours
- **High**: Within 7 days
- **Medium**: Within 30 days
- **Low**: Next regular release

Subscribe to releases to stay informed:
https://github.com/Hyperpolymath/nextgen-languages-evangeliser/releases

## 📞 Contact

For security concerns:

- **Email**: See [MAINTAINERS.md](MAINTAINERS.md)
- **PGP Key**: See [.well-known/security.txt](.well-known/security.txt)
- **Security.txt**: RFC 9116 compliant file in [.well-known/](.well-known/)

---

**Last Updated**: 2024-11-22
**Policy Version**: 1.0
