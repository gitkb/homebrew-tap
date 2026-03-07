# typed: false
# frozen_string_literal: true

class Gitkb < Formula
  desc "Git-native knowledge base with AI-powered code intelligence"
  homepage "https://github.com/harmony-labs/gitkb-releases"
  version "0.1.20"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/harmony-labs/gitkb-releases/releases/download/v#{version}/gitkb-darwin-arm64.tar.gz"
      sha256 "7a3d6b824a4ed1a53dbeb7df70e196d43a5769ad3fee85a8c05f5c2cb3762118"
    end
    on_intel do
      url "https://github.com/harmony-labs/gitkb-releases/releases/download/v#{version}/gitkb-darwin-x64.tar.gz"
      sha256 "02d5c1e6996bfa29fe66458ea986a6a29c8d647fb43e600fab2990285f32a8d7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/harmony-labs/gitkb-releases/releases/download/v#{version}/gitkb-linux-arm64.tar.gz"
      sha256 "7c0f53e6d185e86967f92dd9c53a62cba66722c025e7c54efda7b85ee1c8edc7"
    end
    on_intel do
      url "https://github.com/harmony-labs/gitkb-releases/releases/download/v#{version}/gitkb-linux-x64.tar.gz"
      sha256 "5be1a07d4ac831509a3251ee41080518d31efd3c3073658ebd3417d85e166444"
    end
  end

  def install
    bin.install "git-kb"
  end

  test do
    system "#{bin}/git-kb", "--version"
  end
end
