class Atc < Formula
  desc "Air Traffic Control — agent orchestrator for AI coding agents"
  homepage "https://github.com/gitkb/atc"
  version "0.1.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.5/atc-darwin-arm64.tar.gz"
      sha256 "d37d392ba8ff15878fbdbb6a8a874cc1219851d7a7cbb5fa44dd8833575cd381"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.5/atc-darwin-x64.tar.gz"
      sha256 "17c642357575a1c49097d335a8ad2b1e35c2ab79f33048a0a2220520c3a50db6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.5/atc-linux-arm64.tar.gz"
      sha256 "ade4109538e78670d21d6d77176369574396885181f709d4773835dd9c530061"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.5/atc-linux-x64.tar.gz"
      sha256 "2133f4275ab31e96da20af416f0e1024df530675c5aa7934d3aa20ca29528162"
    end
  end

  def install
    bin.install "atc"
  end

  test do
    system bin/"atc", "--help"
  end
end
