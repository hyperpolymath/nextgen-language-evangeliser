#!/usr/bin/env bash
# SPDX-License-Identifier: MPL-2.0

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# Least-privilege Deno permissions (CWE-250 — never `-A`):
#   --allow-read  cartridge data + gui assets
#   --allow-net   the workspace HTTP server
#   --allow-env   honour EVANGELISER_GUI_PORT (server.js degrades gracefully without it)
#   --allow-run   spawn the browser for --open (sensible-browser / gio / xdg-open)
exec deno run --allow-read --allow-net --allow-env --allow-run gui/server.js --open "$@"
