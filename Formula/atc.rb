class Atc < Formula
  desc "Air Traffic Control — agent orchestrator for AI coding agents"
  homepage "https://github.com/gitkb/atc-releases"
  version "0.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/atc-releases/releases/download/v0.2.0/atc-darwin-arm64.tar.gz"
      sha256 "4db4741d2257559c6460248f894e0238a6e9ef6eceefbaafdad81fd0206942ca"
    end
    on_intel do
      url "https://github.com/gitkb/atc-releases/releases/download/v0.2.0/atc-darwin-x64.tar.gz"
      sha256 "892e5390ee5d076f711e298a977c515c05d4acdb0e1c3d93c1518bed291c2183"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/atc-releases/releases/download/v0.2.0/atc-linux-arm64.tar.gz"
      sha256 "354cb2cbb9393eea7aee9ad56e4e48bbd9770c1b81051d22f3dc09e561570c63"
    end
    on_intel do
      url "https://github.com/gitkb/atc-releases/releases/download/v0.2.0/atc-linux-x64.tar.gz"
      sha256 "c1528c6174cb5a8571371f71136593c00ce076cd099ec7058a13993b8f3f15cb"
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
