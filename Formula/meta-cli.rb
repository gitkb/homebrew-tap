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
      sha256 "700bf88e0958a6e7720cb7bf0088ff460adc486044c2840eb3203bfaa2088823"
    end
    on_intel do
      url "https://github.com/gitkb/meta/releases/download/v#{version}/meta-darwin-x64.tar.gz"
      sha256 "bd393086a3b8e0f55e86c826fc9de0ebc53ba18d4e21868a594cc5e6e35a5974"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/meta/releases/download/v#{version}/meta-linux-arm64.tar.gz"
      sha256 "a56adb1672a165daf87ffaa1862702261ad04d23875a4ad4a3f21627d218da89"
    end
    on_intel do
      url "https://github.com/gitkb/meta/releases/download/v#{version}/meta-linux-x64.tar.gz"
      sha256 "08f9db0f0bc4a9d931fa69177298e1ce25982cbcc4e43bebebc1dedd4dfbd2a7"
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
