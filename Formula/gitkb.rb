# typed: false
# frozen_string_literal: true

class Gitkb < Formula
  desc "Git-native knowledge base with AI-powered code intelligence"
  homepage "https://github.com/gitkb/gitkb-releases"
  version "0.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/gitkb-releases/releases/download/v#{version}/gitkb-darwin-arm64.tar.gz"
      sha256 "67cd9c9e817b42cf00466bf29460a5c92747ab38e995ac6e9c07e38569f9b83b"
    end
    on_intel do
      url "https://github.com/gitkb/gitkb-releases/releases/download/v#{version}/gitkb-darwin-x64.tar.gz"
      sha256 "ef80c6d0633340b0d1eeefceb73df303adbcc266e7cd894fc6604c13e393394d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/gitkb-releases/releases/download/v#{version}/gitkb-linux-arm64.tar.gz"
      sha256 "c2241d85b7864d6eb7bfcb93661d7444fe0c7433ab733bf4704a69c281983c3a"
    end
    on_intel do
      url "https://github.com/gitkb/gitkb-releases/releases/download/v#{version}/gitkb-linux-x64.tar.gz"
      sha256 "40fa0f93b3c1f3337333f3cece30536cea257ff9d42e1566fe6a18fafc618385"
    end
  end

  def install
    bin.install "git-kb"
  end

  test do
    system "#{bin}/git-kb", "--version"
  end
end
