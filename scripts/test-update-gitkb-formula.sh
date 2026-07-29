#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GENERATOR="${SCRIPT_DIR}/update-gitkb-formula.sh"
TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT

CHECKSUM_DIR="${TEST_ROOT}/checksums"
mkdir -p "$CHECKSUM_DIR"

checksum="0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
for artifact in \
  gitkb-darwin-arm64.tar.gz \
  gitkb-darwin-x64.tar.gz \
  gitkb-linux-arm64.tar.gz \
  gitkb-linux-x64.tar.gz
do
  printf '%s  %s\n' "$checksum" "$artifact" > "${CHECKSUM_DIR}/${artifact}.sha256"
done

stable_dir="${TEST_ROOT}/stable"
CHANNEL=stable \
  VERSION=1.2.3 \
  CHECKSUM_DIR="$CHECKSUM_DIR" \
  FORMULA_DIR="$stable_dir" \
  "$GENERATOR"
ruby -c "${stable_dir}/gitkb.rb"
grep -Fq 'class Gitkb < Formula' "${stable_dir}/gitkb.rb"
grep -Fq 'version "1.2.3"' "${stable_dir}/gitkb.rb"

alpha_dir="${TEST_ROOT}/alpha"
CHANNEL=alpha \
  VERSION=1.2.4-alpha.123.1.abcdef0 \
  CHECKSUM_DIR="$CHECKSUM_DIR" \
  FORMULA_DIR="$alpha_dir" \
  "$GENERATOR"
ruby -c "${alpha_dir}/gitkb-alpha.rb"
grep -Fq 'class GitkbAlpha < Formula' "${alpha_dir}/gitkb-alpha.rb"
grep -Fq 'conflicts_with "gitkb"' "${alpha_dir}/gitkb-alpha.rb"

if CHANNEL=stable \
  VERSION=1.2.4-alpha.123.1.abcdef0 \
  CHECKSUM_DIR="$CHECKSUM_DIR" \
  FORMULA_DIR="${TEST_ROOT}/invalid-stable" \
  "$GENERATOR"
then
  echo "stable channel accepted an alpha version" >&2
  exit 1
fi

if CHANNEL=alpha \
  VERSION=1.2.4 \
  CHECKSUM_DIR="$CHECKSUM_DIR" \
  FORMULA_DIR="${TEST_ROOT}/invalid-alpha" \
  "$GENERATOR"
then
  echo "alpha channel accepted a stable version" >&2
  exit 1
fi

printf '%s\n' "not-a-checksum" > "${CHECKSUM_DIR}/gitkb-linux-x64.tar.gz.sha256"
if CHANNEL=stable \
  VERSION=1.2.3 \
  CHECKSUM_DIR="$CHECKSUM_DIR" \
  FORMULA_DIR="${TEST_ROOT}/invalid-checksum" \
  "$GENERATOR"
then
  echo "generator accepted a malformed checksum" >&2
  exit 1
fi
