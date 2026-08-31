#!/usr/bin/env bash

cd /tmp || { echo "Failed to change directory to /tmp"; exit 1; }

curl -L -o firefox-developer-edition.tar.xz "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US"

tar -xJf firefox-developer-edition.tar.xz

sudo mv firefox /opt/firefox-dev

sudo ln -sf /opt/firefox-dev/firefox /usr/local/bin/firefox-dev

sudo cp "$HOME/dotfiles/desktop/firefox-dev.desktop" "/usr/share/applications/firefox-dev.desktop"

cd "$HOME/dotfiles" || { echo "Failed to change directory to ~/dotfiles"; exit 1; }
