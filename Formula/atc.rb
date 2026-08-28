class Atc < Formula
  desc "Air Traffic Control — agent orchestrator for AI coding agents"
  homepage "https://github.com/gitkb/atc"
  version "0.1.13"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.13/atc-darwin-arm64.tar.gz"
      sha256 "6c3076b989373dc7c1e21125ee3a15a35b1934a84306b0f5fb143a3fee1b19b1"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.13/atc-darwin-x64.tar.gz"
      sha256 "17183880d5b804f9b06aaae2c5681ca5b7504899318ff5f852d28703f13e6d44"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.13/atc-linux-arm64.tar.gz"
      sha256 "2a96054ad9a83b99a2000689133c7e5909ce4347586042b03fa050b6a4f56bc7"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.13/atc-linux-x64.tar.gz"
      sha256 "4bcdde491a033c9127860f205fa485dfc7d80360a6a82c9746699d19aed61fb2"
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
