class Atc < Formula
  desc "Air Traffic Control — agent orchestrator for AI coding agents"
  homepage "https://github.com/gitkb/atc"
  version "0.1.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.3/atc-darwin-arm64.tar.gz"
      sha256 "9e404491482c7993e0b3a693ec9edce2d634e17f677af4e9c3ac10a2c9294b39"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.3/atc-darwin-x64.tar.gz"
      sha256 "e81b61c75f6fef54dc0187ce66e51f09b3381fea3f207527dcc169a64518ad37"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.3/atc-linux-arm64.tar.gz"
      sha256 "75a8494832b4efb17552d712fce09eb36c558dcefb502a4f5e10cce829f3435e"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.3/atc-linux-x64.tar.gz"
      sha256 "c591c2965cd952d030a36c0fb76189ec58e596bb7730a2b7831d049452920007"
    end
  end

  def install
    bin.install "atc"
  end

  test do
    system bin/"atc", "--help"
  end
end
