#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

rg -n '[ぁ-んァ-ン一-龯]' "$ROOT" -g '*.md' -g '*.MD' || true
