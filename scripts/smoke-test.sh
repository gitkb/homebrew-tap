#!/usr/bin/env bash
# smoke-test.sh TAP_DIR FORMULA_FILE...
#
# Installs each formula from the tap checkout at TAP_DIR the way a user does
# (`brew install gitkb/tap/<name>`, on an up-to-date Homebrew) and checks that
# what landed works on this host: every executable in the release archive is
# installed into the formula's bin, each of them can be loaded here (on
# Linux: every shared library and glibc symbol version it needs is present;
# on macOS only that it is installed), the formula's own `test do` block
# passes, and the formula's first `bin.install` prints a non-empty
# `--version`. Every check runs and every failure is reported.
#
# CI runs it natively on macOS and inside the `homebrew/brew` image on Linux,
# the minimal Ubuntu with Homebrew's glibc floor, so a release built against a
# newer glibc or an undeclared system library fails here and not for a user.
#
# It deletes the installed gitkb/tap and uninstalls what it tests, so it runs
# only when SMOKE_TEST_THROWAWAY_HOMEBREW=1 says this Homebrew is disposable.
# The workflow sets it; locally, use a fresh container:
#   docker run --rm -e SMOKE_TEST_THROWAWAY_HOMEBREW=1 -v "$PWD:/src:ro" homebrew/brew /src/scripts/smoke-test.sh /src Formula/atc.rb
# Being in a container or CI is not enough: toolbox, distrobox, devcontainers
# and Codespaces share a real home and Homebrew.
#
# Runs under macOS's system bash 3.2: no `mapfile`, no associative arrays.
set -euo pipefail

if [ $# -lt 2 ]; then
    echo "usage: $0 TAP_DIR FORMULA_FILE..." >&2
    exit 2
fi
if [ "${SMOKE_TEST_THROWAWAY_HOMEBREW:-}" != 1 ]; then
    echo "smoke-test.sh deletes gitkb/tap and uninstalls formulae; set SMOKE_TEST_THROWAWAY_HOMEBREW=1 only in a disposable Homebrew (see the script's header)" >&2
    exit 2
fi
src="$1"
shift

export HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_INSTALL_CLEANUP=1
# The homebrew/brew image ships the Homebrew of its build date; a user's
# first `brew` command updates it. Test the current one (GitHub keeps its
# macOS runners' Homebrew current), then hold it there for the run.
if [ "$(uname -s)" = Linux ]; then
    brew update --quiet
fi
export HOMEBREW_NO_AUTO_UPDATE=1
echo "Testing with $(brew --version | head -1) on $(uname -sm)"
# Unpacked archives go in Homebrew's own cache, not the system temp dir.
work="$(brew --cache)/gitkb-smoke-test"
rm -rf "$work"
mkdir -p "$work"
trap 'rm -rf "$work"' EXIT

# Homebrew only installs formulae from a tap, so the checkout is copied in as
# gitkb/tap and the formulae under test are the ones in this tree. A copy, not
# a symlink: inside the container the checkout belongs to another user.
tap_dir="$(brew --repository)/Library/Taps/gitkb/homebrew-tap"
rm -rf "$tap_dir"
mkdir -p "$tap_dir"
cp -R "$src/." "$tap_dir/"
brew tap | grep -qx 'gitkb/tap' || { echo "::error::tap not registered" >&2; brew tap; exit 1; }

# Tests one formula and reports every check that fails, so a bump that both
# drops a worker and cannot load shows both. Only a failed install stops it
# early. `set -e` is off inside a function called from `||`, so each step's
# status is checked by hand.
smoke() {
    local file="$1" name keg archive unpacked exe base installed missing bin out shipped=0 ok=0
    name="$(basename "$file" .rb)"

    brew install --formula --verbose "gitkb/tap/$name" || return 1
    # This formula's own bin, so a same-named file from another formula
    # doesn't count.
    keg="$(brew --prefix "gitkb/tap/$name")" || return 1

    # Every executable the release ships must be installed, so a worker the
    # formula forgets fails here rather than at `atc run`. `._*` entries are
    # macOS AppleDouble metadata that some archives carry, not programs.
    archive="$(brew --cache --formula "gitkb/tap/$name")" || return 1
    unpacked="$work/$name"
    mkdir -p "$unpacked"
    if ! tar xzf "$archive" -C "$unpacked" 2>/dev/null; then
        echo "::error::$name: cannot unpack $archive as a .tar.gz" >&2
        ok=1
    fi
    for exe in "$unpacked"/*; do
        base="$(basename "$exe")"
        case "$base" in ._*) continue ;; esac
        [ -f "$exe" ] && [ -x "$exe" ] || continue
        shipped=$((shipped + 1))
        installed="$keg/bin/$base"
        if [ ! -x "$installed" ]; then
            echo "::error::$name: the release archive ships $base but the formula does not install it" >&2
            ok=1
            continue
        fi
        if [ "$(uname -s)" = Linux ]; then
            # ldd reports both a missing library (`=> not found`) and a missing
            # glibc symbol version (`version \`GLIBC_2.39' not found`).
            missing="$(ldd "$installed" 2>&1 | grep 'not found')"
            if [ -n "$missing" ]; then
                echo "::error::$name: $base cannot load on this Linux: $missing" >&2
                ok=1
                continue
            fi
            echo "$name: $base installed and loadable"
        else
            echo "$name: $base installed"
        fi
    done
    if [ "$shipped" -eq 0 ]; then
        echo "::error::$name: no executables found in $archive" >&2
        ok=1
    fi

    if ! brew test "gitkb/tap/$name"; then
        echo "::error::$name: the formula's test do block failed" >&2
        ok=1
    fi

    # The main executable comes from the formula's own `bin.install` line, not
    # the formula name: gitkb installs `git-kb`, meta-cli installs `meta`.
    bin="$(sed -n 's/.*bin\.install "\([^"]*\)".*/\1/p' "$tap_dir/$file" | head -1)"
    if [ -z "$bin" ]; then
        echo "::error::$name: could not determine the main executable from $file" >&2
        ok=1
    elif ! out="$("$keg/bin/$bin" --version)"; then
        echo "::error::$name: $bin --version failed" >&2
        ok=1
    elif [ -z "${out//[[:space:]]/}" ]; then
        echo "::error::$name: $bin --version printed nothing" >&2
        ok=1
    else
        echo "$bin --version => $out"
    fi

    brew uninstall --formula --ignore-dependencies "gitkb/tap/$name" || ok=1
    return "$ok"
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
