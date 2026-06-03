class Atc < Formula
  desc "Air Traffic Control — agent orchestrator for AI coding agents"
  homepage "https://github.com/gitkb/atc"
  version "0.1.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.6/atc-darwin-arm64.tar.gz"
      sha256 "d5827bdc44008fbbdea1ea2aa590dcb8014bb279f9abe730c329b264d1f2dc56"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.6/atc-darwin-x64.tar.gz"
      sha256 "5dd001ae54854dde83d19aa7780871fb0b226e5afa9d21d68b1620d3f06b6e00"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.6/atc-linux-arm64.tar.gz"
      sha256 "06eea8b7a011538c653e0d2b07fb8fdf1d3bb370aa4d58254ffa42cfb0b6dc29"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.6/atc-linux-x64.tar.gz"
      sha256 "389c23d192c8486e3a7646aaf2fcedf04a9f483a5faf71d14dfc7a414a0efd80"
    end
  end

  def install
    bin.install "atc"
  end

  test do
    system bin/"atc", "--help"
  end
end
