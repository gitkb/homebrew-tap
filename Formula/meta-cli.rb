# typed: false
# frozen_string_literal: true

class MetaCli < Formula
  desc "Multi-repo management CLI with AI integration"
  homepage "https://github.com/harmony-labs/meta"
  version "0.2.19"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/harmony-labs/meta/releases/download/v#{version}/meta-darwin-arm64.tar.gz"
      sha256 "eb42b085f11d6a3954a6568c8bb7269668e81937f8d70e685a3f4ff6d66848e1"
    end
    on_intel do
      url "https://github.com/harmony-labs/meta/releases/download/v#{version}/meta-darwin-x64.tar.gz"
      sha256 "d9df576c905b1dd8e70cb7ac54769fbdc5bfa0c96cacfbb48af19efc9b04c4ca"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/harmony-labs/meta/releases/download/v#{version}/meta-linux-arm64.tar.gz"
      sha256 "e507088b883394fb21eb7b652f1486e1b64459d68c16280d81a94486195040c9"
    end
    on_intel do
      url "https://github.com/harmony-labs/meta/releases/download/v#{version}/meta-linux-x64.tar.gz"
      sha256 "525d4ac0009d30ee78c8ce5784a7da22cb45b164e769637d2f304a75c36bd524"
    end
  end

  def install
    bin.install "meta"
    bin.install "meta-git"
    bin.install "meta-project"
    bin.install "meta-mcp"
    bin.install "loop"
  end

  test do
    system "#{bin}/meta", "--version"
  end
end
