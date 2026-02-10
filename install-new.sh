#!/bin/bash

# Mac Installation Script with Progress Bar
# This script installs Homebrew and various applications

set -e  # Exit on any error

# Define packages to install
CASK_PACKAGES=(
    "jetbrains-toolbox"
    "visual-studio-code"
    "bruno"
    "colima"
    "docker"
    "awscli"
    "clipy"
    "codex"
    "git-credential-manager"
)

# Define additional tasks
ADDITIONAL_TASKS=(
    "download_zshrc"
    "download_hosts"
)

# Array to track failed installations
FAILED_INSTALLS=()

# Function to display progress bar
show_progress() {
    local current=$1
    local total=$2
    local task_name=$3
    local percentage=$((current * 100 / total))
    local filled=$((percentage / 2))
    local empty=$((50 - filled))
    
    printf "\n[%3d%%] [" "$percentage"
    printf "%${filled}s" | tr ' ' '='
    printf "%${empty}s" | tr ' ' '-'
    printf "] %s\n" "$task_name"
}

# Function to install a cask package
install_cask() {
    local package=$1
    echo "Installing $package..."
    if brew install --cask "$package" 2>/dev/null; then
        echo "✓ $package installation complete."
        return 0
    else
        echo "✗ Failed to install $package"
        FAILED_INSTALLS+=("$package")
        return 1
    fi
}

# Function to download .zshrc
download_zshrc() {
    echo "Downloading .zshrc to your home directory..."
    if curl -fsSL https://raw.githubusercontent.com/jthieme/mac-install/main/.zshrc -o ~/.zshrc; then
        echo "✓ .zshrc downloaded and installed successfully."
        return 0
    else
        echo "✗ Failed to download .zshrc"
        FAILED_INSTALLS+=("zshrc download")
        return 1
    fi
}

# Function to download hosts file
download_hosts() {
    echo "Downloading hosts file to /etc/hosts (requires sudo)..."
    if sudo curl -fsSL https://raw.githubusercontent.com/jthieme/mac-install/main/hosts -o /etc/hosts; then
        echo "✓ /etc/hosts updated successfully."
        return 0
    else
        echo "✗ Failed to update /etc/hosts"
        FAILED_INSTALLS+=("hosts file download")
        return 1
    fi
}

# Main installation process
main() {
    echo "========================================"
    echo "  Mac Installation Script with Progress"
    echo "========================================"
    echo ""
    
    # Calculate total tasks
    local total_tasks=$((1 + ${#CASK_PACKAGES[@]} + ${#ADDITIONAL_TASKS[@]}))
    local current_task=0
    
    # Install Homebrew
    current_task=$((current_task + 1))
    show_progress "$current_task" "$total_tasks" "Checking Homebrew"
    
    if command -v brew >/dev/null 2>&1; then
        echo "Homebrew is already installed, skipping installation..."
    else
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo "✓ Homebrew installation complete."
    fi
    
    # Install cask packages
    for package in "${CASK_PACKAGES[@]}"; do
        current_task=$((current_task + 1))
        show_progress "$current_task" "$total_tasks" "Installing $package"
        install_cask "$package" || true  # Continue even if one fails
    done
    
    # Execute additional tasks
    for task in "${ADDITIONAL_TASKS[@]}"; do
        current_task=$((current_task + 1))
        show_progress "$current_task" "$total_tasks" "Executing $task"
        $task || true  # Continue even if one fails
    done
    
    echo ""
    echo "========================================"
    echo "  All installation tasks completed!"
    echo "========================================"
    
    # Display failed installations if any
    if [ ${#FAILED_INSTALLS[@]} -gt 0 ]; then
        echo ""
        echo "⚠️  WARNING: The following installations failed:"
        echo "========================================"
        for failed in "${FAILED_INSTALLS[@]}"; do
            echo "  ✗ $failed"
        done
        echo "========================================"
        echo "Total failed: ${#FAILED_INSTALLS[@]}"
    else
        echo ""
        echo "✓ All installations completed successfully!"
    fi
}

# Run main function
main
