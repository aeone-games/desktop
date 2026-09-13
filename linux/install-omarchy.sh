#!/bin/bash
# Install or update the aeone.games desktop app on Omarchy (or any Arch system):
#
#   curl -fsSL https://raw.githubusercontent.com/aeone-games/desktop/main/linux/install-omarchy.sh | bash
#
# Builds the package from this repo's PKGBUILD with makepkg, so pacman owns the install —
# re-run to update, remove with `sudo pacman -R aeone-games-bin`.
set -euo pipefail

sudo pacman -S --needed --noconfirm git base-devel

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

git clone --depth 1 https://github.com/aeone-games/desktop.git "$work/desktop"
cd "$work/desktop/linux"
makepkg -si --noconfirm --needed

echo "aeone.games installed — press Super+Space and search 'aeone'."
