# typed: false
# frozen_string_literal: true

class Gitkb < Formula
  desc "Git-native knowledge base with AI-powered code intelligence"
  homepage "https://github.com/harmony-labs/gitkb-releases"
  version "0.1.27"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/harmony-labs/gitkb-releases/releases/download/v#{version}/gitkb-darwin-arm64.tar.gz"
      sha256 "cb4137b56cbcb58b08e0054e0abc08a986e2b907ed35cd7ad53976251cba6ee6"
    end
    on_intel do
      url "https://github.com/harmony-labs/gitkb-releases/releases/download/v#{version}/gitkb-darwin-x64.tar.gz"
      sha256 "e4004d523440c13dbdb36bf9210888ca466bbb35f5704db362a28c62bb2fa7ff"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/harmony-labs/gitkb-releases/releases/download/v#{version}/gitkb-linux-arm64.tar.gz"
      sha256 "4858016beb4d99b022bdde265fe3f8c8cbf381aceaf124f2c7d059ef2ed863cc"
    end
    on_intel do
      url "https://github.com/harmony-labs/gitkb-releases/releases/download/v#{version}/gitkb-linux-x64.tar.gz"
      sha256 "9f4639a7d682805f1efb551a4550c08d851fcfc88ff0fe6b59ac5d0760bb275c"
    end
  end

  def install
    bin.install "git-kb"
  end

  test do
    system "#{bin}/git-kb", "--version"
  end
end
