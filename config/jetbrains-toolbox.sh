#!/bin/bash

TOOLBOX_URL="https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.23.11731.tar.gz"
INSTALL_DIR="/opt/jetbrains-toolbox"
TEMP_DIR="/tmp/jetbrains-toolbox"

apt install libfuse2

mkdir -p "$TEMP_DIR"

curl -L "$TOOLBOX_URL" -o "$TEMP_DIR/jetbrains-toolbox.tar.gz"

tar -xzf "$TEMP_DIR/jetbrains-toolbox.tar.gz" -C "$TEMP_DIR"

mkdir -p "$INSTALL_DIR"

mv "$TEMP_DIR"/* "$INSTALL_DIR"

rm -rf "$TEMP_DIR"

ln -s "$INSTALL_DIR/jetbrains-toolbox" "$HOME/.local/bin/jetbrains-toolbox"

EXTRACTED_DIR=$(find "$INSTALL_DIR" -maxdepth 1 -type d -name "jetbrains-toolbox-*")
"$EXTRACTED_DIR/jetbrains-toolbox" &

echo "JetBrains Toolbox has been installed and started successfully."
