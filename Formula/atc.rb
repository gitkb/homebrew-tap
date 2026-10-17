class Atc < Formula
  desc "Air Traffic Control — agent orchestrator for AI coding agents"
  homepage "https://github.com/gitkb/atc-releases"
  version "0.2.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/atc-releases/releases/download/v0.2.1/atc-darwin-arm64.tar.gz"
      sha256 "02389c67c75d41a5baea220fda51728d061c351d2ff01058502ed0bfa30661ee"
    end
    on_intel do
      url "https://github.com/gitkb/atc-releases/releases/download/v0.2.1/atc-darwin-x64.tar.gz"
      sha256 "bfa5ef91f76713d95e12930bcfbc42a071815f0f59363a61ece03e8d30aa6a97"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/atc-releases/releases/download/v0.2.1/atc-linux-arm64.tar.gz"
      sha256 "79143118759f49cbd1b3d55c80a8c980017556fa63d32beada7cc0a826cb47ba"
    end
    on_intel do
      url "https://github.com/gitkb/atc-releases/releases/download/v0.2.1/atc-linux-x64.tar.gz"
      sha256 "f7a9d6085e59a916087a3eb389dc1064b1c688e58661059859f937b7cf929a38"
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
