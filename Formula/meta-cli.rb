# typed: false
# frozen_string_literal: true

class MetaCli < Formula
  desc "Multi-repo management CLI with AI integration"
  homepage "https://github.com/gitkb/meta"
  version "0.2.21"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/meta/releases/download/v#{version}/meta-darwin-arm64.tar.gz"
      sha256 "a68a0195ba12020e0d5bb70963eb832f30dd04fcaffe24443cddbb1c59383bcf"
    end
    on_intel do
      url "https://github.com/gitkb/meta/releases/download/v#{version}/meta-darwin-x64.tar.gz"
      sha256 "ca350f4017c52820870c250a06d4746a13861d4771d9a50264062d04d9a5d15f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/meta/releases/download/v#{version}/meta-linux-arm64.tar.gz"
      sha256 "a6e63375083964c422c9c7740117fb264678a74d069236d5882d83d26fcb634e"
    end
    on_intel do
      url "https://github.com/gitkb/meta/releases/download/v#{version}/meta-linux-x64.tar.gz"
      sha256 "55102f18702aa8e0d43edb220e7e9c4d2c490ee0f4d9a858627d9ee242fb83fe"
    end
  end

  def install
    bin.install "meta"
    bin.install "meta-git"
    bin.install "meta-project"
    bin.install "meta-mcp"
    bin.install "loop"
  end

  test do
    system "#{bin}/meta", "--version"
  end
end
