#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

export PATH="${HOME}/.pub-cache/bin:${PATH}"

# Detect SDK Manager
if command -v puro &>/dev/null; then
  DART_CMD="puro dart"
elif command -v fvm &>/dev/null; then
  DART_CMD="fvm dart"
else
  DART_CMD="dart"
fi

echo "Running build_runner..."
$DART_CMD run build_runner build

echo "Done."
