#!/bin/bash

TOOLBOX_URL="https://download.jetbrains.com/toolbox/jetbrains-toolbox-3.1.2.64642.tar.gz"
INSTALL_DIR="/opt/jetbrains-toolbox"
TEMP_DIR="/tmp/jetbrains-toolbox"

sudo apt install -y libfuse2

rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"
mkdir -p "$HOME/.local/bin"

curl -L "$TOOLBOX_URL" -o "$TEMP_DIR/jetbrains-toolbox.tar.gz"
tar -xzf "$TEMP_DIR/jetbrains-toolbox.tar.gz" -C "$TEMP_DIR"

EXTRACTED_DIR=$(find "$TEMP_DIR" -maxdepth 1 -type d -name "jetbrains-toolbox-*")

if [ ! -d "$EXTRACTED_DIR" ]; then
    echo "Error: JetBrains Toolbox archive not extracted properly."
    exit 1
fi

sudo rm -rf "$INSTALL_DIR"
sudo mkdir -p "$INSTALL_DIR"

sudo cp -r "$EXTRACTED_DIR"/* "$INSTALL_DIR"

BIN_PATH=$(find "$INSTALL_DIR" -type f -name "jetbrains-toolbox" | head -n 1)

if [ -z "$BIN_PATH" ]; then
    echo "Error: jetbrains-toolbox binary not found even after extraction."
    find "$INSTALL_DIR" -maxdepth 2 -type f
    exit 1
fi

sudo chmod +x "$BIN_PATH"

ln -sf "$BIN_PATH" "$HOME/.local/bin/jetbrains-toolbox"

DESKTOP_ENTRY="$HOME/.local/share/applications/jetbrains-toolbox.desktop"

cat > "$DESKTOP_ENTRY" <<EOL
[Desktop Entry]
Type=Application
Name=Toolbox
Exec=$BIN_PATH
Icon=/opt/dotfiles/public/img/jetbrains-toolbox.ico
Categories=Development;IDE;
Comment=JetBrains Toolbox
Terminal=false
StartupNotify=true
EOL

chmod +x "$DESKTOP_ENTRY"

echo "JetBrains Toolbox installed and launched successfully."
