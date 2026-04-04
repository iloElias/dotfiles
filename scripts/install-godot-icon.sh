#!/bin/bash

# Godot Installation and Desktop Icon Setup
# Installs Godot to /opt/godot and creates a desktop application icon

set -e

GODOT_SOURCE="/home/murilo-elias/Downloads/Godot_v4.6.1-stable_mono_linux_x86_64"
GODOT_INSTALL_DIR="/opt/godot"
GODOT_VERSION="4.6.1"
GODOT_ICON_URL="https://raw.githubusercontent.com/godotengine/godot/master/icon.svg"

echo "=== Godot Desktop Icon Installation ==="
echo ""

# Check if source directory exists
if [ ! -d "$GODOT_SOURCE" ]; then
    echo "✗ Error: Godot source directory not found at $GODOT_SOURCE"
    exit 1
fi

# Create installation directory
echo "Creating installation directory..."
sudo mkdir -p "$GODOT_INSTALL_DIR"

# Copy Godot files
echo "Installing Godot to $GODOT_INSTALL_DIR..."
sudo cp -r "$GODOT_SOURCE"/* "$GODOT_INSTALL_DIR/"

# Rename executable to simpler name
if [ -f "$GODOT_INSTALL_DIR/Godot_v4.6.1-stable_mono_linux.x86_64" ]; then
    sudo mv "$GODOT_INSTALL_DIR/Godot_v4.6.1-stable_mono_linux.x86_64" "$GODOT_INSTALL_DIR/godot"
fi

# Make executable
sudo chmod +x "$GODOT_INSTALL_DIR/godot"

# Download Godot icon
echo "Downloading Godot icon..."
sudo wget -q "$GODOT_ICON_URL" -O "$GODOT_INSTALL_DIR/godot-icon.svg"

# Create .desktop file
echo "Creating desktop launcher..."
cat > /tmp/godot.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Godot Engine
GenericName=Game Engine
Comment=Multi-platform 2D and 3D game engine with a feature-rich editor
Exec=/opt/godot/godot %f
Icon=/opt/godot/godot-icon.svg
Terminal=false
Categories=Development;IDE;
MimeType=application/x-godot-project;
StartupNotify=true
StartupWMClass=Godot
EOF

# Install desktop file
sudo mv /tmp/godot.desktop /usr/share/applications/godot.desktop
sudo chmod 644 /usr/share/applications/godot.desktop

# Update desktop database
if command -v update-desktop-database &> /dev/null; then
    sudo update-desktop-database /usr/share/applications
fi

# Create symbolic link in /usr/local/bin for command-line access
echo "Creating command-line shortcut..."
sudo ln -sf "$GODOT_INSTALL_DIR/godot" /usr/local/bin/godot

echo ""
echo "✓ Installation complete!"
echo ""
echo "Godot $GODOT_VERSION installed to: $GODOT_INSTALL_DIR"
echo "Desktop launcher created: /usr/share/applications/godot.desktop"
echo ""
echo "You can now:"
echo "  • Launch Godot from your application menu"
echo "  • Run 'godot' from the command line"
echo ""
echo "Note: The original files remain at $GODOT_SOURCE"
echo "      You can delete them if installation is successful."
echo ""
