class Atc < Formula
  desc "Air Traffic Control — agent orchestrator for AI coding agents"
  homepage "https://github.com/gitkb/atc"
  version "0.1.14"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.14/atc-darwin-arm64.tar.gz"
      sha256 "90603009fcf4f02c3d4d23af17cc922fd309f037572b9f4d866f76f8a44514ad"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.14/atc-darwin-x64.tar.gz"
      sha256 "e94f73e149e7c60813b304649182bb3a9e5b3c0274262c0052bc8205ef8864d0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.14/atc-linux-arm64.tar.gz"
      sha256 "995897dfe717e7df18ddee9dd6a3b878c1713cd3db50f1c875553cb4f7b53d62"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.14/atc-linux-x64.tar.gz"
      sha256 "7331268ebbb4474a4656500ddfa2070f6d322b2263c15d50cb6ab8eba4caf71f"
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
