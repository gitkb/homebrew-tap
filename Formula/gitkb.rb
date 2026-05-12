# typed: false
# frozen_string_literal: true

class Gitkb < Formula
  desc "Git-native knowledge base with AI-powered code intelligence"
  homepage "https://github.com/gitkb/gitkb-releases"
  version "0.2.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/gitkb-releases/releases/download/v#{version}/gitkb-darwin-arm64.tar.gz"
      sha256 "fbaea32199ec0f5c7e7a49143df7831a5632a3207c5dbdac07988bd3c26abdc2"
    end
    on_intel do
      url "https://github.com/gitkb/gitkb-releases/releases/download/v#{version}/gitkb-darwin-x64.tar.gz"
      sha256 "afb0714ef2d639091f4ecab92bb1b5a20a83c93aef8aa3815501be6a17a7bee2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/gitkb-releases/releases/download/v#{version}/gitkb-linux-arm64.tar.gz"
      sha256 "6f80e46f01c8cb3e995a916def135975600fdf8339ede0e2574b3f46a1e517d5"
    end
    on_intel do
      url "https://github.com/gitkb/gitkb-releases/releases/download/v#{version}/gitkb-linux-x64.tar.gz"
      sha256 "9f9b04db3f1ebb0ead8767dcbbdeb797acda4016f2db52bca2fe668f992e29f8"
    end
  end

  def install
    bin.install "git-kb"
  end

  test do
    system "#{bin}/git-kb", "--version"
  end
end
