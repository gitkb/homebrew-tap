class Atc < Formula
  desc "Air Traffic Control — agent orchestrator for AI coding agents"
  homepage "https://github.com/gitkb/atc"
  version "0.1.14"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.14/atc-darwin-arm64.tar.gz"
      sha256 "4ec4479acbc6af3867e2227cfbbbbf54f73df7c07b747014c07e69acf5be75fc"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.14/atc-darwin-x64.tar.gz"
      sha256 "e6cf634ea97559167f83d1b4af78325401f5b721b9f7543bca6ffdf36db5abc1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/gitkb/atc/releases/download/v0.1.14/atc-linux-arm64.tar.gz"
      sha256 "617268cc2af35446ac6e5a1f1a326b8eaae5822a382d46937468a585f41db715"
    end
    on_intel do
      url "https://github.com/gitkb/atc/releases/download/v0.1.14/atc-linux-x64.tar.gz"
      sha256 "bc950f055ad9c51e16cd6149fe200a1cf8c63ddeda256e5757e54b562029886c"
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
