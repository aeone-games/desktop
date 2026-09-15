# Install or update the aeone.games desktop app on Windows, from PowerShell:
#
#   irm https://raw.githubusercontent.com/aeone-games/desktop/main/windows/install-windows.ps1 | iex
#
# Downloads the latest Windows release, checks it against the release's SHA256SUMS, unpacks
# it to %LOCALAPPDATA%\Programs\aeone.games and adds a Start menu shortcut — re-run to update;
# delete that folder and the shortcut to uninstall. No administrator rights needed. The exe
# is unsigned; a file downloaded by PowerShell carries no mark-of-the-web, so SmartScreen does
# not stop it.
& {
  $ErrorActionPreference = 'Stop'
  $ProgressPreference = 'SilentlyContinue'

  $release = 'https://github.com/aeone-games/desktop/releases/latest/download'
  $work = Join-Path ([System.IO.Path]::GetTempPath()) ('aeone-games-' + [guid]::NewGuid())
  New-Item -ItemType Directory -Path $work | Out-Null
  try {
    Invoke-WebRequest -UseBasicParsing "$release/SHA256SUMS" -OutFile (Join-Path $work 'SHA256SUMS')
    $line = Get-Content (Join-Path $work 'SHA256SUMS') |
      Where-Object { $_ -match '^[0-9a-f]{64}  aeone-games-[0-9.]+-win-x64\.zip$' } |
      Select-Object -First 1
    if (-not $line) { throw 'aeone.games: the latest release has no Windows build' }
    $sum, $name = $line -split '  ', 2

    $zip = Join-Path $work $name
    Invoke-WebRequest -UseBasicParsing "$release/$name" -OutFile $zip
    if ((Get-FileHash -Algorithm SHA256 $zip).Hash.ToLower() -ne $sum) {
      throw "aeone.games: checksum mismatch for $name"
    }

    $target = Join-Path $env:LOCALAPPDATA 'Programs\aeone.games'
    Get-Process -Name 'aeone.games' -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Milliseconds 500
    if (Test-Path $target) { Remove-Item -Recurse -Force $target }
    Expand-Archive -Path $zip -DestinationPath $target

    $shell = New-Object -ComObject WScript.Shell
    $link = $shell.CreateShortcut((Join-Path ([Environment]::GetFolderPath('Programs')) 'aeone.games.lnk'))
    $link.TargetPath = Join-Path $target 'aeone.games.exe'
    $link.WorkingDirectory = $target
    $link.Save()

    Write-Host "aeone.games installed — open it from the Start menu ('aeone')."
  } finally {
    Remove-Item -Recurse -Force $work -ErrorAction SilentlyContinue
  }
}
