#!/bin/bash

# Mac Installation Script
# This script installs Homebrew and various applications

set -e  # Exit on any error

echo "Starting Mac installation script..."

# Check if Homebrew is already installed
if command -v brew >/dev/null 2>&1; then
    echo "Homebrew is already installed, skipping installation..."
else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew installation complete."
fi

echo "Using Homebrew to install JetBrains Toolbox..."
if brew install --cask jetbrains-toolbox; then
    echo "JetBrains Toolbox installation complete."
else
    echo "Failed to install JetBrains Toolbox"
fi

echo "Using Homebrew to install Visual Studio Code..."
if brew install --cask visual-studio-code; then
    echo "Visual Studio Code installation complete."
else
    echo "Failed to install Visual Studio Code"
fi

echo "Using Homebrew to install Bruno..."
if brew install --cask bruno; then
    echo "Bruno installation complete."
else
    echo "Failed to install Bruno"
fi

echo "Downloading .zshrc to your home directory..."
if curl -fsSL https://raw.githubusercontent.com/jthieme/mac-install/main/.zshrc -o ~/.zshrc; then
    echo ".zshrc downloaded and installed successfully."
else
    echo "Failed to download .zshrc"
fi

echo "Downloading hosts file to /etc/hosts (requires sudo)..."
if sudo curl -fsSL https://raw.githubusercontent.com/jthieme/mac-install/main/hosts -o /etc/hosts; then
    echo "/etc/hosts updated successfully."
else
    echo "Failed to update /etc/hosts"
fi

echo "All installation tasks completed!"