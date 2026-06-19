#!/usr/bin/env bash
set -euo pipefail

CHANNEL="${CHANNEL:?CHANNEL is required: stable or alpha}"
VERSION="${VERSION:?VERSION is required without leading v}"
REPO="${REPO:-gitkb/gitkb-releases}"
CHECKSUM_DIR="${CHECKSUM_DIR:-checksums}"
FORMULA_DIR="${FORMULA_DIR:-Formula}"

case "$CHANNEL" in
  stable)
    formula_file="${FORMULA_DIR}/gitkb.rb"
    class_name="Gitkb"
    desc="Git-native knowledge base with AI-powered code intelligence"
    conflicts=""
    ;;
  alpha)
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
  awk '{print $1}' "${CHECKSUM_DIR}/${file}.sha256"
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
