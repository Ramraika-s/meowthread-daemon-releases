<div align="center">
  <img src="https://raw.githubusercontent.com/Ramraika-s/meowthread/main/web/public/signal-engine-logo.png" alt="MeowThread Daemon" width="120" />
  <h1>MeowThread Daemon</h1>
  <p>The secure, cross-platform remote development and AI execution daemon for the MeowThread ecosystem.</p>
</div>

## 🚀 Installation

Install the pre-compiled binary securely in one command. The installer automatically verifies the cryptographic SHA256 checksums to ensure supply-chain security.

### Linux & macOS
```bash
curl -sSL https://raw.githubusercontent.com/Ramraika-s/meowthread-daemon-releases/main/install.sh | bash
```

### Windows
Run the following command in PowerShell:
```powershell
irm https://raw.githubusercontent.com/Ramraika-s/meowthread-daemon-releases/main/install.ps1 | iex
```

---

## 🛠️ CLI Quick Start

Once installed, the `meowthread` command is globally available in your terminal.

#### 1. Login & Setup
```bash
meowthread --login
```
Authenticates with your MeowThread account, generates local X25519 encryption keys, and securely registers this machine.

#### 2. Background Service Management
The daemon can install itself natively as a background service (Systemd, LaunchDaemons, or Windows Service):
```bash
meowthread --install     # Registers the native service
meowthread --connect     # Starts the background daemon
meowthread --disconnect  # Stops the background daemon
```

#### 3. Registering Local AI Models
Want to hook your local Ollama or llama.cpp instance into the MeowThread chat?
```bash
meowthread --register
```
This prompts you for a nickname (e.g., `llama3`) and the terminal command (e.g., `ollama run llama3.1`). It will execute the command locally so you can verify it works before syncing it to your account. You can then trigger this model from the web UI by typing `@llama3 <prompt>`.

#### 4. Automatic Updates
```bash
meowthread --update
```
The daemon securely queries the GitHub API, downloads the latest verified binary, performs an atomic executable replacement, and restarts the background service.

---

## 🔒 Security & Verification

MeowThread enforces a strict zero-trust, end-to-end encryption model. The daemon never runs arbitrary commands sent over the network unless they are explicitly whitelisted in your `~/.meowthread-engine/config.toml` or permitted in `~/.meowthread-engine/permissions.toml`.

You can manually verify the integrity of the binaries against the release checksums:
```bash
sha256sum -c checksums.txt
```

---

## 🔑 Elevated Execution & Sudo Configuration

For administrative commands (like system upgrades or service restarts), the daemon supports **Passwordless Elevated Execution**. This allows authorized actions to run safely without exposing or storing your password.

We recommend two security options depending on your environment:

### Option A: Power User Blanket Control (Easiest)
Allows the daemon to run *any* elevated command instantly after you click approve in the E2EE Web UI.
* Add this line to your sudoers file:
  ```sudoers
  <username> ALL=(ALL) NOPASSWD: ALL
  ```
  *(Replace `<username>` with your system's username).*

### Option B: Predefined Whitelist (Max Security)
Restricts the daemon to *only* a specific list of approved system binaries.
* Add this line to your sudoers file:
  ```sudoers
  <username> ALL=(ALL) NOPASSWD: /usr/bin/dnf, /usr/bin/systemctl, /usr/bin/apt-get
  ```

---

### ⚠️ CRITICAL SAFETY WARNING
> [!CAUTION]
> **Never** edit sudoers files directly using standard text editors (such as `nano` or `vim`). A single typo can completely break the `sudo` subsystem, locking all administrators out of system privilege escalation.
> 
> **Always** run this command to safely edit and validate the rules:
> ```bash
> sudo visudo -f /etc/sudoers.d/meowthread
> ```
> This automatically checks file syntax before writing and aborts if errors are found, protecting your system.
