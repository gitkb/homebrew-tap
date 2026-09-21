class Atc < Formula
  desc "Air Traffic Control — agent orchestrator for AI coding agents"
  homepage "https://github.com/gitkb/atc"
  version "0.1.18"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.18/atc-darwin-arm64.tar.gz"
      sha256 "50c3beef738afd899fae65c4e510fc3c35fd4064f37f1a1d5ae604abc2fe254b"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.18/atc-darwin-x64.tar.gz"
      sha256 "aa06fd972516553957ccc742156e247046faa41b81ff006b91db6da1ef0fa245"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.18/atc-linux-arm64.tar.gz"
      sha256 "56224eb0270c0819e7423b9905e9288f316836dd5d9b5030598948f178ab49c8"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.18/atc-linux-x64.tar.gz"
      sha256 "16778970b7538fd60bbbe748bf7861c41e59113e62346449311c7722fd9aa0ab"
    end
  end

  def install
    # The base formula must not pull in a macFUSE/libfuse-dependent helper.
    # Session-world filesystem backends are opt-in capabilities, not part of
    # the stock ATC installation.
    bin.install "atc"
    # Productionize sidecar ships beside atc so same-directory worker
    # resolution finds it without configuration.
    bin.install "atc-productionize"
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
