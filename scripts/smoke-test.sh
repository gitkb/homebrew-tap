#!/usr/bin/env bash
# smoke-test.sh TAP_DIR FORMULA_FILE...
#
# Installs each formula from the tap checkout at TAP_DIR the way a user does
# (`brew install gitkb/tap/<name>`) and checks that what landed works on this
# host: the formula's own `test do` block passes, every executable in the
# release archive is installed into Homebrew's bin, each of them can be loaded
# here (on Linux: every shared library and glibc symbol version it needs is
# present), and the formula's first `bin.install` prints a non-empty
# `--version`.
#
# CI runs it natively on macOS and inside the `homebrew/brew` image on Linux,
# the minimal Ubuntu with Homebrew's glibc floor, so a release built against a
# newer glibc or an undeclared system library fails here and not for a user.
#
# Runs under macOS's system bash 3.2: no `mapfile`, no associative arrays.
set -euo pipefail

src="$1"
shift

export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_INSTALL_CLEANUP=1
prefix="$(brew --prefix)"

# Homebrew only installs formulae from a tap, so the checkout is copied in as
# gitkb/tap and the formulae under test are the ones in this tree. A copy, not
# a symlink: inside the container the checkout belongs to another user.
tap_dir="$(brew --repository)/Library/Taps/gitkb/homebrew-tap"
rm -rf "$tap_dir"
mkdir -p "$tap_dir"
cp -R "$src/." "$tap_dir/"
brew tap | grep -qx 'gitkb/tap' || { echo "::error::tap not registered" >&2; brew tap; exit 1; }

# Tests one formula. Each step ends in `|| return 1` because `set -e` is off
# inside a function called from `||`, and every formula should be reported,
# not just the first failure.
smoke() {
    local file="$1" name archive unpacked exe base installed missing bin out shipped=0
    name="$(basename "$file" .rb)"

    brew install --formula --verbose "gitkb/tap/$name" || return 1
    brew test "gitkb/tap/$name" || return 1

    # Every executable the release ships must be installed, so a worker the
    # formula forgets fails here rather than at `atc run`. `._*` entries are
    # macOS AppleDouble metadata that some archives carry, not programs.
    archive="$(brew --cache --formula "gitkb/tap/$name")" || return 1
    unpacked="$(mktemp -d)" || return 1
    tar xzf "$archive" -C "$unpacked" 2>/dev/null || return 1
    for exe in "$unpacked"/*; do
        base="$(basename "$exe")"
        case "$base" in ._*) continue ;; esac
        [ -f "$exe" ] && [ -x "$exe" ] || continue
        shipped=$((shipped + 1))
        installed="$prefix/bin/$base"
        if [ ! -x "$installed" ]; then
            echo "::error::$name: the release archive ships $base but the formula does not install it" >&2
            return 1
        fi
        if [ "$(uname -s)" = Linux ]; then
            # ldd reports both a missing library (`=> not found`) and a missing
            # glibc symbol version (`version \`GLIBC_2.39' not found`).
            missing="$(ldd "$installed" 2>&1 | grep 'not found')"
            if [ -n "$missing" ]; then
                echo "::error::$name: $base cannot load on this Linux: $missing" >&2
                return 1
            fi
        fi
        echo "$name: $base installed and loadable"
    done
    rm -rf "$unpacked"
    if [ "$shipped" -eq 0 ]; then
        echo "::error::$name: no executables found in $archive" >&2
        return 1
    fi

    # The main executable comes from the formula's own `bin.install` line, not
    # the formula name: gitkb installs `git-kb`, meta-cli installs `meta`.
    bin="$(sed -n 's/.*bin\.install "\([^"]*\)".*/\1/p' "$tap_dir/$file" | head -1)"
    if [ -z "$bin" ]; then
        echo "::error::$name: could not determine the main executable from $file" >&2
        return 1
    fi
    out="$("$prefix/bin/$bin" --version)" || return 1
    if [ -z "${out//[[:space:]]/}" ]; then
        echo "::error::$name: $bin --version printed nothing" >&2
        return 1
    fi
    echo "$bin --version => $out"

    brew uninstall --formula --ignore-dependencies "gitkb/tap/$name"
}

failed=""
for file in "$@"; do
    name="$(basename "$file" .rb)"
    echo "::group::$name"
    smoke "$file" || failed="$failed $name"
    echo "::endgroup::"
done
if [ -n "$failed" ]; then
    echo "::error::failed on $(uname -sm):$failed" >&2
    exit 1
fi
