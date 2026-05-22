#!/usr/bin/env bash
# SPDX-License-Identifier: MPL-2.0

set -euo pipefail

LOCK="lib/rescript.lock"

if [ -f "$LOCK" ]; then
  PID="$(tr -cd '0-9' < "$LOCK")"
  if [ -n "$PID" ] && ! kill -0 "$PID" 2>/dev/null; then
    mv "$LOCK" "/tmp/nextgen-language-evangeliser-rescript.lock.${PID}.stale"
  fi
fi

exec deno run -A npm:rescript build "$@"
