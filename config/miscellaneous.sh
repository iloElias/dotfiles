#!/usr/bin/env bash

set -e

sudo apt-get update
sudo apt-get install -y gnome-shell-extensions curl

GNOME_EXTENSIONS=(
    "6670" # bluetooth-battery-meter
    "4679" # burn-my-windows
    "4839" # clipboard-history
    "3396" # color-picker
    "1319" # gsconnect
    "4470" # media-controls
    "4651" # notification-banner-reloaded
    "4985" # php-laravel-valet
    "5964" # quick-settings-audio-devices-hider
    "6000" # quick-settings-audio-devices-renamer
    "5835" # rx-input-layout-switcher
    "6385" # steal-my-focus-window
    "1653" # tweaks-in-system-menu
)

#   

echo "Opening GNOME Extension pages in Chrome..."

for EXT in "${GNOME_EXTENSIONS[@]}"; do
    EXT_URL="https://extensions.gnome.org/extension/$EXT"
    echo "Opening: $EXT_URL"
    if command -v google-chrome >/dev/null; then
        google-chrome "$EXT_URL" &
    elif command -v chromium-browser >/dev/null; then
        chromium-browser "$EXT_URL" &
    elif command -v chromium >/dev/null; then
        chromium "$EXT_URL" &
    else
        echo "No Chrome browser found (google-chrome, chromium-browser, chromium). Please open $EXT_URL manually."
    fi
done

echo "Finished opening GNOME extension pages. Please install them via your browser."

