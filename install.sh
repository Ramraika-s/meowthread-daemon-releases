#!/bin/bash
# ============================================================================
# MeowThread Daemon - Universal Installer
# Fetches the latest cryptographically signed binary from GitHub Releases
# ============================================================================

set -e

REPO="Ramraika-s/meowthread-daemon-releases"
INSTALL_DIR="$HOME/.local/bin"
BINARY_NAME="meowthread"

echo "==========================================="
echo "   MeowThread Daemon - Installer"
echo "==========================================="

# 1. Detect OS and Architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

if [ "$OS" == "mingw64" ] || [ "$OS" == "msys" ] || [[ "$OS" == *"windows"* ]]; then
    echo "❌ Error: This installer script is for Linux and macOS."
    echo "For Windows, please download the .exe directly from the Releases page and run it from PowerShell."
    exit 1
fi

if [ "$ARCH" == "x86_64" ]; then
    ARCH="amd64"
elif [ "$ARCH" == "aarch64" ] || [ "$ARCH" == "arm64" ]; then
    ARCH="arm64"
else
    echo "❌ Error: Unsupported architecture: $ARCH"
    exit 1
fi

ASSET_NAME="meowthread-daemon-${OS}-${ARCH}"
if [ "$OS" == "darwin" ]; then
    # macOS doesn't support systemd natively in the same way, but the kardianos service library will handle launchd
    echo "[*] Detected macOS ($ARCH)"
else
    echo "[*] Detected Linux ($ARCH)"
fi

# 2. Fetch Latest Release Metadata
echo "[*] Querying GitHub for latest release..."
LATEST_RELEASE_URL=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"browser_download_url":' | grep "$ASSET_NAME\"" | cut -d '"' -f 4)
CHECKSUM_URL=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"browser_download_url":' | grep "checksums.txt" | cut -d '"' -f 4)

if [ -z "$LATEST_RELEASE_URL" ]; then
    echo "❌ Error: Could not find binary asset $ASSET_NAME in the latest release."
    exit 1
fi

# 3. Download and Verify Checksum
TMP_DIR=$(mktemp -d)
echo "[*] Downloading binary..."
curl -sSL -o "$TMP_DIR/$ASSET_NAME" "$LATEST_RELEASE_URL"
curl -sSL -o "$TMP_DIR/checksums.txt" "$CHECKSUM_URL"

echo "[*] Verifying cryptographic checksum..."
cd "$TMP_DIR"
if ! grep "$ASSET_NAME" checksums.txt | sha256sum -c - &>/dev/null; then
    echo "❌ CRITICAL ERROR: SHA256 checksum verification failed!"
    echo "The binary may be corrupted or compromised. Aborting installation."
    rm -rf "$TMP_DIR"
    exit 1
fi
echo "✅ Checksum verified successfully."

# 4. Install Binary
echo "[*] Installing to $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"
mv "$ASSET_NAME" "$INSTALL_DIR/$BINARY_NAME"
chmod +x "$INSTALL_DIR/$BINARY_NAME"
cd - > /dev/null
rm -rf "$TMP_DIR"

# Ensure ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo "⚠️  Warning: $HOME/.local/bin is not in your PATH."
    echo "Please add 'export PATH=\$HOME/.local/bin:\$PATH' to your ~/.bashrc or ~/.zshrc."
    export PATH="$HOME/.local/bin:$PATH"
fi

# 5. Service Configuration Prompts
echo ""
read -p "Would you like to install the daemon as a background service? [Y/n] " INSTALL_SVC < /dev/tty
if [[ "$INSTALL_SVC" =~ ^([yY][eE][sS]|[yY]|)$ ]]; then
    "$INSTALL_DIR/$BINARY_NAME" --install
    
    echo ""
    read -p "Would you like the daemon to automatically start when your system boots? [Y/n] " AUTO_BOOT < /dev/tty
    if [[ "$AUTO_BOOT" =~ ^([yY][eE][sS]|[yY]|)$ ]]; then
        if [ "$OS" == "linux" ] && command -v loginctl >/dev/null; then
            loginctl enable-linger "$USER"
            echo "✅ Boot persistence enabled via loginctl."
        else
            echo "ℹ️  Boot persistence is handled by the OS service manager."
        fi
    fi
    
    echo "[*] Starting daemon service..."
    "$INSTALL_DIR/$BINARY_NAME" --connect
fi

echo ""
echo "🎉 Installation complete!"
echo ""
echo "If you haven't logged in yet, run the following command to link this machine:"
echo "    meowthread --login"
echo ""
