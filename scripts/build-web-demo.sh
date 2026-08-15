#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE="$ROOT/library-template.html"
SAMPLE="$ROOT/examples/library.sample.json"
OUT="${1:-$ROOT/dist/web/index.html}"

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

[ -f "$TEMPLATE" ] || fail "Template not found: $TEMPLATE"
[ -f "$SAMPLE" ] || fail "Sample library not found: $SAMPLE"
grep -q '__GAME_DATA_PLACEHOLDER__' "$TEMPLATE" || fail "Game-data placeholder is missing from the template."

mkdir -p "$(dirname -- "$OUT")"
{
  sed -n '1,/__GAME_DATA_PLACEHOLDER__/p' "$TEMPLATE" | sed '$d'
  printf 'const GAME_DATA =\n'
  cat "$SAMPLE"
  printf ';\n'
  sed -n '/__GAME_DATA_PLACEHOLDER__/,$p' "$TEMPLATE" | tail -n +2
} > "$OUT.tmp"
mv -- "$OUT.tmp" "$OUT"

printf 'Built web demo: %s\n' "$OUT"
