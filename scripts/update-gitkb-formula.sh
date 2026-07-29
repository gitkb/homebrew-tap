#!/usr/bin/env bash
set -euo pipefail

CHANNEL="${CHANNEL:?CHANNEL is required: stable or alpha}"
VERSION="${VERSION:?VERSION is required without leading v}"
REPO="${REPO:-gitkb/gitkb-releases}"
CHECKSUM_DIR="${CHECKSUM_DIR:-checksums}"
FORMULA_DIR="${FORMULA_DIR:-Formula}"

if [[ ! "$REPO" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]]; then
  echo "invalid REPO: ${REPO}" >&2
  exit 1
fi

case "$CHANNEL" in
  stable)
    if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      echo "invalid stable VERSION: ${VERSION} (expected MAJOR.MINOR.PATCH)" >&2
      exit 1
    fi
    formula_file="${FORMULA_DIR}/gitkb.rb"
    class_name="Gitkb"
    desc="Git-native knowledge base with AI-powered code intelligence"
    conflicts=""
    ;;
  alpha)
    if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+-alpha\.[0-9]+\.[0-9]+\.[0-9a-f]{7,40}$ ]]; then
      echo "invalid alpha VERSION: ${VERSION} (expected MAJOR.MINOR.PATCH-alpha.RUN.ATTEMPT.SHA)" >&2
      exit 1
    fi
    formula_file="${FORMULA_DIR}/gitkb-alpha.rb"
    class_name="GitkbAlpha"
    desc="Pre-release GitKB CLI"
    conflicts='
  conflicts_with "gitkb", because: "both install git-kb"'
    ;;
  *)
    echo "unsupported CHANNEL: ${CHANNEL}" >&2
    exit 1
    ;;
esac

read_checksum() {
  local file="$1"
  local path="${CHECKSUM_DIR}/${file}.sha256"
  local checksum

  if [ ! -f "$path" ]; then
    echo "missing checksum file: ${path}" >&2
    exit 1
  fi

  checksum="$(awk 'NF { print $1; exit }' "$path")"
  if [[ ! "$checksum" =~ ^[0-9a-fA-F]{64}$ ]]; then
    echo "invalid sha256 in ${path}" >&2
    exit 1
  fi
  printf '%s\n' "$checksum"
}

darwin_arm64="$(read_checksum gitkb-darwin-arm64.tar.gz)"
darwin_x64="$(read_checksum gitkb-darwin-x64.tar.gz)"
linux_arm64="$(read_checksum gitkb-linux-arm64.tar.gz)"
linux_x64="$(read_checksum gitkb-linux-x64.tar.gz)"

mkdir -p "$FORMULA_DIR"

cat > "$formula_file" <<FORMULA
# typed: false
# frozen_string_literal: true

class ${class_name} < Formula
  desc "${desc}"
  homepage "https://github.com/${REPO}"
  version "${VERSION}"
  license "MIT"${conflicts}

  on_macos do
    on_arm do
      url "https://github.com/${REPO}/releases/download/v#{version}/gitkb-darwin-arm64.tar.gz"
      sha256 "${darwin_arm64}"
    end
    on_intel do
      url "https://github.com/${REPO}/releases/download/v#{version}/gitkb-darwin-x64.tar.gz"
      sha256 "${darwin_x64}"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/${REPO}/releases/download/v#{version}/gitkb-linux-arm64.tar.gz"
      sha256 "${linux_arm64}"
    end
    on_intel do
      url "https://github.com/${REPO}/releases/download/v#{version}/gitkb-linux-x64.tar.gz"
      sha256 "${linux_x64}"
    end
  end

  def install
    bin.install "git-kb"
  end

  test do
    system "#{bin}/git-kb", "--version"
  end
end
FORMULA

echo "$formula_file"
