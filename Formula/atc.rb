class Atc < Formula
  desc "Air Traffic Control — agent orchestrator for AI coding agents"
  homepage "https://github.com/gitkb/atc"
  version "0.1.16"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.16/atc-darwin-arm64.tar.gz"
      sha256 "cb5f8206e574fba796303f8af97e1967838d4349b199e3b202f023140a3f7416"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.16/atc-darwin-x64.tar.gz"
      sha256 "fef84637850a6e73a025ebbbe836629f418edbaa681dd9cdc80f519bc0a2624c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.16/atc-linux-arm64.tar.gz"
      sha256 "29271a07039477706c40f7fb18c25094918cd913bdf37b87d19038e737fedd2a"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.16/atc-linux-x64.tar.gz"
      sha256 "792cf691d8b97777462e5ed1af236a3c86586d617514f3d502b8ef5e109336fa"
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
