#!/usr/bin/env bash

sudo apt update
sudo snap install code --classic
sudo snap install code-insiders --classic

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cp "$DOTFILES_DIR/editors/vscode-insiders/code-insiders-flags.conf" "$HOME/.config/code-insiders-flags.conf"
