class Atc < Formula
  desc "Air Traffic Control — agent orchestrator for AI coding agents"
  homepage "https://github.com/gitkb/atc"
  version "0.1.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.8/atc-darwin-arm64.tar.gz"
      sha256 "842b9fefbfa674244e3b82b8d22003097fa24d85d2ba67253eded49607c9f270"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.8/atc-darwin-x64.tar.gz"
      sha256 "f96c95996a876e624ec4cb644926f3288b9946e0f28d3067c2d84602387989e8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.8/atc-linux-arm64.tar.gz"
      sha256 "c916f47b89bc1100b29cdd329b09f571be0fae427bf98ced36223ae1b05e7dbb"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.8/atc-linux-x64.tar.gz"
      sha256 "72e42d76f0740f1707aa470d1f1e0d2b2636bc8a40a24326fc34837242b43ced"
    end
  end

  def install
    bin.install "atc"
  end

  test do
    system bin/"atc", "--help"
  end
end
