# typed: false
# frozen_string_literal: true

class Gitkb < Formula
  desc "Git-native knowledge base with AI-powered code intelligence"
  homepage "https://github.com/harmony-labs/gitkb-releases"
  version "0.1.35"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/harmony-labs/gitkb-releases/releases/download/v#{version}/gitkb-darwin-arm64.tar.gz"
      sha256 "24f2503eabe2e63c15c006311ab4f6588a45241097331248cdd402ebdcc7f541"
    end
    on_intel do
      url "https://github.com/harmony-labs/gitkb-releases/releases/download/v#{version}/gitkb-darwin-x64.tar.gz"
      sha256 "f9ae9028240408b2b92cd90761a1289e0f3bca93e43dcc6c918436ccda3c6cdc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/harmony-labs/gitkb-releases/releases/download/v#{version}/gitkb-linux-arm64.tar.gz"
      sha256 "97400d3101a6a9b55eb1c11edb080e5b19dc6b0dee8db37b08ca95e7a7467b34"
    end
    on_intel do
      url "https://github.com/harmony-labs/gitkb-releases/releases/download/v#{version}/gitkb-linux-x64.tar.gz"
      sha256 "e80ee90de25a601d16d48c7cb62f84f78ed0b44666abcc916f3b7edbc13b9724"
    end
  end

  def install
    bin.install "git-kb"
  end

  test do
    system "#{bin}/git-kb", "--version"
  end
end
