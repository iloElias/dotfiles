#!/bin/bash

# Configure VS Code Insiders as Godot's external editor
# This script modifies Godot's editor settings

set -e

VSCODE_PATH="/snap/bin/code-insiders"

echo "=== Configuring VS Code Insiders for Godot ==="
echo ""

# Check if VS Code Insiders is installed
if ! command -v code-insiders &> /dev/null; then
    echo "✗ Error: VS Code Insiders not found"
    echo "  Install it first: sudo snap install code-insiders --classic"
    exit 1
fi

echo "✓ VS Code Insiders found at: $VSCODE_PATH"

# Find Godot config file (supports different versions)
GODOT_CONFIG=$(find "$HOME/.config/godot" -name "editor_settings-*.tres" 2>/dev/null | head -1)

# Check if Godot config exists
if [ -z "$GODOT_CONFIG" ] || [ ! -f "$GODOT_CONFIG" ]; then
    echo ""
    echo "⚠ Godot editor settings not found at:"
    echo "  $GODOT_CONFIG"
    echo ""
    echo "Please:"
    echo "  1. Launch Godot at least once to create the config"
    echo "  2. Then run this script again"
    echo ""
    echo "Or configure manually in Godot:"
    echo "  Editor → Editor Settings → Text Editor → External"
    echo "  • Use External Editor: ON"
    echo "  • Exec Path: $VSCODE_PATH"
    echo "  • Exec Flags: {project} --goto {file}:{line}:{col}"
    exit 1
fi

echo "✓ Godot config found"
echo ""

# Backup original config
BACKUP="${GODOT_CONFIG}.backup.$(date +%Y%m%d_%H%M%S)"
cp "$GODOT_CONFIG" "$BACKUP"
echo "✓ Backed up config to: $BACKUP"

# Update external editor settings
echo "✓ Configuring external editor settings..."

# Check if settings already exist and update them, or add them
if grep -q "text_editor/external/use_external_editor" "$GODOT_CONFIG"; then
    sed -i 's|text_editor/external/use_external_editor.*|text_editor/external/use_external_editor = true|' "$GODOT_CONFIG"
else
    echo 'text_editor/external/use_external_editor = true' >> "$GODOT_CONFIG"
fi

if grep -q "text_editor/external/exec_path" "$GODOT_CONFIG"; then
    sed -i "s|text_editor/external/exec_path.*|text_editor/external/exec_path = \"$VSCODE_PATH\"|" "$GODOT_CONFIG"
else
    echo "text_editor/external/exec_path = \"$VSCODE_PATH\"" >> "$GODOT_CONFIG"
fi

if grep -q "text_editor/external/exec_flags" "$GODOT_CONFIG"; then
    sed -i 's|text_editor/external/exec_flags.*|text_editor/external/exec_flags = "{project} --goto {file}:{line}:{col}"|' "$GODOT_CONFIG"
else
    echo 'text_editor/external/exec_flags = "{project} --goto {file}:{line}:{col}"' >> "$GODOT_CONFIG"
fi

echo ""
echo "✅ Configuration complete!"
echo ""
echo "VS Code Insiders is now set as Godot's external editor."
echo "Restart Godot for changes to take effect."
echo ""
