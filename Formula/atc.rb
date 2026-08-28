class Atc < Formula
  desc "Air Traffic Control — agent orchestrator for AI coding agents"
  homepage "https://github.com/gitkb/atc"
  version "0.1.13"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.13/atc-darwin-arm64.tar.gz"
      sha256 "0bfb6b10e73806ddd3fed1263a619f05ad307ce610a11e687f36031bff1c482f"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.13/atc-darwin-x64.tar.gz"
      sha256 "447cbd2ee5aa264d9d1b77504572b348940a82943f2274a5c8c85abb3e208be0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.13/atc-linux-arm64.tar.gz"
      sha256 "ee81f930e9d0622ac646f4f8ccfa032e7136e35f1991e90b7bc8d5e1bff50147"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.13/atc-linux-x64.tar.gz"
      sha256 "85a810ff2a5c9f43570b9109356a9f00b2bc6f7839f9d8aa935c240c00d047c8"
    end
  end

  def install
    # The base formula must not pull in a macFUSE/libfuse-dependent helper.
    # Session-world filesystem backends are opt-in capabilities, not part of
    # the stock ATC installation.
    bin.install "atc"
    # Keep the signed app bundle intact: its main executable is the process
    # macOS attributes Accessibility/Input Monitoring consent to, and its icon
    # brands the native permission surfaces. The CLI discovers it at prefix.
    prefix.install "ATC Hotkey.app" if OS.mac?
  end

  # Homebrew upgrades replace the versioned keg while a user LaunchAgent may
  # still be running the previous ATC executable. Reconcile only ATC-owned
  # state; the command is a no-op for users who have not enabled hotkeyd and
  # refuses foreign or ambiguous LaunchAgents.
  def post_install
    return unless OS.mac?

    atc = opt_bin/"atc"
    return unless atc.exist?

    system atc, "shims", "overlay", "setup", "hotkeyd", "--reconcile", "--json"
  rescue ErrorDuringExecution => e
    opoo "ATC hotkeyd was not automatically reconciled after upgrade: #{e}"
  end

  test do
    system bin/"atc", "--help"
  end
end
