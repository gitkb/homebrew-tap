#!/usr/bin/env bash
# test-smoke-guard.sh: smoke-test.sh must refuse, before running any `brew`
# command, unless SMOKE_TEST_THROWAWAY_HOMEBREW=1 says Homebrew is disposable.
# `CI` being set (as in a devcontainer or a shell that exports it) is not
# enough. A fake `brew` on PATH records whether it was ever called.
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
scratch="$(mktemp -d -p "${RUNNER_TEMP:-$PWD}")"
trap 'rm -rf "$scratch"' EXIT
mkdir "$scratch/bin"
printf '#!/bin/sh\ntouch "%s/called"\nexit 1\n' "$scratch" > "$scratch/bin/brew"
chmod +x "$scratch/bin/brew"

fail=0
for value in "" 0 yes; do
    rm -f "$scratch/called"
    status=0
    env PATH="$scratch/bin:$PATH" CI=true SMOKE_TEST_THROWAWAY_HOMEBREW="$value" \
        "$here/smoke-test.sh" "$here/.." Formula/atc.rb 2>/dev/null || status=$?
    if [ "$status" -ne 2 ] || [ -e "$scratch/called" ]; then
        echo "::error::smoke-test.sh with CI=true and SMOKE_TEST_THROWAWAY_HOMEBREW='$value' did not refuse before touching Homebrew (exit $status)" >&2
        fail=1
    fi
done
[ "$fail" -eq 0 ] && echo "smoke-test.sh refuses without SMOKE_TEST_THROWAWAY_HOMEBREW=1"
exit "$fail"
