class Atc < Formula
  desc "Air Traffic Control — agent orchestrator for AI coding agents"
  homepage "https://github.com/gitkb/atc"
  version "0.1.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.7/atc-darwin-arm64.tar.gz"
      sha256 "eed531aa44d292d39c4ae894815fca41e5d40ae53a9d9ae83486d6714b768316"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.7/atc-darwin-x64.tar.gz"
      sha256 "53488e32a59a8b370069fc4f84656c4d9efe02939c1e275de1ea4bdb201d986c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.7/atc-linux-arm64.tar.gz"
      sha256 "018bfdc2ce52cbfa85b7d6d3593bc8c2cdf9eb7d3f153421303fef955d6b3e1d"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.7/atc-linux-x64.tar.gz"
      sha256 "bf34edcc6f2a73a8c8ba027dfa861cfcbfaa80e71e703f5c5faab79c2c7e0c86"
    end
  end

  def install
    bin.install "atc"
  end

  test do
    system bin/"atc", "--help"
  end
end
