#!/bin/bash

# Godot C# / .NET Setup Script
# This script installs .NET SDK 8.0 for Godot C# support

set -e

echo "=== Godot C# / .NET Setup ==="
echo ""

# Check if .NET is already installed
if command -v dotnet &> /dev/null; then
    DOTNET_VERSION=$(dotnet --version)
    echo "✓ .NET SDK is already installed: $DOTNET_VERSION"
    
    # Check if version is 8.0 or higher
    MAJOR_VERSION=$(echo $DOTNET_VERSION | cut -d'.' -f1)
    if [ "$MAJOR_VERSION" -ge 8 ]; then
        echo "✓ Version is sufficient for Godot"
        exit 0
    else
        echo "⚠ Version is too old. Installing .NET 8.0..."
    fi
else
    echo "✗ .NET SDK not found. Installing..."
fi

echo ""

# Get Ubuntu version
source /etc/os-release
UBUNTU_VERSION=$VERSION_ID

echo "Detected Ubuntu $UBUNTU_VERSION"
echo ""

# Install prerequisites
echo "Installing prerequisites..."
sudo apt-get update
sudo apt-get install -y wget apt-transport-https

# Add Microsoft package repository
echo "Adding Microsoft package repository..."
wget https://packages.microsoft.com/config/ubuntu/$UBUNTU_VERSION/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
sudo dpkg -i /tmp/packages-microsoft-prod.deb
rm /tmp/packages-microsoft-prod.deb

# Update package list
sudo apt-get update

# Install .NET SDK 8.0
echo ""
echo "Installing .NET SDK 8.0..."
sudo apt-get install -y dotnet-sdk-8.0

# Verify installation
echo ""
echo "Verifying installation..."
if command -v dotnet &> /dev/null; then
    INSTALLED_VERSION=$(dotnet --version)
    echo ""
    echo "✓ .NET SDK $INSTALLED_VERSION installed successfully!"
    echo ""
    
    # Display installed SDKs
    echo "Installed SDKs:"
    dotnet --list-sdks
    echo ""
    
    # Display installed runtimes
    echo "Installed Runtimes:"
    dotnet --list-runtimes
    echo ""
    
    echo "=== Setup Complete ==="
    echo ""
    
    # Set environment variables for .NET
    echo "Configuring environment variables..."
    DOTNET_ROOT="/usr/lib/dotnet"
    
    # Add to current shell profile
    if [ -f "$HOME/.zshrc" ]; then
        if ! grep -q "DOTNET_ROOT" "$HOME/.zshrc"; then
            echo "" >> "$HOME/.zshrc"
            echo "# .NET Core configuration for Godot" >> "$HOME/.zshrc"
            echo "export DOTNET_ROOT=$DOTNET_ROOT" >> "$HOME/.zshrc"
            echo "export PATH=\$PATH:\$DOTNET_ROOT" >> "$HOME/.zshrc"
            echo "✓ Added DOTNET_ROOT to ~/.zshrc"
        fi
    fi
    
    if [ -f "$HOME/.bashrc" ]; then
        if ! grep -q "DOTNET_ROOT" "$HOME/.bashrc"; then
            echo "" >> "$HOME/.bashrc"
            echo "# .NET Core configuration for Godot" >> "$HOME/.bashrc"
            echo "export DOTNET_ROOT=$DOTNET_ROOT" >> "$HOME/.bashrc"
            echo "export PATH=\$PATH:\$DOTNET_ROOT" >> "$HOME/.bashrc"
            echo "✓ Added DOTNET_ROOT to ~/.bashrc"
        fi
    fi
    
    echo ""
    echo "Please restart Godot to use C# support."
    echo "If Godot was already open, you may need to:"
    echo "  1. Close Godot completely"
    echo "  2. Restart your terminal session (or run: source ~/.zshrc)"
    echo "  3. Launch Godot again"
    echo ""
else
    echo ""
    echo "✗ Installation failed. Please try manually:"
    echo "  Visit https://get.dot.net for instructions"
    exit 1
fi

