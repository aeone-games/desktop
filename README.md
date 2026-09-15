# aeone.games desktop

The aeone.games desktop app. Run the command for your system to install it, and run it again to update.

## Omarchy / Arch Linux

```sh
curl -fsSL https://raw.githubusercontent.com/aeone-games/desktop/main/linux/install-omarchy.sh | bash
```

## macOS (Apple silicon and Intel)

Paste into Terminal. Installs to `~/Applications/aeone.games.app`.

```sh
curl -fsSL https://raw.githubusercontent.com/aeone-games/desktop/main/macos/install-macos.sh | bash
```

## Windows 10 and 11

Paste into PowerShell. Installs to `%LOCALAPPDATA%\Programs\aeone.games` with a Start menu shortcut.

```powershell
irm https://raw.githubusercontent.com/aeone-games/desktop/main/windows/install-windows.ps1 | iex
```

Release files are generated from the aeone.games source repo; changes made here are overwritten.
