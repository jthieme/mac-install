echo "Installing Bruno..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "Bruno installation complete."

echo "Using Homebrew to install JetBrains Toolbox..."
brew install --cask jetbrains-toolbox
echo "JetBrains Toolbox installation complete."

echo "Using Homebrew to install Visual Studio Code..."
brew install --cask visual-studio-code
echo "Visual Studio Code installation complete."

echo "Using Homebrew to install Bruno..."
brew install --cask bruno
echo "Bruno installation complete."

echo "Downloading .zshrc to your home directory..."
curl -fsSL https://raw.githubusercontent.com/jthieme/mac-install/main/.zshrc -o ~/.zshrc
echo ".zshrc downloaded."

echo "Downloading hosts file to /etc/hosts (requires sudo)..."
sudo curl -fsSL https://raw.githubusercontent.com/jthieme/mac-install/main/hosts -o /etc/hosts
echo "/etc/hosts updated."

echo "Installation complete."