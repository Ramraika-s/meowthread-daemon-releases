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
$RepoPath = "Ramraika-s/meowthread-daemon-releases"
$ApiUrl = "https://api.github.com/repos/$RepoPath/releases/latest"
$InstallDir = "$env:ProgramFiles\MeowThread"
$ExecutablePath = "$InstallDir\meowthread-daemon.exe"

Write-Host "Querying GitHub for latest release..."
try {
    $Release = Invoke-RestMethod -Uri $ApiUrl -ErrorAction Stop
    $Asset = $Release.assets | Where-Object { $_.name -eq $BinaryName }
    if (-not $Asset) {
        Write-Host "❌ Error: Could not find binary asset $BinaryName in the latest release."
        exit
    }
    $DownloadUrl = $Asset.browser_download_url
} catch {
    Write-Host "❌ Error: Failed to fetch release from GitHub API. Please check your internet connection."
    exit
}

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

Write-Host ""
Write-Host "Installation complete! 🎉"
Write-Host "Please restart your PowerShell to apply PATH changes, then run:"
Write-Host "  meowthread --login"
Write-Host ""
