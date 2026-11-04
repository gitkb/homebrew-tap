# gitkb Homebrew tap

```sh
brew install gitkb/tap/atc       # atc and its workflow workers
brew install gitkb/tap/gitkb     # git-kb
brew install gitkb/tap/meta-cli  # meta and its subcommands
```

## Platforms

macOS (arm64, x86_64) and Linux via Homebrew on Linux (x86_64, arm64), matching the release assets.

Every pull request installs each changed formula on all four (`formula-test`): natively on macOS, and on
Linux inside Homebrew's own `homebrew/brew` image, so a binary that needs a newer glibc or a system
library the formula doesn't provide fails there. `scripts/smoke-test.sh` is the check; it also fails when a
release archive ships an executable the formula doesn't install.

## Updates

Formula bumps come from each project's release automation (atc via `gitkb/atc-releases`, meta from
`gitkb/meta`, gitkb from `gitkb-core`), which opens a PR here and turns on auto-merge. Auto-merge waits
only for required checks, so `formula-test` must be a required status check on `main`.
