#!/bin/bash
# MeowThread Daemon Installer for macOS and Linux

set -e

echo "🐱 Welcome to the MeowThread Daemon Installer!"

# Detect OS and Arch
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

BINARY_NAME="meowthread-daemon-${OS}-${ARCH}"
# REPLACE THIS URL ONCE YOU PUSH TO GITHUB
DOWNLOAD_URL="https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/meowthread-daemon-releases/main/${BINARY_NAME}"
INSTALL_DIR="/usr/local/bin"
EXECUTABLE_NAME="meowthread-daemon"

echo "Downloading ${BINARY_NAME}..."
curl -sSL -o "/tmp/${EXECUTABLE_NAME}" "$DOWNLOAD_URL"
chmod +x "/tmp/${EXECUTABLE_NAME}"

echo "Installing to ${INSTALL_DIR} (requires sudo)..."
sudo mv "/tmp/${EXECUTABLE_NAME}" "${INSTALL_DIR}/${EXECUTABLE_NAME}"

echo "Installation complete! 🎉"
echo "To initialize your device, run:"
echo "  meowthread-daemon -init"
