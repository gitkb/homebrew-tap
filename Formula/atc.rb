class Atc < Formula
  desc "Air Traffic Control — agent orchestrator for AI coding agents"
  homepage "https://github.com/harmony-labs/atc"
  version "0.1.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/harmony-labs/atc/releases/download/v0.1.1/atc-darwin-arm64.tar.gz"
      sha256 "0fce2ab88fafd13d89b22aa1f1c06ea9c9ec3f2fb4ddf96953143ef96f225c76"
    end
    on_intel do
      url "https://github.com/harmony-labs/atc/releases/download/v0.1.1/atc-darwin-x64.tar.gz"
      sha256 "e23028113aad067263d51861a4f010fcee423ffd6513af2f8723e48c6b017624"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/harmony-labs/atc/releases/download/v0.1.1/atc-linux-arm64.tar.gz"
      sha256 "fcd0461d19a60d87914290e21c176a496f0f81c34e51b7ddc6238fba9525ee23"
    end
    on_intel do
      url "https://github.com/harmony-labs/atc/releases/download/v0.1.1/atc-linux-x64.tar.gz"
      sha256 "63e621fa66c1d0fa4a4a1e05068512227346c589a0a1c0d1a209094ebe008b2d"
    end
  end

  def install
    bin.install "atc"
  end

  test do
    system bin/"atc", "--help"
  end
end
