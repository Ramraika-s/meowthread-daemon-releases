# MeowThread Daemon Releases

This repository contains the pre-compiled binaries and installation scripts for the **MeowThread Daemon**.

The MeowThread Daemon connects your local machine's terminal directly to the MeowThread web interface with E2E Encryption, allowing you to run AI-powered commands and control your machine securely from anywhere.

## Installation

### Mac / Linux
Open your terminal and run the following command:
```bash
curl -sSL https://raw.githubusercontent.com/Ramraika-s/meowthread-daemon-releases/main/install.sh | bash
```

### Windows
Open PowerShell as Administrator and run:
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Ramraika-s/meowthread-daemon-releases/main/install.ps1" -OutFile "install.ps1"; .\install.ps1
```

## Manual Installation
If you prefer to install it manually:
1. Download the correct binary for your OS and architecture from this folder.
2. Place it in a directory that is in your system's PATH.
3. Rename the binary to `meowthread-daemon` (or `meowthread-daemon.exe` on Windows).
4. Run `meowthread-daemon -init` to generate your device keys.
5. Provide the device keys to the MeowThread web app.
