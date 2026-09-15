#!/bin/bash
# Install or update the aeone.games desktop app on macOS:
#
#   curl -fsSL https://raw.githubusercontent.com/aeone-games/desktop/main/macos/install-macos.sh | bash
#
# Downloads the latest release for this Mac (Apple silicon or Intel), checks it against the
# release's SHA256SUMS and puts aeone.games.app in ~/Applications — re-run to update, remove
# with `rm -rf ~/Applications/aeone.games.app`. The app is ad-hoc signed, not notarized; a
# download made by curl carries no quarantine flag, so Gatekeeper does not stop it.
set -euo pipefail

release="https://github.com/aeone-games/desktop/releases/latest/download"
case "$(uname -m)" in
  arm64) arch=arm64 ;;
  x86_64) arch=x64 ;;
  *) echo "aeone.games: unsupported Mac architecture $(uname -m)" >&2; exit 1 ;;
esac

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

curl -fsSL "$release/SHA256SUMS" -o "$work/SHA256SUMS"
line="$(grep -E "^[0-9a-f]{64}  aeone-games-[0-9.]+-mac-$arch\.tar\.gz$" "$work/SHA256SUMS")" || {
  echo "aeone.games: the latest release has no macOS $arch build" >&2
  exit 1
}
sum="${line%%  *}"
name="${line##*  }"

curl -fL --progress-bar "$release/$name" -o "$work/$name"
echo "$sum  $work/$name" | shasum -a 256 -c - >/dev/null

tar -xzf "$work/$name" -C "$work"
pkill -x aeone.games 2>/dev/null || true
mkdir -p "$HOME/Applications"
rm -rf "$HOME/Applications/aeone.games.app"
mv "$work/aeone.games.app" "$HOME/Applications/"

echo "aeone.games installed — open it from Spotlight (Cmd+Space, 'aeone')."
