# typed: false
# frozen_string_literal: true

class Gitkb < Formula
  desc "Git-native knowledge base with AI-powered code intelligence"
  homepage "https://github.com/gitkb/gitkb-releases"
  version "0.2.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/gitkb-releases/releases/download/v#{version}/gitkb-darwin-arm64.tar.gz"
      sha256 "3877bd548321b36fadc94cc98fd95c4738e7fd662d468e4a774a7798d88d35f6"
    end
    on_intel do
      url "https://github.com/gitkb/gitkb-releases/releases/download/v#{version}/gitkb-darwin-x64.tar.gz"
      sha256 "d1b3c6973a5df96e9b6391649e3140138aaa8018887b39f6cc07cf1d1694bd49"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/gitkb-releases/releases/download/v#{version}/gitkb-linux-arm64.tar.gz"
      sha256 "2f8cdb4b4469e85a059a6e380541d5ca8ab85b00ed6b02a736a9c6f8bf9eb34a"
    end
    on_intel do
      url "https://github.com/gitkb/gitkb-releases/releases/download/v#{version}/gitkb-linux-x64.tar.gz"
      sha256 "14d78c9c236d657f843bc930a3a5252107ee9e7e5c71f925fba77f8c872a2321"
    end
  end

  def install
    bin.install "git-kb"
  end

  test do
    system "#{bin}/git-kb", "--version"
  end
end
