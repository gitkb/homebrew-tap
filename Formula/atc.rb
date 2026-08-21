class Atc < Formula
  desc "Air Traffic Control — agent orchestrator for AI coding agents"
  homepage "https://github.com/gitkb/atc"
  version "0.1.10"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.10/atc-darwin-arm64.tar.gz"
      sha256 "1b1bc970382a65a5fe2bd69508f5a9cffb5b3bfabe1bf08473220ed966615a56"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.10/atc-darwin-x64.tar.gz"
      sha256 "1b43b9f3a0d2ea7c13bbd6be015306a5b61005ff7ef878ae9cb4a79c612d490d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.10/atc-linux-arm64.tar.gz"
      sha256 "d239ed2a6b997a565e4e452baa063b13ee5171170b191b4b83fb475fb8530680"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.10/atc-linux-x64.tar.gz"
      sha256 "e228630a2495db8233aed3583b82fde2f20ccdbcec3876c5f6132db96b8215d6"
    end
  end

  def install
    bin.install "atc"
  end

  test do
    system bin/"atc", "--help"
  end
end
