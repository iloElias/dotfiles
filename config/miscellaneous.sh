#!/usr/bin/env bash

set -e

sudo apt-get install -y gnome-shell-extensions curl jq unzip

GNOME_VERSION=$(gnome-shell --version | awk '{print $3}')
GNOME_VERSION_MAJOR=$(echo "$GNOME_VERSION" | cut -d. -f1)

# GNOME_EXTENSIONS=(
#     "6670" # bluetooth-battery-meter
#     "4679" # burn-my-windows
#     "4839" # clipboard-history
#     "3396" # color-picker
#     "1319" # gsconnect
#     "4470" # media-controls
#     "4651" # notification-banner-reloaded
#     "4985" # php-laravel-valet
#     "5964" # quick-settings-audio-devices-hider
#     "6000" # quick-settings-audio-devices-renamer
#     "5835" # rx-input-layout-switcher
#     "6385" # steal-my-focus-window
#     "1653" # tweaks-in-system-menu
# )

GNOME_EXTENSIONS_PACKAGES=(
    "Bluetooth-Battery-Meter@maniacx.github.com"
    "burn-my-windows@schneegans.github.com"
    "clipboard-history@alexsaveau.dev"
    "color-picker@tuberry"
    "gsconnect@andyholmes.github.io"
    "mediacontrols@cliffniff.github.com"
    "notification-banner-reloaded@marcinjakubowski.github.com"
    "php-laravel-valet@rahulhaque"
    "quicksettings-audio-devices-hider@marcinjahn.com"
    "quicksettings-audio-devices-renamer@marcinjahn.com"
    "steal-my-focus-window@steal-my-focus-window"
    "tweaks-system-menu@extensions.gnome-shell.fifi.org"
    "rx-input-layout-switcher@wzmn.net"
    "CustomizeClockOnLockScreen@pratap.fastmail.fm"
    "caffeine@patapon.info"
    "ding@rastersoft.com"
    "tiling-assistant@ubuntu.com"
    "ubuntu-appindicators@ubuntu.com"
    "ubuntu-dock@ubuntu.com"
    "apps-menu@gnome-shell-extensions.gcampax.github.com"
    "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
    "drive-menu@gnome-shell-extensions.gcampax.github.com"
    "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
    "light-style@gnome-shell-extensions.gcampax.github.com"
    "native-window-placement@gnome-shell-extensions.gcampax.github.com"
    "places-menu@gnome-shell-extensions.gcampax.github.com"
    "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
    "system-monitor@gnome-shell-extensions.gcampax.github.com"
    "user-theme@gnome-shell-extensions.gcampax.github.com"
    "window-list@gnome-shell-extensions.gcampax.github.com"
    "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
    "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
)

install_extension() {
    local uuid="$1"

    echo "----"
    echo "Instalando extensão: $uuid"

    if gnome-extensions list | grep -q "$uuid"; then
        echo "[IGNORADO] Já instalada: $uuid"
        return
    fi

    SEARCH_URL="https://extensions.gnome.org/extension-query/?search=$uuid"

    EXT_ID=$(curl -s "$SEARCH_URL" | jq ".extensions[] | select(.uuid==\"$uuid\") | .pk")

    if [ -z "$EXT_ID" ]; then
        echo "[ERRO] Não foi possível localizar o ID da extensão para: $uuid"
        return
    fi

    INFO_URL="https://extensions.gnome.org/extension-info/?pk=$EXT_ID&shell_version=$GNOME_VERSION_MAJOR"

    DOWNLOAD_URL=$(curl -s "$INFO_URL" | jq -r '.download_url')

    if [ "$DOWNLOAD_URL" = "null" ]; then
        echo "[ERRO] Nenhum pacote disponível para sua versão do GNOME: $uuid"
        return
    fi

    ZIP_URL="https://extensions.gnome.org$DOWNLOAD_URL"
    ZIP_FILE="/tmp/$uuid.zip"

    echo "Baixando: $ZIP_URL"
    curl -L -o "$ZIP_FILE" "$ZIP_URL"

    echo "Instalando extensão..."
    gnome-extensions install --force "$ZIP_FILE"

    echo "[OK] Instalada: $uuid"

    rm "$ZIP_FILE"
}

for extension in "${GNOME_EXTENSIONS_PACKAGES[@]}"; do
    install_extension "$extension"
done

echo "-------------------------------------"
echo "Todas as extensões foram processadas!"
echo "Reinicie o GNOME (ALT+F2 → r) se estiver no Xorg."
echo "-------------------------------------"
