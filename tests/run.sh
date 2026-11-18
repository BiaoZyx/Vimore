#!/usr/bin/env bash
# 在隔离的 HOME 里跑冒烟测试，不碰用户自己的 ~/.vim
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/home" "$TMP/work"
export HOME="$TMP/home"
export SMOKE_TMP="$TMP/work"
cd "$TMP/work"
vim --clean -Nu "$ROOT/Vimore.vimrc" -es -S "$ROOT/tests/smoke.vim" </dev/null
cat "$TMP/work/smoke.out"
