#!/usr/bin/env bash
set -euo pipefail

if [ -n "${ENABLE_DESKTOP:-}" ]; then
  . /usr/local/bin/start-desktop.sh
fi

exec /usr/bin/tini -- "$@"
