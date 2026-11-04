# gitkb Homebrew tap

```sh
brew install gitkb/tap/atc       # atc and its workflow workers
brew install gitkb/tap/gitkb     # git-kb
brew install gitkb/tap/meta-cli  # meta and its subcommands
```

Use the full `gitkb/tap/<name>`: current Homebrew trusts the tap for that formula when you install it by
that name. `brew tap gitkb/tap && brew install atc` is refused ("untrusted tap") unless you first run
`brew trust gitkb/tap`.

## Platforms

macOS (arm64, x86_64) and Linux via Homebrew on Linux (x86_64, arm64), matching the release assets.

Every pull request installs each changed formula on all four (`formula-test`): natively on macOS, and on
Linux inside Homebrew's own `homebrew/brew` image updated to the current Homebrew, so a binary that needs
a newer glibc or a system library the formula doesn't provide fails there. `scripts/smoke-test.sh` is the
check; it also fails when a release archive ships an executable the formula doesn't install. It replaces
the tap and uninstalls what it tests, so it runs only with `SMOKE_TEST_THROWAWAY_HOMEBREW=1`, in CI or a
fresh container:

```sh
docker run --rm -e SMOKE_TEST_THROWAWAY_HOMEBREW=1 -v "$PWD:/src:ro" homebrew/brew /src/scripts/smoke-test.sh /src Formula/atc.rb
```

## Updates

Formula bumps come from each project's release automation (atc via `gitkb/atc-releases`, meta from
`gitkb/meta`, gitkb from `gitkb-core`), which opens a PR here and turns on auto-merge. Auto-merge waits
only for required checks, so `formula-test` has to be a required status check on `main`, in a ruleset
that covers only this repo (other repos never report it). Until it is, bumps merge without waiting for it.
