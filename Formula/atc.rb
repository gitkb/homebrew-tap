class Atc < Formula
  desc "Air Traffic Control — agent orchestrator for AI coding agents"
  homepage "https://github.com/gitkb/atc"
  version "0.1.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.4/atc-darwin-arm64.tar.gz"
      sha256 "658e88c8617676993e7aaa810b64691b297dd677208eeeb1d22ffe5ba4d66b0a"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.4/atc-darwin-x64.tar.gz"
      sha256 "f4c7b0187556814783136a9c34b6121a00fa283ff2ce216ee44b50dce52580d3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.4/atc-linux-arm64.tar.gz"
      sha256 "1e5daf9c200922b5264dcf39a80271f7c1701a8b940345be027b4a33ae5ab5d6"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.4/atc-linux-x64.tar.gz"
      sha256 "8a392972c06711d0e765943a68f542330b9803aa4e8f13638ebb49163e19f6ab"
    end
  end

  def install
    bin.install "atc"
  end

  test do
    system bin/"atc", "--help"
  end
end
