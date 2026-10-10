#!/usr/bin/env bash
# SPDX-License-Identifier: CC-BY-SA-4.0
#
# check-wellknown.sh — validate the canonical www/.well-known/ contents.
# Minted from hyperpolymath/rsr-template-repo www/tests/check-wellknown.sh
# (the stage-5 well-known sweep validator, rsr-template-repo#53/#119).

set -uo pipefail
WWW="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WK="$WWW/.well-known"
FAIL=0
bad() { echo "WELLKNOWN FAIL: $*" >&2; FAIL=1; }
ok()  { echo "ok: $*"; }

for f in security.txt ai.txt humans.txt; do
    [ -f "$WK/$f" ] && ok "$f present" || bad "$f missing from www/.well-known/"
done

# RFC 9116: Contact and Expires are required fields.
if [ -f "$WK/security.txt" ]; then
    grep -q '^Contact:' "$WK/security.txt" && ok "security.txt has Contact" || bad "security.txt missing Contact"
    if grep -q '^Expires:' "$WK/security.txt"; then
        EXP=$(grep '^Expires:' "$WK/security.txt" | head -1 | cut -d: -f2- | tr -d ' ')
        case "$EXP" in
            *'{{'*) ok "security.txt Expires carries a mint placeholder (pre-mint)" ;;
            *)
                if date -d "$EXP" >/dev/null 2>&1; then
                    DAYS=$(( ($(date -d "$EXP" +%s) - $(date +%s)) / 86400 ))
                    [ "$DAYS" -ge 0 ] && ok "security.txt Expires valid ($DAYS days)" || bad "security.txt EXPIRED"
                else
                    bad "security.txt Expires is not a parseable timestamp: $EXP"
                fi ;;
        esac
    else
        bad "security.txt missing Expires"
    fi
fi

# ai.txt: the stance lines the estate's ai.txt convention requires.
if [ -f "$WK/ai.txt" ]; then
    grep -q '^User-Agent:' "$WK/ai.txt" && ok "ai.txt has User-Agent" || bad "ai.txt missing User-Agent"
    grep -q '^Disallow-Training:' "$WK/ai.txt" && ok "ai.txt has Disallow-Training" || bad "ai.txt missing Disallow-Training"
fi

# humans.txt: humanstxt.org section markers.
if [ -f "$WK/humans.txt" ]; then
    grep -q '/\* TEAM \*/' "$WK/humans.txt" && ok "humans.txt has TEAM" || bad "humans.txt missing TEAM section"
    grep -q '/\* SITE \*/' "$WK/humans.txt" && ok "humans.txt has SITE" || bad "humans.txt missing SITE section"
fi

# Migration window: a repository-root .well-known/ alongside the bundle is
# legacy; warn (do not fail) — the canonical location is www/.well-known/.
if [ -d "$WWW/../.well-known" ]; then
    echo "WELLKNOWN WARN: legacy root .well-known/ still present — move it into www/.well-known/" >&2
fi

exit "$FAIL"
