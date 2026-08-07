class Atc < Formula
  desc "Air Traffic Control — agent orchestrator for AI coding agents"
  homepage "https://github.com/gitkb/atc"
  version "0.1.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.9/atc-darwin-arm64.tar.gz"
      sha256 "fe03d38cd256129300adda59960dd2abc07b78d6bb7fbf0c1d4567b3e2acf164"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.9/atc-darwin-x64.tar.gz"
      sha256 "a35625c743a600392397f6626992705ecb774590e51bf09aaa346c881a968fa0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.9/atc-linux-arm64.tar.gz"
      sha256 "0d8843270315d554dcf5e383c504e50091ad551cd09d46e90ed0486e609c6b2c"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.9/atc-linux-x64.tar.gz"
      sha256 "0a03d5d1527244c67317acc8ffae8cafaf71fa5c56d7e037b62d787769c17302"
    end
  end

  def install
    bin.install "atc"
  end

  test do
    system bin/"atc", "--help"
  end
end
