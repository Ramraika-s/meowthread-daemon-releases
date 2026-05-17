# MeowThread Daemon Installer for Windows

Write-Host "🐱 Welcome to the MeowThread Daemon Installer!"

$Arch = (Get-WmiObject Win32_Processor).Architecture
if ($Arch -eq 9) {
    $ArchStr = "amd64"
} else {
    Write-Host "Unsupported architecture. Currently only x64 (amd64) is supported on Windows."
    exit
}

$BinaryName = "meowthread-daemon-windows-$ArchStr.exe"
# REPLACE THIS URL ONCE YOU PUSH TO GITHUB
$DownloadUrl = "https://raw.githubusercontent.com/Ramraika-s/meowthread-daemon-releases/main/$BinaryName"
$InstallDir = "$env:ProgramFiles\MeowThread"
$ExecutablePath = "$InstallDir\meowthread-daemon.exe"

Write-Host "Downloading $BinaryName..."
if (-not (Test-Path -Path $InstallDir)) {
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
}

Invoke-WebRequest -Uri $DownloadUrl -OutFile $ExecutablePath

# Add to PATH if not already present
$CurrentPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
if ($CurrentPath -notmatch [regex]::Escape($InstallDir)) {
    Write-Host "Adding $InstallDir to system PATH..."
    [Environment]::SetEnvironmentVariable("PATH", $CurrentPath + ";$InstallDir", "Machine")
}

Write-Host "Installation complete! 🎉"
Write-Host "Please restart your PowerShell to apply PATH changes, then run:"
Write-Host "  meowthread-daemon -init"
