class Atc < Formula
  desc "Air Traffic Control — agent orchestrator for AI coding agents"
  homepage "https://github.com/gitkb/atc"
  version "0.1.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.2/atc-darwin-arm64.tar.gz"
      sha256 "003dde1a94b5d238b4d3987f208c3c6ff938300ca567399ddcfa0faf7bf7f51c"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.2/atc-darwin-x64.tar.gz"
      sha256 "44413af566bdf078316be964b43df858651889b2c35684f5a3aef3daeda81e29"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.2/atc-linux-arm64.tar.gz"
      sha256 "0b47439ba5bb37a954ec6c73764557da3dcccbb383461f854ef57eed2441321c"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.2/atc-linux-x64.tar.gz"
      sha256 "699f4e6971f576e26da6350f14af5dc2a00a90770705bb0b61dd5bbeaf38dbf7"
    end
  end

  def install
    bin.install "atc"
  end

  test do
    system bin/"atc", "--help"
  end
end
