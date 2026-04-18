# typed: false
# frozen_string_literal: true

class Gitkb < Formula
  desc "Git-native knowledge base with AI-powered code intelligence"
  homepage "https://github.com/gitkb/gitkb-releases"
  version "0.1.49"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/gitkb-releases/releases/download/v#{version}/gitkb-darwin-arm64.tar.gz"
      sha256 "28601b5296d340a25a9b6c345a38e91d2abbf1371b1444907ec25bc3b4af6d34"
    end
    on_intel do
      url "https://github.com/gitkb/gitkb-releases/releases/download/v#{version}/gitkb-darwin-x64.tar.gz"
      sha256 "bd0c5852d43493ee1f44d4ca8673661b16bac95782d4ea35aec2fa7606634a46"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/gitkb-releases/releases/download/v#{version}/gitkb-linux-arm64.tar.gz"
      sha256 "10e710dc332342bf0cda2b2e0d3bce7ba731ad171a4c12fd8cfa59748d7c0189"
    end
    on_intel do
      url "https://github.com/gitkb/gitkb-releases/releases/download/v#{version}/gitkb-linux-x64.tar.gz"
      sha256 "a1d4ed390d71e765eea878ad3b9876438779bb55cebaedd9d93f610b71fdc2e0"
    end
  end

  def install
    bin.install "git-kb"
  end

  test do
    system "#{bin}/git-kb", "--version"
  end
end
