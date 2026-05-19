# typed: false
# frozen_string_literal: true

class MetaCli < Formula
  desc "Multi-repo management CLI with AI integration"
  homepage "https://github.com/gitkb/meta"
  version "0.2.22"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/meta/releases/download/v#{version}/meta-darwin-arm64.tar.gz"
      sha256 "18d1d6d75d83e9e05554cbcc40bea156d49867cebc10c558cc3dff35822389ec"
    end
    on_intel do
      url "https://github.com/gitkb/meta/releases/download/v#{version}/meta-darwin-x64.tar.gz"
      sha256 "77e3046e66644f69c066a0cd06c2a7c4b555920b0e091acb1614892a77aa3d09"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/meta/releases/download/v#{version}/meta-linux-arm64.tar.gz"
      sha256 "58c40ee62342a0a033f666f3ced3f76af20b7472aca59a4e6414c3da452255b1"
    end
    on_intel do
      url "https://github.com/gitkb/meta/releases/download/v#{version}/meta-linux-x64.tar.gz"
      sha256 "28946046927da46d04d2daac5db1a64da0bec46f65f891fdcb0bf4c9e420d68c"
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
