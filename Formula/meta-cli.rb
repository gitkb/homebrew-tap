# typed: false
# frozen_string_literal: true

class MetaCli < Formula
  desc "Multi-repo management CLI with AI integration"
  homepage "https://github.com/gitkb/meta"
  version "0.3.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/meta/releases/download/v#{version}/meta-darwin-arm64.tar.gz"
      sha256 "3a7befd146dcd85b11a1168e3c8d0b9c7bf44592d183556f6c104ca074a8a031"
    end
    on_intel do
      url "https://github.com/gitkb/meta/releases/download/v#{version}/meta-darwin-x64.tar.gz"
      sha256 "591d8706a4b0854714a39778fe4d0ed1eeca9295e6254e23ccd4a1b4bcc3421e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/meta/releases/download/v#{version}/meta-linux-arm64.tar.gz"
      sha256 "50d578f9bae3564e0e7f2c195641cd4c337b9d2e9606cb218f586afff7f32338"
    end
    on_intel do
      url "https://github.com/gitkb/meta/releases/download/v#{version}/meta-linux-x64.tar.gz"
      sha256 "320cab1594f9552f02516adb19edc60061ff6f6b347f74e9949a1fb8e1c989e4"
    end
  end

  def install
    bin.install "loop"
    bin.install "meta"
    bin.install "meta-git"
    bin.install "meta-mcp"
    bin.install "meta-cargo"
  end

  test do
    system "#{bin}/meta", "--version"
  end
end
