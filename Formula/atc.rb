class Atc < Formula
  desc "Air Traffic Control — agent orchestrator for AI coding agents"
  homepage "https://github.com/gitkb/atc"
  version "0.1.17"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.17/atc-darwin-arm64.tar.gz"
      sha256 "26670bf7002d97ee0c9178da6ee76af8ef73be501deb9ef5172ea77921a3125a"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.17/atc-darwin-x64.tar.gz"
      sha256 "0629fdb7ca504fb1d4cf9c1b4d7be24addd3c1a67ac0d32b24a75eba703378a9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.17/atc-linux-arm64.tar.gz"
      sha256 "72c0aba91e84941d62b2f2d7e30010319076bb56e0ef23d0d93ed1003ca09ed2"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.17/atc-linux-x64.tar.gz"
      sha256 "6f44f40e241af7e767a1c06c66dabee6e381a5da3c34f51d68df509b3550411c"
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
