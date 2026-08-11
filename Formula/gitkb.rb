# typed: false
# frozen_string_literal: true

class Gitkb < Formula
  desc "Git-native knowledge base with AI-powered code intelligence"
  homepage "https://github.com/gitkb/gitkb-releases"
  version "0.2.17"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/gitkb-releases/releases/download/v#{version}/gitkb-darwin-arm64.tar.gz"
      sha256 "6b19a964c1e7f9043d5a9bc83e571b66066785f6180a7386cd74736c5bd446c2"
    end
    on_intel do
      url "https://github.com/gitkb/gitkb-releases/releases/download/v#{version}/gitkb-darwin-x64.tar.gz"
      sha256 "c6c17fa1a5e9ce681d59c2e66b4b714bf3d9619f5b89ad080012f869ba9332ac"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/gitkb-releases/releases/download/v#{version}/gitkb-linux-arm64.tar.gz"
      sha256 "a35ee37c9af1ae7fc0fba10cda1147648d87a30de96e941765a738f3cdecb0e6"
    end
    on_intel do
      url "https://github.com/gitkb/gitkb-releases/releases/download/v#{version}/gitkb-linux-x64.tar.gz"
      sha256 "65e26e30efa49401f4a2525e06d3d0588adc7ab22241b96114dcd1f161ccd32a"
    end
  end

  def install
    bin.install "git-kb"
  end

  test do
    system "#{bin}/git-kb", "--version"
  end
end
