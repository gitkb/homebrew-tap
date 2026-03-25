# typed: false
# frozen_string_literal: true

class MetaCli < Formula
  desc "Multi-repo management CLI with AI integration"
  homepage "https://github.com/harmony-labs/meta"
  version "0.2.18"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/harmony-labs/meta/releases/download/v#{version}/meta-darwin-arm64.tar.gz"
      sha256 "24b680656816e2332afb32eafa5124974e1d1a6a1adc82e1729f63b342929b58"
    end
    on_intel do
      url "https://github.com/harmony-labs/meta/releases/download/v#{version}/meta-darwin-x64.tar.gz"
      sha256 "8e765a495a9b46b62d89296ccd392ebd28fd91b0fa38d3a7fbee87beed20db35"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/harmony-labs/meta/releases/download/v#{version}/meta-linux-arm64.tar.gz"
      sha256 "9f3930888a1edb766131f08f2165c390a6543ae4302d371a1bf0c358eab3a16e"
    end
    on_intel do
      url "https://github.com/harmony-labs/meta/releases/download/v#{version}/meta-linux-x64.tar.gz"
      sha256 "2eae990ce256cbe8de695919ce92a794b8d6d3bf0c7ef8ddf8b6cb3ba0d6ab0f"
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
