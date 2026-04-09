#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export XDG_CONFIG_HOME="$(mktemp -d)"
export XDG_DATA_HOME="$(mktemp -d)"
export XDG_STATE_HOME="$(mktemp -d)"
export XDG_CACHE_HOME="$(mktemp -d)"

cleanup() {
  rm -rf "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME" "$XDG_CACHE_HOME"
}
trap cleanup EXIT

cd "$ROOT_DIR"
exec nix run . -- --headless "$@" '+qall'
